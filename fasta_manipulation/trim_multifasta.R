#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='trim the start and end of input single/multifasta sequences')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--start', help= 'number of nucleotides/aminoacids to trim from the start of the sequences')
parser$add_argument('--end', help= 'number of nucleotides/aminoacids to trim from the end of the sequences(negative number)')
parser$add_argument('--out', help= 'output fasta file')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# trim input fasta sequence/s
imported_fasta$seq.text <- str_sub(imported_fasta$seq.text,start = args$start,end = args$end)
# export fasta
dat2fasta(imported_fasta,outfile = args$out)
