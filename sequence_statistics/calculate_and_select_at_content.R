#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='calculate the AT content for each input sequence')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', type="integer",default='0',  help= 'min AT content cutoff to export(integer, default = 0)')
parser$add_argument('--max', type="integer",default='100', help= 'max AT content cutoff to export(integer, default = 100)')
parser$add_argument('--out', help= 'output txt file with fasta headers and AT content for each sequence')
args <- parser$parse_args()
# main
at_content <- function(x) {
  cont <- round(((str_count(x,"A") + str_count(x,"T")) / nchar(x)) * 100, 2)
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
colnames(aa_table) <- c("fasta_header","%AT")
# export txt file with headers & AT content
write.table(aa_table,file = args$out,row.names = F,quote = F,sep = "\t")
