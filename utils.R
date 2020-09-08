library(stringr);

tidy_up_names <- function(dataset){
    names(dataset) <- names(dataset) %>%
        tolower() %>%
        str_replace_all(" - ", " ") %>%
        str_replace_all(" ", "_") %>%
        str_replace_all("-","_") %>%
        str_replace_all("/","_or_");
    dataset
}

`%without%` <- function(a, b){
    a[!(a %in% b)];
}

write_wrapped <- function(s, file, append=FALSE){
  s <- strwrap(s);
  write(s,file,append=append);
}
