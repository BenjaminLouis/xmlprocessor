to_install <- c("dplyr","magrittr","purrr","rlang","stringr","tibble","xml2")
for (i in to_install) {
  message(paste("looking for ", i))
  if (!requireNamespace(i)) {
    message(paste("     installing", i))
    install.packages(i)
  }

}