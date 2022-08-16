#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

setup_conda_env <- function() {
  
  if(!dir.exists("miniconda")){
    install_miniconda(path = "miniconda")
    
    conda_create(envname = "./miniconda/envs/tensorflow", forge = T, conda = "./miniconda/condabin/conda", python_version = "3.7", packages = c("tensorflow-gpu", "keras-gpu"))
    
    use_condaenv(condaenv = "./miniconda/envs/tensorflow/", conda = "./miniconda/condabin/conda")
    use_python(python = "./miniconda/envs/tensorflow/bin/python3.7m")
    
  }

  list.files("./miniconda/envs/tensorflow", full.names = T)
  
}
