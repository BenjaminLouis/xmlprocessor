## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
library(xmlprocessor)

## ------------------------------------------------------------------------
library(xml2)
template <- read_xml("<parent>
                        <child nom='child1'>
                          <grandchild>grandchild1</grandchild>
                          <grandchild>grandchild2</grandchild>
                        </child>
                        <child nom='child2'>
                          null
                        </child>
                      </parent>")
print(template)                   

## ------------------------------------------------------------------------
toreplace <- data.frame(child1 = c("Ben", "Thomas"), child2 = c("Sarah", "Marie"),
grandchild1 = c("Brad", "Angelica"), grandchild2 = c("Jude", "Lea"))
toreplace

## ------------------------------------------------------------------------
# No export, no collapsing
newxml <- xml_fill_template(xmltemplate = template, with = toreplace)
print(newxml[[1]])
print(newxml[[2]])

## ------------------------------------------------------------------------
# Export and collapsing
newxml <- xml_fill_template(xmltemplate = template, with = toreplace, collapse = "grandparent")
print(newxml)

