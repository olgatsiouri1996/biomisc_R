#!/usr/bin/env Rscript
library(argparse)
library(edgeR)
# input parameters
parser <- ArgumentParser(description='Command line interface for the edgeR pipeline for 2 conditions')
parser$add_argument('--counts', help= 'txt table with ids in rows and reads per sample in columns')
parser$add_argument('--groups', help= '1 column txt table that contains 2 conditions with their biological replicates e.g 1 1 2 2')
parser$add_argument('--genes', help= 'number of genes that the differentially expression analysis is done for')
parser$add_argument('--DEGs', help= 'output txt file containing only the differentially expressed genes')
args <- parser$parse_args()
# main
# import the file with the raw read count data and the condition groups
x <- read.delim(args$counts,header = T,row.names = 1)
mx <- data.matrix(x)
conditions <- read.delim(args$groups,header = F)
# convert to vector 
group <- factor(unlist(conditions))
# import to edgeR
y <- DGEList(counts=mx,group=group)
y <- calcNormFactors(y)
# create design matrix and estimate dispersions
design <- model.matrix(~group)
y <- estimateDisp(y,design)
# perform statistical analysis and export the statistically significant results
et <- exactTest(y,prior.count = 1)
res <- topTags(et,n = args$genes,p.value = 0.05)
t <- res[["table"]]
degs <- subset(t, logFC > 1 | logFC < -1)
write.table(degs,file = args$DEGs,quote = F,row.names = T,sep = "\t")
