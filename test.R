library(here)
library(data.table)
library(tinyplot)
library(parameters)

library(rms)
library(grf)
library(tmle)
library(SuperLearner)
library(WeightIt)
library(marginaleffects)
library(MatchIt)


lalonde <- setDT(MatchIt::lalonde)

ols_fit <- rms::ols(re78 ~ treat + age + educ + race + married + nodegree + re74 + re75, data = lalonde)


# rhc <- data.table::fread(here::here("rhc.csv")) |> 
#     dplyr::mutate(
#         swang1 = if_else(swang1 == "RHC", 1, 0), 
#         death01 = if_else(death == "Yes", 1, 0)
#     ) |> 
#     tidyr::drop_na(death01, swang1, age, crea1, alb1, hrt1)

