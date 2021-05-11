#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='select fasta headers from sequences that have a specific range of length')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', help= 'min length of fasta sequence')
parser$add_argument('--max', help= 'max length of fasta sequence')
parser$add_argument('--headers', help= 'txt output file with fasta headers')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# count the length of each sequence
imported_fasta$seq.length <- nchar(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of sequence length
filtered_fasta <- subset(imported_fasta, seq.length >= args$min & seq.length <= args$max)
# keep only the fasta headers
ids <- filtered_fasta$seq.name
# export txt file with headers
write.table(ids,file = args$headers,sep = "\t",row.names = F,col.names = F,quote = F)

