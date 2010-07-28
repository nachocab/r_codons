library(seqinr)

get_codon_aa_table <- function(genome, trans_table=1){
    codons <- colnames(genome) # aaa ... ttt
    aminos <- sapply(codons, function(x) aaa(translate(s2c(x), numcode=trans_table))) # Lys ... Phe
    # generates a list with the codons of each aa: codons_of$Phe => "ttt" "ttc"
    sapply(unique(aminos), function(x) c(names(aminos[aminos == x])))
}

calculate_relative_frequencies <- function(genome, trans_table=1){
    codons_of <- get_codon_aa_table(genome, trans_table)
    # we only want to use aas with more than one synonymous codon
    codons_of <- codons_of[sapply(codons_of,function(x) length(x) > 1)]

    genome_rf <- sapply(names(codons_of), function(x) {
        t(apply(genome[,codons_of[[x]]],1, function(x) x/sum(x)))
    })
    genome_rf <- do.call('cbind',genome_rf)
    genome_rf <- genome_rf[,order(colnames(genome_rf))]
}

shannon.entropy <- function(x){
    -sum(x*log2(x))
}

# calculates the shannon weighted entropy for each gene
shannon.weighted.entropy <- function(entropies, degeneracies, aa_freqs){
    ae <- aa_freqs*entropies
    apply(ae,1, function(x) sum(x/log2(degeneracies)))
}

my_cai <- function(af_data, w){
    sigma <- af_data %*% log(w)
    exp(sigma/sum(af_data))
}

drop.levels <- function(dat){
  # Drop unused factor levels from all factors in a data.frame
  # Author: Kevin Wright.  Idea by Brian Ripley.
  dat[] <- lapply(dat, function(x) x[,drop=TRUE])
  return(dat)
}