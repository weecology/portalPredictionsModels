#' @importFrom coda as.mcmc HPDinterval
#' @importFrom forecast Arima auto.arima ets forecast na.interp
#' @importFrom graphics abline axis mtext par plot points polygon rect text
#' @importFrom grDevices grey rgb
#' @importFrom httr content GET stop_for_status
#' @importFrom jsonlite fromJSON serializeJSON unserializeJSON write_json
#' @importFrom portalr get_future_moons load_trapping_data ndvi 
#'  summarize_rodent_data weather
#' @importFrom runjags run.jags runjags.options
#' @importFrom rEDM simplex tde_gp
#' @importFrom scoringRules crps_sample
#' @importFrom stats AIC lm na.omit predict qnorm quantile rgamma rnorm runif
#'  sd
#' @importFrom tscount tsglm
#' @importFrom utils download.file packageDescription read.csv sessionInfo
#'  tail unzip write.csv write.table
#' @importFrom viridis viridis
#' @importFrom yaml as.yaml yaml.load_file

#' @title Functions for Portalcasting (Forecasting Portal Rodents)
#'
#' @description This package contains the functions used for continuous
#'  analysis and forecasting of 
#'  \href{https://portal.weecology.org/}{Portal rodent populations},
#'  as implemented in the 
#'  \href{https://bit.ly/2Lo2xnQ}{Portal Predictions repository}. \cr
#'  Functions in \code{portalcasting} are designed to be portable, allowing
#'  users to set up a fully-functional replica repository for development
#'  and testing of new models (a.k.a. \emph{sandboxing}) in the same 
#'  directory and codebase as the production pipeline. 
#'
#' @name portalcasting
#'
#' @docType package
#'
#' @keywords package
#'
NULL

