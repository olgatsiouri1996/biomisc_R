#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='merge fasta files into one multifasta file')
parser$add_argument('--dir', help= 'input directory with fasta files')
parser$add_argument('--out', help= 'output fasta file')
args <- parser$parse_args()
# change directory to import files into R
setwd(args$dir)
# create a list of dataframes of imported fasta
file_list <- list.files(path=args$dir)
fasta_list <-lapply(file_list,read.fasta)
# merge all dataframes one under the other
multi_fasta <- Reduce(rbind, fasta_list)
# export as fasta
dat2fasta(multi_fasta,outfile = args$out)
