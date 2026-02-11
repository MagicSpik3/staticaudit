usethis::use_package("devtools", type = "Suggests")
usethis::use_package("lintr", type = "Suggests")
usethis::use_package("styler", type = "Suggests")


usethis::use_build_ignore(".lintr")
usethis::use_build_ignore("runner.R")

styler::style_pkg()
lintr::lint_package()
here::dr_here()
devtools::check()
devtools::test()
devtools::build()


library(mypkg)
# This uses R's built-in tool to check what is currently live
#getNamespaceExports("staticanalysis")
getNamespaceExports("mypkg")
library(rdyntrace)

# 1. Dynamic Phase
rdyntrace::instrument_package("mypkg")
# 1. Load the latest version of your tools

# 2. Define target as the current project root
target <- "/home/jonny/R_Code/mypkg"
setwd(target)

mypkg::hello()
mypkg::is_prime(123)
mypkg::nth_prime(321)

dynamic_data <- trace_results()
restore_package("mypkg")
print(dynamic_data)
# 2. Static Phase (using your existing tool)
static_funcs <- origin::get_exported_functions("mypkg")
print(static_funcs)
# 3. The Audit
# Find functions that exist statically but have 0 dynamic calls
dead_candidates <- dynamic_data$func[dynamic_data$calls == 0]

# (Optional) Double check against exports to prioritize public API cleanup
dead_exports <- intersect(dead_candidates, static_funcs)

print(paste("Potentially unused exported functions:", paste(dead_exports, collapse = ", ")))



