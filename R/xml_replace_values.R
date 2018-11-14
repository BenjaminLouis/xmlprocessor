#' Replace values in a xml template document
#'
#' @param xml a xml document read with \code{read_xml}
#' @param replacement one of a one row dataframe, a named list or a named vector where (col)names correspond to the values to replace in the xml template and the elements are the values to replace with
#'
#' @return a new xml document with changes applied to the xml template
#'
#' @importFrom dplyr mutate filter select mutate_if
#' @importFrom purrr map_lgl map_chr pwalk
#' @importFrom stringr str_replace_all str_replace str_split str_detect str_c
#' @importFrom tibble as_tibble
#' @importFrom rlang set_names
#' @import xml2
#'
#' @export
#'
#' @examples
#' library(xml2)
#' template <- read_xml("<parent><child nom=\"child1\"><grandchild>grandchild1</grandchild>
#' <grandchild>grandchild2</grandchild></child><child nom=\"child2\">null</child></parent>")
#' toreplace <- c(child1 = "Ben", child2 = "Sarah", grandchild1 = "Brad", grandchild2 = "Jude")
#' newxml <- xml_replace_values(xml = template, replacement = toreplace)
xml_replace_values <- function(xml, replacement) {

  #attention :
  # 1. nom à remplir doivent être exacte (y compris extension si fichier)

  # Create a new xml document fromtemplate
  newxml <- as_xml_document(as_list(xml))

  # Coerce to a named vector of strings
  replacement <- as.list(replacement) %>%
    as_tibble() %>%
    mutate_if(is.factor, as.character) %>%
    unlist()

  # Change nodes values
  text_only <- xml_find_all(newxml, "//text()")
  xml_text(text_only) <- str_replace_all(string = xml_text(text_only), pattern = set_names(replacement, str_c("^", names(replacement), "$")))

  # Change attributes values
  xml_find_all(newxml, ".//@*") %>%
    as.character() %>%
    str_replace(pattern = "^\\s", replacement = "") %>%
    str_split(pattern = "=", simplify = TRUE) %>%
    as_tibble() %>%
    mutate(path = xml_path(xml_parent(xml_find_all(newxml, ".//@*")))) %>%
    filter(map_lgl(V2, ~ any(str_detect(., names(replacement))))) %>%
    mutate(replace = map_chr(V2, ~ replacement[str_detect(., str_c("\"", names(replacement), "\""))])) %>%
    select(V1, path, replace) %>%
    pwalk(function(V1, path, replace) {
      newxml %>%
        xml_find_all(path) %>%
        xml_set_attr(V1, replace)
    })

  return(newxml)
}
