detach('package:staticaudit')
devtools::document()
devtools::load_all()
devtools::test()


echo "find ./R -name '*.R' -exec cat {} \; > R.txt" > R.txt
find ./R -name '*.R' -exec cat {} \; >> R.txt
echo "find ./tests -name '*.R' -exec cat {} \; >> R.txt" >>  R.txt
find ./tests -name '*.R' -exec cat {} \; >> R.txt
echo "tree >> R.txt"
tree >> R.txt
echo "Rscript -e \"devtools::test()\" >> R.txt 2>&1" >> R.txt
Rscript -e "devtools::test()" >> R.txt 2>&1