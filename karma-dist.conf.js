var karmaBase = require('./karma.conf.js');

module.exports = function(config) {
  'use strict';
  karmaBase(config);

  config.set({
    files: [
      'bower_components/angular/angular.js',
      'bower_components/angular-mocks/angular-mocks.js',
      'bower_components/lodash/dist/lodash.underscore.js',
      'dist/angular-collection-json.min.js',
      'test/**/*.coffee',
      'test/fixtures/*.js',
    ]
  });
};
