library(tidyverse)
library(gbm)
source("utils.R")

powers <- read_csv("derived_data/powers.csv");
info <- read_csv("derived_data/information.csv");

n_male <- sum(info$gender == "Male");
n_female <- sum(info$gender == "Female");
n_neuter <- sum(info$gender == "-");

usable_power_counts <- powers %>% group_by(power) %>% summarize(n = sum(has)) %>% filter(n>10);
power_counts_by_gender <- powers %>%
    left_join(info, by="name") %>% 
    group_by(power) %>%
    summarize(p_male = sum(gender == "Male" & has == TRUE)/n_male,
              p_female = sum(gender == "Female" & has == TRUE)/n_female,
              p_neuter = sum(gender == "-" & has == TRUE)/n_neuter) %>%
    mutate(gender_diff = abs(p_male - p_female)) %>%
    arrange(desc(gender_diff));


                                                                      )

## feature_cols <- unique(powers$power)
## feature_cols <- feature_cols[feature_cols %in% usable_power_counts$power];

feature_cols <- head(power_counts_by_gender$power, 4);

## the one case we don't want long/tidy data

powers <- powers %>% pivot_wider(names_from=power, values_from=has) %>%
    left_join(info, by="name") %>%
    mutate(train=runif(length(gender))<0.75) %>%
    mutate(gender=factor(gender,c("Male","Female","-")));

powers <- powers[complete.cases(powers), ];

## factorize the appropriate columns

for(c in feature_cols){
    powers[[c]] <- factor(powers[[c]]);
}

model_formula <- as.formula(sprintf("gender ~ %s", paste(feature_cols,collapse=" + ")));

training_data <- powers %>% filter(train==T);
testing_data <- powers %>% filter(train==F);

model <- gbm(model_formula, data = training_data, shrinkage=0.01, interaction.depth=4, n.trees=1000);

testing_maxes <- c("Male","Female","-")[apply(predict.gbm(model, testing_data, type="response", n.trees=1000), 1, which.max)]
testing_data$gender.p <- testing_maxes;

training_maxes <- c("Male","Female","-")[apply(predict.gbm(model, training_data, type="response", n.trees=1000), 1, which.max)]
training_data$gender.p <- training_maxes;

print(sum(testing_data$gender == testing_data$gender.p)/nrow(testing_data))
print(sum(testing_data$gender == "Male")/nrow(testing_data))

print(sum(training_data$gender == training_data$gender.p)/nrow(training_data))
print(sum(training_data$gender == "Male")/nrow(training_data));

write_wrapped(sprintf("We used a gradient boosting machine to predict gender on the basis of %d super power features. The accuracy of the model on a held out set was %0.2f. This is similar to a model which just predicts the most common case: that the character is male (accuracy: %0.2f).",
              length(feature_cols), sum(testing_data$gender == testing_data$gender.p)/nrow(testing_data),
              sum(testing_data$gender == "Male")/nrow(testing_data)),
      file="fragments/gbm.fragment.tex");

