library(dplyr)
library(tidyr)
library(magrittr)
library(purrr)
library(stringr)
library(corrr)
library(ggplot2)

convert_counts_to_boolean <- function(tibble, col_indexes) {
  tibble %>%
    mutate(across(all_of(col_indexes), ~ case_when(
      . > 0 ~ 1,
      . == 0 ~ 0,
      TRUE ~ NA_real_
    )))
}

add_cols_for_means <- function(tibble) {
  tibble %>%
    mutate(mean_HD_Vehicles = rowMeans(select(
      tibble,
      starts_with("HD_Vehicles_")
    ), na.rm = TRUE)) %>%
    mutate(mean_HD_Livestocksightings = rowMeans(select(
      tibble,
      starts_with("livestock_")
    ), na.rm = TRUE)) %>%
    mutate(mean_HD_People = rowMeans(select(
      tibble,
      starts_with("HD_People_")
    ), na.rm = TRUE)) %>%
    mutate(mean_HD_Trash = rowMeans(select(
      tibble,
      starts_with("HD_Trash_")
    ), na.rm = TRUE)) %>%
    mutate(mean_rain_score = rowMeans(select(
      tibble,
      starts_with("Rain_score_")
    ), na.rm = TRUE))
}

summarize_columns <- function(datasheet) {
  datasheet %>%
    mutate(
      cattle = as.numeric(rowSums(
        x = select(., starts_with("Cattle_")),
        na.rm = TRUE
      ) > 0)
    )
}

reorder_columns <- function(datasheet) {
  ordered_columns <- with(datasheet, {
    data.frame(
      col_name = names(datasheet),
      base_name = str_extract(names(datasheet), "^(.*)_"),
      number = as.numeric(str_extract(names(datasheet), "\\d+"))
    ) %>%
      arrange(base_name, number) %>%
      pull(col_name)
  })

  datasheet %>% select(all_of(ordered_columns))
}

preprocess_ultimate_sheet <- function(ultimate_sheet_path) {
  master_sheet <- readr::read_csv(
    file = ultimate_sheet_path,
    show_col_types = FALSE
  )

  master_sheet <- master_sheet %>%
    convert_counts_to_boolean(23:152) %>%
    add_cols_for_means() %>%
    summarize_columns() %>%
    reorder_columns()
}

save_correlations <- function(master_sheet, filenames) {
  correlation_set1 <- master_sheet %>% select(c(
    "mean_livestock_wildprey",
    "Dist_to_PA_km",
    "livestock",
    "Human_disturbance_score",
    "total_land_area_per_grid_sqkm",
    "NDVI",
    "wildprey"
  ))

  plot <- correlation_set1 %>%
    corrr::correlate(method = "pearson", use = "pairwise.complete.obs") %>%
    corrr::rearrange(method = "MDS") %>%
    corrr::shave() %>%
    corrr::rplot(print_cor = TRUE) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1))

  ggplot2::ggsave(filename = filenames[[1]], plot = plot)

  correlation_set2 <- master_sheet %>% select(c(
    "mean_HD_Vehicles",
    "mean_HD_Livestocksightings",
    "mean_HD_People",
    "mean_HD_Trash",
    "mean_rain_score"
  ))

  plot2 <- correlation_set2 %>%
    corrr::correlate(method = "pearson", use = "pairwise.complete.obs") %>%
    corrr::rearrange(method = "MDS") %>%
    corrr::shave() %>%
    corrr::rplot(print_cor = TRUE) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1))

  ggplot2::ggsave(filename = filenames[[2]], plot = plot2)
}

combine_columns_by_prefix <- function(datasheet) {
  prefixes <- unique(
    str_extract(names(datasheet), "^(.*)(?=_[^_]+$)")
  )
  as_tibble(sapply(prefixes, function(prefix) {
    unlist(
      select(datasheet, starts_with(prefix)),
      use.names = FALSE
    )
  }))
}

create_prediction_data <- function(
  datasheet,
  columns,
  datapoints = 100
) {
  data_matrix <- matrix(
    data = list(rep(0, datapoints)),
    nrow = length(columns),
    ncol = length(columns)
  )
  for (i in seq_len(nrow(data_matrix))) {
    column_data <- datasheet[[columns[i]]]
    data_matrix[[i, i]] <- seq(
      from = trunc(min(column_data, na.rm = TRUE) * 10) / 10,
      to = trunc(max(column_data, na.rm = TRUE) * 10) / 10,
      length.out = datapoints
    )
  }

  data_matrix %>%
    data.frame() %>%
    setNames(columns) %>%
    unnest(everything())
}

create_predictive_plots <- function(
  sample_data,
  model,
  titles,
  x_labels
) {
  if ((ncol(sample_data) != length(x_labels)) ||
      length(titles) != length(x_labels)
  ) {
    print(
      "Number of labels does not equal number of variables.
Stopping predictions."
    )
    return()
  }

  sample_data_renamed <- setNames(
    object = sample_data,
    nm = x_labels
  )
  predictions <- predict(
    object = model,
    newdata = sample_data,
    param = "psi"
  )
  plot_data <- tibble(sample_data_renamed, predictions)
  plot_data_long <- plot_data %>%
    tidyr::pivot_longer(
      cols = !colnames(predictions),
      names_to = "Labels",
      values_to = "Values"
    )
  plot_data_long$Values[plot_data_long$Values == 0] <- NA

  ggplot(
    data = plot_data_long,
    mapping = aes(x = Values, y = est)
  ) +
    geom_line() +
    geom_ribbon(
      mapping = aes(ymin = lower_0.95, ymax = upper_0.95),
      fill = "grey80",
      alpha = 0.3
    ) +
    labs(
      title = "Elephant occupancy",
      y = "Occupancy probability"
    ) +
    facet_wrap(
      ~ Labels,
      ncol = 2,
      scales = "free_x",
      labeller = labeller(Labels = setNames(titles, x_labels))
    ) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5))
}
