#!/usr/bin/env Rscript
library(argparse)
# input parameters
parser <- ArgumentParser(description='combine the secondary structure statistics of pdb files into 1 table')
parser$add_argument('--txtdir', help= 'absolute path to the directory of input txt files(with pdb ids as part of their names and suffix: "_stats.txt") derived with: https://github.com/olgatsiouri1996/biomisc/blob/main/pdb_corner/pdb_secondary_structure_statistics.py or https://github.com/olgatsiouri1996/biomisc/blob/main/pdb_corner/dssp_statistics_by_chain.py)')
parser$add_argument('--out', help= 'output txt table with pdb ids as rows and secondary structure symbols as columns')
args <- parser$parse_args()
# main
# set absolute path for working directory and input files 
setwd(args$txtdir)
file_list <- list.files(path= args$txtdir)
# import files as list of dataframes
table_list <-lapply(file_list,read.table)
# merge into one table
dssp_data <- Reduce(function(x,y) merge(x = x, y = y, by = "V1",all = T), table_list)
# convert NA values to 0
dssp_data[is.na(dssp_data)] <- 0
# rename columns according to file names
colnames(dssp_data) <- c("", gsub(x = file_list, pattern = "_stats.txt", replacement = ""))
# convert rows to colums and vice versa
dssp_data <- as.data.frame(t(dssp_data))
# export table to txt
write.table(dssp_data,file = args$out,quote = F,row.names = T,col.names = F,sep = "\t")
