#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

make_db_summaries <- function() {

    dbs <- entrez_dbs()
    
    db_summaries <- map(dbs, ~entrez_db_summary(.x))
    
    names(db_summaries) <- dbs
    
    db_summaries
    
}
