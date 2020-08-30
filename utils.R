
tidy_up_names <- function(dataset){
    names(dataset) <- names(dataset) %>%
        tolower() %>%
        str_replace_all(" - ", " ") %>%
        str_replace_all(" ", "_");
    dataset
}
