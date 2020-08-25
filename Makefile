.PHONY: clean

clean:
	rm derived_data/*
  
derived_data/information.csv derived_data/powers.csv:\
 source_data/datasets_26532_33799_heroes_information.csv\
 source_data/datasets_26532_33799_super_hero_powers.csv\
 tidy_data.R
	Rscript tidy_data.R