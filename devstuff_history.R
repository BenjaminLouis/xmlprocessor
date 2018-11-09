usethis::use_build_ignore("devstuff_history.R")
usethis::use_gpl3_license("Benjamin Louis")
usethis::use_readme_md()
usethis::use_code_of_conduct()
usethis::use_travis()

usethis::use_pipe()

attachment::att_to_description()
usethis::use_tidy_description()

usethis::use_vignette("use_of_xmlprocessor")
devtools::build_vignettes()

usethis::use_testthat()
usethis::use_test("xml_replace_values")
usethis::use_test("xml_fill_template")

attachment::create_dependencies_file()
