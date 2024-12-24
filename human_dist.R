config <- new.env()
sys.source("./config.R", envir = config)
#config file has filepaths, list of animals, and the models to run
utils <- new.env()
sys.source("./utils.R", envir = utils)
#functions for processing the csv file and for running and saving correlations

library(arrow)
library(dplyr)
library(cowplot)
library(ggplot2)
library(ggbiplot)
library(purrr)

processed_ultimate_sheet <-
  read_parquet(file = config$merged_data_sheet)

human_disturbance_covars <- processed_ultimate_sheet %>%
  select(c(
    "mean_HD_People",
    "mean_HD_Livestocksightings",
    "mean_HD_Lopping",
    "mean_HD_Grass_bamboo_cut",
    "mean_HD_Trash",
    "mean_HD_Mining",
    "mean_HD_Garbage_dump",
    "mean_HD_Vehicles",
    "mean_HD_built_up",
    "mean_HD_Feral_dogs"
  )) %>%
  mutate(
    across(everything(), scale)
  )

#--------------------Histograms--------------------
histograms <- human_disturbance_covars %>%
  map2(
    .y = stringr::str_replace_all(
      colnames(human_disturbance_covars), "mean_", ""
    ),
    .f = ~ ggplot(
      x = .x,
      mapping = aes(x = .x)
    ) +
      geom_histogram(bins = 10) +
      labs(x = .y) +
      theme_minimal()
  )

hists_plot <- cowplot::plot_grid(
  plotlist = histograms,
  ncol = 3
)

ggsave(
  filename = config$human_dist_histograms,
  plot = hists_plot,
  bg = "white"
)

#--------------------Covariance--------------------
plot <- human_disturbance_covars %>%
  corrr::correlate(method = "pearson", use = "pairwise.complete.obs") %>%
  corrr::rearrange(method = "MDS") %>%
  corrr::shave() %>%
  corrr::rplot(print_cor = TRUE) +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1))

ggplot2::ggsave(
  filename = config$human_dist_covariance,
  plot = plot
)

#--------------------PCA--------------------
pca <- human_disturbance_covars %>%
  prcomp(center = FALSE)
scree_values <- tibble(
  components = colnames(pca$rotation),
  variance = pca$sdev ^ 2 / sum(pca$sdev ^ 2),
  cum_variance = cumsum(variance)
) %>%
  arrange(as.numeric(str_extract(components, "\\d+")))

scree <- ggplot(data = scree_values, mapping = aes(
  x = components,
  y = variance
)) +
  geom_col() +
  scale_x_discrete(
    limit = unique(scree_values$components)
  ) +
  labs(
    title = "Human Disturbance PCA",
    x = "Component",
    y = "Variance"
  )
biplot <- ggbiplot(pca)

write_csv(
  x = as.data.frame(pca$rotation) %>%
    rownames_to_column(var = "component"),
  file = config$human_dist_pca_loadings
)

ggsave(
  filename = config$human_dist_scree,
  plot = scree
)
ggsave(
  filename = config$human_dist_biplot,
  plot = biplot
)


#--------------------Attach PCs--------------------
processed_ultimate_sheet %>%
  mutate(
    pc1 = pca$x[, 1],
    pc2 = pca$x[, 2],
    pc3 = pca$x[, 3],
    pc4 = pca$x[, 4]
  ) %>%
  utils$reorder_columns() %>%
  arrow::write_parquet(config$data_sheet_with_pcs)
