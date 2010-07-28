library(getopt)
source("codon_services.r")

# read parameters
opt <- getopt(matrix(c(
    'input','i',1,'character',
    'output','o',1,'character',
    'translation','t',2,'integer'), 
    byrow=T, ncol=4))
if (is.null(opt$translation)) opt$translation <- 1    
    
genome_rf <- read.table(opt$input, header=T)

codons_of <- get_codon_aa_table(genome_rf, opt$translation)

# we only want to use aas with more than one synonymous codon
codons_of <- codons_of[sapply(codons_of,function(x) length(x) > 1)]

# for each aa (Phe, Lys,...), get its codons (columns),
genome_entropies <- sapply(names(codons_of), function(x) {
    #access their rf and calculate entropy (on rows)
    apply(genome_rf[,codons_of[[x]]],1, shannon.entropy)
})
write.table(genome_entropies, opt$output)