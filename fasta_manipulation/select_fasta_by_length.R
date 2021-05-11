#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='select fasta sequences under a range of sequence length')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', help= 'min length of fasta sequence')
parser$add_argument('--max', help= 'max length of fasta sequence')
parser$add_argument('--out', help= 'output fasta file')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# count the length of each sequence
imported_fasta$seq.length <- nchar(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of sequence length
filtered_fasta <- subset(imported_fasta, seq.length >= args$min & seq.length <= args$max)
# remove seq.length column
final_fasta <- filtered_fasta[ ,-3]
# export fasta
dat2fasta(final_fasta,outfile = args$out)
