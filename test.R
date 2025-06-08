library(here)
library(data.table)
library(tidyverse)
library(grf)
library(tmle)

rhc <- data.table::fread(here::here("rhc.csv")) |> 
    dplyr::mutate(
        swang1 = if_else(swang1 == "RHC", 1, 0)
    )



tmle::tmle(
  Y = rhc$y,
  A = rhc$A,
  W = rhc[, c("x1", "x2", "x3")],
  family = "binomial",
  Q.SL.library = c("SL.mean"),
  g.SL.library = c("SL.mean"),
  verbose = TRUE
)