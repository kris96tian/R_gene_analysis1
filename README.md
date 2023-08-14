This R code performs the following tasks:

Load libraries dplyr, tidyverse, GEOquery, and ggplot2.

Read Data "GSE183947_fpkm.csv" into a data frame called dat.

Get Metadata using the GEOquery library.

Metadata Manipulation: renaming columns, removing prefixes from values, in df: metadata.modified.

Reshape & Join Data

Explore the joined data retaining only rows where the gene is either "BRCA1" or "BRCA2" and also grouping the data by 'gene' and 'tissue'. It also calculates the mean and median FPKM values, and arranges the results in desc. order of mean FPKM.

Plotting using the ggplot2 library. The x-axis represents the genes, the y-axis represents the mean FPKM values, and the bars are grouped by tissue.
