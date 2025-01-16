data_sheet_path <- "./data/Ultimate_Master_sheet.csv"
disturbance_score_factors <- "./data/Human_disturbance_score.csv"
merged_data_sheet <- "./data/Ultimate_Ultimate_Master_sheet.parquet"
data_sheet_with_pcs <- "./data/data_sheet_with_pcs.parquet"
data_sheet_with_new_ndvi <- "./data/data_with_ndvi.parquet"
ndvi_sheet <- "./data/Mean_and_SD_NDVI_in_grid_cells.csv"

animals <- c(
  "Elephant",
  "Small_cat",
  "Wild_buffalo",
  "One_horned_rhino",
  "Tiger"
)

naive_occupancies_file <- "./output/naive_occupancies.csv"

correlation_images <- c(
  "./images/correlation_set1.png",
  "./images/correlation_set2.png"
)
human_dist_covariance <- c(
  "./images/human_dist/correlation.png"
)
human_dist_histograms <- c(
  "./images/human_dist/hists.png"
)
human_dist_scree <- c("./images/human_dist/scree.png")
human_dist_biplot <- c("./images/human_dist/biplot.png")

orig_elephants_occupancy_plot <- "./reproduction/images/elephants_occupancy.png"
orig_rhinos_occupancy_plot <- "./reproduction/images/rhinos_occupancy.png"
final_elephants_occupancy_plot <- "./elephants/images/best_occ_model.png"

human_dist_pca_loadings <- c("./output/human_dist/pca_loadings.csv")

orig_elephants_aic_table <- "./reproduction/output/elephants_models.csv"
orig_rhinos_aic_table <- "./reproduction/output/rhinos_models.csv"

elephants_pc_table <-
  "./elephants/output/elephants_models_pcs.csv"
elephants_pc_coeffs <- "./elephants/output/coeffs_pcs.csv"
elephants_final_aic_table <-
  "./elephants/output/elephants_models_final.csv"
elephants_final_coeffs <- "./elephants/output/coeffs_final.csv"

elephants_hum_impact_aic_table <-
  "./elephants/output/elephants_models_hum_impact.csv"
elephants_hum_impact_coeffs <-
  "./elephants/output/coeffs_hum_impact.csv"
elephants_hum_impact_plus_covars_aic_table <-
  "./elephants/output/elephants_models_hum_impact_plus_covars.csv"
elephants_hum_impact_plus_covars_coeffs <-
  "./elephants/output/coeffs_hum_impact_plus_covars.csv"

elephants_new_ndvi_aic_table <-
  "./elephants/output/elephants_models_new_ndvi.csv"
elephants_new_ndvi_coeffs <-
  "./elephants/output/coeffs_new_ndvi.csv"

elephants_final_final_aic_table <-
  "./elephants/output/elephants_models_actual_final.csv"
