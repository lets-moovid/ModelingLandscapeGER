library(tidyverse)
library(rvest)


urls <-  paste0("https://iddjobs.org/jobs/archive/", c("phd", "postdoc", "junior_faculty", "senior_faculty", "non_academic", "other")) %>% as.list()

getIDD <- function(url) {
    return(url %>% read_html() %>% html_nodes("table") %>% html_table(fill = T) %>% as.data.frame())
}

results <- lapply(urls, getIDD)

str(results)

str(df)

tables <- data.frame()

for (i in seq(2,18,2)) {
    temp <- df[[i]] 
  tables <- bind_rows(tables, temp)
}