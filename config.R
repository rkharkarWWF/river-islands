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
elephants_final_final_plot <-
  "./elephants/images/elephants_actual_final.png"

#--------------------Rhino output files--------------------
rhinos_ss_hines_comp <- "./rhinos/output/ss_v_hines.csv"
rhinos_hum_act_aic_table <- "./rhinos/output/hum_act_aic.csv"
rhinos_hum_act_coeffs <- "./rhinos/output/hum_act_coeffs.csv"

rhinos_hum_act_plus_others_aic_table <-
  "./rhinos/output/hum_act_plus_others_aic.csv"
rhinos_hum_act_plus_others_coeffs <-
  "./rhinos/output/hum_act_plus_others_coeffs.csv"
rhinos_hum_act_plus_others_plot <-
  "./rhinos/images/hum_act_plus_others.png"

rhinos_detection_aic <- "./rhinos/output/detection_aic.csv"
rhinos_detection_coeffs <- "./rhinos/output/detection_coeffs.csv"

rhinos_final_aic_table <- "./rhinos/output/final_aic.csv"
rhinos_final_coeffs <- "./rhinos/output/final_coeffs.csv"
rhinos_final_p_coeffs <- "./rhinos/output/final_p_coeffs.csv"
rhinos_final_coeffs_best_model <-
  "./rhinos/output/final_coeffs_best_model.csv"
rhinos_final_p_coeffs_best_model <-
  "./rhinos/output/final_p_coeffs_best_model.csv"
rhinos_final_plot <-
  "./rhinos/images/final.png"
rhinos_psi_values <-
  "./rhinos/output/psi.csv"

#--------------------Tigers output--------------------
tigers_ss_hines_comp <- "./tigers/output/ss_v_hines.csv"

tigers_hum_act_aic <- "./tigers/output/human_activity_aic.csv"
tigers_hum_act_coeffs <- "./tigers/output/human_activity_coeffs.csv"

tigers_hum_act_plus_others_aic <-
  "./tigers/output/human_activity_plus_others_aic.csv"
tigers_hum_act_plus_others_coeffs <-
  "./tigers/output/human_activity_plus_others_coeffs.csv"
tigers_hum_act_plus_others_plot <-
  "./tigers/images/human_activity_plus_others.png"

tigers_detection_aic <-
  "./tigers/output/detection_aic.csv"
tigers_detection_coeffs <-
  "./tigers/output/detection_coeffs.csv"

# Tigers final
tigers_final_aic <-
  "./tigers/output/final_aic.csv"
tigers_final_coeffs <-
  "./tigers/output/final_coeffs.csv"
tigers_final_coeffs_best_model <-
  "./tigers/output/final_coeffs_best_model.csv"
tigers_final_p_coeffs_best_model <-
  "./tigers/output/final_p_coeffs_best_model.csv"
tigers_final_plot <-
  "./tigers/images/final.png"
tigers_psi_values <-
  "./tigers/output/psi.csv"

#--------------------Files for redoing elephants--------------------
elephants_ss_hines_comp <- "./elephants/output/ss_v_hines.csv"

elephants_hum_act_aic <- "./elephants/output/human_activity_aic.csv"
elephants_hum_act_coeffs <- "./elephants/output/human_activity_coeffs.csv"

elephants_hum_act_plus_others_aic <-
  "./elephants/output/human_activity_plus_others_aic.csv"
elephants_hum_act_plus_others_coeffs <-
  "./elephants/output/human_activity_plus_others_coeffs.csv"
elephants_hum_act_plus_others_plot <-
  "./elephants/images/human_activity_plus_others.png"

elephants_detection_aic <-
  "./elephants/output/detection_aic.csv"
elephants_detection_coeffs <-
  "./elephants/output/detection_coeffs.csv"

#Elephants pre-final
elephants_pre_final_aic <-
  "./elephants/output/pre_final_aic.csv"
elephants_pre_final_coeffs <-
  "./elephants/output/pre_final_coeffs.csv"
elephants_pre_final_p_coeffs <-
  "./elephants/output/pre_final_p_coeffs.csv"

# Elephants final
elephants_final_aic <-
  "./elephants/output/final_aic.csv"
elephants_final_coeffs <-
  "./elephants/output/final_coeffs.csv"
elephants_final_p_coeffs <-
  "./elephants/output/final_p_coeffs.csv"
elephants_final_coeffs_best_model <-
  "./elephants/output/final_coeffs_best_model.csv"
elephants_final_p_coeffs_best_model <-
  "./elephants/output/final_p_coeffs_best_model.csv"
elephants_final_plot <-
  "./elephants/images/final.png"
elephants_psi_values <-
  "./elephants/output/psi.csv"
