usethis::use_package("devtools", type = "Suggests")
usethis::use_package("lintr", type = "Suggests")
usethis::use_package("styler", type = "Suggests")


usethis::use_build_ignore(".lintr")
usethis::use_build_ignore("runner.R")
#usethis::use_build_ignore("runner.R")
#usethis::use_build_ignore("test.R")



styler::style_pkg()
lintr::lint_package()
here::dr_here()
devtools::check()
devtools::test()
devtools::build()

library(usethis)

# 1. Create the package skeleton (if you haven't already)
create_package("staticaudit") 

# 2. Add the "Lean" Dependencies
use_package("fs")
use_package("codetools")
use_package("DiagrammeR")
use_package("cli")  # Makes your audit logs look great

# 3. Setup Testing
use_testthat()

# 4. Create the Core Files (Empty placeholders)
file.create("R/00_ast_engine.R")
file.create("R/01_inventory.R")
file.create("R/02_integrity.R")
file.create("R/03_visualization.R")
