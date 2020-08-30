library(tidyverse);
source("utils.R");

`%without%` <- function(a, b){
    a[!(a %in% b)];
}

information <- 
  read_csv("source_data/datasets_26532_33799_heroes_information.csv");
powers <- read_csv("source_data/datasets_26532_33799_super_hero_powers.csv");

powers <- tidy_up_names(powers);
information <- tidy_up_names(information);

powers <- powers %>%
    rename(name=hero_names);

powers <- powers  %>%
    pivot_longer(cols=names(powers) %without% "name",
                 names_to="power",values_to="has");

# Do something to clean stuff up.

write_csv(information, "derived_data/information.csv");
write_csv(powers, "derived_data/powers.csv");

