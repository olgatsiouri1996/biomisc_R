#!/usr/bin/env Rscript
library(argparse)
library(Biostrings,warn.conflicts = F,quietly = T)
# input parameters
parser <- ArgumentParser()
parser$add_argument('--fa', help= 'input fasta or fasta.gz file')
parser$add_argument('--out', help= 'output txt file with fasta headers and the length for each fasta sequence')
args <- parser$parse_args()
# main
# index fasta file
fai <- fasta.index(args$fa, seqtype = "B")
fai <- fai[ ,4:5]
# select the desc column as data.frame and export as txt
write.table(fai,file = args$out,sep = "\t",row.names = F,col.names = c("id","length"),quote = F)
