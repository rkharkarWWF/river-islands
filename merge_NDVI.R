config <- new.env()
sys.source("config.R", envir = config)

utils <- new.env()
sys.source("utils.R", envir = utils)

library(arrow)
library(readr)

data_sheet <- read_parquet(config$data_sheet_with_pcs)
ndvi_sheet <- read_csv(
  config$ndvi_sheet,
  show_col_types = FALSE
)

merged <- left_join(
  data_sheet,
  distinct(
    ndvi_sheet,
    Grid_ID,
    .keep_all = TRUE
  ),
  by = join_by(Grid_ID)
)

merged %>%
  mutate(
    NDVI_original = NDVI,
    NDVI = NDVI_mean
  ) %>%
  ungroup() %>%
  select(-NDVI_mean) %>%
  utils$reorder_columns() %>%
  write_parquet(config$data_sheet_with_new_ndvi)
