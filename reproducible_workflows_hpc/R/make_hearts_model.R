#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param keras_data
make_hearts_model <- function(keras_data) {

  library(tensorflow)
  library(keras)
  library(tfdatasets)

  # We scale all numeric columns initially due to bug mentioned with
  # normalizer_fn
  hearts_train <- keras_data$train %>%
    mutate(across(where(is.numeric) & !c(age, target), ~scale(.x)))
  hearts_test <- keras_data$test %>%
    mutate(across(where(is.numeric) & !c(age, target), ~scale(.x)))
  
  #Data wrangling specifications - standard mean subtraction and
  #variance normalization on all numeric columns except a few
  #that need other processing, to avoid bug with normalizer_fn we do scaling first before setting up
  # wrangling specifications...left the commented code to see how it could be done only via step_numeric_column
  spec <- feature_spec(hearts_train, target ~ .)
  spec <- spec %>% 
    step_numeric_column(
      all_numeric(), -cp, -restecg, -exang, -sex, -fbs
      # normalizer_fn = scaler_standard() # Bug prevents model from saving during serialization (see https://github.com/rstudio/tfdatasets/pull/82)
    ) %>%
    # Set up categorical column using thal column
    step_categorical_column_with_vocabulary_list(thal)
  
  # Change age into buckets of age groups
  spec <- spec %>% 
    step_bucketized_column(age, boundaries = c(18, 25, 30, 35, 40, 45, 50, 55, 60, 65))
  
  # Change categorical to numeric representation as an embedding layer
  spec <- spec %>% 
    step_indicator_column(thal) %>% 
    step_embedding_column(thal, dimension = 2)
  
  # Add interaction between tha1 and age
  spec <- spec %>% 
    step_crossed_column(thal_and_age = c(thal, bucketized_age), hash_bucket_size = 1000) %>% 
    step_indicator_column(thal_and_age)
  
  # Fit the data wranging steps
  spec_prep <- fit(spec)
  
  # Set up the model to use the wrangled data to predict
  # target column (diagnosis of heart disease angiographic)
  # we will use Adam with binary crossentropy for optimization
  # on accuracy of prediction
  input <- layer_input_from_dataset(hearts_train %>% select(-target))
  
  output <- input %>% 
    layer_dense_features(dense_features(spec_prep)) %>% 
    layer_dense(units = 32, activation = "relu") %>% 
    layer_dense(units = 1, activation = "sigmoid")
  
  model <- keras_model(input, output)
  
  model %>% compile(
    loss = loss_binary_crossentropy, 
    optimizer = "adam", 
    metrics = "binary_accuracy"
  )
  
  model %>%
    fit(x = hearts_train %>% select(-target),
        y = hearts_train$target,
        epochs = 15,
        validation_split = 0.2)
  
  model

}
