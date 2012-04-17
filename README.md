A proxy server built on
[node-http-proxy](https://github.com/nodejitsu/node-http-proxy) for
npm to publish packages to a child/private registry and install
packages from a child or parent/public registry (if the child doesn't
have the package).

[![Build Status](https://secure.travis-ci.org/g-k/npm-proxy.png)](http://travis-ci.org/g-k/npm-proxy)

## Install

Requires node version 0.6.6 or newer.

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
      -t, --target [localhost:8080]                         hostname and port to listen on
      -c, --child-registry-target [localhost:5984]          NPM registry to push packages and pull from first
      -p, --parent-registry-target [registry.npmjs.org:80]  NPM registry to pull packages from if the child doesn't have it

Once the proxy is running point npm to it using any of the methods
from "Using the registry with the npm client" section of the
[npmjs.org](http://github.com/isaacs/npmjs.org) project.
