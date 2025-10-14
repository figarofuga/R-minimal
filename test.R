library(here)
library(data.table)
library(rms)
library(tidyverse)
library(grf)
library(tmle)
library(SuperLearner)

rhc <- data.table::fread(here::here("rhc.csv")) |> 
    dplyr::mutate(
        swang1 = if_else(swang1 == "RHC", 1, 0), 
        death01 = if_else(death == "Yes", 1, 0)
    ) |> 
    tidyr::drop_na(death01, swang1, age, crea1, alb1, hrt1)

Y <- rhc$death01
A <- rhc$swang1
W <- rhc[, c("age", "crea1", "alb1", "hrt1")]


tmle::tmle(
  Y,
  A,
  W,
  family = "binomial",
  Q.SL.library = c("SL.mean"),
  g.SL.library = c("SL.mean"),
  verbose = TRUE
)

fit <- grf::quantile_forest(
  X = W,
  Y = rhc$hema1,
  quantiles = c(0.25, 0.5, 0.75)
)

tinyplot::plt(
  alb1 ~ hema1 | sex, data = rhc, alpha = 0.5, 
  xlab = "ヘマトクリット", ylab = "アルブミン"

)
