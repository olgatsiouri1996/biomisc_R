#!/usr/bin/env Rscript
library(argparse)
# input parameters
parser <- ArgumentParser(description='codon optimize sequences in  multi-fasta files')
parser$add_argument('--fasta', help= 'input multi fasta file')
parser$add_argument('--org', help= 'organism to select from the wSet data frame of GeneGA')
parser$add_argument('--prefix', help= 'prefix of output multi fasta file(the suffix contain the organism to optimize from org and _opt.fasta)')
args <- parser$parse_args()
# input packages to inport fasta
library(ape)
library(phylotools)
input_fasta <- read.fasta(args$fasta)
# convert to a list of strings and optimize based on the codon usage of a selected organism from the wSet data set
seq <- input_fasta$seq.text
# input packages for codon optimization
library(GeneGA)
library(seqinr)
library(hash)
optimized <- lapply(seq,function(x) GeneCodon(x,organism = args$org,max = T))
# create new ids for the optimized sequences
ids <- lapply(input_fasta$seq.name,function(x) paste(x,args$org,"opt",sep = "_"))
# convert all final resulted lists from lapply into a data frame so it can be easily exported
optimized_df <- data.frame(Reduce(rbind, optimized))
ids_df <- data.frame(Reduce(rbind, ids))
optimized_fastas <- cbind(ids_df,optimized_df)
colnames(optimized_fastas) <- c("seq.name","seq.text")
# export data frame to fasta
dat2fasta(optimized_fastas,outfile = paste(args$prefix,"_",args$org,"_opt",".fasta",sep = ""))

