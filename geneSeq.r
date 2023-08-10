if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GEOquery")

#Load libraries
library(dplyr)
library(tidyverse)
library(GEOquery)

# Read the data
dat <- read.csv(file = "../project/data/GSE183947_fpkm.csv")

# Get Metadata
gse <- getGEO(GEO = 'GSE183947', GSEMatrix = TRUE)
Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 1000)

gse

metadata <- pData(phenoData(gse[[1]]))
head(metadata)

metadata.subset <- select(metadata, c(1,10,11,17))

metadata.modified <- metadata %>%
  select(1,10,11,17) %>%
  rename(tissue = characteristics_ch1) %>%
  rename(metastasis = characteristics_ch1.1) %>%
  mutate(tissue = gsub("tissue: ", "", tissue)) %>%
  mutate(metastasis = gsub("metastasis: ", "", metastasis))

head(dat)

# Reashaping the data into the 'long format'
dat.long <- dat %>%
  rename(gene = X) %>%
  gather(key='samples', value='FPKM', -gene) 

# join dataframes = dat.long + metadata.modified
dat.long <- dat.long %>%
  left_join(., metadata.modified, by = c("samples" = "description"))

# explore the data
dat.long <- dat.long %>%
  filter(gene == "BRCA1" | gene=="BRCA2") %>%
  group_by(gene, tissue) %>%
  summarize(mean_FPKM = mean(FPKM),
            median_FPKM = median(FPKM)) %>%
  arrange(-mean_FPKM) 

dat.long


#plot:
library(ggplot2)

# Create a grouped bar plot
plot <- ggplot(dat.long, aes(x = gene, y = mean_FPKM, fill = tissue)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Mean FPKM Values for Genes by Tissue",
       x = "Gene", y = "Mean FPKM") +
  theme_minimal()

# Show the plot
print(plot)
