rm(list=ls())
m1 <- read.csv('data/results/predictions-03102018-a.csv', stringsAsFactors = FALSE)
m2 <- read.csv('data/results/predictions-03102018-b.csv', stringsAsFactors = FALSE)
m3 <- read.csv('data/results/predictions-03102018-c.csv', stringsAsFactors = FALSE)
m4 <- read.csv('data/results/predictions-03102018-d.csv', stringsAsFactors = FALSE)
m5 <- read.csv('data/results/predictions-03102018-e.csv', stringsAsFactors = FALSE)

models.mat <- merge(m1, m2, by = "id")

models.mat <- merge(models.mat, m3, by = "id")

models.mat <- merge(models.mat, m4, by = "id")

models.mat <- merge(models.mat, m5, by = "id")

names(models.mat) <- c("id", "m1", "m2", "m3", "m4", "m5")

cor(models.mat[,c("m1", "m2", "m3", "m4", "m5")])
plot(density(models.mat$m1))
lines(density(models.mat$m2))
lines(density(models.mat$m3))
lines(density(models.mat$m4))
lines(density(models.mat$m5))
summary(models.mat)
