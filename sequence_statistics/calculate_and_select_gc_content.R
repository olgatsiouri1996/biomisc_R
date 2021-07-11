#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='calculate the GC content for each input sequence')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', type="integer",default='0', help= 'min GC content  cutoff to export(integer, default = 0)')
parser$add_argument('--max', type="integer",default='100', help= 'max GC content  cutoff to export(integer, default = 100)')
parser$add_argument('--out', help= 'output txt file with fasta headers and GC content for each sequence')
args <- parser$parse_args()
# main
gc_content <- function(x) {
  cont <- round(((str_count(x,"G") + str_count(x,"C")) / nchar(x)) * 100, 2)
  return(cont)
}
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# count the GC content of each sequence
imported_fasta$seq.gc_content <- gc_content(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of %GC
filtered_fasta <- subset(imported_fasta, seq.gc_content >= args$min & seq.gc_content <= args$max)
# remove the sequences
gc_table <- filtered_fasta[ ,-2]
colnames(gc_table) <- c("fasta_header","%GC")
# export txt file with headers & GC content
write.table(gc_table,file = args$out,row.names = F,quote = F,sep = "\t")
