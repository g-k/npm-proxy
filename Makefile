clean:
	rm -f npm-debug.log
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

unit-test:
	./node_modules/mocha/bin/mocha -u bdd --compilers coffee:coffee-script --bail --growl test/*.coffee
