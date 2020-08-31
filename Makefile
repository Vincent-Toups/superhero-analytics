.PHONY: clean

clean:
	rm derived_data/*.csv
	rm derived_data/*.json
	rm figures/*.png
	rm figures/*.pdf
	rm fragments/*.tex
	rm report.pdf

figures/gender_power_comparison.png\
 figures/gender_power_comparison_single.png\
 figures/gender_power_comparison_single2.png\
 figures/gender_power_comparison_single3.png:\
 utils.R\
 gender_power_comparison.R\
 derived_data/information.csv\
 derived_data/powers.csv
	Rscript gender_power_comparison.R

derived_data/information.csv derived_data/powers.csv:\
 source_data/datasets_26532_33799_heroes_information.csv\
 source_data/datasets_26532_33799_super_hero_powers.csv\
 tidy_data.R
	Rscript tidy_data.R

fragments/real_comics_weight_height.tex:\
 derived_data/real_height_weights.csv\
 derived_data/information.csv\
 height_weight_vs_real_people.R
	Rscript height_weight_vs_real_people.R

