#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='calculate various statistics related to sequence  %GC and %AT content  using as input multiple multi-fasta files')
parser$add_argument('--dir', help= 'absolute path to the directory of input multi-fasta files')
parser$add_argument('--out', help= 'output txt table with fasta file names as rows and "min","mean","max"  as columns for  %GC and %AT content respectively')
args <- parser$parse_args()
# main
# create function to calculate %AT content
at_content <- function(x) {
  cont <- round(((str_count(x,"A") + str_count(x,"T")) / nchar(x)) * 100, 2)
  return(cont)
}
# create function to calculate %GC content
gc_content <- function(x) {
  cont <- round(((str_count(x,"G") + str_count(x,"C")) / nchar(x)) * 100, 2)
  return(cont)
}
# set absolute path for working directory and input files 
setwd(args$dir)
file_list <- list.files(path= args$dir)
# import files as list of dataframes
fasta_list <-lapply(file_list,read.fasta)
# calculate the %GC and %AT content of each sequence in each multifasta file
feature_length_list <- lapply(fasta_list,function(x) data.frame(gc_content(x$seq.text),at_content(x$seq.text)))
# calculate the min, max , mean values of all rows for each fasta file
feature_stats_list <- lapply(feature_length_list,function(x) data.frame(min(x$gc_content.x.seq.text.),mean(x$gc_content.x.seq.text.),max(x$gc_content.x.seq.text.), min(x$at_content.x.seq.text.),mean(x$at_content.x.seq.text.),max(x$at_content.x.seq.text.)))
# combine list of data frames to create final data frame
feature_stats_df <- data.frame(Reduce(rbind,feature_stats_list))
row.names(feature_stats_df) <- gsub(x = file_list, pattern = ".fasta", replacement = "")
colnames(feature_stats_df) <- c("min %GC content","mean %GC content","max %GC content", "min %AT content","mean %AT content","max %AT content" )
# export data frame as txt
write.table(feature_stats_df,file = args$out,quote = F,row.names = T,col.names = T,sep = "\t")
