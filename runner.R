detach('package:staticaudit')
devtools::document()
devtools::load_all()
devtools::test()
testthat::test_file('tests/testthat/test-analyse_project.R')

echo "find ./R -name '*.R' -exec cat {} \; > R.txt" > R.txt
find ./R -name '*.R' -exec cat {} \; >> R.txt
echo "cat NAMESPACE >> R.txt"
cat NAMESPACE >> R.txt
echo "find ./tests -name '*.R' -exec cat {} \; >> R.txt" >>  R.txt
find ./tests -name '*.R' -exec cat {} \; >> R.txt
echo "tree >> R.txt"
tree >> R.txt
echo "Rscript -e \"devtools::test()\" >> R.txt 2>&1" >> R.txt
Rscript -e "devtools::test()" >> R.txt 2>&1
echo "XXXXXXX TARGET REPO XXXXXXXX" >> R.txt
echo "find ../hello/R -name '*.R' -exec cat {} \; >> R.txt"
find ../hello/R -name '*.R' -exec cat {} \; >> R.txt
echo "cat ../hello/NAMESPACE >> R.txt"
cat ../hello/NAMESPACE >> R.txt
echo "(from console) analyse_project("../hello/R")" >> R.txt
analyse_project("../hello/R")

library(staticaudit)
scan_project('../hello')

pd <- utils::getParseData(parse(text = "get('a')", keep.source = TRUE))
print(pd[, c("token", "text")])

# Assuming you are in the staticaudit project directory
# and the dmmy package is in a folder called "hello"
results <- analyse_project("../hello/R")

results
# Print the report


# The Map is now the Territory
report <- analyse_project("tests/fixtures/bad")
report  # Automatically triggers the S3 print method

devtools::load_all("../staticaudit")
bad_results <- analyse_project("../smellypkg/R")
bad_results
#!/usr/bin/env Rscript
devtools::load_all("path/to/staticaudit")
args <- commandArgs(trailingOnly = TRUE)
path <- if(length(args) > 0) args[1] else "."

smells <- staticaudit::analyse_project(path)
staticaudit::print_smells(smells)