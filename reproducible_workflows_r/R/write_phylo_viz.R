#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pop_set_file
write_phylo_viz <- function(pop_set_file) {
  
  # Read the population set file and align all sequences with msa
  coi <- readDNAStringSet(pop_set_file, format = "fasta")
  coi_aligned <- msaClustalW(coi)
  
  # Convert aligned sequences to DNAbin
  coi_aligned <- as.DNAbin(coi_aligned)
  
  # Perform neighbor-joining tree estimation and label the nodes
  tree <- nj(dist.dna(coi_aligned))
  labels <- str_split(tree$tip.label, " ")
  label <- map_chr(labels, ~.x[[1]])
  species <- map_chr(labels, ~paste(.x[2:3], collapse = " "))
  
  tree$tip.label <- paste(label, species, sep = ": ")
  
  # Create ggtree plot of phylogenetic tree
  p <- ggtree(tr = tree) + geom_tiplab()
  
  # Create output directory and save the plot
  if(!dir.exists("output/plots")){
    use_directory("output/plots")
  }
  
  ggsave(filename = "phylo_tree.jpg", path = "output/plots", plot = p,
         device = "jpeg", width = 40, height = 20, units = "in", dpi = 300)
  
  # List the full path of the saved file to return to target
  list.files("output/plots", pattern = "phylo_tree", full.names = T)
  
  
}
