.PHONY: clean

report.pdf:\
 report.Rmd\
 figures/comparison_of_heights_and_weights.png
	Rscript -e "rmarkdown::render('report.Rmd',output_format='pdf_document')"

clean:
	rm -f derived_data/*.csv
	rm -f derived_data/*.json
	rm -f figures/*.png
	rm -f figures/*.pdf
	rm -f fragments/*.tex
	rm -f report.pdf

figures/gender_power_comparison.png\
 figures/gender_power_comparison_single.png\
 figures/gender_power_comparison_single2.png\
 figures/gender_power_comparison_single3.png:\
 utils.R\
 gender_power_comparison.R\
 derived_data/information.csv\
 derived_data/powers.csv
	Rscript gender_power_comparison.R

derived_data/information.csv\
 derived_data/powers.csv\
 derived_data/real_height_weights.csv:\
 source_data/datasets_26532_33799_heroes_information.csv\
 source_data/datasets_26532_33799_super_hero_powers.csv\
 tidy_data.R
	Rscript tidy_data.R

fragments/real_comics_weight_height.tex\
 fragments/height_weight.fragment.Rmd\
 figures/comparison_of_heights_and_weights.png:\
 derived_data/real_height_weights.csv\
 derived_data/information.csv\
 height_weight_vs_real_people.R
	Rscript height_weight_vs_real_people.R

fragments/gbm.fragment.tex:\
 predict-gender-gbm.R\
 derived_data/information.csv\
 derived_data/powers.csv
	Rscript predict-gender-gbm.R

fragments/gender-hw-gbm.fragment.tex\
fragments/real-gender-hw-gbm.fragment.tex:\
 predict-gender-hw.R\
 derived_data/information.csv\
 derived_data/real_height_weights.csv
	Rscript predict-gender-hw.R

assets/comparison_of_heights_and_weights.png: figures/comparison_of_heights_and_weights.png
	cp figures/comparison_of_heights_and_weights.png assets/comparison_of_heights_and_weights.png

assets/gender_power_comparison_single3.png: figures/gender_power_comparison_single3.png
	cp figures/gender_power_comparison_single3.png assets/gender_power_comparison_single3.png

