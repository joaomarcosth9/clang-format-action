#!/bin/bash

set -eu

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

echo "## Initializing git repo..."
git init
git config --global --add safe.directory /github/workspace
echo "### Adding git remote..."
git remote add origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
echo "### Getting branch"
BRANCH=${GITHUB_REF#*refs/heads/}
echo "### git fetch $BRANCH ..."
git fetch origin $BRANCH
echo "### Branch: $BRANCH (ref: $GITHUB_REF )"
git checkout $BRANCH

echo "## Configuring git author..."
git config --global user.email "clang-format@1337z.ninja"
git config --global user.name "Clang Format"

# Ignore workflow files (we may not touch them)
git update-index --assume-unchanged .github/workflows/*

echo "## Running clang-format on C/C++ source"
(git ls-tree --full-tree -r HEAD | grep -e "\.\(c\|cpp\)\$" | cut -f 2) | while read -r FILE; do clang-format -i -style=file "$FILE"; done

echo "## Commiting files..."
git commit -a -m "apply clang-format" || true

echo "## Pushing to $BRANCH"
git push -u origin $BRANCH
