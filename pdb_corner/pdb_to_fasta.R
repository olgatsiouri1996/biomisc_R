#!/usr/bin/env Rscript
library(argparse)
library(bio3d)
# input parameters
parser <- ArgumentParser(description='convert an input pdb file as fasta')
parser$add_argument('--pdb', help= 'input pdb file')
parser$add_argument('--header', help= 'header of the output fasta file')
parser$add_argument('--fasta', help= 'output fasta file')
args <- parser$parse_args()
# main
input_pdb <- read.pdb(args$pdb)
# convert and export to fasta
pdb_aa <- paste(pdbseq(input_pdb),sep = ",",collapse = "")
write.fasta(seqs = pdb_aa,ids = args$header,file = args$fasta)
