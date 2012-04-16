if process.env.COVERAGE
  module.exports = require('./lib-cov')
else
  module.exports = require('./lib')
