# Usage: Rscript codon_plot.r -[i|input] <input_file> [-[-output|o] <output_file>] [--genes=<comma_separated_gene_lines>] [--only_codons=<comma_separated_codons] [--except_codons=<comma_separated_codons]
library(plyr)
library(reshape)
library(grid)
library(proto)
library(ggplot2)
library(getopt)
source("codon_services.r")


opt <- getopt(matrix(c(
    'input','i',1,'character',
    'output','o',1,'character',
    'lines','l',0,'logical',
    'bars','b',0,'logical',
    'genes','g',2,'character',
    'only_codons','s',2,'character',
    'except_codons','e',2,'character',
    'width','w',1,'integer'), 
    byrow=T, ncol=4))
    
# set defaults
if (is.null(opt$genes)) opt$genes <- 1 else {
   opt$genes <- as.integer(strsplit(opt$genes, ",")[[1]])
} 
if (is.null(opt$height)) opt$height <- 7 
if (is.null(opt$width)) opt$width <- 7

genome_rf <- read.table(opt$input, header=T)

# define what codons are going to be plotted
if (!is.null(opt$only_codons) && is.null(opt$except_codons)){
    codons <- strsplit(opt$only_codons, ",")[[1]]
} else if (is.null(opt$only_codons) && !is.null(opt$except_codons)){
    remove_codons <- strsplit(opt$except_codons, ",")[[1]]
    codons <- setdiff(colnames(genome_rf),remove_codons)
} else {
    codons <- colnames(genome_rf)
}
genome_rf <- genome_rf[opt$genes, codons]
genome_rf <- drop.levels(genome_rf)
genome_rf$gene <- rownames(genome_rf)

m_cu <- melt(genome_rf)
colnames(m_cu) <- c("gene","codon","rf")
m_cu$gene <- factor(m_cu$gene)

if(is.null(opt$bars)){
    ggplot(m_cu, aes(codon,rf)) + geom_line(aes(group=gene, color=gene))
} else {
    ggplot(m_cu, aes(codon,rf, fill=gene)) + geom_bar(position="dodge")
}    
ggsave(file=opt$output, width=opt$width, height=opt$height)

