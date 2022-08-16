#' .. content for \description{} (no empty lines) ..
#'  Modified from https://tensorflow.rstudio.com/guide/tfdatasets/feature_spec/
#' .. content for \details{} ..
#'
#' @title
#' @param conda_env
make_keras_data <- function(conda_env) {
  
  use_python(python = "miniconda/envs/tensorflow/bin/python3.7m")
  use_condaenv(condaenv = "./miniconda/envs/tensorflow/", conda = "./miniconda/condabin/conda")

  library(tfdatasets)
  
  #Download dataset example (heart attack risk)
  data(hearts)
  
  #Split into train and test set
  set.seed(-10)
  ids_train <- sample.int(nrow(hearts), size = 0.75*nrow(hearts))
  hearts_train <- hearts[ids_train,]
  hearts_test <- hearts[-ids_train,]
  
  return(list("train" = hearts_train,
              "test" = hearts_test))
  
}
