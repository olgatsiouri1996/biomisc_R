#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='merge the sequences of a multifasta file into 1 large sequence')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--header', help= 'header of the output fasta file')
parser$add_argument('--out', help= 'output fasta file')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# merge all sequences
seq.text <- data.frame(paste(imported_fasta$seq.text,collapse = "",sep = "\n"))
# give a name to the final sequence
seq.name <- data.frame(c(args$header))
merged_fasta <- cbind(seq.name,seq.text)
colnames(merged_fasta) <- c("seq.name","seq.text")
# export fasta
dat2fasta(merged_fasta,outfile = args$out)
