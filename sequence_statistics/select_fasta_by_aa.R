#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='select fasta sequences under an amino acid content cutoff')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', type="integer", help= 'min aa content cutoff(integer)')
parser$add_argument('--max', type="integer", help= 'max aa content cutoff(integer)')
parser$add_argument('--aa', help= 'amino acid to search the content for')
parser$add_argument('--out', help= 'output fasta file')
args <- parser$parse_args()
# main
aa_content <- function(x) {
  cont <- round((str_count(x, as.character(args$aa)) / nchar(x)) * 100, 2)
  return(cont)
}
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# count the amino acid content of each sequence
imported_fasta$seq.aa_content <- aa_content(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of aa content
filtered_fasta <- subset(imported_fasta, seq.aa_content >= args$min & seq.aa_content <= args$max)
# remove seq.aa_content column
final_fasta <- filtered_fasta[ ,-3]
# export fasta
dat2fasta(final_fasta,outfile = args$out)
