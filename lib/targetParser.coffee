url = require 'url'

module.exports =
  targetParser: targetParser = (target) ->
    # Splits a url string into an object with host and port
    p = /((.*):\/\/)?([^:/]+)(:(\d+))?((\/.*)*)/;
    m = url.match p
    scheme: m[2] or 'http'
    host: m[3]
    port: parseInt(m[5], 10) or 80
    path: m[6] or ''
