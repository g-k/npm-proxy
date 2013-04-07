http = require 'http'

httpProxy = require 'http-proxy'
rest = require 'restler'


createNpmProxyServer = (options) ->
  proxy = options.target
  parent_npm = options.parentRegistryTarget
  child_npm = options.childRegistryTarget

  child_npm.check = (req) ->
      url = "#{@scheme}//#{@host}:#{@port}#{@path}" + req.url
      console.log "#{req.method}:", url
      req.headers['host'] = "#{@host}:#{@port}"
      rest.get url, headers: req.headers

  strip_url_for_npm_vhost = (url) ->
      # Strips the couchdb npmjs.org app from the URL
      # for NPM registries with the registry vhost set
      url.replace '/registry/_design/scratch/_rewrite/', ''

  server = httpProxy.createServer (req, res, proxy) ->
      buffer = httpProxy.buffer req

      if req.method is 'GET'
          # Check if the child npm has it
          check = child_npm.check req

          # Found it in our repo
          check.on 'success', (data) ->
              req.url = child_npm.path + req.url
              console.info "INFO: Found #{req.url} in child npm!"

              req.headers['host'] = child_npm.host
              proxyOpts = child_npm
              proxyOpts['buffer'] = buffer

              proxy.proxyRequest req, res, proxyOpts

          check.on 'error', (err) ->
              console.error "ERROR: Can't find #{req.url} in child npm"

              req.url = strip_url_for_npm_vhost req.url

              req.url = parent_npm.path + req.url
              console.info "INFO: proxying to parent npm #{req.url}"

              req.headers['host'] = parent_npm.host
              delete req.headers['authorization']
              proxyOpts = parent_npm
              proxyOpts['buffer'] = buffer

              proxy.proxyRequest req, res, proxyOpts
      else
          # Update our repo
          req.url = child_npm.path + req.url
          console.info "INFO: Updating #{req.url}"

          req.headers['host'] = child_npm.host
          proxyOpts = child_npm
          proxyOpts['buffer'] = buffer

          proxy.proxyRequest req, res, proxyOpts

  server.on 'error', (err) ->
      console.error 'ERROR: Server Error:', err

  server.listen proxy.port, proxy.host, () ->
      console.info "Proxying #{proxy.host}:#{proxy.port}"

  return server

module.exports = createNpmProxyServer: createNpmProxyServer
