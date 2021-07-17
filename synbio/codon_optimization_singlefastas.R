#!/usr/bin/env Rscript
library(argparse)
# input parameters
parser <- ArgumentParser(description='codon optimize  sequences in single-fasta files')
parser$add_argument('--dir', help= 'absolute path to  directory with fasta files')
parser$add_argument('--org', help= 'organism to select from the wSet data frame of GeneGA(the newly fasta headers and fasta files contain as prefix the input gene ids, and as suffix the organism to optimize from --org and _opt)')
args <- parser$parse_args()
# input packages for codon optimization
library(GeneGA)
library(seqinr)
library(hash)
# change directory to import files into R
setwd(args$dir)
# put file names into a list and import fastas as list
file_list <- list.files(path=args$dir)
fasta_list <-lapply(file_list,read.fasta)
# convert to a list of strings and optimize based on the codon usage of a selected organism from the wSet data set
seq <- lapply(fasta_list,function(x) unlist(getSequence(x,as.string=TRUE)))
optimized <- lapply(seq,function(x) GeneCodon(x,organism = args$org,max = T))
# create new ids for the optimized sequences
ids <- lapply(fasta_list,function(x) paste(attr(x,"name"),args$org, "opt",sep = "_"))
# convert all final resulted lists from lapply into a data frame so it can be easily exported
optimized_df <- data.frame(Reduce(rbind, optimized))
ids_df <- data.frame(Reduce(rbind, ids))
optimized_fastas <- cbind(ids_df,optimized_df)
colnames(optimized_fastas) <- c("seq.name","seq.text")
# input packages to export
library(ape)
library(phylotools)
# iterate and export each row to a seperate file
for (i in 1:nrow(optimized_fastas)) {
  dat2fasta(optimized_fastas[ i, ],outfile = paste((optimized_fastas$seq.name)[i],".fasta",sep = ""))
}

