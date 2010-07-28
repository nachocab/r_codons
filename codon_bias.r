# setwd("/Users/nachocab/Code/codon services");
library(seqinr)
library(getopt)
source("codon_services.r")

opt <- getopt(matrix(c(
    'input','i',1,'character',
    'output','o',1,'character',
    'translation','t',2,'integer'), 
    byrow=T, ncol=4))
    
if (is.null(opt$translation)) opt$translation <- 1

# read codon frequency matrix in wide format
genome_af <- read.table(opt$input, header=T)

genome_rf <- calculate_relative_frequencies(genome_af, opt$translation)
write.table(genome_rf, opt$output)