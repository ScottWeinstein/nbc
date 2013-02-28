#!/bin/sh

grunt
git checkout gh-pages
mv output/* .
rm -r output
rm doc/index.html
mv doc/lib doc/doc_lib
mv doc/*
git add -A
git commit -m "update docs"
git push 