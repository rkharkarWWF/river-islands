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
