#!/usr/bin/env Rscript
# this script has 4 arguments: input file with  ids and number of reads in each sample, file with samples as rows and contitions and biological replicates(batch) as columns, q value and output file
# note that the columns of the input reads file should be the rows of the second input file
# the script is reuseable as you can add any values to batch,condition and col
library(argparse)
# input parameters
parser <- ArgumentParser(description='Command line interface for DESeq2 pipeline for 2 conditions')
parser$add_argument('--counts', help= 'txt table with ids in rows and reads per sample in columns')
parser$add_argument('--design', help= 'txt table samples as rows(the same name as in <counts>) with condition(2 experimental conditions: treatment and control) and batch(biological replicates) as column names')
parser$add_argument('--DEGs', help= 'output txt file containing only the differentially expressed genes')
args <- parser$parse_args()
# the package used for the analysis is loaded into R
library(DESeq2)
# from the above the columns with counts were chosen and were converted into a data matrix
table <- read.delim(args$counts)
col <- read.delim(args$design)
y <- data.matrix(table[ ,-1])
# so after the data frame containing the factors is created the raw count matrix is transformed into a DESeq2 object
col$batch <- as.factor(col$batch)
col$condition <- as.factor(col$condition)
ds <- DESeqDataSetFromMatrix(countData = y, colData = col, design = ~ batch + condition)
# after that the DEseq analysis was made using the default options(estimation of size factors,estimation of dispersion and wald statistical test) 
ds <- DESeq(ds)
# the following function creates a data matrix with the normalized counts for all experiments
cnt <- counts(ds, normalized = T)
# to output the results of the deseq2 analysis the results function is called using the name argument so that log(treatment/control)
rs <- results(ds, name = "condition_treatment_vs_control")
t <- data.frame(rs@listData)
# the t data frame was merged with columns of raw and normalize counts
stats <- cbind(table,cnt,t)
# to find the genes the common DEG's results were filltered so that the remaining genes have a logfold < -1 & > 1 and a q value < 0.05(padj)
# the | sumbol is the or logic gate used here because the log2 can give positive and negative values
fill_deseq2 <- subset(stats, log2FoldChange > 1 | log2FoldChange < -1)
fill_deseq2_final <-  subset(fill_deseq2, padj < 0.05 )
write.table(fill_deseq2_final, file = args$DEGs, sep = '\t',row.names = F, quote = F)