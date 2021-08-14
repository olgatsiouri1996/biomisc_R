#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='ligate a specific vector to specific sequence')
parser$add_argument('--vr', help= 'input multi-fasta file with vectors')
parser$add_argument('--fasta', help= 'input multi-fasta file with sequences to add vectors')
parser$add_argument('--out', help= 'output multi-fasta file')
args <- parser$parse_args()
# main
# import fasta as data frame
insert <- read.fasta(file = args$fasta)
# import vectors
plasmid <- read.fasta(file = args$vr)
# ligate a specific plasmid to each sequence
ligated <- cbind(data.frame(paste(insert$seq.name,plasmid$seq.name,sep= "_")),data.frame(paste(insert$seq.text,plasmid$seq.text,sep= "")))
# rename to export
colnames(ligated) <- c("seq.name","seq.text")
# export to fasta
dat2fasta(ligated,outfile = args$out)
