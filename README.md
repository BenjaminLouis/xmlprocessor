[![Travis build status](https://travis-ci.org/BenjaminLouis/xmlprocessor.svg?branch=master)](https://travis-ci.org/BenjaminLouis/xmlprocessor)

# Package {xmlprocessor}

The goal of xmlprocessor is to help with the preparation of xml files. It was motivated by the laborious work of xml files processing that are used for simulations in an agronomic model (STICS). It strongly rests on the {xml2} package but contains functions that are wrappers for the creation and filling of xml template. 


## Installation

You can install the released version of xmlprocessor the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("BenjaminLouis/xmlprocessor")
```
Package {xmlprocessor} depends on other package. To install them, please run the command lines in [dependencies.R](https://github.com/BenjaminLouis/xmlprocessor/blob/master/inst/dependencies.R)

## Use package {xmlprocessor}

``` r
library(xmlprocessor)
```

### Fill a xml template

One of the main goal of package {xmlprocessor} is to facilitate the serial creatoin of xml file. From a xml template, you can use a dataframe to replace text and attribute values.

Starting with the creation and printing of a template :

``` r
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
```

The xml template contains 4 values that can be changed : grandchild1, grandchild2, child1 and child2. The first two are texts and the two latter are attributes values.

To fill the template with different values, you can build a dataframe where the columns names are the exact text to be replaced. For text values, this should be the whole text between xml element (<...>thistext</...>) and for attributes values, this should be the whole text between quotes.


``` r
toreplace <- data.frame(child1 = c("Ben", "Thomas"), child2 = c("Sarah", "Marie"),
grandchild1 = c("Brad", "Angelica"), grandchild2 = c("Jude", "Lea"))
```

You can then fill the template with information contained in `toreplace` to create a list with two xml documents with the structure as `template` but where grandchild1, grandchild2, child1 and child2 are replaced by the corresponding values in `toreplace`.

``` r
# No export, no collapsing
newxml <- xml_fill_template(xmltemplate = template, with = toreplace)
# Export and collapsing
newxml <- xml_fill_template(template, toreplace, collapse = "grandparent",
export = getwd(), name = "testexport")
```
## Vignette

This package also contains a vignette that explained with more details the use of package {xmlprocessor}. After installing it, you can see the vignette through :

``` r
vignette("use_of_xmlprocessor", package = "xmlprocessor")
```

## Code of conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.
