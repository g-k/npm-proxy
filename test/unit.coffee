expect = require 'expect.js'
{ targetParser, server } = require '..'


describe 'targetParser', ->

  it 'should return host and port', ->
    expect(targetParser 'localhost:8080').to.eql {
      host: 'localhost'
      port: 8080
    }

  it 'should default to port 80', ->
    expect(targetParser('').port).to.equal 80
