#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='select fasta sequences or headers under a range of sequence length')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', help= 'min length of fasta sequence')
parser$add_argument('--max', help= 'max length of fasta sequence')
parser$add_argument('--pro', type="integer",default='1', help= 'program to choose(1.extract fasta sequences, 2.extract fasta headers). Default is 1')
parser$add_argument('--out', help= 'output fasta file')
parser$add_argument('--headers', help= 'txt output file with fasta headers')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# count the length of each sequence
imported_fasta$seq.length <- nchar(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of sequence length
filtered_fasta <- subset(imported_fasta, seq.length >= args$min & seq.length <= args$max)
# select program
program <- args$pro
# select fasta sequences
if (program == 1) {
# remove seq.length column
  final_fasta <- filtered_fasta[ ,-3]
# export fasta
  dat2fasta(final_fasta,outfile = args$out)
} else if (program == 2) {
# keep only the fasta headers
  ids <- filtered_fasta$seq.name
# export txt file with headers
  write.table(ids,file = args$headers,sep = "\t",row.names = F,col.names = F,quote = F)
}
