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
# make iterables for each fasta record
imported_fasta_rows <- seq(1,nrow(imported_fasta),by=1)
# collect fasta sequences, reverse complement sequences, length, window and step size from input parameters
fasta_sequence <-lapply(imported_fasta_rows, function(x) as.character(imported_fasta[x, 2]))
rev_sequence <- lapply(imported_fasta_rows,function(x) paste(reverseComplement(DNAString(fasta_sequence[[x]]))))
seq_length <- lapply(imported_fasta_rows, function(x) nchar(as.character(fasta_sequence[[x]])))
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
starts <- lapply(imported_fasta_rows, function(x) seq(1, seq_length[[x]] - window +1 ,by = step))
# chop it up
df1 <-lapply(imported_fasta_rows, function(x) data.frame(sapply(starts[[x]], function(i) {
  substr(fasta_sequence[[x]], i, i + window -1)
})))
# now do for the reverse complement sequences
df2 <- lapply(imported_fasta_rows, function(x) data.frame(sapply(starts[[x]], function(i) {
  substr(rev_sequence[[x]], i, i + window -1)
})))
# add begin, end columns
# forward sequences
for (x in imported_fasta_rows) {
  df1[[x]]$start <- starts[[x]]
  df1[[x]]$end <- nchar(as.character(df1[[x]]$sapply.starts..x....function.i...)) + starts[[x]] -1
  df1[[x]]$id <- imported_fasta[x, 1]
  df1[[x]]$strand <- "+"
  # reverse complement sequences
  df2[[x]]$start <- -1 *(nchar(as.character(df2[[x]]$sapply.starts..x....function.i...)) + starts[[x]] - seq_length[[x]])
  df2[[x]]$end <- -1 *(starts[[x]] - seq_length[[x]])
  df2[[x]]$id <- imported_fasta[x, 1]
  df2[[x]]$strand <- "-"
}
# first merge each list item by column to end up with 2 data frames
df1_merged <- Reduce(rbind,df1)
df2_merged <- Reduce(rbind,df2)
# combine the 2 dataframes with forward and reverse complement data and calculate the Obs, Obs/Exp ratio and %GC content
df <- rbind(df1_merged,df2_merged)
df$gc_content <- gc_content(df$sapply.starts..x....function.i...)
df$gc_obs <- gc_obs(df$sapply.starts..x....function.i...)
df$gc_ratio <- gc_ratio(df$sapply.starts..x....function.i...)
# filter by Obs/Exp ratio and %GC content
cpg_islands <- subset(df[ ,-1], gc_content >= args$gc & gc_ratio >= args$ratio)
# order from biggest to smallest ratio
cpg_islands <- cpg_islands[order(cpg_islands$gc_ratio, decreasing = T), ]
# put the id column first
cpg_islands <- cpg_islands[ ,c(3,1,2,4:7)]
# add column names
colnames(cpg_islands) <- c("id","start","end","strand","%GC","Obs","Obs/Exp")
# export results as txt 
write.table(cpg_islands,file = args$txt,row.names = F,quote = F,sep = "\t")
