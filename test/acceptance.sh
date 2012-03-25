# npm should work with our local npmjs.org
# and it should work through npm-proxy

# REGISTRY=http://localhost:5984/registry/_design/app/_rewrite/
# REGISTRY=http://localhost:8080/

## Add user (requires prompt)

# npm adduser --registry=$REGISTRY
# should have user in local npm

## Publish local package

# npm publish .  --registry=$REGISTRY # run from project root
# should have npm-proxy in local npm
# curl -X $REGISTRY

## Get non-local package

# npm install -d colors
# should get from global npmjs

## Get local package

# npm install -d npm-proxy --registry=$REGISTRY
# Should pull npm-proxy from local couchdb
# Should pull dependencies from 3rd party
