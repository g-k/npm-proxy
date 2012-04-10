#!/usr/bin/env bash -l

set -v
set -e

## Setup couchdb for local OSX homebrew install
HOMEBREW_COUCHDB=/usr/local/etc/couchdb

# Allow insecure rewrite rules
sed -i '.bak' 's/secure_rewrites = true/secure_rewrites = false/' $HOMEBREW_COUCHDB/default.ini

# Enable default admin so we can make an npm user
sed -i '.bak' 's/;admin = mysecretpassword/admin = mysecretpassword/' $HOMEBREW_COUCHDB/local.ini
