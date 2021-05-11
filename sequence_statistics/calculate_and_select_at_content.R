#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='calculate the AT content for each input sequence')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', help= 'min AT content cutoff to export')
parser$add_argument('--max', help= 'max AT content cutoff to export')
parser$add_argument('--headers', help= 'output txt file with fasta headers and AT content for each sequence')
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
# remove the sequences
gc_table <- filtered_fasta[ ,-2]
colnames(gc_table) <- c("fasta_header","%AT")
# export txt file with headers & AT content
write.table(gc_table,file = args$headers,row.names = F,quote = F,sep = "\t")
