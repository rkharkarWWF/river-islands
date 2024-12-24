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

cluster <- utils$setup_parallel()

library(arrow)
library(readr)
library(arrow)
library(purrr)
library(tibble)
library(stringr)
library(ggplot2)
library(foreach)
library(doParallel)
library(RPresence)

processed_ultimate_sheet <-
  read_parquet(config$data_sheet_with_pcs)

psi_covars <- processed_ultimate_sheet %>%
  select(c(
    "Grid_ID",
    "pc1",
    "pc2",
    "pc3",
    "pc4",
    "NDVI",
    "Human_disturbance_score",
    "Dist_to_PA_km",
    "total_land_area_per_grid_sqkm"
  )) %>%
  mutate(
    across(c(
      "NDVI",
      "Human_disturbance_score",
      "Dist_to_PA_km",
      "total_land_area_per_grid_sqkm"
    ), scale)
  )
p_covars <- processed_ultimate_sheet %>%
  select(matches("Rain_score_|HD_Vehicles_|substrate_score_")) %>%
  utils$combine_columns_by_prefix()

#--------------------Models--------------------
grids_and_elephants_survey <- processed_ultimate_sheet %>%
  select("Grid_ID", starts_with("Elephant_"))

hines_models <- lapply(
  formulae$elephant_models,
  function(formula) {
    models$calculate_hines_occupancy(
      site_and_detection_history = grids_and_elephants_survey,
      model_formula = formula,
      unitcov = psi_covars,
      survcov = p_covars
    )
  }
)
aic_table <- createAicTable(
  hines_models,
  use.aicc = TRUE
)
coeffs_table <- hines_models %>%
  map(.f = ~ coef(.x, param = "psi", prob = 0.05)) %>%
  bind_rows() %>%
  tibble::rownames_to_column(var = "model") %>%
  tibble()

write_csv(
  x = aic_table$table,
  file = config$elephants_pc_table
)
write_csv(
  x = coeffs_table,
  file = config$elephants_pc_coeffs
)

#--------------------Final Models--------------------
clusterExport(
  cluster,
  varlist = c(
    "models",
    "grids_and_elephants_survey",
    "psi_covars",
    "p_covars"
  )
)

hines_models_final <- foreach(
  formula = formulae$elephant_models_final,
  .packages = c("RPresence", "dplyr")
) %dopar% {
  models$calculate_hines_occupancy(
    site_and_detection_history = grids_and_elephants_survey,
    model_formula = formula,
    unitcov = psi_covars,
    survcov = p_covars
  )
}
aic_table_final <- createAicTable(
  hines_models_final,
  use.aicc = TRUE
)
coeffs_table_final <- hines_models_final %>%
  map(.f = ~ coef(.x, param = "psi", prob = 0.05)) %>%
  bind_rows() %>%
  tibble::rownames_to_column(var = "model") %>%
  tibble()

write_csv(
  x = aic_table_final$table,
  file = config$elephants_final_aic_table
)
write_csv(
  x = coeffs_table_final,
  file = config$elephants_final_coeffs
)

utils$cleanup_parallel(cluster)

#--------------------Predictions--------------------
prediction_data <- utils$create_prediction_data(
  psi_covars,
  colnames(hines_models_final[[2]]$data$unitcov),
  datapoints = 100
)

pred_plots <- utils$create_predictive_plots(
  sample_data = prediction_data,
  model = hines_models_final[[2]],
  plot_title = "Predictions scaled values",
  subplot_titles = colnames(prediction_data),
  x_labels = colnames(prediction_data)
)

pred_plots

test_func <- function(model_num) {
  prediction_data <- utils$create_prediction_data(
    psi_covars,
    colnames(hines_models_final[[model_num]]$data$unitcov),
    datapoints = 100
  )

  pred_plots <- utils$create_predictive_plots(
    sample_data = prediction_data,
    model = hines_models_final[[model_num]],
    plot_title = "Predictions scaled values",
    subplot_titles = colnames(prediction_data),
    x_labels = colnames(prediction_data)
  )

  pred_plots
}

test_func(11)
