## Load your packages, e.g. library(targets).
source("./packages.R")

plan(batchtools_sge, template = "sge.tmpl")

tar_option_set(format = "qs", 
               resources = tar_resources(
                 qs = tar_resources_qs(preset = "fast"),
                 future = tar_resources_future(plan = tweak(
                   batchtools_sge,
                   template = "sge.tmpl",
                   resources = list(
                     memory = "4G"
                   )))))

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

tar_plan(
  
  tar_target(name = conda_env,
             command = setup_conda_env(),
             format = "file",
             resources = tar_resources(
               future = tar_resources_future(plan = tweak(
                 batchtools_sge,
                 template = "sge.tmpl",
                 resources = list(
                   ngpus = 1,
                   ncpus = 1,
                   memory = "16G"
                 ))))),

  tar_target(name = keras_data,
             command = make_keras_data(conda_env),
             resources = tar_resources(
               future = tar_resources_future(plan = tweak(
                 batchtools_sge,
                 template = "sge.tmpl",
                 resources = list(
                   ngpus = 1,
                   ncpus = 4,
                   memory = "8G"
                 ))))),

  tar_target(name = hearts_keras_model,
             command = make_hearts_model(keras_data),
             format = "keras",
             resources = tar_resources(
               future = tar_resources_future(plan = tweak(
                 batchtools_sge,
                 template = "sge.tmpl",
                 resources = list(
                   ngpus = 1,
                   ncpus = 4,
                   memory = "8G"
                 )))))
)