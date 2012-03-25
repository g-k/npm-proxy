#!/usr/bin/env sh
set -e
set -v

## Add user
./test/add-user.sh $REGISTRY
# should add to child npm

## Publish local package

npm publish .  --registry=$REGISTRY --force # run from project root
# should have npm-proxy in child npm

## Get non-child package

npm install -d colors --registry=$REGISTRY
# should get from global npmjs


## Get child package

mkdir -p ../npm-proxy-tmp && cd ../npm-proxy-tmp
npm install -d npm-proxy --registry=$REGISTRY
cd ../npm-proxy
rm -rf ../npm-proxy-tmp
# Should pull npm-proxy from child couchdb
# Should pull dependencies from parent npm

## Unpublish local package

npm unpublish npm-proxy --registry=$REGISTRY --force
