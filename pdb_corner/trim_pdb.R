#!/usr/bin/env Rscript
library(argparse)
library(bio3d)
# input parameters
parser <- ArgumentParser(description='trim an input pdb file')
parser$add_argument('--pdb', help= 'input pdb file')
parser$add_argument('--chain', help= 'chain to select from pdb file')
parser$add_argument('--start', type="integer", help= 'number of resudue to start')
parser$add_argument('--end', type="integer", help= 'number of resudue to end')
parser$add_argument('--out', help= 'output pdb file')
args <- parser$parse_args()
# main
input_pdb <- read.pdb(args$pdb)
# select chain and residues
idx <- atom.select(input_pdb, chain= args$chain, resno=args$start:args$end)
trimed_pdb <- trim.pdb(input_pdb,inds = idx)
# export as pdb
write.pdb(trimed_pdb,file = args$out,type = c("ATOM"))

