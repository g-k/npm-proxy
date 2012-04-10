#!/usr/bin/env coffee

fs = require 'fs'

server = require './server'
program = require 'commander'
{ targetParser } = require './targetParser'


npmPackage = JSON.parse fs.readFileSync require.resolve('../package.json'), 'utf8'

program
    .version(npmPackage.version)
    .option('-t, --target [localhost:8080]',
        'hostname and port to listen on', targetParser,
        { host: 'localhost', port:8080 })
    .option('-c, --child-registry-target [localhost:5984]',
        'NPM registry to push packages and pull from first', targetParser,
        { host: 'localhost', port:5984 })
    .option('-p, --parent-registry-target [registry.npmjs.org:80]',
        "NPM registry to pull packages from if the child doesn't have it", targetParser,
        { host: 'registry.npmjs.org', port: 80 })
    .parse(process.argv)

server.createNpmProxyServer program