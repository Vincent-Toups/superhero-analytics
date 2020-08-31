library(tidyverse);

data <- rbind(read_csv("derived_data/real_height_weights.csv") %>%
              select(gender, height, weight) %>%
              mutate(type="real"),
              read_csv("derived_data/information.csv") %>%
              select(gender, height, weight) %>%
              mutate(type="comics")) %>%
    mutate(weight=weight*2.204623) %>%
    filter(gender %in% c("Male","Female"));

non_na <- function(x){
    x[!is.na(x)];
}

stats <- data %>%
    group_by(gender, type) %>%
    summarize(median_weight=median(non_na(weight)),
              median_height=median(non_na(height)));

print(xtable(stats, type = "latex"), file = "fragments/real_comics_weight_height.tex");

