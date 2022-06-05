#!/usr/bin/env Rscript
library(argparse)
library(Biostrings,warn.conflicts = F,quietly = T)
# input parameters
parser <- ArgumentParser(description='calculate various statistics related to sequence lenght using as input multiple multi-fasta files')
parser$add_argument('--dir', help= 'relative of absolute path to the directory of input multi-fasta files')
parser$add_argument('--out', help= 'output txt table with fasta file names as rows and "min","mean","max" and "sum" as columns')
args <- parser$parse_args()
# main
# set absolute path for working directory and input files 
setwd(args$dir)
file_list <- list.files()
# import files as list of dataframes
fai_list <-lapply(file_list,function(x) fasta.index(x, seqtype = "B"))
# calculate the length of each sequence in each multifasta file
feature_length_list <- lapply(fai_list,function(x) x$seqlength)
# calculate the min, max , mean values and sum all rows for each fasta file
feature_stats_list <- lapply(feature_length_list,function(x) data.frame(min(x),round(mean(x), 2),max(x),sum(x)))
# combine list of data frames to create final data frame
feature_stats_df <- data.frame(Reduce(rbind,feature_stats_list))
row.names(feature_stats_df) <- gsub(x = file_list, pattern = ".fasta", replacement = "")
colnames(feature_stats_df) <- c("min","mean","max","sum")
# export data frame as txt
write.table(feature_stats_df,file = args$out,quote = F,row.names = T,col.names = T,sep = "\t")
