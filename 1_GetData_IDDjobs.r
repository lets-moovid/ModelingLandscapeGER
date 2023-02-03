

source("0_helper.R")

urls <-  paste0("https://iddjobs.org/jobs/archive/", occ_levels)

results <- lapply(urls, getIDD)
names(results) <- occ_levels

df <- bind_rows(results, .id = "LEVEL") %>%
  separate('Closing date', into = c("MonthDay", "Year"), sep=",", convert=T) %>%
  mutate(Country = gsub("^.*,", "", Location)) %>%
  mutate(Country = str_to_lower(Country), Country = str_trim(Country, side = "both")) %>%
  mutate(Country = ifelse(Country %in% c("españa"), "spain", Country), 
         Country = ifelse(Country %in% c("cambodia (flexible in the gms)"), "spain", Country), 
         Country = ifelse(Country %in% c("myanmar (flexible in gms)"), "myanmar", Country), 
         Country = ifelse(Country %in% c("netherlands"), "the netherlands", Country),
         Country = ifelse(Country %in% c("u.k.", "uk", "warwick", "surrey", "wiltshire", "scotland", "united kingdon", "england"), "united kingdom", Country),
         Country = ifelse(Country %in% c("usa", "ga", "ca", "ma", "md", "mi", "u.s.a.", "us", "united stated", "united sates", "united states of america", "university"), "united states", Country),
         Country = ifelse(Country %in% c("deutschland"), "germany", Country),
         Country = ifelse(Country %in% c("hong kong sar"), "hong kong", Country),
         Country = ifelse(Country %in% c("belgië"), "belgium", Country),
         Country = ifelse(Country %in% c("schweiz"), "switzerland", Country),
         Country = ifelse(Country %in% c("quebec"), "canada", Country),
         Country = ifelse(Country %in% c("viet nam"), "vietnam", Country),
         Country = ifelse(Country %in% c("any", "remote", "tbd", "east africa", "australia & france", "france/switzerland", "uk / australia", 
                                         "uk / japan", "uk / japan / vietnam", "uk/ japan", "us/uk",
                                         "uk/japan", "portugal & the netherlands", "united kingdom & peru"), "multiple (without GER)", Country),
         Country = ifelse(Country %in% c("uk (or germany)"), "multiple (with GER)", Country)) %>%
  mutate(LEVEL = factor(LEVEL, levels = occ_levels, ordered = T)) %>%
  mutate(Level = factor(LEVEL, levels = occ_levels, labels = c("phd", "post-doc", "faculty", "faculty", "other", "other"), ordered = T)) %>%
  as.data.frame()

saveRDS(df, "IDD_data.rds")

