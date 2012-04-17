url = require 'url'

module.exports =
  targetParser: targetParser = (target) ->
    # Splits a target string into an object with host and port
    # or a url string into an object with scheme, host, port, and path
    if not target.match /^.*:\/\//
        target = 'http://' + target
    m = url.parse target
    scheme: m.protocol or 'http:'
    host: m.hostname
    port: m.port or 80
    path: m.pathname or ''
