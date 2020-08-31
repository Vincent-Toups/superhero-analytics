library(tidyverse);
source("utils.R");

information <- 
  read_csv("source_data/datasets_26532_33799_heroes_information.csv");
powers <- read_csv("source_data/datasets_26532_33799_super_hero_powers.csv");

real_height_weights <- tidy_up_names(read_csv("source_data/datasets_26073_33239_weight-height.csv")) %>%
    mutate(height=height*2.54, weight=0.4535924*weight);

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
write_csv(real_height_weights, "derived_data/real_height_weights.csv");
