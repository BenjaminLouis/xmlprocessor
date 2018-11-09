context("test-xml_fill_template")

test_that("xml_fill_template works", {

  library(xml2)
  template <- read_xml("<parent><child nom=\"child1\"><grandchild>grandchild1</grandchild>
<grandchild>grandchild2</grandchild></child><child nom=\"child2\">null</child></parent>")
  toreplace <- data.frame(child1 = c("Ben1", "Ben2"), child2 = c("Sarah1", "Sarah2"),
                          grandchild1 = c("Brad1", "Brad2"), grandchild2 = c("Jude1", "jude2"))

  # No export, no collapsing
  newxml <- xml_fill_template(template, toreplace)
  expect_is(newxml, class="list")
  expect_true(all(unlist(lapply(newxml, function(x) "xml_document" %in% class(x)))))

  # Export and collapsing
  newxml <- xml_fill_template(template, toreplace, collapse = "grandparent",
                              export = tempdir(), name = "testexport")
  exportxml <- read_xml(paste0(tempdir(), "/testexport.xml"))
  expect_is(newxml, class="xml_document")
  expect_is(exportxml, class="xml_document")

})
