library(tidyverse);
library(gridExtra);

info <- read_csv("derived_data/information.csv") %>%
    select(name, gender) %>%
    distinct();

powers <- read_csv("derived_data/powers.csv") %>%
    inner_join(info, by="name");

top_n_hist <- function(dataset, top_n=20, save_as="figures/last.png", title=""){
    counts <- dataset %>%
        group_by(power) %>%
        summarize(n=sum(has)) %>%
        arrange(desc(n));
    counts$power <- factor(counts$power, levels = counts$power);
    dataset$power <- factor(dataset$power, levels = counts$power);
    top_n_powers <- head(counts$power, top_n);

    p <- ggplot(dataset %>%
                filter(power %in% top_n_powers) %>%
                filter(has==TRUE),
                aes(power)) +
        geom_histogram(stat="count") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
        labs(title=title);
    ggsave(save_as, plot=p);
    p
}

female_fig <- top_n_hist(powers %>% filter(gender=="Female"),title="Female Superheroes");
male_fig <- top_n_hist(powers %>% filter(gender=="Male"), title="Male Superheroes");

p <- grid.arrange(female_fig, male_fig, nrow=2);

ggsave("figures/gender_power_comparison.png",plot=p);

##

all_gender_ranks <- powers %>%
    filter(has==TRUE) %>% 
    group_by(power) %>%
    tally() %>%
    arrange(desc(n)) %>%
    mutate(rank = seq(length(n)));

gender_counts <- info %>% group_by(gender) %>% tally(name="total");

top_20 <- all_gender_ranks$power %>% head(20);
powers$power <- factor(powers$power, all_gender_ranks$power);

p <- ggplot(powers %>%
            filter(has==TRUE) %>% 
            filter(gender %in% c("Male","Female")) %>%
            filter(power %in% top_20), aes(power)) +
    geom_histogram(stat="count", position="dodge",
                   aes(fill=gender)) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1));

ggsave("figures/gender_power_comparison_single.png");

##

normalized_counts <- powers %>%
    group_by(power, gender) %>%
    summarize(n=sum(has)) %>%
    inner_join(gender_counts,by="gender") %>%
    mutate(p=n/total);

p <- ggplot(normalized_counts %>% filter(power %in% top_20) %>% 
          filter(gender %in% c("Male","Female")), aes(power, p)) +
    geom_bar(stat="identity",
             position=position_dodge2(preserve = "single"),
             aes(fill=gender)) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1));

ggsave("figures/gender_power_comparison_single2.png",plot=p);

##

normalized_counts <- normalized_counts %>%
    group_by(gender) %>% arrange(desc(p)) %>%
    mutate(rank = seq(length(p))) %>%
    ungroup();


small_set <- normalized_counts %>% filter(gender %in% c("Male", "Female") & rank <= 20);

gender_to_position <- function(g){
    c(Female=-2,Male=2)[g]
}

gender_to_line_position <- function(g){
    c(Female=-1,Male=1)[g]
}


small_set$x_pos <- gender_to_position(small_set$gender);
small_set$line_x_pos <- gender_to_line_position(small_set$gender);

p <- ggplot(small_set, aes(x_pos,
                           rank)) +
    scale_y_reverse() + 
    geom_tile(width=2.25,height=0.8,aes(fill=power)) +
    geom_text(aes(label=power)) +
    theme(legend.position="bottom") +
    geom_line(aes(x=line_x_pos, color=power)) +
    scale_x_continuous("Gender",c()) +
    geom_text(data=tibble(x=c(-2,2),y=c(22,22),label=c("Female", "Male")),
              aes(x=x,y=y,label=label));
ggsave("figures/gender_power_comparison_single3.png",plot=p)
