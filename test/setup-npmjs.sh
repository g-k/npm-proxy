#!/usr/bin/env bash -l

set -v
set -e

## Setup a npmjs.org in the local couch DB setup with setup-couchdb.sh
# Requires ar running couchdb
REGISTRY_URL=http://admin:mysecretpassword@localhost:5984/registry

# Add the registry
curl -X PUT $REGISTRY_URL

# Install npmjs.org
if [[ ! -d ./npmjs.org/ ]]; then
    git clone https://github.com/isaacs/npmjs.org.git
fi
cd npmjs.org

npm install couchapp --registry http://registry.npmjs.org/
npm install semver --registry http://registry.npmjs.org/
couchapp push registry/app.js $REGISTRY_URL
couchapp push www/app.js $REGISTRY_URL
cd ..
