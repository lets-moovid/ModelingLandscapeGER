library(tidyverse)
library(ggplot2)
library(RISmed)

search_topic <- "(infect* OR epidemic OR epidemics OR epidemiology OR epidemiological OR epidemiologic OR pandem* OR outbreak*) AND (disease* OR vaccin*) AND (model OR models OR modelling OR modeling OR simulat* OR transmission*)’"


search_query <- EUtilsSummary(search_topic, mindate=2000, maxdate=2023)
summary(search_query)

records<- EUtilsGet(search_query)
class(records)

# store it
df <- data.frame('ID' = PMID(records),
                 'TITLE' = ArticleTitle(records),
                 'ABSTRACT' = AbstractText(records),
                 'YEAR.1' = YearAccepted(records),
                 'YEAR.2' = YearArticleDate(records),
                 'YEAR.3' = YearPubDate(records)) %>%
  mutate(YEAR = pmin(YEAR.1, YEAR.2, YEAR.3, na.rm = T))

df.keywords <- bind_rows(Keywords(records), .id = "ID")

df.author <- bind_rows(Author(records), .id = "ID")

df.affi <- bind_rows(Affiliation(records), .id = "ID")

ggplot(df, aes(x=YEAR)) + geom_histogram(bins=23)

table(df$COUNTRY, useNA = "always")
