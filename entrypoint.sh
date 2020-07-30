#!/bin/sh -l

diff_filename="./nightfalldlp_raw_diff.txt"
if [ $2 ]; then
  echo "DIFF ON PR";
  git fetch origin $2 --depth=1;
  git diff origin/$2 $1 > $diff_filename;
  DIFF_OUTPUT_PR=$(git diff origin/$2 $1)
  echo "${DIFF_OUTPUT_PR}"
  echo "Diff between origin/$2 and $1";
else
  echo "DIFF ON PUSH";
  git fetch origin $3 --depth=1;
  git diff $3 $1 > $diff_filename;
  DIFF_OUTPUT_PUSH=$(git diff origin/$3 $1)
  echo "${DIFF_OUTPUT_PUSH}"
  echo "Diff between $3 and $1";
  fi;
echo "FILE CONTENTS: "
cat $diff_filename;
