
library(tidyverse)
library(rvest)
library(ggplot2)


occ_levels <- c("phd", "postdoc", "junior_faculty", "senior_faculty", "non_academic", "other")


getIDD <- function(url) {
  dummy <- url %>% read_html() %>% html_nodes("table") %>% html_table(fill = T)
  return(dummy[[1]])
}