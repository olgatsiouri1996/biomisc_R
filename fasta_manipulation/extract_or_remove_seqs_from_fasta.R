#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='extract or remove sequences from a fasta file by a list of ids')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--ids', help= 'input txt file with fasta headers')
parser$add_argument('--pro', type="integer",default='1', help= 'program to choose(1.extract fasta sequences, 2.remove fasta sequences). Default is 1')
parser$add_argument('--out', help= 'output fasta file')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# import txt header file
imported_ids <- read.delim(file = args$ids, header = F)
colnames(imported_ids) <- c("seq.name")
# select program
program <- args$pro
#select the fasta sequences of the ids imported in a new data frame
if (program == 1) {
  selected_seqs <- merge(imported_ids,imported_fasta,by = "seq.name")
#select the fasta sequences that do not match the ids imported in a new data frame
} else if (program == 2) {
  selected_seqs <- subset(imported_fasta, !(seq.name %in% imported_ids$seq.name))
}
# convert data frame to fasta
dat2fasta(selected_seqs,outfile = args$out)
