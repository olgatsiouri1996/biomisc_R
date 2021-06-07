#!/usr/bin/env Rscript
library(argparse)
library(bio3d)
# input parameters
parser <- ArgumentParser(description='trim an input pdb by selecting a chain')
parser$add_argument('--pdb', help= 'input pdb file')
parser$add_argument('--chain', help= 'chain to select from pdb file')
parser$add_argument('--out', help= 'output pdb file')
args <- parser$parse_args()
# main
# inport pdb to R and select a chain
input_pdb <- read.pdb(args$pdb)
idx <- atom.select(input_pdb, chain= args$chain)
trimed_pdb <- trim.pdb(input_pdb,inds = idx)
# export as pdb
write.pdb(trimed_pdb,file = args$out,type = c("ATOM"))

