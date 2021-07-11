#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='select fasta sequences based on a pattern of their fasta headers')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--pattern', help= 'regular expression with the pattern to search')
parser$add_argument('--case',type="logical", help= 'boolean, if TRUE ignore case')
parser$add_argument('--out', help= 'output fasta file')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
#select the fasta sequences with header that contain a specific pattern
selected_seqs <- subset(imported_fasta, grepl(args$pattern,seq.name,ignore.case = args$case))
# convert data frame to fasta
dat2fasta(selected_seqs,outfile = args$out)
