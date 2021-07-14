#!/usr/bin/env Rscript
library(argparse)
library(ape)
library(phylotools)
# input parameters
parser <- ArgumentParser(description='split a single-fasta file using a sliding window approach and export each sequence in a single-fasta file')
parser$add_argument('--fasta', help= 'input single-fasta file')
parser$add_argument('--win', type="integer", help= 'window size (integer)')
parser$add_argument('--step', type="integer", help= 'step size (integer)')
parser$add_argument('--ori1', default= 'forward', help= 'forward/reverse orientation  (default= forward, change to reverse  with default --ori2 to get only the reverse complemented sequences)')
parser$add_argument('--ori2', default= 'reverse', help= 'forward/reverse orientation  (default= reverse, change to forward with default --ori1 to get only forward sequences)')
args <- parser$parse_args()
# main
library(Biostrings)
# import fasta as data frame
imported_fasta <- read.fasta(file = args$fasta)
# collect fasta sequence, length, window and step size from input parameters
fasta_sequence <- as.character(imported_fasta$seq.text)
rev_sequence <- paste(reverseComplement(DNAString(fasta_sequence)))
seq_length <- nchar(as.character(imported_fasta$seq.text))
window <- args$win
step <- args$step
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
# add start, end coordinates
df1$start <- starts
df1$end <- nchar(as.character(df1$sapply.starts..function.i...)) + starts -1
df2$start <- starts
df2$end <- nchar(as.character(df2$sapply.starts..function.i...)) + starts -1
# add orientation
df1$orientation <- c("forward")
df2$orientation <- c("reverse")
# merge results
df <- rbind(df1,df2)
# add the fasta header from the input fasta file
df$seq.name <- imported_fasta$seq.name
df <- subset(df, orientation == args$ori1 | orientation == args$ori2)
# create empty data frate to add final data
splitted_fasta <-data.frame(matrix(ncol = 2, nrow = nrow(df)))  
colnames(splitted_fasta) <- c("seq.name","seq.text")
# create fasta headers
splitted_fasta$seq.name <- paste(df$seq.name,df$start,df$end,df$sep,df$orientation, sep = "_")
# add the sequences
splitted_fasta$seq.text <- df$sapply.starts..function.i...
# iterate and export each row to a seperate file
for (i in 1:nrow(splitted_fasta)) {
  dat2fasta(splitted_fasta[ i, ],outfile = paste((splitted_fasta$seq.name)[i],".fasta",sep = ""))
}
