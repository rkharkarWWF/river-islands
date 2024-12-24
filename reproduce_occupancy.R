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
sys.source("./orig_covariates.R", envir = formulae)
#covariates for occupancy and detection
library(readr)
library(dplyr)
library(tidyr)
library(magrittr)
library(purrr)

processed_ultimate_sheet <-
  utils$preprocess_ultimate_sheet(
    config$merged_data_sheet
  )
utils$save_correlations(
  processed_ultimate_sheet,
  config$correlation_images
)

#--------------------Naive occupancies--------------------
naive_occupancies <- data.frame(
  Animal = config$animals,
  Occupancy = NA_real_,
  stringsAsFactors = FALSE
)
naive_occupancies$Occupancy <- sapply(config$animals, function(name) {
  models$calculate_naive_occupancy(processed_ultimate_sheet, name)
})
write_csv(naive_occupancies, config$naive_occupancies_file)

#--------------------Reproduce elephants--------------------
grids_and_elephants_survey <- processed_ultimate_sheet %>%
  select("Grid_ID", starts_with("Elephant_"))
psi_covars_elephants <- processed_ultimate_sheet %>%
  select(c(
    "total_land_area_per_grid_sqkm",
    "NDVI",
    "Dist_to_PA_km",
    "Human_disturbance_score",
    "cattle"
  ))
p_covars_elephants <- processed_ultimate_sheet %>%
  select(matches("Rain_score_|HD_Vehicles_|substrate_score_")) %>%
  utils$combine_columns_by_prefix()

elephants_hines_occupancy <- lapply(
  formulae$elephants_models,
  function(formula) {
    models$calculate_hines_occupancy(
      site_and_detection_history = grids_and_elephants_survey,
      model_formula = formula,
      unitcov = psi_covars_elephants,
      survcov = p_covars_elephants
    )
  }
)

hines_aic_elephants <- createAicTable(
  elephants_hines_occupancy,
  use.aicc = TRUE
)
write_csv(
  x = hines_aic_elephants$table,
  file = config$orig_elephants_aic_table
)

prediction_data_elephants <- utils$create_prediction_data(
  datasheet = processed_ultimate_sheet,
  columns = c("NDVI", "Human_disturbance_score")
)

occupancy_plot_elephants <- utils$create_predictive_plots(
  sample_data = prediction_data_elephants,
  model = elephants_hines_occupancy[[as.numeric(
    rownames(hines_aic_elephants$table)[[1]]
  )]],
  plot_title = "Elephant Occupancy",
  subplot_titles = c("NDVI", "Human disturbance"),
  x_labels = c("NDVI", "Human disturbance index")
)
ggsave(
  filename = config$orig_elephants_occupancy_plot,
  plot = occupancy_plot_elephants
)

#--------------------reproduce rhinos--------------------
grids_and_rhinos_survey <- processed_ultimate_sheet %>%
  select("Grid_ID", starts_with("One_horned_rhino_"))
psi_covars_rhinos <- processed_ultimate_sheet %>%
  select(c(
    "NDVI",
    "Dist_to_PA_km",
    "Human_disturbance_score"
  ))
p_covars_rhinos <- processed_ultimate_sheet %>%
  select(matches("anthro_")) %>%
  mutate(across(everything(), ~ as.numeric(. > 0))) %>%
  utils$combine_columns_by_prefix()

rhinos_hines_occupancy <- lapply(
  formulae$rhinos_models,
  function(formula) {
    models$calculate_hines_occupancy(
      site_and_detection_history = grids_and_rhinos_survey,
      model_formula = formula,
      unitcov = psi_covars_rhinos,
      survcov = p_covars_rhinos
    )
  }
)

hines_aic_rhinos <- createAicTable(rhinos_hines_occupancy, use.aicc = TRUE)
write_csv(
  x = hines_aic_rhinos$table,
  file = config$orig_rhinos_aic_table
)

prediction_data_rhinos <- utils$create_prediction_data(
  datasheet = processed_ultimate_sheet,
  columns = c("NDVI", "Human_disturbance_score")
)

occupancy_plot_rhinos <- utils$create_predictive_plots(
  sample_data = prediction_data_rhinos,
  model = rhinos_hines_occupancy[[as.numeric(
    rownames(hines_aic_rhinos$table)[[1]]
  )]],
  plot_title = "Rhino Occupancy",
  subplot_titles = c("NDVI", "Human disturbance"),
  x_labels = c("NDVI", "Human disturbance index")
)
ggsave(
  filename = config$orig_rhinos_occupancy_plot,
  plot = occupancy_plot_rhinos
)
