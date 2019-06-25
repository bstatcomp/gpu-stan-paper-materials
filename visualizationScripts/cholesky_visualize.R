# This script visualizes the speedups for the Cholesky for different scenarios
# and GPUs.
#
# Note: Set working directory to the location of this script. The script assumes
# that the root structure of the results output was preserved.

library(reshape2)
library(ggplot2)

data_path <- "../measurementData/Cholesky/"
scenario_folders <- list.files(data_path, include.dirs = T, full.names = F)
all_res <- NULL

for (folder in scenario_folders) {

  gpus <- list.files(paste0(data_path, folder), full.names = F)

  res <- NULL

  for (gpu in gpus) {

    dat <- read.table(paste0(data_path, folder, "/", gpu))
    tmp <- melt(dat, id.vars = "V1")
    res <- rbind(res, data.frame(GPU = strsplit(gpu, "_", fixed = T)[[1]][1],
                                 N = tmp[,1],
                                 Time = tmp[,3]))
  }

  # calculate speedups, remove CPU
  tmp <- tapply(res$Time, list(res$GPU, res$N), median)
  tmp <- 1 / tmp
  tmp <- sweep(tmp, 2, 1 / tmp[row.names(tmp) == "i7",], "*")
  tmp <- tmp[row.names(tmp) != "i7", ]
  tmp <- melt(tmp)
  names(tmp) <- c("GPU", "n", "speedup")
  tmp$scenario <- folder

  all_res <- rbind(all_res, tmp)
}

all_res <- all_res[complete.cases(all_res),]

g1 <- ggplot(all_res, aes(x = n, y = speedup, group = GPU, colour = GPU)) +
  geom_point() + geom_line()+ theme_bw()  +
  theme(legend.position="bottom") + facet_wrap(~ scenario)
plot(g1)
ggsave(g1, file = "./output/cholesky_speedups.pdf", width = 10.5, height = 4)

