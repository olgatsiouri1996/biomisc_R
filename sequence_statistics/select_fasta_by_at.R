#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='select fasta sequences under a AT content cutoff')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', help= 'min AT content cutoff')
parser$add_argument('--max', help= 'max AT content cutoff')
parser$add_argument('--out', help= 'output fasta file')
args <- parser$parse_args()
# main
at_content <- function(x) {
  cont <- round((str_count(x,"A") + str_count(x,"T")) / nchar(x) * 100, 2)
  return(cont)
}
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# count the AT content of each sequence
imported_fasta$seq.at_content <- at_content(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of AT content
filtered_fasta <- subset(imported_fasta, seq.at_content >= args$min & seq.at_content <= args$max)
# remove seq.at_content column
final_fasta <- filtered_fasta[ ,-3]
# export fasta
dat2fasta(final_fasta,outfile = args$out)
