# This script visualizes the times and speedups for GP regression.
#
# Note: Set working directory to the location of this script. The script assumes
# that the root structure of the results output was preserved.

library(ggplot2)

dat <- readRDS("../measurementData/GP//gp.rds")

g1 <- ggplot(dat, aes(x = n, y = time_in_ms, group = type, colour = type)) +
  geom_point() + geom_line() + theme(legend.position="bottom") + ylab("time (ms)")
plot(g1)
ggsave(g1, file = "./output/gp.pdf", width = 10.5 / 3 + 1, height = 4)

dat <- aggregate(time_in_ms ~ type + n, data = dat, FUN = mean)
tmp <- dat
for (i in 1:nrow(tmp)) {
  tmp[i,]$time_in_ms <- dat1[dat1$type == "cpu" & dat$n == tmp[i,]$n,]$time_in_ms / dat[i,]$time_in_ms
}

g1 <- ggplot(tmp, aes(x = n, y = time_in_ms, group = type, colour = type)) +
  geom_point() + geom_line() + theme(legend.position="bottom") + ylab("speedup (relative to CPU)")
plot(g1)
ggsave(g1, file = "./output/gp_speedup.pdf", width = 10.5 / 3 + 1, height = 4)