## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(
  
  tar_target(entrez_db_summaries, make_db_summaries()),
  
  tar_target(pop_set_file, write_pop_set(entrez_db_summaries), format = "file"),

  tar_target(phylo_viz, write_phylo_viz(pop_set_file), format = "file")

)
