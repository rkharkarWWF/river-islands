config <- new.env()
sys.source("./config.R", envir = config)
#config file has filepaths, list of animals, and the models to run
utils <- new.env()
sys.source("./utils.R", envir = utils)
#functions for processing the csv file and for running and saving correlations
models <- new.env()
sys.source("models.R", envir = models)
#naive occupancy, single season occupancy, and hines models
formulae <- new.env()
sys.source("./tiger_model_covars.R", envir = formulae)
#covariates for occupancy and detection

library(arrow)
library(RPresence)

#--------------------Models comparison--------------------
# Comparing single season and hines models
datasheet <- read_parquet("./data/data_with_ndvi.parquet")
grids_and_occupancy <- datasheet %>%
  select(Grid_ID, starts_with("Tiger_"))

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
  file = config$tigers_ss_hines_comp
)

#--------------------Human activity--------------------
# Single season and hines are very close for the base model. Hines
# will probably be better when covariates are involved. For the
# sake of uniformity, I will keep using Hines

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
  "mean_HD_Feral_dogs",
  "wildprey"
)

hum_act_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "Tiger_",
  psi_covars_list = human_activity_covars,
  models_list = formulae$hum_act_models,
  aic_table_filepath = config$tigers_hum_act_aic,
  coeffs_table_filepath = config$tigers_hum_act_coeffs
)

#--------------------Add in covars--------------------
# Add in covariates. For human activity, HD_People and HD_Livestocksightings
# were most important, with a 20+ delta AIC between the two

psi_covars_list <- c(
  "mean_HD_People",
  "wildprey",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)

hum_act_plus_others_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "Tiger_",
  psi_covars_list = psi_covars_list,
  mutation_list = psi_covars_list,
  models_list = formulae$hum_activity_plus_others,
  aic_table_filepath = config$tigers_hum_act_plus_others_aic,
  coeffs_table_filepath = config$tigers_hum_act_plus_others_coeffs,
  preds_image_filepath = config$tigers_hum_act_plus_others_plot
)

#--------------------Detection covars--------------------
# Covariates affecting detection.
p_covars_match_string <-
  "Rain_score_|substrate_score_|Cattle_|HD_Vehicles_"

p_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "Tiger_",
  p_covars_match_string = p_covars_match_string,
  models_list = formulae$detection_models,
  aic_table_filepath = config$tigers_detection_aic,
  p_coeffs_table_filepath = config$tigers_detection_coeffs
)

#--------------------Final models--------------------
# For p, only using vehicles since the top rated models were
# not converging. The vehicles model was the top ranked one
# to converge
psi_covars_list <- c(
  "mean_HD_People",
  "wildprey",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)
p_covars_match_string <- "HD_Vehicles_"

p_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "Tiger_",
  psi_covars_list = psi_covars_list,
  mutation_list = psi_covars_list,
  p_covars_match_string = p_covars_match_string,
  models_list = formulae$final_models,
  aic_table_filepath = config$tigers_final_aic,
  coeffs_table_filepath = config$tigers_final_coeffs,
  p_coeffs_table_filepath = config$tigers_final_p_coeffs
)
