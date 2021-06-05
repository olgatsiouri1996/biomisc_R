#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='split multi-fasta file into single-fasta files with the fasta header as file name')
parser$add_argument('--fasta', help= 'input multi-fasta file')
args <- parser$parse_args()
# main
# inport fasta file as dataframe
input_fasta <-read.fasta(args$fasta)
# iterate and export each row to a seperate file
for (i in 1:nrow(input_fasta)) {
  dat2fasta(input_fasta[ i, ],outfile = paste((input_fasta$seq.name)[i],".fasta",sep = ""))
}
