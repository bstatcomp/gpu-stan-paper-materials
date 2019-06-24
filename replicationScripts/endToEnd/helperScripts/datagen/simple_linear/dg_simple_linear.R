generator = function(variant) {
  
  inv_logit <- function(x) {
    1 / (1 + exp(-x))  
  }
  
  set.seed(variant$seed)
  X <- matrix(rnorm(variant$n * variant$k), ncol = variant$k)

  if (is.null(variant$type) || variant$type == "normal") {
    y <- 3 * X[,1] - 2 * X[,2] + 5
    y <- y + rnorm(variant$n)
  } else if (variant$type == "bernoulli") {
    y <- 3 * X[,1] - 2 * X[,2] + 1
    p <- runif(variant$n)
    y <- ifelse(p < inv_logit(y), 1, 0)
  } else {
    error("unsupported type of dataset")
  }
  
  list(k = ncol(X), n = nrow(X), y = y, X = X)
}

normalizer <- function(x) {
  results <- data.frame(beta.1 = mean(x$beta.1),
            beta.2 = mean(x$beta.2),
            beta.3 = mean(x$beta.3),
            alpha = mean(x$alpha),
            sigma = mean(x$sigma),
            accept = mean(x$accept_stat__),
            tree = mean(x$treedepth__),
            step = mean(x$stepsize__))
  results
}

dg_simple_linear <- function(variants = expand.grid(seed = 0, 
                                         n = 4^(2:5),
                                         k = c(10), 
                                         type = "normal")) {
  
  res <- create_datagen("dg_simple_linear",
                                  variants = variants,
                                  generator = generator,
                                  normalizer = normalizer
    )
  
  res
}
