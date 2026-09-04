setwd("/data2/projects/dyao/compare/hyphy/06_relax_genespace_Basso/GO/fdr_0.1")
#install.packages("ggplot2")
library(ggplot2)

dat = read.table("relaxed_fdr_0.1_p_0.05_GO_BP.txt",header = T,sep = "\t", fill = TRUE)

dat_filtered <- dat[dat$pvalue <= 0.05, ]
dat_filtered <- na.omit(dat_filtered)

#dat_filtered <- dat_filtered[order(dat_filtered$pvalue), ]

dat_filtered$Description <- factor(dat_filtered$Description, 
                                   levels = rev(dat_filtered$Description[order(dat_filtered$pvalue)]))
p <- ggplot(dat_filtered, aes(y = Count, x = Description, fill = pvalue)) + 
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() + 
  theme_bw() +
  scale_fill_gradientn(colors = c("#FF0000", "#800080", "#0000FF")) +  # 红色到紫色到蓝色
  theme(plot.title = element_text(hjust = 0.5),
        strip.text.y = element_text(size = 14),
        legend.position = "right",
        legend.title = element_text(size = 18),
        legend.text = element_text(size = 14),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 16),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14))
p



ggsave(p,filename = "relaxed_Basso_fdr0.1_GO.pdf",width = 13,height = 11,dpi=300)
ggsave(p,filename = "relaxed_Basso_fdr0.1_GO.svg",width = 13,height = 11,dpi=300)

