library(dplyr)
library(RPresence)

calculate_naive_occupancy <- function(
  ultimate_sheet,
  animal
) {

  num_sites_total <- nrow(ultimate_sheet)
  num_sites_occupied <- ultimate_sheet %>%
    select(starts_with(animal)) %>%
    filter(if_any(everything(), ~ . == 1)) %>%
    nrow()
  return(num_sites_occupied / num_sites_total)
}

calculate_ss_occupancy <- function(
  site_and_detection_history,
  model_formula,
  ...
) {
  pao_obj <- createPao(
    data = select(site_and_detection_history, -1),
    unitnames = pull(site_and_detection_history, 1),
    ...
  )

  occMod(
    model = model_formula,
    type = "so",
    data = pao_obj,
    seed = 100,
    randinit = 50
  )
}

calculate_hines_occupancy <- function(
  site_and_detection_history,
  model_formula,
  ...
) {
  pao_obj <- createPao(
    data = select(site_and_detection_history, -1),
    unitnames = pull(site_and_detection_history, 1),
    ...
  )

  occMod(
    model = append(model_formula, theta ~ PRIME),
    type = "so.cd",
    data = pao_obj,
    seed = 100,
    randinit = 200
  )
}
