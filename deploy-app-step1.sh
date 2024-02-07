#!/bin/bash

set -eo pipefail

if [ "$#" -eq 1 ]; then
    TAG="${1}"
else
    echo "Expected a single argument, the git tag to build and deploy." 2>&1
    exit 1
fi

WEB_HOST=tulip
CODE_DIR=checkout-app

if [ -d "${CODE_DIR}" ]; then
    pushd "${CODE_DIR}"

    # Clean up any leftover changes from the previous deploy.
    git reset --hard
    git clean -xdf .

    # Find updated refs from the origin and check out the one we want.
    git fetch --all
    git checkout "${TAG}"

    # Tags and commit hashes don't get out of sync with the origin, so
    # if this is a branch, make sure you're at the origin's commit.
    if git branch -r | grep -q "^\s*origin\/${TAG}\s*$"; then
        git reset --hard "origin/${TAG}"
    fi
else
    git clone https://github.com/fractalate/pakrypt.git "${CODE_DIR}"
    pushd "${CODE_DIR}"
    git checkout "${TAG}"
fi

npm ci .
npm run build

echo "deploy time: $( date )" > ./dist/deployment_metadata.txt
echo "git commit hash: $( git rev-parse HEAD )" >> ./dist/deployment_metadata.txt
echo "node version: $( node --version )" >> ./dist/deployment_metadata.txt
echo "npm version: $( npm --version )" >> ./dist/deployment_metadata.txt

mv dist "pakrypt-${TAG}"
tar czvf "../pakrypt-${TAG}.tar.gz" "pakrypt-${TAG}"

popd
