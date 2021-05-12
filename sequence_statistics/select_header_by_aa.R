#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='select fasta headers from sequences under an amino acid content cutoff')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', help= 'min aa content cutoff')
parser$add_argument('--max', help= 'max aa content cutoff')
parser$add_argument('--aa', help= 'amino acid to search the content for')
parser$add_argument('--headers', help= 'output fasta file')
args <- parser$parse_args()
# main
aa_content <- function(x) {
  cont <- round(str_count(x, args$aa) / nchar(x) * 100, 2)
  return(cont)
}
# import fasta file and convert to daaa frame
imported_fasta <- read.fasta(file = args$fasta)
# count the amino acid content of each sequence
imported_fasta$seq.aa_content <- aa_content(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of aa content
filtered_fasta <- subset(imported_fasta, seq.aa_content >= args$min & seq.aa_content <= args$max)
# keep only the fasta headers
ids <- filtered_fasta$seq.name
# export txt file with headers
write.table(ids,file = args$headers,row.names = F,col.names = F,quote = F,sep = "\t")
