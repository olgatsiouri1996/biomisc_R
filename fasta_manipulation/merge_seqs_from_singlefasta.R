#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='merge sequences from single-fasta files into one')
parser$add_argument('--dir', help= 'input directory with fasta files')
parser$add_argument('--header', help= 'header of the output fasta file')
parser$add_argument('--out', help= 'output fasta file')
args <- parser$parse_args()
# change directory to import files into R
setwd(args$dir)
# create a list of dataframes of imported fasta
file_list <- list.files(path=args$dir)
fasta_list <-lapply(file_list,read.fasta)
# merge all dataframes one under the other
multi_fasta <- Reduce(rbind, fasta_list)
# merge all sequences
seq.text <- data.frame(paste(multi_fasta$seq.text,collapse = "",sep = "\n"))
# give a name to the final sequence
seq.name <- data.frame(c(args$header))
merged_fasta <- cbind(seq.name,seq.text)
colnames(merged_fasta) <- c("seq.name","seq.text")
# export as fasta
dat2fasta(merged_fasta,outfile = args$out)
