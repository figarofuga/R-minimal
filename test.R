#' ---
#' title: "AF 速報解析"
#' format:
#'   html
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
#' - データソース: lalonde
#' - results of RCT is 1794.3433.
#' - 主要変数: treat, age, educ, race, married, nodegree, re74, re75
#' ## 通常の回帰モデル


#| include: false
#| message: false
#| warning: false

lalonde <- setDT(MatchIt::lalonde)

univariate_fit <- rms::ols(re78 ~ treat, data = lalonde)
ols_fit <- rms::ols(re78 ~ treat + age + educ + race + married + nodegree + re74 + re75, data = lalonde)
ols_rcs_fit <- rms::ols(re78 ~ treat + rcs(age,4) + educ + race + married + nodegree + rcs(re74, 4) + rcs(re75, 4), data = lalonde)


regression_res <- parameters::compare_models(
  univariate_fit,
  ols_fit,
  ols_rcs_fit, 
  keep = c("treat"))

display(regression_res, format = "tt")

#' ## Propensity score matching

m_out <- MatchIt::matchit(
    treat ~ age + educ + race + married + nodegree + re74 + re75, 
    data = lalonde, 
    estimand = "ATT",
    method = "nearest", 
    distance = "glm")

matched_data <- MatchIt::match.data(m_out)

ps_fit <- lm(re78 ~ treat * (age + educ + race + married +
                            nodegree + re74 + re75),
          data = matched_data,
          weights = weights)

matched_res <- avg_comparisons(ps_fit,
                variables = "treat",
                vcov = ~subclass)

#' ## 主要結果
#' 散布図と回帰直線。
tinyplot::plt(re78 ~ age, data = lalonde)

#' ---



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

