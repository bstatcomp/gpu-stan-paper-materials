# This script visualizes the times and speedups for GP regression.
#
# Note: Set working directory to the location of this script. The script assumes
# that the root structure of the results output was preserved.

library(ggplot2)

dat <- readRDS("../measurementData/GP//gp.rds")

g1 <- ggplot(dat, aes(x = n, y = time_in_ms, group = type, colour = type)) +
  geom_point() + geom_line() + theme_bw() + theme(legend.position="bottom") + ylab("time (ms)")
plot(g1)
ggsave(g1, file = "./output/gp.pdf", width = 10.5 / 3 + 1, height = 4)

# extrapolate 4096 and 6144 for CPU
tmp <- dat[dat$type == "cpu",]
tmp1 <- data.frame(x = log(tmp$n), y = log(tmp$time_in_ms))
model <- lm(y ~ x, tmp1)
new_rows <- tmp[1:2,]
new_rows$n <- c(4096, 6144)
new_rows$time_in_ms <- exp(predict(model, data.frame(x = log(c(4096, 6144)))))
dat <- rbind(dat, new_rows)
#

dat <- aggregate(time_in_ms ~ type + n, data = dat, FUN = mean)
tmp <- dat
for (i in 1:nrow(tmp)) {
  tmp[i,]$time_in_ms <- dat[dat$type == "cpu" & dat$n == tmp[i,]$n,]$time_in_ms / dat[i,]$time_in_ms
}

g1 <- ggplot(tmp, aes(x = n, y = time_in_ms, group = type, colour = type)) +
  geom_point() + geom_line()  + theme_bw() + theme(legend.position="bottom") + ylab("speedup (relative to CPU)")
plot(g1)
ggsave(g1, file = "./output/gp_speedup.pdf", width = 10.5 / 3 + 1, height = 4)