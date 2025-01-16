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
sys.source("./elephant_model_covars.R", envir = formulae)
#covariates for occupancy and detection

library(tibble)

#--------------------Models--------------------
# Exploratory models: determine which and how many principal components
# need to be used. Also figure out which other variables can contribute
psi_covars_list <- c(
  "Grid_ID",
  "pc1",
  "pc2",
  "pc3",
  "pc4",
  "NDVI",
  "Human_disturbance_score",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)
mutation_list <- c(
  "NDVI",
  "Human_disturbance_score",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)
p_covars_match_string <- "Rain_score_|HD_Vehicles_|substrate_score_"

pc_explore_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_pcs,
  animal_prefix = "Elephant_",
  psi_covars_list = psi_covars_list,
  mutation_list = mutation_list,
  p_covars_match_string = p_covars_match_string,
  models_list = formulae$elephant_models,
  aic_table_filepath = config$elephants_pc_table,
  coeffs_table_filepath = config$elephants_pc_coeffs
)

#--------------------Final Models--------------------
# More refined set of models based on the results from
# the previous set
final_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_pcs,
  animal_prefix = "Elephant_",
  psi_covars_list = psi_covars_list,
  mutation_list = mutation_list,
  p_covars_match_string = p_covars_match_string,
  models_list = formulae$elephant_models_final,
  aic_table_filepath = config$elephants_final_aic_table,
  coeffs_table_filepath = config$elephants_final_coeffs,
  preds_image_filepath = config$final_elephants_occupancy_plot
)

#--------------------Human impact exploration--------------------
# The PCAs produced better AIC scores, but the graphs were terrible.
# Now going to try each of the individual components to see what works. Will also try boolean values instead of means
human_impact_covars <- c(
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

more_expl_models <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_pcs,
  animal_prefix = "Elephant_",
  psi_covars_list = human_impact_covars,
  mutation_list = starts_with("mean_"),
  models_list = formulae$more_exp_models,
  aic_table_filepath = config$elephants_hum_impact_aic_table,
  coeffs_table_filepath = config$elephants_hum_impact_coeffs
)

#--------------------Introduce other covars--------------------
# Only vehicles and built-up were comparatively significant in
# the previous analysis. Now I'll start introducing other covariates.
# 'p' will still be 1.
psi_covars_list <-c(
  "mean_HD_Vehicles",
  "mean_HD_built_up",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)

models_reint_covars <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_pcs,
  animal_prefix = "Elephant_",
  psi_covars_list = psi_covars_list,
  models_list = formulae$hum_impact_plus_others,
  aic_table_filepath = config$elephants_hum_impact_plus_covars_aic_table,
  coeffs_table_filepath = config$elephants_hum_impact_plus_covars_coeffs
)

#--------------------Compare NDVIs--------------------
# Extracted mean NDVI values and SDs using landsat 8. This section
# compares the two NDVI values. From the look of things, neither of
# them is great. Error for the original NDVI is very large, while
# the graph for the new NDVI seems like it has an inflection point
# It is what it is. AIC score is better, so I'll use the new values
psi_covars_list <- c(
  "NDVI_original",
  "NDVI_mean",
  "NDVI_SD"
)

models_comp_ndvis <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "Elephant_",
  psi_covars_list = psi_covars_list,
  mutation_list = psi_covars_list,
  models_list = formulae$ndvi_comparison_models
)

#--------------------Rerun with new NDVI--------------------
# We will run the analyses from the other covars section with
# the new mean NDVI. Hopefully, the coefficients and models
# will be better
psi_covars_list <- c(
  "mean_HD_Vehicles",
  "mean_HD_built_up",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm"
)

models_new_ndvis <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "Elephant_",
  psi_covars_list = psi_covars_list,
  mutation_list = psi_covars_list,
  models_list = formulae$hum_impact_plus_others,
  aic_table_filepath = config$elephants_new_ndvi_aic_table,
  coeffs_table_filepath = config$elephants_new_ndvi_coeffs
)

#--------------------Finalized models--------------------
# Finalized set of models. Ignoring all that either don't converge
# or have VC warnings
psi_covars_list <- c(
  "mean_HD_Vehicles",
  "mean_HD_built_up",
  "NDVI",
  "Dist_to_PA_km",
  "total_land_area_per_grid_sqkm",
  "Human_disturbance_score"
)
p_covars_match_string <- "Rain_score_|substrate_score_"

models_final_final <- utils$run_models_return_output(
  datasheet_path = config$data_sheet_with_new_ndvi,
  animal_prefix = "Elephant_",
  psi_covars_list = psi_covars_list,
  p_covars_match_string = p_covars_match_string,
  models_list = formulae$actual_final_models,
  aic_table_filepath = config$elephants_final_final_aic_table
)
