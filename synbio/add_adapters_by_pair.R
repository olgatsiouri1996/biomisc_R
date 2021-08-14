#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='add specific adapter pairs to each sequence in a multi-fasta file')
parser$add_argument('--up', help= 'input multi-fasta file with adapters to be added upstream')
parser$add_argument('--fasta', help= 'input multi-fasta file with sequences to add adapters')
parser$add_argument('--down', help= 'input multi-fasta file with adapters to be added downstream')
parser$add_argument('--out', help= 'output multi-fasta file')
args <- parser$parse_args()
# main
# import fasta as data frame
imported_fasta <- read.fasta(file = args$fasta)
# import upstream adapters
upad <- read.fasta(file = args$up)
# import downstream adapters
downad <- read.fasta(file = args$down)
# add a specific addapter pair to each sequence
seqad <- cbind(imported_fasta$seq.name,data.frame(paste(upad$seq.text,imported_fasta$seq.text,downad$seq.text,sep= "")))
# rename to export
colnames(seqad) <- c("seq.name","seq.text")
# export to fasta
dat2fasta(seqad,outfile = args$out)
