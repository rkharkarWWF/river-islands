config <- new.env()
sys.source("config.R", envir = config)

library(readr)
library(dplyr)
library(arrow)

ultimate_sheet <- read_csv(
  file = config$data_sheet_path,
  show_col_types = FALSE
)
hum_dist_determinants <- read_csv(
  file = config$disturbance_score_factors,
  show_col_types = FALSE
)

hum_dist_determinants <- hum_dist_determinants %>%
  mutate(
    bool_hd_people = as.numeric(mean_HD_People > 0),
    bool_hd_livestocksightings = as.numeric(mean_HD_Livestocksightings > 0),
    bool_hd_lopping = as.numeric(mean_HD_Lopping > 0),
    bool_hd_grass_bamboo_cut = as.numeric(mean_HD_Grass_bamboo_cut > 0),
    bool_hd_trash = as.numeric(mean_HD_Trash > 0),
    bool_hd_mining = as.numeric(mean_HD_Mining > 0),
    bool_hd_garbage_dump = as.numeric(mean_HD_Garbage_dump > 0),
    bool_hd_vehicles = as.numeric(mean_HD_Vehicles > 0),
    bool_hd_feral_dogs = as.numeric(mean_HD_Feral_dogs),
    bool_hd_built_up = as.numeric(mean_HD_built_up)
  ) %>%
  dplyr::select(-c(
    Human_disturbance_score,
    Human_Population,
    mean_nightlight_score,
    ...14
  ))

merged_table <- left_join(
  x = ultimate_sheet,
  y = hum_dist_determinants,
  by = "Grid_ID",
  keep = FALSE
)

write_parquet(
  x = merged_table,
  sink = config$merged_data_sheet
)
