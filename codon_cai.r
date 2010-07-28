# Usage: Rscript codon_cai.r -[i|input] <input_file> -[o|output] <output_file>
library(getopt)
source("codon_services.r")

opt <- getopt(matrix(c(
    'input','i',1,'character',
    'output','o',1,'character',
    'translation','t',2,'integer'), 
    byrow=T, ncol=4))

# read codon frequency matrix in wide format
genome_af <- read.table(opt$input, header=T)
genome_af <- genome_af[,!grepl("atg|tgg",colnames(genome_af))]

# calculate gene correlation with global profile
global_genome_af <- as.integer(genome_af[1,])
gene_corr <- apply(genome_af[-1,], 1, function(x) cor(x,global_genome_af))

# choose top 1% correlated genes to be S (representative set of genes for the organism)
template_gene_names <- names(sort(gene_corr,decreasing=T)[1:(nrow(genome_af)/100)])
template_genes_af <- genome_af[template_gene_names,]
global_template_genes_af <- data.frame(t(apply(template_genes_af, 2, sum)))

# calculate template relative frequencies
template_rf <- calculate_relative_frequencies(global_template_genes_af, 1)

# calculate cai
genome_cai <- apply(genome_af[-1,], 1, function(x) my_cai(x, template_rf))
write.table(genome_cai, opt$output)