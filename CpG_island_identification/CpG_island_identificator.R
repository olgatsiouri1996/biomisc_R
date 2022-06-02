#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
library(stringr)
# input parameters
parser <- ArgumentParser(description='retrieve the start, end  and strand coordinates of CpG islands in a sequence(forward and reverse complement), with their %GC content and Obs/Exp ratio, by using a sliding window aproach (Gardiner-Garden and Frommer, 1987)')
parser$add_argument('--fasta', help= 'input fasta file')
parser$add_argument('--win', type="integer", help= 'window size for the calculation of Obs/Exp ratio (integer)')
parser$add_argument('--step', type="integer", help= 'step size for the calculation of Obs/Exp ratio (integer)')
parser$add_argument('--gc', type="integer", default='50', help= 'min GC content cutoff(integer, default= 50)')
parser$add_argument('--ratio',default='0.6', help= 'min Obs/Exp ratio(float, default= 0.6)')
parser$add_argument('--txt', help= 'output txt file')
args <- parser$parse_args()
# main
library(Biostrings)
# import fasta as data frame
imported_fasta <- read.fasta(file = args$fasta)
# collect fasta sequence, reverse complement sequence, length, window and step size from input parameters
fasta_sequence <- as.character(imported_fasta$seq.text)
rev_sequence <- paste(reverseComplement(DNAString(fasta_sequence)))
seq_length <- nchar(as.character(imported_fasta$seq.text))
window <- args$win
step <- args$step
# function to calculate observed  CG islands
gc_obs <- function(x) {
  obs <- str_count(x,"CG")
  return(obs)
}
# function to calculate Obs/Exp ratio
gc_ratio <- function(x) {
  expected <- (str_count(x,"C") * str_count(x,"G")) / window
  obs_exp <- round(str_count(x,"CG") / expected, 2)
  return(obs_exp)
}
# function to calculate %GC content
gc_content <- function(x) {
  cont <- round((str_count(x,"G") + str_count(x,"C")) / nchar(x) * 100, 2)
  return(cont)
}
# calculate indices where each substring will start
starts <- seq(1, seq_length - window +1 ,by = step)
# chop it up
df1 <- data.frame(sapply(starts, function(i) {
  substr(fasta_sequence, i, i + window -1)
}))
# now do for the reverse complement sequence
df2 <- data.frame(sapply(starts, function(i) {
  substr(rev_sequence, i, i + window -1)
}))
# add begin, end, id and strand columns
# forward sequence
df1$start <- starts
df1$end <- nchar(as.character(df1$sapply.starts..function.i...)) + starts -1
df1$id <- imported_fasta$seq.name
df1$strand <- "+"
# reverse complement sequence
df2$start <- -1 *(nchar(as.character(df2$sapply.starts..function.i...)) + starts - seq_length)
df2$end <- -1 *(starts - seq_length)
df2$id <- imported_fasta$seq.name
df2$strand <- "-"
# combine results and calculate the Obs, Obs/Exp ratio and %GC content
df <-rbind(df1,df2)
df$gc_content <- gc_content(df$sapply.starts..function.i...)
df$gc_obs <- gc_obs(df$sapply.starts..function.i...)
df$gc_ratio <- gc_ratio(df$sapply.starts..function.i...)
# fillter by Obs/Exp ratio and %GC content
cpg_islands <- subset(df[ ,-1], gc_content >= args$gc & gc_ratio >= args$ratio)
# order by CpG Obs/Exp ratio in descending order
cpg_islands <- cpg_islands[order(cpg_islands$gc_ratio, decreasing = T), ]
# rearrange so id column comes first
cpg_islands <- cpg_islands[ ,c(3,1,2,4:7)]
# rename columns
colnames(cpg_islands) <- c("id","start","end","strand","%GC","Obs","Obs/Exp")
# export results as txt 
write.table(cpg_islands,file = args$txt,row.names = F,quote = F,sep = "\t")
