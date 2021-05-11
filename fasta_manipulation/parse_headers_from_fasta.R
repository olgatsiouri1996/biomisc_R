#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
# input parameters
parser <- ArgumentParser()
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--headers', help= 'output txt file with fasta headers')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# select the headers column as data.frame and export as txt
ids <- data.frame(imported_fasta[ ,1])
write.table(ids,file = args$headers,sep = "\t",row.names = F,col.names = F,quote = F)
