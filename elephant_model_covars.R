elephant_models <- list(
  c(
    psi ~ Human_disturbance_score,
    p ~ 1
  ),
  c(
    psi ~ pc1,
    p ~ 1
  ),
  c(
    psi ~ pc2,
    p ~ 1
  ),
  c(
    psi ~ pc3,
    p ~ 1
  ),
  c(
    psi ~ pc4,
    p ~ 1
  ),
  c(
    psi ~ pc1 + pc2,
    p ~ 1
  ),
  c(
    psi ~ pc1 + pc2 + pc3,
    p ~ 1
  ),
  c(
    psi ~ pc1 + pc2 + pc3 + pc4,
    p ~ 1
  ),
  c(
    psi ~ pc1 + pc2 + pc3 + pc4 + NDVI,
    p ~ 1
  ),
  c(
    psi ~ Human_disturbance_score + NDVI,
    p ~ 1
  ),
  c(
    psi ~ 1,
    p ~ Rain_score
  ),
  c(
    psi ~ 1,
    p ~ HD_Vehicles
  ),
  c(
    psi ~ 1,
    p ~ substrate_score
  ),
  c(
    psi ~ 1,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ pc1 + pc2 + pc3 + pc4 + NDVI,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ Human_disturbance_score + NDVI,
    p ~ Rain_score + HD_Vehicles + substrate_score
  )
)

#--------------------supposedly final models--------------------
elephant_models_final <- list(
  c(
    psi ~ 1,
    p ~ 1
  ),
  c(
    psi ~ pc1,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ pc2,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ NDVI,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ Dist_to_PA_km,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ total_land_area_per_grid_sqkm,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ pc1 + pc2 + NDVI,
    p ~ 1
  ),
  c(
    psi ~ 1,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ pc1 + pc2 + NDVI,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ pc1 + pc2 + Dist_to_PA_km,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ pc1 + pc2 + Dist_to_PA_km + NDVI,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ pc1 + pc2 + total_land_area_per_grid_sqkm + NDVI,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ pc1 + pc2 + Dist_to_PA_km + total_land_area_per_grid_sqkm + NDVI,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ pc1 + pc2 + Dist_to_PA_km + total_land_area_per_grid_sqkm,
    p ~ Rain_score + HD_Vehicles + substrate_score
  )
)

#--------------------Human impact models--------------------
more_exp_models <- list(
  c(
    psi ~ mean_HD_People,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_people,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Livestocksightings,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_livestocksightings,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Lopping,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_lopping,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Grass_bamboo_cut,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_grass_bamboo_cut,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Trash,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_trash,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Mining,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_mining,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Garbage_dump,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_garbage_dump,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Vehicles,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_vehicles,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_built_up,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_built_up,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Feral_dogs,
    p ~ 1
  ),
  c(
    psi ~ bool_hd_feral_dogs,
    p ~ 1
  )
)

#--------------------Plus other covars--------------------
hum_impact_plus_others <- list(
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm
   ,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      NDVI +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      NDVI,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up,
    p ~ 1
  ),
  c(
    psi ~
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      NDVI +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      NDVI,
    p ~ 1
  ),
  c(
    psi ~
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_built_up +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ 1
  )
)

#--------------------Test NDVI--------------------
ndvi_comparison_models <- list(
  c(
    psi ~ NDVI_original,
    p ~ 1
  ),
  c(
    psi ~ NDVI_mean,
    p ~ 1
  ),
  c(
    psi ~ NDVI_SD,
    p ~ 1
  ),
  c(
    psi ~ NDVI_mean * NDVI_SD,
    p ~ 1
  )
)

#--------------------Final models--------------------
actual_final_models <- list(
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      NDVI,
    p ~ Rain_score + substrate_score
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up,
    p ~ Rain_score + substrate_score
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score
  ),
  c(
    psi ~
      mean_HD_Vehicles +
      mean_HD_built_up +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score
  ),
  c(
    psi ~ 1,
    p ~ Rain_score + substrate_score
  ),
  c(
    psi ~ 1,
    p ~ 1
  ),
  c(
    psi ~ Human_disturbance_score + NDVI,
    p ~ Rain_score + substrate_score
  )
)
