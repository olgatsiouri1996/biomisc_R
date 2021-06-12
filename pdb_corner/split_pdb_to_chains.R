#!/usr/bin/env Rscript
library(argparse)
library(bio3d)
# input parameters
parser <- ArgumentParser(description='split to various pdb files one by chain')
parser$add_argument('--pdb', help= 'input pdb file')
parser$add_argument('--outdir', help= 'directory of output pdb files')
args <- parser$parse_args()
# main
files <- pdbsplit(path = args$outdir,pdb.files = c(args$pdb))

