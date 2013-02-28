#!/bin/sh

grunt
git commit -am "update"
git checkout gh-pages
mv output/* .
rm -r output
rm index.html
mv nbc.html index.html

rm -rf assets
rm doc/index.html
mv doc/lib doc_lib
mv doc/* .
git add -A
git commit -m "update docs"
git push 
git checkout master

