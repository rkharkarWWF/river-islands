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

library(tibble)

#--------------------Human activity--------------------
human_activity_covars <- c(
  "mean_HD_People",
  "bool_hd_people",
  "mean_HD_Livestocksightings",
  "bool_hd_livestocksightings",
  "mean_HD_Lopping",
  "bool_hd_lopping",
  "mean_HD_Grass_bamboo_cut",
  "bool_hd_grass_bamboo_cut",
  "mean_HD_Trash",
  "bool_hd_trash",
  "mean_HD_Mining",
  "bool_hd_mining",
  "mean_HD_Garbage_dump",
  "bool_hd_garbage_dump",
  "mean_HD_Vehicles",
  "bool_hd_vehicles",
  "mean_HD_built_up",
  "bool_hd_built_up",
  "mean_HD_Feral_dogs",
  "bool_hd_feral_dogs"
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
# were massive
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

#--------------------Model detection as well--------------------
# Introduce modeling of detection probability. Use best models
# from previous section
psi_covars_list <- c(
  "mean_HD_People",
  "mean_HD_Vehicles",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)
p_covars_match_string <- "Rain_score_|HD_Vehicles_|substrate_score_"

final_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "One_horned_rhino_",
  psi_covars_list = psi_covars_list,
  mutation_list = psi_covars_list,
  p_covars_match_string = p_covars_match_string,
  models_list = formulae$final_models,
  aic_table_filepath = config$rhinos_final_aic_table,
  coeffs_table_filepath = config$rhinos_final_coeffs,
  preds_image_filepath = config$rhinos_final_plot
)

#--------------------Model p without vehicles--------------------
# Remove vehicles from probability of detection
psi_covars_list <- c(
  "mean_HD_People",
  "mean_HD_Vehicles",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)
p_covars_match_string <- "Rain_score_|substrate_score_"

final_models_without_v <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "One_horned_rhino_",
  psi_covars_list = psi_covars_list,
  mutation_list = psi_covars_list,
  p_covars_match_string = p_covars_match_string,
  models_list = formulae$final_models_without_v,
  aic_table_filepath = config$rhinos_no_v_aic_table,
  coeffs_table_filepath = config$rhinos_no_v_coeffs,
  preds_image_filepath = config$rhinos_no_v_plot
)
