A proxy server built on
[node-http-proxy](https://github.com/nodejitsu/node-http-proxy) for
npm to publish packages to a child/private registry and install
packages from a child or parent/public registry (if the child doesn't
have the package).

[![Build Status](https://secure.travis-ci.org/g-k/npm-proxy.png)](http://travis-ci.org/g-k/npm-proxy)

## Deprecation Warning

We ran into a few issues updating our npm repo with newer npm and
npmjs.org checkouts.

Newer versions of npmjs.org have different
[rewrite urls](https://github.com/isaacs/npmjs.org/issues/72) and
require a
[trailing slash](https://github.com/isaacs/npmjs.org/issues/70), but
vhosts should fix these issues.

Around the introduction of the npm-registry-client (version ~1.1.25),
npm required couchdb auth credentials for package GET requests (for
security reasons I think). We use different credentials for our public
and private repos and couldn't naively proxy GET requests to the
public npmjs.org anymore.

@wyrdvans fixed these issues by setting up vhosts, replicating the
npmjs.org registry and our private registry. This also improved
performance on our network, reduced load on the public npmjs.org, made
it easier to run security audits on our node dependencies, and removed
the need to run this proxy.

Hopefully we can support multiple npm repositories in npm itself
instead of needing a fully replicated repo or an npm proxy:

* https://github.com/isaacs/npm/issues/19
* https://github.com/isaacs/npm/issues/100
* https://github.com/isaacs/npm/issues/1401

## Install

Requires node version 0.6.6 or newer. Untested on node 0.8.

### Local

1. Run

```
    npm install npm-proxy
```

1. Run locally:

```
	./bin/npm-proxy --child-registry-target http://mysecret.npmjs.org:5984
```

### As a couchdb os process deamon on the child npm registry:

1. Install npm-proxy globally

```
    sudo npm install -g npm-proxy
```

1. Add the following line to the `os_daemons` section of
`/etc/couchdb/local.ini` on the child npm registry:

```
    npm_proxy = /usr/bin/npm-proxy --child-registry-target http://mysecret.npmjs.org:5984
```

1. Restart couchdb and make sure npm-proxy started with it

## Usage

    Usage: npm-proxy [options]

    Options:

      -h, --help                                            output usage information
      -V, --version                                         output the version number
      -t, --target [localhost:8080]                         hostname and port to listen on or url
      -c, --child-registry-target [localhost:5984]          NPM registry to push packages and pull from first
      -p, --parent-registry-target [registry.npmjs.org:80]  NPM registry to pull packages from if the child doesn't have it

Once the proxy is running point npm to it using any of the methods
from "Using the registry with the npm client" section of the
[npmjs.org](http://github.com/isaacs/npmjs.org) project.


### Development

Janky OSX Testing on for my machine:

```
# brew install couchdb
rm npm-shrinkwrap.json
npm install -d . --registry=http://registry.npmjs.org/

make clean setup-couch
couchdb # start couch
make setup-npmjs

# start npm-proxy
./bin/npm-proxy -c localhost:5984
make acceptance test
```

#### TODO

* ANSI colors for log output
* 100% unit test coverage
* For acceptance tests, setup and teardown multiple processes using node
* For integration tests, record and playback npm requests and npmjs.org responses
