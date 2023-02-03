source("0_helper.R")

df <- readRDS("IDD_data.rds")

# Advertisements overall by Country
df.plot <- df %>% 
  group_by(Country) %>% summarise(CountryCount = n()) %>% ungroup() %>%
  mutate(CountryFill = ifelse(Country %in% c("germany", "multiple (with GER)"), "Germany", "other"))

p <- ggplot(df.plot, aes(x=reorder(Country, -CountryCount), y=CountryCount, fill=CountryFill)) + geom_bar(stat = "identity")
p <- p + geom_text(aes(x=Country, y=CountryCount, label = factor(Country)), angle = 90, hjust = -0.1, vjust = 0.25, size = 3)
p <- p + scale_y_continuous("Number of Job Advertisments", limits = c(0, 800))
p <- p + scale_x_discrete("Country")
p <- p + theme_minimal() + theme(axis.text.x = element_blank(), axis.ticks = element_blank(),
                                 panel.grid = element_blank() , legend.position = "none",
                                 text = element_text(size = 8))
p
ggsave("plots/IDD_overall_byCountry.png", width = 150, height = 75, units = "mm", dpi = 300)

# Advertisements by country and occupational level
df.plot <- df %>% 
  group_by(Country, Level) %>% summarise(CountryCount = n()) %>% ungroup() %>%
  group_by(Level) %>% mutate(CountryCountRank = dense_rank(-CountryCount)) %>% ungroup() %>%
  filter(CountryCountRank < 11) %>% 
  as.data.frame()
  
p <- ggplot(df.plot, aes(x=reorder(Country, -CountryCount), group=Country, y=CountryCount, fill=Level))
p <- p + geom_bar(stat = "identity")
#p <- p + geom_text(aes(x=Country, y=CountryCount, label = factor(Country)), angle = 90, hjust = -0.1, vjust = 0.25, size = 3)
p <- p + scale_y_continuous("Number of Job Advertisments")
p <- p + scale_x_discrete("Country")
p <- p + theme_minimal() + theme(axis.text.x = element_blank(), axis.ticks = element_blank(),
                                 panel.grid = element_blank() , #legend.position = "none",
                                 text = element_text(size = 8))
p
ggsave("IDD_overall_byCountry.png", width = 150, height = 75, units = "mm", dpi = 300)

df.plot <- df %>% group_by(Country, LEVEL) %>% mutate(CountryCount = n()) %>% ungroup() %>%
  group_by(LEVEL) %>%
  mutate(CountryCountRank = dense_rank(-CountryCount)) %>%
  mutate(FillCountry = ifelse(CountryCountRank > 3, "other", Country)) %>%
  ungroup() %>%
  mutate(LEVEL = factor(LEVEL, levels = occ_levels, ordered = T))
