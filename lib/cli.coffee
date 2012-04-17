#!/usr/bin/env coffee

fs = require 'fs'

server = require './server'
program = require 'commander'
{ targetParser } = require './targetParser'


npmPackage = JSON.parse fs.readFileSync require.resolve('../package.json'), 'utf8'


program
    .version(npmPackage.version)
    .option('-t, --target [localhost:8080]',
        'hostname and port to listen on or url', targetParser,
        { scheme: 'http:', host: 'localhost', port:8080 , path: '' })
    .option('-c, --child-registry-target [localhost:5984]',
        'NPM registry to push packages and pull from first', targetParser,
        { scheme: 'http:', host: 'localhost', port:5984, path: '' })
    .option('-p, --parent-registry-target [registry.npmjs.org:80]',
        "NPM registry to pull packages from if the child doesn't have it", targetParser,
        { scheme: 'http:', host: 'registry.npmjs.org', port: 80, path: '' })
    .parse(process.argv)

server.createNpmProxyServer program