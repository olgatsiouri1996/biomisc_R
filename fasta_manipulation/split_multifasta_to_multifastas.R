#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='split multi-fasta file into multiple random multi-fasta files')
parser$add_argument('--fasta', help= 'input multi-fasta file')
parser$add_argument('--filenum', help= 'number of files to generate')
parser$add_argument('--prefix', help= 'prefix of the generated output files e.g: "output"')
args <- parser$parse_args()
# main
# inport fasta file as dataframe
input_fasta <- read.fasta(args$fasta)
# split to list of random dataframes
fasta_list <- split(input_fasta, sample(1:args$filenum, nrow(input_fasta), replace=T))
# export each dataframe as fasta
lapply(seq_along(fasta_list),function(i)dat2fasta(fasta_list[[i]],outfile = paste(args$prefix,names(fasta_list)[i],".fasta",sep = "")))