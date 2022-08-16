#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param entrez_db_summaries
write_pop_set <- function(entrez_db_summaries) {

    if(!dir.exists("output/fasta")){
      use_directory("output/fasta")
    }
    
    pop_search <- entrez_search(db="popset", term="1847589303[UID]")
    
    pop_results <- entrez_fetch(db="popset", id = pop_search$ids, rettype = "fasta")
    
    write(pop_results, "output/fasta/pop_set.fasta")
    
    list.files("output/fasta", pattern = ".fasta", full.names = T)

}
