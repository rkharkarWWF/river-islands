elephants_models <- list(
  c(
    psi ~ 1,
    p ~ 1
  ),
  c(
    psi ~ 1,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ total_land_area_per_grid_sqkm,
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
    psi ~ Human_disturbance_score,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ cattle,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ Human_disturbance_score + Dist_to_PA_km,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ NDVI + Human_disturbance_score,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~ NDVI + Human_disturbance_score + Dist_to_PA_km,
    p ~ Rain_score + HD_Vehicles + substrate_score
  ),
  c(
    psi ~
      NDVI +
        Human_disturbance_score +
        Dist_to_PA_km +
        total_land_area_per_grid_sqkm,
    p ~ Rain_score + HD_Vehicles + substrate_score
  )
)

rhinos_models <- list(
  c(
    psi ~ 1,
    p ~ 1
  ),
  c(
    psi ~ 1,
    p ~ anthro
  ),
  c(
    psi ~ NDVI,
    p ~ anthro
  ),
  c(
    psi ~ Human_disturbance_score,
    p ~ anthro
  ),
  c(
    psi ~ Dist_to_PA_km,
    p ~ anthro
  ),
  c(
    psi ~ NDVI + Human_disturbance_score,
    p ~ anthro
  ),
  c(
    psi ~ Dist_to_PA_km + Human_disturbance_score,
    p ~ anthro
  ),
  c(
    psi ~ NDVI + Dist_to_PA_km,
    p ~ anthro
  ),
  c(
    psi ~ NDVI + Dist_to_PA_km + Human_disturbance_score,
    p ~ anthro
  )
)

tigers_models <- list(
  c(
    psi ~ 1,
    p ~ 1
  )
)
