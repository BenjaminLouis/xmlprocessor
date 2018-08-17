#' Title
#'
#' @param xmltemplate a xml document to use as template
#' @param with a dataframe with the values of elements to replace in \code{xmltemplate}. Colnames and text of elements to replace in \code{xmltemplate} must be equals.
#' @param collapse if \code{NULL} (default) the function return a list of xml documents of length the number of rows in \code{with}. otherwse you can specify a root name to collapse all new xml documents in one. If the given root name is also the root name of \code{xmltemplate}, the latter root must have only one children node.
#' @param export a string giving the path to the folder where the xml files are exported. If \code{NULL} (default), nothing is exported
#' @param name optional. Only if \code{export} is not \code{NULL}, either a single string with the name of the exported file or a vector of strings with the names of all the exported xml files. Length of name must be either 1 or equal to the rows number of \code{with}
#'
#' @return either a list of length \code{nrow(with)} where each element is a new xml document or only one new xml document if \code{collapse!=NULL}
#'
#' @importFrom purrr map walk
#' @importFrom stringr str_c
#'
#' @export
#'
#' @examples
#' library(xml2)
#' template <- read_xml("<parent><child nom=\"child1\"><grandchild>grandchild1</grandchild>
#' <grandchild>grandchild2</grandchild></child><child nom=\"child2\">null</child></parent>")
#' toreplace <- data.frame(child1 = c("Ben1", "Ben2"), child2 = c("Sarah1", "Sarah2"),
#' grandchild1 = c("Brad1", "Brad2"), grandchild2 = c("Jude1", "jude2"))
#'
#' # No export, no collapsing
#' newxml <- xml_fill_template(template, toreplace)
#'
#' # Export and collapsing
#' \dontrun{
#' newxml <- xml_fill_template(template, toreplace, collapse = "grandparent",
#' export = getwd(), name = "testexport")
#' }
xml_fill_template <- function(xmltemplate, with, collapse = NULL, export = NULL, name = NULL) {

  #attention :
  # 1. nom à remplir doivent être exacte (y compris extension si fichier)
  # 2. si collapse = "text" et si text est le root de template, root ne doit contenir qu'un seul enfant

  # Transform the dataframe en list of rows
  lwith <- split(with, f = 1:nrow(with))

  # Apply the xml_replace_values to lwith
  newxml <- map(lwith, ~ xml_replace_values(xml = xmltemplate, replacement = .))

  if (!is.null(collapse)) {
    if (xml_name(xmltemplate) != collapse) {
      lnewxml <- map(newxml, ~ setNames(list(as_list(.)), collapse))
      newxml <- map(lnewxml, ~ as_xml_document(.))
    }
    final_newxml <- as_xml_document(as_list(newxml[[1]]))
    walk(newxml[-1], ~ xml_add_child(final_newxml,
                                              xml_children(.x)[[1]],
                                              .where = "after"))
    it <- 1
    if (!is.null(export)) toexport <- list(final_newxml)
  } else {
    final_newxml <- newxml
    it <- 1:nrow(with)
    if (!is.null(export)) toexport <- final_newxml
  }

  if (!is.null(export)) {
    if (is.null(name)) { name <- "xmlfile" }
    if (!length(name) %in% c(1, nrow(with))) {
      stop("name should either of length 1 or of the same row number of with")
    }
    if (is.null(collapse) & length(name) < nrow(with)) {
      name <- str_c(name, 1:nrow(with))
    }
    path <- str_c(export, "/", name, ".xml")
    lapply(it, function(i) write_xml(x = toexport[[i]], file = path[[i]]))
  }

  return(final_newxml)
}
