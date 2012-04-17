expect = require 'expect.js'
{ targetParser, server } = require '..'


describe 'targetParser', ->

  it 'should default to scheme http', ->
    expect(targetParser('').scheme).to.equal 'http:'

  it 'should default to empty string for host', ->
    expect(targetParser('').host).to.equal ''

  it 'should default to port 80', ->
    expect(targetParser('').port).to.equal 80

  it 'should default to empty string for root path', ->
    expect(targetParser('').path).to.equal ''

  it 'should return url object for a target', ->
    expect(targetParser 'localhost:8080').to.eql {
      scheme: 'http:'
      host: 'localhost'
      port: 8080
      path: '/'
    }

  it 'should return url object with path for a url', ->
    expect(targetParser 'localhost:8080/staging').to.eql {
      scheme: 'http:'
      host: 'localhost'
      port: 8080
      path: '/staging'
    }

  it 'should return url object with scheme for a url', ->
    expect(targetParser 'https://localhost:8080/').to.eql {
      scheme: 'https:'
      host: 'localhost'
      port: 8080
      path: '/'
    }

  it 'should return url object with scheme and path for a url', ->
    expect(targetParser 'https://localhost:8080/staging').to.eql {
      scheme: 'https:'
      host: 'localhost'
      port: 8080
      path: '/staging'
    }
