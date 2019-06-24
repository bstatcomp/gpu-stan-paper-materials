generator = function(variant) {
  N <- variant$n
  x <- runif(N, -10, 10)
  y <- x + 4 * x ^ 2 - x ^ 3 + 100 * sin(x * 2)
  y <- as.vector(((y - 133.4722) / 400.7542) + rnorm(N, 0, .1))
  N_predict <- N
  x_predict <- runif(N_predict, -10, 10)
  list(N = N, x = x, y = y, N_predict = N_predict, x_predict = x_predict)
}

normalizer <- function(x) {
  results <- data.frame(y.1 = mean(x$y_predict.1),
                        y.2 = mean(x$y_predict.2),
                        y.3 = mean(x$y_predict.3),
                        alpha = mean(x$alpha),
                        sigma = mean(x$sigma),
                        rho = mean(x$sigma),
                        accept = mean(x$accept_stat__),
                        tree = mean(x$treedepth__),
                        step = mean(x$stepsize__))
  results
}

dg_1D_nonlinear <- function(variants = expand.grid(seed = 0, n = 100)) {
  
  res <- create_datagen("dg_1d_nonlinear",
                        variants = variants,
                        generator = generator,
                        normalizer = normalizer
  )
  
  res
}