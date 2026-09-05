# set working directory
setwd("/data2/projects/dyao/lty_snp/03.gatk/01_joined_genotype1/popkin_relatedness")

# load required packages
library(BEDMatrix)
library(popkin)

# load genotype data from bed file
X <- BEDMatrix("lty_converted.bed")
dim(X)

# estimate kinship matrix
kinship <- popkin(X)

# plot kinship matrix
plot_popkin(
  kinship, 
  mar = 1
)

# display histogram of kinship values
hist(kinship)

# write full kinship matrix to tsv
write.table(kinship, file = "kinship.tsv", quote = FALSE, row.names = TRUE, col.names = TRUE, sep = "\t")

# write inbreeding coefficients to tsv
write.table(inbr_diag(kinship), file = "kinship_diaginbrdcoef.tsv", quote = FALSE, row.names = TRUE, col.names = TRUE, sep = "\t")

# calculate pairwise fst from kinship
pairwise_fst <- pwfst(kinship)

# plot pairwise fst matrix
leg_title <- expression(paste('Pairwise ', F[ST]))
plot_popkin(
  pairwise_fst,
  labs_even = TRUE,
  labs_line = 1,
  labs_cex = 0.7,
  leg_title = leg_title,
  mar = c(2, 0.2)
)