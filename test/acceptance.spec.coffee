exec = require('child_process').exec
http = require 'http'

expect = require 'expect.js'

restler = require 'restler'


log = registry = undefined
beforeEach ->
  # npm should work with our local npmjs.org
  # and it should work through npm-proxy
  registry = process.env.REGISTRY
  verbose = process.env.VERBOSE or false
  if not verbose
    log = () ->
  else
    log = console.log

describe 'npm adduser', ->

  it 'should exit with code 0', (done) ->
    # Wrapped in shell script because it requires interactive prompt
    cmd = exec "./test/add-user.sh #{registry}", timeout: 1000,
      (error, stdout, stderr) ->
        log 'stdout: ' + stdout
        log 'stderr: ' + stderr
        if error != null
          log 'exec error: ' + error

    cmd.on 'exit', (code, signal) ->
      log code, signal
      expect(code).to.be(0)
      done()

  it 'should add user to registry', (done) ->
    getUser = restler.get "#{registry}-/user/org.couchdb.user:test",
      parser: restler.parsers.json

    getUser.on 'complete', (result, response) ->
      log result, typeof result
      expect(result.type).to.be('user')
      done()


describe 'npm publish npm-proxy', ->

  it 'should exit with code 0', (done) ->
    # must run from project root
    # requires a adduser to have succeeded
    timeout = 3000
    @timeout timeout

    cmd = exec "npm publish -d . --force --registry=#{registry}",
      cwd: process.cwd()
      timeout: timeout,
      (error, stdout, stderr) ->
        log 'stdout: ' + stdout
        log 'stderr: ' + stderr
        if error != null
          log 'exec error: ' + error

    cmd.on 'exit', (code, signal) ->
      log code, signal
      expect(code).to.be(0)
      done()

  it 'should have package in registry', (done) ->
    addPkg = restler.get "#{registry}", parser: restler.parsers.json

    addPkg.on 'complete', (result, response) ->
      log result, typeof result
      expect(result).to.contain('npm-proxy')
      done()


## Get non-local package

# npm install -d colors
# proxy should get from global npmjs
# npmjs should fail if != registry.npmjs.org

describe 'npm install npm-proxy', ->

  it 'should exit with code 0', (done) ->
    # must run from project root

    # Set test and restler timeout
    timeout = 10000
    @timeout timeout

    cmd = exec "npm install -d . --force --registry=#{registry}",
      cwd: process.cwd()
      timeout: timeout,
      (error, stdout, stderr) ->
        log 'stdout: ' + stdout
        log 'stderr: ' + stderr
        if error != null
          log 'exec error: ' + error

    cmd.on 'exit', (code, signal) ->
      log code, signal
      expect(code).to.be(0)
      done()

  it 'should have package in locally', (done) ->
    checkForPkg = re
    # addPkg = restler.get "#{registry}", parser: restler.parsers.json

    # addPkg.on 'complete', (result, response) ->
    #   log result, typeof result
    #   expect(result).to.contain('npm-proxy')
    #   done()


## Get local package

# npm install -d npm-proxy --registry=$REGISTRY
# Should pull npm-proxy from local couchdb
# Should pull dependencies from 3rd party


# More commands to test
# npm owner
# npm unpublish
# npm deprecate
# npm star
# npm info
# npm search
# npm outdated
# npm tag