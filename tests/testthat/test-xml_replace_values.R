context("test-xml_replace_values")

test_that("xml_replace_values works", {

  library(xml2)
  template <- read_xml("<parent><child nom=\"child1\"><grandchild>grandchild1</grandchild>
<grandchild>grandchild2</grandchild></child><child nom=\"child2\">null</child></parent>")
  toreplace <- c(child1 = "Ben", child2 = "Sarah", grandchild1 = "Brad", grandchild2 = "Jude")
  newxml <- xml_replace_values(xml = template, replacement = toreplace)

  expect_is(newxml, "xml_document")
})
