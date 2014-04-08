all: test compile

node_modules:
	npm install

bower_components: node_modules
	./node_modules/bower/bin/bower install

test: bower_components
	./node_modules/karma/bin/karma start --single-run

dist:
		@mkdir -p dist

dist/angular-collection-json.js: node_modules dist lib
		@echo "Compiling coffee..."
		@./node_modules/coffee-script/bin/coffee \
			--bare \
			--compile \
			--no-header \
			--print \
			--join \
			lib/client.coffee \
			lib/attributes/*.coffee \
			> dist/angular-collection-json.js

compile: dist/angular-collection-json.js

clean:
	rm -rf dist

clean_deps:
	rm -rf node_modules bower_components

.PHONY: all test clean clean_deps
