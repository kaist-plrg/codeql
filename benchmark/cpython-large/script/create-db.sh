#!/bin/bash

set -e

rm -rf db
mkdir db

apps=(
  "bitarray"
  "bounter"
  "cvxopt"
  "distance"
  "immutables"
  "japronto"
  "noise"
  "numpy"
  "pyahocorasick"
  "pyo"
  "python-Levenshtein"
  "python-llist"
  "simplejson"
)

for app in ${apps[@]}; do
  echo "========$app========"
  $CODEQL_HOME/script/cpython/create-db.sh src/$app db/$app | grep "Took" | tee time.txt
done
