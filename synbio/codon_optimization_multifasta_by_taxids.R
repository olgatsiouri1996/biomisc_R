#!/usr/bin/env Rscript
library(argparse)
# input parameters
parser <- ArgumentParser(description='codon optimize sequences in  multi-fasta files')
parser$add_argument('--fasta', help= 'input multi fasta file')
parser$add_argument('--org', help= '1-column txt file with organism name to codon optimize (from the wSet data frame of GeneGA)')
parser$add_argument('--prefix', help= 'prefix of output multi fasta file(the suffix is _opt.fasta)')
args <- parser$parse_args()
# input packages to inport fasta
library(ape)
library(phylotools)
library(stringr)
input_fasta <- read.fasta(args$fasta)
taxids <- read.delim(args$org, header=F)
# iterate by each row and optimize based on the codon usage of a selected organism from the wSet data set
iter_counts <- seq(1, nrow(input_fasta),by = 1)
# input packages for codon optimization
library(GeneGA)
library(seqinr)
library(hash)
optimized <- data.frame(sapply(iter_counts,function(x) GeneCodon(input_fasta[x ,2],organism = taxids[x, 1],max = T)))
# create new ids for the optimized sequences
ids <- data.frame(sapply(iter_counts,function(x) paste(input_fasta[x ,1],taxids[x, 1],"opt",sep = "_")))
# convert all final resulted lists from sapply into a data frame so it can be easily exported
optimized_fastas <- cbind(ids,optimized)
colnames(optimized_fastas) <- c("seq.name","seq.text")
# export data frame to fasta
dat2fasta(optimized_fastas,outfile = paste(args$prefix,"_opt",".fasta",sep = ""))
