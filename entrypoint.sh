#!/bin/sh -l

# download relevant branch and write the diff to a local file
diff_filename="./nightfalldlp_raw_diff.txt"
echo "GITHUB_SHA: $GITHUB_SHA";
echo "BASE_REF: $GITHUB_BASE_REF";
echo "EVENT_BEFORE: $EVENT_BEFORE";
if [ "$GITHUB_BASE_REF" ]; then
  git fetch origin "$GITHUB_BASE_REF" --depth=1;
  echo "PR: fetching diff between origin/$GITHUB_BASE_REF and $GITHUB_SHA";
  git diff origin/"$GITHUB_BASE_REF" "$GITHUB_SHA" > $diff_filename;
else
  if [ "$EVENT_BEFORE" = "0000000000000000000000000000000000000000" ]; then
    git diff "HEAD" "$GITHUB_SHA" > $diff_filename;
  else
    git fetch origin "$EVENT_BEFORE" --depth=1;
    echo "PUSH: fetching diff between $EVENT_BEFORE and $GITHUB_SHA";
    git diff "$EVENT_BEFORE" "$GITHUB_SHA" > $diff_filename;
fi;

# run nightfalldlp binary
"$GOPATH/bin/nightfalldlp"

