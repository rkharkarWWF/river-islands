base_model <- c(
  psi ~ 1,
  p ~ 1
)

#--------------------Human activity--------------------
hum_act_models <- list(
  c(
    psi ~ mean_HD_People,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Livestocksightings,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Lopping,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Grass_bamboo_cut,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Trash,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Mining,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Garbage_dump,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Vehicles,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_built_up,
    p ~ 1
  ),
  c(
    psi ~ mean_HD_Feral_dogs,
    p ~ 1
  ),
  c(
    psi ~ wildprey,
    p ~ 1
  )
)

#--------------------Add in other covars--------------------
hum_activity_plus_others <- list(
  c(
    psi ~
      wildprey +
      mean_HD_People +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      NDVI +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      NDVI,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People,
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
      wildprey +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_People +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      NDVI,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      NDVI +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      wildprey +
      total_land_area_per_grid_sqkm +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_People +
      NDVI,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_People +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_People +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_People +
      NDVI +
      Dist_to_PA_km,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_People +
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ 1
  ),
  c(
    psi ~
      mean_HD_People +
      total_land_area_per_grid_sqkm +
      Dist_to_PA_km,
    p ~ 1
  )
)

#--------------------Try detection covars--------------------
detection_models <- list(
  c(
    psi ~ 1,
    p ~ Rain_score
  ),
  c(
    psi ~ 1,
    p ~ substrate_score
  ),
  c(
    psi ~ 1,
    p ~ HD_Vehicles
  ),
  c(
    psi ~ 1,
    p ~ Rain_score + substrate_score
  ),
  c(
    psi ~ 1,
    p ~ Rain_score + HD_Vehicles
  ),
  c(
    psi ~ 1,
    p ~ substrate_score + HD_Vehicles
  ),
  c(
    psi ~ 1,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~ 1,
    p ~ 1
  )
)

#--------------------Try detection covars--------------------
final_models <- list(
  c(
    psi ~
      wildprey +
      mean_HD_People +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      NDVI +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      NDVI,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      mean_HD_People,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      NDVI +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      NDVI,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      mean_HD_People +
      NDVI +
      Dist_to_PA_km +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      NDVI,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      NDVI +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      wildprey +
      total_land_area_per_grid_sqkm +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      mean_HD_People +
      NDVI,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      mean_HD_People +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      mean_HD_People +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      mean_HD_People +
      NDVI +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      mean_HD_People +
      NDVI +
      total_land_area_per_grid_sqkm,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~
      mean_HD_People +
      total_land_area_per_grid_sqkm +
      Dist_to_PA_km,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~ 1,
    p ~ Rain_score + substrate_score + HD_Vehicles
  ),
  c(
    psi ~ 1,
    p ~ 1
  )
)
