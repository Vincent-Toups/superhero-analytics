library(tidyverse);

information <- 
  read_csv("source_data/datasets_26532_33799_heroes_information.csv");
powers <- read_csv("source_data/datasets_26532_33799_super_hero_powers.csv");

# Do something to clean stuff up.

write_csv(information, "derived_data/information.csv");
write_csv(powers, "derived_data/powers.csv");

