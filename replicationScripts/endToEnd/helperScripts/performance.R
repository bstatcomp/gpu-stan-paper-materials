library(rstan)
library(digest)
library(microbenchmark)

# TODO:
# - models support individual data and output transforms
# - models support individual additional data
# - don't recompute results that you already have
# - cmdstan param change shouldn't force model rebuild

get_cmdstan_param_string <- function(num_samples = 200,
                                     num_warmup  = 200,
                                     seed = 0) {
  s <- paste0(
    " num_samples=", num_samples,
    " num_warmup=", num_warmup,
    " random seed=", seed
  )
  s
}

get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}

create_datagen <- function(name, variants, generator, normalizer) {
  list(name = name, variants = variants, generator = generator, normalizer = normalizer)
}

compile_and_sample <- function(stan_file,
                               stan_data,
                               cmdstan_dir,
                               temp_dir,
                               cmdstan_param_string) {
  
  # Hash experiment settings ---------------------------------------------------
  model_code <- readLines(stan_file)
  experiment_hash <- digest(list(model_code, cmdstan_dir, cmdstan_param_string))
  
  # Copy model code and compile model ------------------------------------------
  model_name <- paste0("model_", experiment_hash)
  model_file <- paste0(temp_dir, "/", model_name, ".stan")
  if (!file.exists(model_file)) writeLines(model_code, con = model_file)
  
  exe_file <- paste0(temp_dir, model_name, ".exe")
  if (get_os() != "windows")   exe_file <- paste0(temp_dir, model_name)
  make_call <- paste0("make --directory=", cmdstan_dir, " ", exe_file)
  print(make_call)
  if (!file.exists(exe_file)) system(make_call, intern = T)
  
  # Dump dataset if needed -----------------------------------------------------
  data_file <- paste0(temp_dir, "/", digest(stan_data), "_data.R")
  
  if (!file.exists(data_file)) {
    nms <- c()
    for (i in 1:length(stan_data)) {
      nm <- names(stan_data)[i]
      nms <- c(nms, nm)
      eval(parse(text = paste0(nm, " <- stan_data[[i]]")))
    }
    rstan::stan_rdump(nms, file = data_file)
  }
  
  # Sample from model ----------------------------------------------------------
  samples_file <- paste0(temp_dir, "/", experiment_hash, "_samples.csv")

  x <- microbenchmark(
    system(paste0(
      exe_file,
      " method=sample",
      "", cmdstan_param_string,
      " data file=", data_file,
      " output file=", samples_file
    )),
    times = 1
  )
  
  return (list(samples = read.table(samples_file, sep = ",", h = T), 
               time_in_millis = x$time / 1000000))
}

create_model <- function(stan_file, 
                         cmdstan_dir = NULL, 
                         temp_dir = NULL, 
                         cmdstan_param_string = NULL) {

  return (list(stan_file = stan_file, 
               cmdstan_dir = cmdstan_dir,
               temp_dir = temp_dir, 
               cmdstan_param_string = cmdstan_param_string))
  
}

benchmark <- function(models, 
                      datagens,
                      cmdstan_dir,
                      temp_dir,
                      n_reps = 1,
                      cmdstan_param_string = "") {

  for (datagen in datagens) {
      res <- NULL
      for (i in 1:nrow(datagen$variants)) {
        variant <- datagen$variants[i,]
        stan_data <- datagen$generator(variant)
        print(variant)
        for (model in models) {
          
          for (j in 1:n_reps) {
            
            tmp <- compile_and_sample(model$stan_file,
                                           stan_data,
                                           ifelse(is.null(model$cmdstan_dir), cmdstan_dir, model$cmdstan_dir),
                                           ifelse(is.null(model$temp_dir), temp_dir, model$temp_dir),
                                           ifelse(is.null(model$cmdstan_param_string), cmdstan_param_string, model$cmdstan_param_string)
                                           )
            
            results <- datagen$normalizer(tmp$samples)
            
            res <- rbind(res, data.frame(stan_file = model$stan_file, 
                                         cmdstan_dir = ifelse(is.null(model$cmdstan_dir), cmdstan_dir, model$cmdstan_dir),
                                         datagen = datagen$name,
                                         time_in_ms = tmp$time_in_millis, 
                                         variant = i, rep = j, variant, results))
          }
    
        }
        
      }
    
  }
    
  return (list(all_results = res))
}