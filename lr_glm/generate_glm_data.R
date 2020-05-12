library(jsonlite)

generator = function(seed = 0, n = 1000, k = 10) {

  inv_logit <- function(x) {
    1 / (1 + exp(-x))
  }

  set.seed(seed)
  X <- matrix(rnorm(n * k), ncol = k)

  y <- 3 * X[,1] - 2 * X[,2] + 1
  p <- runif(n)
  y <- ifelse(p < inv_logit(y), 1, 0)

  list(k = ncol(X), n = nrow(X), y = y, X = X)
}

data <- generator(1, 200, 50)

jsonlite::write_json(
  data,
  path = "lr_glm.data.json",
  auto_unbox = TRUE,
  factor = "integer",
  digits = NA,
  pretty = TRUE
)
