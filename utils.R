models <- new.env()
sys.source("models.R", envir = models)

library(dplyr)
library(tidyr)
library(magrittr)
library(purrr)
library(stringr)
library(corrr)
library(ggplot2)
library(parallel)
library(doParallel)
library(arrow)
library(readr)
library(foreach)

convert_counts_to_boolean <- function(tibble, col_indexes) {
  tibble %>%
    mutate(across(all_of(col_indexes), ~ case_when(
      . > 0 ~ 1,
      . == 0 ~ 0,
      TRUE ~ NA_real_
    )))
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
      base_name = str_extract(names(datasheet), "^(.*)_?"),
      number = as.numeric(str_extract(names(datasheet), "\\d+"))
    ) %>%
      arrange(base_name, number) %>%
      pull(col_name)
  })

  datasheet %>% select(all_of(ordered_columns))
}

preprocess_ultimate_sheet <- function(ultimate_sheet_path) {
  master_sheet <- arrow::read_parquet(
    file = ultimate_sheet_path,
    show_col_types = FALSE
  )

  master_sheet <- master_sheet %>%
    convert_counts_to_boolean(23:152) %>%
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
    "mean_HD_Trash"
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
    column_data <- datasheet[,i]
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

unscale <- function(
  col_to_unscale,
  dataframe_to_unscale_by,
  col_to_unscale_by
  ) {
  scaled_scale <- attr(
    dataframe_to_unscale_by[[col_to_unscale_by]],
    "scaled:scale")
  scaled_center <- attr(
    dataframe_to_unscale_by[[col_to_unscale_by]],
    "scaled:center"
  )
  col_to_unscale * scaled_scale + scaled_center
}

create_predictive_plots <- function(
  sample_data,
  model,
  plot_title,
  subplot_titles,
  x_labels,
  columns_to_unscale_by = NULL
) {
  if ((ncol(sample_data) != length(x_labels)) ||
      length(subplot_titles) != length(x_labels)
  ) {
    print(
      "Number of labels does not equal number of variables.
Stopping predictions."
    )
    return()
  }

  predictions <- predict(
    object = model,
    newdata = sample_data,
    param = "psi"
  )

  sample_data_rescaled <- sample_data
  sample_data_rescaled[sample_data_rescaled == 0] <- NA
  if (is.data.frame(columns_to_unscale_by)) {
    cols_to_unscale <- colnames(sample_data)
    sample_data_rescaled <- sample_data_rescaled %>%
      mutate(across(
        all_of(cols_to_unscale),
        ~ unscale(.x, columns_to_unscale_by, cur_column())
      ))
  }
  sample_data_renamed <- setNames(
    object = sample_data_rescaled,
    nm = x_labels
  )

  plot_data <- tibble(sample_data_renamed, predictions)
  plot_data_long <- plot_data %>%
    tidyr::pivot_longer(
      cols = !colnames(predictions),
      names_to = "Labels",
      values_to = "Values"
    )

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
      title = plot_title,
      y = "Occupancy probability",
      x = "Mean Values"
    ) +
    facet_wrap(
      ~ Labels,
      ncol = 2,
      scales = "free_x",
      labeller = labeller(Labels = setNames(subplot_titles, x_labels))
    ) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5))
}

setup_parallel <- function() {
  num_cores <- detectCores() - 1
  cluster <- makeCluster(num_cores)
  registerDoParallel(cluster)
  return(cluster)
}

cleanup_parallel <- function(cluster) {
  stopCluster(cluster)
}

run_models_return_output <- function(
  datasheet_path,
  animal_prefix,
  models_list,
  psi_covars_list = NULL,
  mutation_list = NULL,
  p_covars_match_string = NULL,
  aic_table_filepath = NULL,
  coeffs_table_filepath = NULL,
  p_coeffs_table_filepath = NULL,
  preds_image_filepath = NULL
) {
  datasheet <- read_parquet(datasheet_path)
  print("Datasheet successfully read")

  grids_and_occupancy <- datasheet %>%
    select("Grid_ID", starts_with(animal_prefix))
  psi_covars <- NULL
  if (is.atomic(psi_covars_list)) {
    psi_covars <- datasheet %>%
      select(all_of(psi_covars_list)) %>%
      mutate(across(all_of(mutation_list), scale))
  }
  p_covars <- NULL
  if (is.character(p_covars_match_string)) {
    p_covars <- datasheet %>%
      select(matches(p_covars_match_string)) %>%
      combine_columns_by_prefix()
  }
  print("psi and p covars tables initialized")

  if (!is.list(models_list) || !length(models_list)) {
    stop("Must provide formulae list to run models")
  }

  cluster <- setup_parallel()

  print("starting models")
  hines_models <- foreach(
    formula = models_list,
    .packages = c("RPresence", "dplyr"),
    .export = c("models")
  ) %dopar% {
    models$calculate_hines_occupancy(
      site_and_detection_history = grids_and_occupancy,
      model_formula = formula,
      unitcov = psi_covars,
      survcov = p_covars
    )
  }
  print("models done")
  cleanup_parallel(cluster)

  aic <- createAicTable(
    hines_models,
    use.aicc = TRUE
  )

  model_order <- as.numeric(rownames(aic$table))
  hines_models_reordered <- hines_models[model_order]

  coeffs_table <- hines_models_reordered %>%
    map(.f = ~coef(.x, param = "psi", prob = 0.05)) %>%
    bind_rows() %>%
    tibble::rownames_to_column(var = "model") %>%
    tibble()

  coeffs_table_p <- hines_models_reordered %>%
    map(.f = ~coef(.x, param = "p", prob = 0.05)) %>%
    bind_rows() %>%
    tibble::rownames_to_column(var = "model") %>%
    tibble()

  print("writing aic and coeffs tables if required")
  if (is.character(aic_table_filepath)) {
    write_csv(
      aic$table,
      aic_table_filepath
    )
  }
  if (is.character(coeffs_table_filepath)) {
    write_csv(
      coeffs_table,
      coeffs_table_filepath
    )
  }
  if (is.character(p_coeffs_table_filepath)) {
    write_csv(
      coeffs_table_p,
      p_coeffs_table_filepath
    )
  }

  print("creating plots for top model")
  pred_plots <- NULL
  if (is.character(preds_image_filepath)) {
    prediction_data <- create_prediction_data(
      psi_covars,
      colnames(hines_models_reordered[[1]]$data$unitcov),
      datapoints = 100
    )

    pred_plots <- create_predictive_plots(
      sample_data = prediction_data,
      model = hines_models_reordered[[1]],
      plot_title = "Predictions scaled values",
      subplot_titles = colnames(prediction_data),
      x_labels = colnames(prediction_data)
    )

    ggsave(
      filename = preds_image_filepath,
      plot = pred_plots
    )
  }

  return(list(
    "datasheet" = datasheet,
    "psi_covars" = psi_covars,
    "p_covars" = p_covars,
    "aic" = aic,
    "models" = hines_models_reordered,
    "plot" = pred_plots
  ))
}

show_model_plots <- function(model) {
  prediction_data <- create_prediction_data(
    model$data$unitcov,
    colnames(model$data$unitcov),
    datapoints = 100
  )

  create_predictive_plots(
    sample_data = prediction_data,
    model = model,
    plot_title = "Predictions scaled values",
    subplot_titles = colnames(prediction_data),
    x_labels = colnames(prediction_data)
  )
}
