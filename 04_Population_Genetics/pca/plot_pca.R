# check and load ggplot2 library
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)

# load eigenvalue data
eval_file <- "LTY_PCA_v2_final.eigenval"
eval <- read.table(eval_file, header = FALSE)

# load eigenvector data
evec_file <- "LTY_PCA_v2_final.eigenvec"
pca <- read.table(evec_file, header = TRUE, comment.char = "", check.names = FALSE)

# rename FID column
colnames(pca)[1] <- "FID"

# calculate percent variance explained
pve <- eval$V1 / sum(eval$V1) * 100
pc1_lab <- paste0("PC1 (", round(pve[1], 2), "%)")
pc2_lab <- paste0("PC2 (", round(pve[2], 2), "%)")

# create population column from sample IDs
pca$Population <- sub("-.*", "", pca$IID)

# define custom visualization aesthetics
my_colors <- c(
  "QD"  = "#FCD768",
  "LYG" = "#E39168",
  "ZS"  = "#015D89",
  "WZ"  = "#A25EA7",
  "YJ"  = "#CC7396",
  "LG"  = "#004B28"
)

my_shapes <- c(
  "LG"  = 16, 
  "WZ"  = 16,
  "LYG" = 15, 
  "ZS"  = 15,
  "QD"  = 17, 
  "YJ"  = 17
)

# generate scatter plot
p <- ggplot(pca, aes(x = PC1, y = PC2, color = Population, shape = Population)) +
  geom_point(size = 7.5, alpha = 0.8) +
  theme_bw() +
  scale_color_manual(values = my_colors) +
  scale_shape_manual(values = my_shapes) +
  labs(
    title = "PCA of LTY Samples",
    x = pc1_lab,
    y = pc2_lab,
    color = "Population",
    shape = "Population"
  ) +
  theme(
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 12),
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 12),
    legend.position = "right"
  )

# save plot to file
output_file <- "PCA_PC1_PC2_no_labels.pdf"
ggsave(output_file, plot = p, width = 8, height = 7)

# print completion message
cat(paste0("Success: PCA plot has been saved to ", output_file, "\n"))