#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='calculate the amino acid content of each amino acid for each input sequence')
parser$add_argument('--fasta', help= 'input multi-fasta file')
parser$add_argument('--out', help= 'output txt file with fasta headers and aa content of each amino acid for each sequence')
args <- parser$parse_args()
# main
# import the 1-letter IUPAC aminoacid codes
aa_list <- c("A","C","D","E","F","G","H","I","K","L","M","N","P","Q","R","S","T","V","W","Y","B","J","Z","X")
input_fasta <- read.fasta(args$fasta)
# calculate %aa content for each gene
all_aa_content <- sapply(aa_list,function(x) {
  cont <- round((str_count(input_fasta$seq.text, as.character(x)) / nchar(input_fasta$seq.text)) * 100, 2)
  return(cont)
})
# combine with the protein ids
protein_ids <- input_fasta$seq.name
multifasta_aa_content <- cbind(protein_ids,all_aa_content)
# export to txt
write.table(multifasta_aa_content,file = args$out,quote = F,row.names = F,col.names = T,sep = "\t")
