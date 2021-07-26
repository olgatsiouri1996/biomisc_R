#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
library(Peptides)
# input parameters
parser <- ArgumentParser(description='calculate biophysical proterties of each protein from an input multifasta file')
parser$add_argument('--fasta', help= 'input multi-fasta file')
parser$add_argument('--pl_pKscale',default='EMBOSS', help= 'pKs scale for isoelectric point calculation. Default= EMBOSS')
parser$add_argument('--charge_pKscale',default='Lehninger', help= 'pKs scale for protein charge calculation. Default= Lehninger')
parser$add_argument('--hydro_scale',default='KyteDoolittle', help= 'scale for hydrophobicity calculation. Default= KyteDoolittle')
parser$add_argument('--out', help= 'output txt file with fasta headers, isoelectric point, charge, hydrophobicity and  molecular weight as columns')
args <- parser$parse_args()
# main
# import multi-fasta file as data frame
input_fasta <- read.fasta(args$fasta)
# create data frame with fasta headers and the results from the calculation of various biophysical properties
biochem <- data.frame(input_fasta$seq.name,pI(input_fasta$seq.text,pKscale = args$pl_pKscale), charge(input_fasta$seq.text, pH = 7, pKscale = args$charge_pKscale),  hydrophobicity(input_fasta$seq.text, scale = args$hydro_scale), mw(input_fasta$seq.text,monoisotopic = FALSE, label = "none",aaShift = NULL))
# rename the columns of the resulted data frame
colnames(biochem) <- c("protein_id","isoelectric_point", "charge","hydrophobicity","molecular_weight")
# export to txt
write.table(biochem,file = args$out,quote = F,row.names = F,col.names = T,sep = "\t")
