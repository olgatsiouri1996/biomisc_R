#!/usr/bin/env Rscript
library(argparse)
library(Biostrings,warn.conflicts = F,quietly = T)
# input parameters
parser <- ArgumentParser()
parser$add_argument('--fasta', help= 'input fasta or fasta.gz file')
parser$add_argument('--headers', help= 'output txt file with fasta headers')
args <- parser$parse_args()
# main
# index fasta file
fai <- fasta.index(args$fasta, seqtype = "B")
# select the desc column as data.frame and export as txt
write.table(fai$desc,file = args$headers,sep = "\t",row.names = F,col.names = F,quote = F)
