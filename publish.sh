#!/bin/sh

grunt
git checkout gh-pages
mv output/* .
rm -r output

rm -rf assets
rm doc/index.html
mv doc/lib doc_lib
mv doc/* .
git add -A
git commit -m "update docs"
git push 
g checkout master
