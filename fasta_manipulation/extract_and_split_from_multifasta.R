#!/usr/bin/env Rscript
library(argparse)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='extract sequences from a fasta file by a list of ids and export each sequence into a single-fasta file with the fasta header as file name')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--ids', help= 'input txt file with fasta headers')
args <- parser$parse_args()
# main
# import fasta file and convert to data frame
imported_fasta <- read.fasta(file = args$fasta)
# import txt header file
imported_ids <- read.delim(file = args$ids, header = F)
colnames(imported_ids) <- c("seq.name")
# select the fasta sequences of the ids imported in a new data frame
selected_seqs <- merge(imported_ids,imported_fasta,by = "seq.name")
# iterate and export each row to a seperate file
for (i in 1:nrow(selected_seqs)) {
  dat2fasta(selected_seqs[ i, ],outfile = paste((selected_seqs$seq.name)[i],".fasta",sep = ""))
}
