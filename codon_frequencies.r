#DELETE NEXT LINE 
#setwd("/Users/nachocab/Code/codon services");

# Usage: Rscript codon_plot.r -i <input_file> -o <output_file>
library(seqinr)
library(getopt)

opt <- getopt(matrix(c(
    'input','i',1,'character',
    'output','o',1,'character'), 
    byrow=T, ncol=4))

fasta <- read.fasta(opt$input)
frequencies <- t(sapply(fasta,uco))   
 
global <- apply(frequencies, 2, sum)

frequencies <- rbind(global, frequencies)
write.table(frequencies, opt$output)
    
