#!/bin/bash

set -eo pipefail

if [ "$#" -eq 1 ]; then
    TAG="${1}"
else
    echo "Expected a single argument, the git tag to build and deploy." 2>&1
    exit 1
fi

WEB_HOST=tulip
CODE_DIR=checkout-www

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
    if git branch -r | grep -q "^origin/${TAG}$"; then
        git reset --hard "origin/${TAG}"
    fi
else
    git clone https://github.com/fractalate/www.pakrypt.com.git "${CODE_DIR}"
    pushd "${CODE_DIR}"
    git checkout "${TAG}"
fi

TIMESTAMP=$( date )
COMMIT=$( git rev-parse HEAD )

echo "deploy time: ${TIMESTAMP}" > deployment_metadata.txt
echo "git commit hash: ${COMMIT}" >> deployment_metadata.txt

rsync -av --delete --exclude=.git/ ./ "${WEB_HOST}:/var/www/www.pakrypt.com/"

popd
