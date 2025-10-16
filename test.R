#' ---
#' title: "AF 速報解析"
#' format:
#'   revealjs:
#'     slide-number: true
#'     incremental: true
#'     code-overflow: wrap
#'     theme: default
#' ---

#| include: false
#| message: false
#| warning: false
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

#' ## データ
#' - データソース: 〇〇
#' - 期間: 20XX-01-01〜20XX-12-31
#' - 主要変数: 〜〜

#| include: false
#| message: false
#| warning: false

lalonde <- setDT(MatchIt::lalonde)
ols_fit <- rms::ols(re78 ~ treat + age + educ + race + married + nodegree + re74 + re75, data = lalonde)
ols_rcs_fit <- rms::ols(re78 ~ treat + rcs(age,4) + educ + race + married + nodegree + rcs(re74, 4) + rcs(re75, 4), data = lalonde)
orm_fit <- rms::orm(re78 ~ treat + age + educ + race + married + nodegree + re74 + re75, data = lalonde)
orm_rcs_fit <- rms::orm(re78 ~ treat + rcs(age,4) + educ + race + married + nodegree + rcs(re74, 4) + rcs(re75, 4), data = lalonde)

#' ## 主要結果

#' ## 主要結果
#' 散布図と回帰直線。
tinyplot::plt(re78 ~ age, data = lalonde)

#' ---
#' ## 回帰モデル


#' ### 話すメモ
#' ::: notes
#' - 交互作用の符号と解釈
#' - 次スライドで感度分析
#' :::

# rhc <- data.table::fread(here::here("rhc.csv")) |> 
#     dplyr::mutate(
#         swang1 = if_else(swang1 == "RHC", 1, 0), 
#         death01 = if_else(death == "Yes", 1, 0)
#     ) |> 
#     tidyr::drop_na(death01, swang1, age, crea1, alb1, hrt1)

