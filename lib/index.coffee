server = require './server'
{ targetParser } = require './targetParser'

module.exports =
  targetParser: targetParser
  server: server