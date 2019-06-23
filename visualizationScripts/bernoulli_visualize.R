# This script visualizes the times and speedups for logistic regression.
#
# Note: Set working directory to the location of this script. The script assumes
# that the root structure of the results output was preserved.

library(ggplot2)

dat <- readRDS("../measurementData/Bernoulli/bernoulli.rds")

# fixed k measurements
dat1 <- dat[dat$k == 10,]
g1 <- ggplot(dat1, aes(x = n, y = time_in_ms, group = type, colour = type)) +
  geom_point() + geom_line() + theme(legend.position="bottom") + ylab("time (ms)")
plot(g1)
ggsave(g1, file = "./output/bernoulli_fixed_k.pdf", width = 10.5 / 3 + 1, height = 4)

dat1 <- aggregate(time_in_ms ~ type + n + k, data = dat1, FUN = mean)
tmp  <- dat1
for (i in 1:nrow(tmp)) {

  tmp[i,]$time_in_ms <- dat1[dat1$type == "basic" & dat1$n == tmp[i,]$n,]$time_in_ms / dat1[i,]$time_in_ms
}

g1 <- ggplot(tmp, aes(x = n, y = time_in_ms, group = type, colour = type)) +
  geom_point() + geom_line() + theme(legend.position="bottom") + ylab("speedup (relative to basic)")
plot(g1)
ggsave(g1, file = "./output/bernoulli_fixed_k_speedup.pdf", width = 10.5 / 3 + 1, height = 4)

# variable k measurements
dat1 <- dat[dat$k != 10,]
g1 <- ggplot(dat1, aes(x = k, y = time_in_ms, group = type, colour = type)) +
  geom_point() + geom_line() + theme(legend.position="bottom") + ylab("time (ms)")
plot(g1)
ggsave(g1, file = "./output/bernoulli_variable_k.pdf", width = 10.5 / 3 + 1, height = 4)

dat1 <- aggregate(time_in_ms ~ type + n + k, data = dat1, FUN = mean)
tmp  <- dat1
for (i in 1:nrow(tmp)) {
  tmp[i,]$time_in_ms <- dat1[dat1$type == "basic" & dat1$k == tmp[i,]$k,]$time_in_ms / dat1[i,]$time_in_ms
}

g1 <- ggplot(tmp, aes(x = k, y = time_in_ms, group = type, colour = type)) +
  geom_point() + geom_line() + theme(legend.position="bottom") + ylab("speedup (relative to basic)")
plot(g1)
ggsave(g1, file = "./output/bernoulli_variable_k_speedup.pdf", width = 10.5 / 3 + 1, height = 4)


