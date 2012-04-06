#!/usr/bin/env node

fs = require 'fs'
http = require 'http'

program = require 'commander'
httpProxy = require 'http-proxy'
rest = require 'restler'


targetParser = (target) ->
    # Splits a target string into an object with host and port
    p = /((.*):\/\/)?([^:/]+)(:(\d+))?((\/.*)*)/;
    m = target.match p
    scheme: m[2] or 'http'
    host: m[3]
    port: parseInt(m[5], 10) or 80
    path: m[6] or ''

package = JSON.parse fs.readFileSync require.resolve('../package.json'), 'utf8'

program
    .version(package.version)
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


proxy = program.target
parent_npm = program.parentRegistryTarget
child_npm = program.childRegistryTarget


child_npm.check = (req) ->
    url = "http://#{@host}:#{@port}#{@path}" + req.url
    console.log "#{req.method}:", url
    req.headers['host'] = "#{@host}:#{@port}"
    rest.get url, headers: req.headers


strip_url_for_npm_vhost = (url) ->
    # Strips the couchdb npmjs.org app from the URL
    # for NPM registries with the registry vhost set
    url.replace 'registry/_design/app/_rewrite/', ''


server = httpProxy.createServer (req, res, proxy) ->
    buffer = httpProxy.buffer req

    if req.method is 'GET'
        # Check if the child npm has it
        check = child_npm.check req

        # Found it in our repo
        check.on 'success', (data) ->
            console.log "INFO: Found #{req.url} in child npm!"

            req.headers['host'] = child_npm.host
            req.url = child_npm.path + req.url
            proxyOpts = child_npm
            proxyOpts['buffer'] = buffer

            proxy.proxyRequest req, res, proxyOpts

        check.on 'error', (err) ->
            console.error "ERROR: Can't find #{req.url} in child npm"

            req.url = strip_url_for_npm_vhost req.url

            console.info "INFO: proxying to parent npm #{req.url}"

            req.headers['host'] = parent_npm.host
            req.url = parent_npm.path + req.url
            proxyOpts = parent_npm
            proxyOpts['buffer'] = buffer

            proxy.proxyRequest req, res, proxyOpts
    else
        # Update our repo
        console.info "INFO: Updating #{req.url}"

        req.headers['host'] = child_npm.host
        req.url = child_npm.path + req.url
        proxyOpts = child_npm
        proxyOpts['buffer'] = buffer

        proxy.proxyRequest req, res, proxyOpts

server.on 'error', (err) ->
    console.error 'ERROR: Server Error:', err

server.listen proxy.port, proxy.host, () ->
    console.info "Proxying #{proxy.host}:#{proxy.port}"
