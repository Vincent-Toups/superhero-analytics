library(tidyverse)
library(gbm)
source("utils.R")

info <- read_csv("derived_data/information.csv") %>%
    filter(complete.cases(.)) %>%
    filter(gender %in% c("Male","Female")) %>%
    mutate(gender_binary = gender == "Male") %>%
    mutate(train=runif(length(gender)) < 0.75);

model_formula <- gender_binary ~ weight + height + hair_color;

training_data <- info %>% filter(train);
testing_data <- info %>% filter(!train);

model <- gbm(model_formula, data = training_data, shrinkage=0.01, interaction.depth=4, n.trees=1000);

training_pred <- c("Female","Male")[1+(predict.gbm(model, training_data, n.trees=1000, type="response") > 0.5)];
training_data$gender.p <- training_pred;

testing_pred <- c("Female","Male")[1+(predict.gbm(model, testing_data, n.trees=1000, type="response") > 0.5)];
testing_data$gender.p <- testing_pred;

training_accuracy <- sum(training_data$gender == training_data$gender.p)/nrow(training_data);
testing_accuracy <- sum(testing_data$gender == testing_data$gender.p)/nrow(testing_data);
null_accuracy <- sum(testing_data$gender == "Male")/nrow(testing_data);

sprintf("Super hero genders are more predictable from their heights and weights. A similar gradient boosting machine model as applied to super hero powers has a test-set accuracy of %0.2f. This outperforms a model which simply guesses Male (%0.2f).", testing_accuracy, null_accuracy) %>%
    write_wrapped("fragments/gender-hw-gbm.fragment.tex");

n_male <- sum(info$gender == "Male");
n_female <- sum(info$gender == "Female");

real_info_raw <- read_csv("./derived_data/real_height_weights.csv");
real_info <- rbind(real_info_raw %>% filter(gender=="Male") %>% sample_n(n_male),
                   real_info_raw %>% filter(gender=="Female") %>% sample_n(n_female)) %>%
    mutate(train=runif(length(gender))<0.75);

real_training_data <- real_info %>% filter(train);
real_testing_data <- real_info %>% filter(!train);

rmodel <- gbm(model_formula, data = real_training_data, shrinkage=0.01, interaction.depth=4, n.trees=1000);

real_training_pred <- c("Female","Male")[1+(predict.gbm(model, real_training_data, n.trees=1000, type="response") > 0.5)];
real_training_data$gender.p <- real_training_pred;

real_testing_pred <- c("Female","Male")[1+(predict.gbm(model, real_testing_data, n.trees=1000, type="response") > 0.5)];
real_testing_data$gender.p <- real_testing_pred;

real_training_accuracy <- sum(real_training_data$gender == real_training_data$gender.p)/nrow(real_training_data);
real_testing_accuracy <- sum(real_testing_data$gender == real_testing_data$gender.p)/nrow(real_testing_data);
real_null_accuracy <- sum(real_testing_data$gender == "Male")/nrow(real_testing_data);

sprintf("It is interesting to compare this to a model which operates on real human height and weight data. For simplicity we adjusted the proportions of our dataset (over gender) to match the super hero set. Such a model has an accuracy of %0.2f. This outperforms a model which simply guesses Male (%0.2f).", real_testing_accuracy, real_null_accuracy) %>%
    write_wrapped("fragments/real-gender-hw-gbm.fragment.tex");
