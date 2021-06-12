#!/usr/bin/env Rscript
library(argparse)
library(bio3d)
# input parameters
parser <- ArgumentParser(description='split a pdb file by chain and convert to fasta')
parser$add_argument('--pdb', help= 'input pdb file')
parser$add_argument('--id', help= 'pdb id')
args <- parser$parse_args()
# main
input_pdb <- read.pdb(args$pdb)
# select chains from pdb
chains <- data.frame(table(input_pdb[["atom"]][["chain"]]))
chains <- data.frame(chains[ ,-2])
# convert and export to fasta
for (i in 1:nrow(chains)) {
  idx <- atom.select(input_pdb, chain= as.character(chains[i, ]))
  trimed_pdb <- trim.pdb(input_pdb,inds = idx)
  pdb_aa <- paste(pdbseq(trimed_pdb),sep = ",",collapse = "")
  write.fasta(seqs = pdb_aa,ids = paste(args$id,"_",chains[i, ],sep = ""),file = paste(args$id,"_",chains[i, ],".fasta",sep = ""))
}
