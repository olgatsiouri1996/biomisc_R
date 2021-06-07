#!/usr/bin/env Rscript
library(argparse)
library(bio3d)
# input parameters
parser <- ArgumentParser(description='trim an input pdb by selecting a chain and export as fasta')
parser$add_argument('--pdb', help= 'input pdb file')
parser$add_argument('--chain', help= 'chain to select from pdb file')
parser$add_argument('--header', help= 'header of the output fasta file')
parser$add_argument('--fasta', help= 'output fasta file')
args <- parser$parse_args()
# main
input_pdb <- read.pdb(args$pdb)
# select chain and residues
idx <- atom.select(input_pdb, chain= args$chain)
trimed_pdb <- trim.pdb(input_pdb,inds = idx)
# convert and export to fasta
pdb_aa <- paste(pdbseq(trimed_pdb),sep = ",",collapse = "")
write.fasta(seqs = pdb_aa,ids = args$header,file = args$fasta)