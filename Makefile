define SAUCE_TARGETS
["Windows 7", "internet explorer", "9"], \
["Windows 7", "internet explorer", "8"], \
["OS X 10.9", "iphone", "7.1"] \

endef

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

test_sauce:
	@echo "Ensure you have Sauce Connect running"
	@echo "Also, set SAUCE_USERNAME and SAUCE_ACCESS_KEY"
	@echo "Running tests for\n$(SAUCE_TARGETS)"
	@echo "Be patient..."
	@curl -X POST https://saucelabs.com/rest/v1/$(SAUCE_USERNAME)/js-tests \
		-u $(SAUCE_USERNAME):$(SAUCE_ACCESS_KEY) \
		-d url="http://localhost:9876" -d framework=jasmine \
		-d platforms='[$(SAUCE_TARGETS)]'
	@./node_modules/karma/bin/karma start --no-browsers

.PHONY: all test test_sauce clean clean_deps
