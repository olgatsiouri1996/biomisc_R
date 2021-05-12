#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='calculate the length of input sequences')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', help= 'min length of fasta sequence to export')
parser$add_argument('--max', help= 'max length of fasta sequence to export')
parser$add_argument('--out', help= 'txt output file with fasta headers and sequence length')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# count the length of each sequence
imported_fasta$seq.length <- nchar(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of sequence length
filtered_fasta <- subset(imported_fasta, seq.length >= args$min & seq.length <= args$max)
# remove the fasta sequences
fasta_length <- filtered_fasta[ ,-2]
colnames(fasta_length) <- c("fasta_header","sequence_length")
# export txt file with headers and sequence length
write.table(fasta_length,file = args$out,sep = "\t",row.names = F,quote = F)

