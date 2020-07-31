#!/bin/sh -l
echo "SOME THINGS $GITHUB_SHA $GITHUB_RUN_ID $GITHUB_REF"
# download relevant branch and write the diff to a local file
diff_filename="./nightfalldlp_raw_diff.txt"
if [ "$BASE_REF" ]; then
  git fetch origin "$BASE_REF" --depth=1;
  echo "PR: fetching diff between origin/$BASE_REF and $SHA";
  git diff origin/"$BASE_REF" "$SHA" > $diff_filename;
else
  git fetch origin "$EVENT_BEFORE" --depth=1;
  echo "PUSH: fetching diff between $EVENT_BEFORE and $SHA";
  git diff "$EVENT_BEFORE" "$SHA" > $diff_filename;
fi;

# run nightfalldlp binary
"$GOPATH/bin/nightfalldlp"

