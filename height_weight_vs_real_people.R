library(tidyverse);
library(xtable);
source("utils.R");

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

## subsample the real data for the sake of clarity.
## it is quite normal so we don't lose much here.

n_comics_male <- data %>%
    filter(type=="comics" & gender=="Male") %>%
    nrow()

n_comics_female <- data %>%
    filter(type=="comics" & gender=="Female") %>%
    nrow()

data <- rbind(read_csv("derived_data/real_height_weights.csv") %>%
              select(gender, height, weight) %>%
              mutate(type="real") %>%
              group_by(gender) %>%
              sample_n(if(gender=="Male") {
                           n_comics_male
                       } else {
                           n_comics_female
                       }) %>%
              ungroup(),
              read_csv("derived_data/information.csv") %>%
              select(gender, height, weight) %>%
              mutate(type="comics")) %>%
    mutate(weight=weight*2.204623) %>%
    filter(gender %in% c("Male","Female"));

p <- ggplot(data, aes(height, weight)) +
    geom_point(aes(color=paste(type,gender,sep=":")),alpha=0.3) +
    xlim(100,250) +
    ylim(0,1000) +
    guides(color=guide_legend(title="Type : Gender")) +
    labs(title="Real Vs Comic Book Heights and Weight w/ Gender");
ggsave("figures/comparison_of_heights_and_weights.png");



write(sprintf("Heights and Weights ===================

Ordinary human beings have fairly normal height and weight
distributions with modest sex-related differences.

![](figures/comparison_of_heights_and_weights.png)
*Human and comic book character heights and sex.*

These distributions are wide compared to those which we see in comic
book characters. In particular, both Male identified and Female
identified comic book characters are taller and weigh less than the
normal distribution of human heights and weights would suggest.

A few other interesting features present themselves: male comic book
characters have some very large weights which are not present in other
populations.
"),file="fragments/height_weight.fragment.Rmd",append=FALSE);
