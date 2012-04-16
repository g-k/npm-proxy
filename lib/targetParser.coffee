module.exports =
  targetParser: targetParser = (target) ->
    # Splits a target string into an object with host and port
    [host, port] = target.split ':'
    host: host
    port: parseInt(port, 10) or 80
