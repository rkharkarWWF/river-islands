config <- new.env()
sys.source("./config.R", envir = config)
#config file has filepaths, list of animals, and the models to run
utils <- new.env()
sys.source("./utils.R", envir = utils)
#functions for processing the csv file and for running and saving correlations
models <- new.env()
sys.source("./models.R", envir = models)
#naive occupancy, single season occupancy, and hines models
formulae <- new.env()
sys.source("./rhino_model_covars.R", envir = formulae)
#covariates for occupancy and detection

library(arrow)
library(RPresence)
library(ggplot2)
library(stringr)
library(readr)

#--------------------Models comparison--------------------
# Comparing single season and hines models
datasheet <- read_parquet("./data/data_with_ndvi.parquet")
grids_and_occupancy <- datasheet %>%
  select(Grid_ID, starts_with("One_horned_rhino_"))

ss_model <- models$calculate_ss_occupancy(
  site_and_detection_history = grids_and_occupancy,
  model_formula = formulae$base_model
)
hines_model <- models$calculate_hines_occupancy(
  site_and_detection_history = grids_and_occupancy,
  model_formula = formulae$base_model
)

aic_table <- createAicTable(list(ss_model, hines_model))

write_csv(
  x = aic_table$table,
  file = config$rhinos_ss_hines_comp
)

#--------------------Human activity--------------------
human_activity_covars <- c(
  "mean_HD_People",
  "mean_HD_Livestocksightings",
  "mean_HD_Lopping",
  "mean_HD_Grass_bamboo_cut",
  "mean_HD_Trash",
  "mean_HD_Mining",
  "mean_HD_Garbage_dump",
  "mean_HD_Vehicles",
  "mean_HD_built_up",
  "mean_HD_Feral_dogs"
)

hum_act_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "One_horned_rhino_",
  psi_covars_list = human_activity_covars,
  models_list = formulae$hum_act_models,
  aic_table_filepath = config$rhinos_hum_act_aic_table,
  coeffs_table_filepath = config$rhinos_hum_act_coeffs
)

#--------------------Add in covars--------------------
# Top two variables from human activity plus other covars.
# Try all combinations. Even though bool_HD_Vehicles was the
# second best variable, I am excluding it because the CIs
# were massive. Note: SEs for People and Vehicles were large
psi_covars_list <- c(
  "mean_HD_People",
  "mean_HD_Vehicles",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)

hum_act_plus_others_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "One_horned_rhino_",
  psi_covars_list = psi_covars_list,
  models_list = formulae$hum_activity_plus_others,
  aic_table_filepath = config$rhinos_hum_act_plus_others_aic_table,
  coeffs_table_filepath = config$rhinos_hum_act_plus_others_coeffs,
  preds_image_filepath = config$rhinos_hum_act_plus_others_plot
)

#--------------------Detection covars--------------------
# Covariates affecting detection.
psi_covars_list <- c(
  "mean_HD_People",
  "mean_HD_Vehicles",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)
p_covars_match_string <-
  "Rain_score_|substrate_score_|HD_Vehicles_"

p_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "One_horned_rhino_",
  psi_covars_list = psi_covars_list,
  p_covars_match_string = p_covars_match_string,
  models_list = formulae$detection_models,
  aic_table_filepath = config$rhinos_detection_aic,
  p_coeffs_table_filepath = config$rhinos_detection_coeffs
)

#--------------------Final models--------------------
# Will not include covariates for p in the final model. Vehicles
# was the best model, but vehicles are also included in the list
# for psi. So this list will be equivalent to the previous
# list with human activity and other relevant covars
psi_covars_list <- c(
  "mean_HD_People",
  "mean_HD_Vehicles",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)

final_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "One_horned_rhino_",
  psi_covars_list = psi_covars_list,
  mutation_list = psi_covars_list,
  p_covars_match_string = p_covars_match_string,
  models_list = formulae$hum_activity_plus_others,
  aic_table_filepath = config$rhinos_final_aic_table,
  coeffs_table_filepath = config$rhinos_final_coeffs
)

best_model <- final_models$models[[1]]
best_model_psi_coeffs <- coef(
  best_model,
  param = "psi",
  prob = 0.05
)
best_model_p_coeffs <- coef(
  best_model,
  param = "p",
  prob = 0.05
)
write_csv(
  best_model_psi_coeffs,
  config$rhinos_final_coeffs_best_model
)
write_csv(
  best_model_p_coeffs,
  config$rhinos_final_p_coeffs_best_model
)

prediction_data <- utils$create_prediction_data(
  best_model$data$unitcov,
  colnames(best_model$data$unitcov),
  datapoints = 200
)
best_model_prediction_plot <- utils$create_predictive_plots(
  prediction_data,
  best_model,
  "Occupancy Covariates",
  c("Signs of Vehicles", "Signs of People", "Total Land Area"),
  c("Vehicles", "People", "Land Area"),
  columns_to_unscale_by = final_models$psi_covars
)
ggsave(config$rhinos_final_plot, best_model_prediction_plot)

ctr <- 0
wgt <- 0
model_list <- list()
wgt_list <- list()
psi_values <- tibble(grid_id = final_models$models[[1]]$data$unitnames)
while (wgt < 0.8) {
  ctr <- ctr + 1
  wgt <- wgt + final_models$aic$table$wgt[[ctr]]
  wgt_list[ctr] <- final_models$aic$table$wgt[[ctr]]
  model_list[ctr] <- final_models$models[[ctr]]$modname
  psi_values[[final_models$models[[ctr]]$modname]] <- final_models$models[[ctr]]$real$psi$est
}

psi_values <- psi_values %>%
  mutate(mean_psi = rowSums(mapply(
    "*",
    across(-c("grid_id")),
    wgt_list
  )) / sum(unlist(wgt_list)))

psi_values %>%
  select(grid_id, mean_psi) %>%
  write_csv(config$rhinos_psi_values)
