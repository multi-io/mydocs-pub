#!/bin/sh

set -e

git ls-files >versioned-files.txt
./wwwpublish-printfiles.pl | sed 's/^.\///g' >published-files.txt 
cat published-files.txt versioned-files.txt | sort | uniq -d >published-versioned-files.txt
cat versioned-files.txt published-versioned-files.txt | sort | uniq -u >unpublished-versioned-files.txt
