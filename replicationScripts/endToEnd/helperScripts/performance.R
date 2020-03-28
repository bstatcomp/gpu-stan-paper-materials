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