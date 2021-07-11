#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='calculate the amino acid content for each input sequence')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--min', type="integer",default='0', help= 'min aa content cutoff to export(integer, default = 0)')
parser$add_argument('--max', type="integer",default='100', help= 'max aa content cutoff to export(integer, default = 100)')
parser$add_argument('--aa', help= 'amino acid to search the content for')
parser$add_argument('--out', help= 'output txt file with fasta headers and aa content for each sequence')
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
# remove the sequences
aa_table <- filtered_fasta[ ,-2]
colnames(aa_table) <- c("fasta_header",paste("%",args$aa,sep = ""))
# export txt file with headers & aa content
write.table(aa_table,file = args$out,row.names = F,quote = F,sep = "\t")
