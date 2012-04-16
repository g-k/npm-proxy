MOCHA=./node_modules/mocha/bin/mocha -u bdd --compilers coffee:coffee-script

clean:
	rm -f npm-debug.log
	rm -rf coverage.html
	rm -f /usr/local/var/lib/couchdb/registry.couch
	rm -rf npmjs.org

setup-couch: clean
	./test/setup-couchdb.sh

start-couch:
	# ./test/start-couchdb.sh

setup-npmjs:
	./test/setup-npmjs.sh

acceptance-test: # clean setup-couch start-couch setup-npmjs
	REGISTRY='http://localhost:8080/registry/_design/app/_rewrite' ./test/acceptance.sh

unit-test-coverage:
	rm -rf lib-cov
	./node_modules/coffee-script/bin/coffee -o lib-cov-tmp -c lib # compile CS
	@jscoverage lib-cov-tmp lib-cov # instrument JS
	rm -rf lib-cov-tmp
	@COVERAGE=1 $(MOCHA) -R html-cov test/*.coffee > coverage.html
	open coverage.html

unit-test:
	$(MOCHA) --bail --growl test/*.coffee

test: unit-test acceptance-test
