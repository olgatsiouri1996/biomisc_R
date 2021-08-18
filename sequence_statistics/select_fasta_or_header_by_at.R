#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='select fasta sequences or headers under a AT content cutoff')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', type="integer", help= 'min AT content cutoff(integer)')
parser$add_argument('--max', type="integer", help= 'max AT content cutoff(integer)')
parser$add_argument('--pro', type="integer",default='1', help= 'program to choose(1.retrieve fasta sequences, 2.retrieve fasta headers). Default is 1')
parser$add_argument('--out', help= 'output fasta file')
parser$add_argument('--headers', help= 'output file with fasta headers')
args <- parser$parse_args()
# main
at_content <- function(x) {
  cont <- round((str_count(x,"A") + str_count(x,"T")) / nchar(x) * 100, 2)
  return(cont)
}
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# count the AT content of each sequence
imported_fasta$seq.at_content <- at_content(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of AT content
filtered_fasta <- subset(imported_fasta, seq.at_content >= args$min & seq.at_content <= args$max)
# remove seq.at_content column
final_fasta <- filtered_fasta[ ,-3]
# select program
program <- args$pro
# export fasta
if (program == 1) {
  dat2fasta(final_fasta,outfile = args$out)
} else if (program == 2) {
# keep only the fasta headers
  ids <- filtered_fasta$seq.name
# export txt file with headers
  write.table(ids,file = args$headers,row.names = F,col.names = F,quote = F,sep = "\t")
}