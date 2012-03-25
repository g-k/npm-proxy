MOCHA=./node_modules/mocha/bin/mocha -u bdd --compilers 'coffee:coffee-script' ./test/*.coffee --growl

clean:
	rm -f npm-debug.log
	rm -f /usr/local/var/lib/couchdb/registry.couch
	rm -rf npmjs.org

setup-couch:
	./test/setup-couchdb.sh

start-couch:
	# ./test/start-couchdb.sh

setup-npmjs:
	./test/setup-npmjs.sh

npmjs-test: # clean setup-couch start-couch setup-npmjs
	REGISTRY='http://localhost:5984/registry/_design/app/_rewrite/' $(MOCHA)

acceptance-test:
	REGISTRY='http://localhost:8080/' $(MOCHA)
