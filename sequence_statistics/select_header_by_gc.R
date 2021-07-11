#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='select fasta headers from sequences under a GC content cutoff')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', type="integer", help= 'min GC content  cutoff(integer)')
parser$add_argument('--max', type="integer", help= 'max GC content  cutoff(integer)')
parser$add_argument('--headers', help= 'output txt file with fasta headers')
args <- parser$parse_args()
# main
gc_content <- function(x) {
  cont <- round((str_count(x,"G") + str_count(x,"C")) / nchar(x) * 100, 2)
  return(cont)
}
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# count the GC content of each sequence
imported_fasta$seq.gc_content <- gc_content(imported_fasta$seq.text)
# filter the data frame by selecting the maximum and minimum value of %GC
filtered_fasta <- subset(imported_fasta, seq.gc_content >= args$min & seq.gc_content <= args$max)
# keep only the fasta headers
ids <- filtered_fasta$seq.name
# export txt file with headers
write.table(ids,file = args$headers,row.names = F,col.names = F,quote = F,sep = "\t")