#!/bin/bash
# This script will reset the current branch to the last commit
# Accept a parameter as branch name, if not provided, it will exit
echo "Resetting the branch to the last commit"

echo "Check if a branch name is provided"
if [ -z "$1" ]
then
  echo "No branch name provided"
  echo "Usage: reset_branch.sh <branch_name>"
  exit 1
fi

echo "Check if the branch exists"
if ! git show-ref --verify --quiet refs/heads/$1
then
  echo "Branch $1 does not exist"
  exit 1
fi

BRANCH=$1
echo "Get last commit description to use as commit message for the new commit"
COMMIT_MSG=$(git log -1 --pretty=%B)
echo "Commit message: ${COMMIT_MSG}"

echo "Creating branch ${BRANCH}_orphan"
git checkout --orphan ${BRANCH}_orphan

echo "Add all staged files"
git add -A

echo "Commit all files with last commit message"
git commit -am "${COMMIT_MSG}"

echo "Delete the current branch ${BRANCH}"
git branch -D ${BRANCH}

echo "Rename the current branch ${BRANCH}_orphan to ${BRANCH}"
git branch -m ${BRANCH}

echo "Push, and apply on remote repository"
git push -f origin ${BRANCH}