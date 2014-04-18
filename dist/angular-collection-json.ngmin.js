angular.module('Collection', []).factory('cj', [
  'Collection',
  '$http',
  '$q',
  function (Collection, $http, $q) {
    var ret;
    ret = function (href, options) {
      var config;
      config = _.extend({ url: href }, options);
      return $http(config).then(function (res) {
        return ret.parse(res.data);
      }, function (res) {
        return ret.parse(res.data).then(function (collection) {
          var e;
          e = new Error('request failed');
          e.response = res;
          e.collection = collection;
          return $q.reject(e);
        });
      });
    };
    ret.parse = function (source) {
      var collectionObj, e, _ref;
      if (_.isString(source)) {
        try {
          source = JSON.parse(source);
        } catch (_error) {
          e = _error;
          return $q.reject(e);
        }
      }
      if (((_ref = source.collection) != null ? _ref.version : void 0) !== '1.0') {
        return $q.reject(new Error('Collection does not conform to Collection+JSON 1.0 Spec'));
      }
      collectionObj = new Collection(source.collection);
      if (collectionObj.error) {
        e = new Error('Parsed collection contains errors');
        e.collection = collectionObj;
        return $q.reject(e);
      } else {
        return $q.when(collectionObj);
      }
    };
    return ret;
  }
]);
angular.module('Collection').provider('Collection', function () {
  return {
    $get: [
      'Link',
      'Item',
      'Query',
      'Template',
      function (Link, Item, Query, Template) {
        var Collection;
        return Collection = function () {
          function Collection(collection) {
            this._collection = collection;
            this._links = null;
            this._queries = null;
            this._items = null;
            this._template = null;
            this.error = this._collection.error;
          }
          Collection.prototype.href = function () {
            return this._collection.href;
          };
          Collection.prototype.version = function () {
            return this._collection.version;
          };
          Collection.prototype.links = function () {
            var l;
            if (this._links) {
              return this._links;
            }
            return this._links = function () {
              var _i, _len, _ref, _results;
              _ref = this._collection.links || [];
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                l = _ref[_i];
                _results.push(new Link(l));
              }
              return _results;
            }.call(this);
          };
          Collection.prototype.link = function (rel) {
            var l, _i, _len, _ref;
            _ref = this.links();
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              l = _ref[_i];
              if (l.rel() === rel) {
                return l;
              }
            }
          };
          Collection.prototype.items = function () {
            var i;
            if (this._items) {
              return this._items;
            }
            return this._items = function () {
              var _i, _len, _ref, _results;
              _ref = this._collection.items || [];
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                i = _ref[_i];
                _results.push(new Item(i));
              }
              return _results;
            }.call(this);
          };
          Collection.prototype.item = function (href) {
            var i, _i, _len, _ref;
            _ref = this.items();
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              i = _ref[_i];
              if (i.href() === href) {
                return i;
              }
            }
          };
          Collection.prototype.queries = function () {
            var q, _i, _len, _ref, _results;
            _ref = this._collection.queries || [];
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              q = _ref[_i];
              _results.push(new Query(q));
            }
            return _results;
          };
          Collection.prototype.query = function (rel) {
            var q, _i, _len, _ref;
            _ref = this._collection.queries || [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              q = _ref[_i];
              if (q.rel === rel) {
                return new Query(q);
              }
            }
          };
          Collection.prototype.template = function () {
            return new Template(this._collection.href, this._collection.template);
          };
          Collection.prototype.meta = function (name) {
            var _ref;
            return (_ref = this._collection.meta) != null ? _ref[name] : void 0;
          };
          return Collection;
        }();
      }
    ]
  };
});
angular.module('Collection').provider('Item', function () {
  return {
    $get: [
      'Link',
      'Template',
      '$injector',
      function (Link, Template, $injector) {
        var Item;
        return Item = function () {
          function Item(_item, _template) {
            this._item = _item;
            this._template = _template;
            this.client = $injector.get('cj');
            this._links = {};
            this._data = null;
          }
          Item.prototype.href = function () {
            return this._item.href;
          };
          Item.prototype.datum = function (key) {
            var datum;
            datum = _.find(this._item.data, function (item) {
              return item.name === key;
            });
            return _.clone(datum);
          };
          Item.prototype.get = function (key) {
            var _ref;
            return (_ref = this.datum(key)) != null ? _ref.value : void 0;
          };
          Item.prototype.promptFor = function (key) {
            var _ref;
            return (_ref = this.datum(key)) != null ? _ref.prompt : void 0;
          };
          Item.prototype.load = function () {
            return this.client(this.href());
          };
          Item.prototype.links = function () {
            return this._item.links;
          };
          Item.prototype.link = function (rel) {
            var link;
            link = _.find(this._item.links || [], function (link) {
              return link.rel === rel;
            });
            if (!link) {
              return null;
            }
            if (link) {
              this._links[rel] = new Link(link);
            }
            return this._links[rel];
          };
          Item.prototype.edit = function () {
            var template;
            if (!this._template) {
              throw new Error('Item does not support editing');
            }
            template = _.clone(this._template);
            template.href = this._item.href;
            return new Template(template, this.data());
          };
          Item.prototype.remove = function () {
            return this.client(this.href(), { method: 'DELETE' });
          };
          return Item;
        }();
      }
    ]
  };
});
angular.module('Collection').provider('Link', function () {
  return {
    $get: [
      '$injector',
      function ($injector) {
        var Link;
        return Link = function () {
          function Link(_link) {
            this._link = _link;
            this.client = $injector.get('cj');
          }
          Link.prototype.href = function () {
            return this._link.href;
          };
          Link.prototype.rel = function () {
            return this._link.rel;
          };
          Link.prototype.prompt = function () {
            return this._link.prompt;
          };
          Link.prototype.follow = function () {
            return this.client(this.href());
          };
          return Link;
        }();
      }
    ]
  };
});
angular.module('Collection').provider('Query', function () {
  return {
    $get: [
      '$injector',
      function ($injector) {
        var Query;
        return Query = function () {
          function Query(_query, form) {
            var _form;
            this._query = _query;
            this.form = form != null ? form : {};
            this.client = $injector.get('cj');
            _query = this._query;
            _form = this.form;
            _.each(_query.data, function (datum) {
              if (_form[datum.name] == null) {
                return _form[datum.name] = datum.value;
              }
            });
          }
          Query.prototype.datum = function (key) {
            var datum;
            datum = _.find(this._query.data || [], function (datum) {
              return datum.name === key;
            });
            return _.clone(datum);
          };
          Query.prototype.get = function (key) {
            return this.form[key];
          };
          Query.prototype.set = function (key, value) {
            return this.form[key] = value;
          };
          Query.prototype.promptFor = function (key) {
            var _ref;
            return (_ref = this.datum(key)) != null ? _ref.prompt : void 0;
          };
          Query.prototype.href = function () {
            return this._query.href;
          };
          Query.prototype.rel = function () {
            return this._query.rel;
          };
          Query.prototype.prompt = function () {
            return this._query.prompt;
          };
          Query.prototype.submit = function (done) {
            if (done == null) {
              done = function () {
              };
            }
            return this.client(this.href(), { params: this.form });
          };
          return Query;
        }();
      }
    ]
  };
});
angular.module('Collection').provider('Template', function () {
  return {
    $get: [
      '$injector',
      function ($injector) {
        var Template;
        return Template = function () {
          var TemplateDatum;
          function Template(_href, _template) {
            var d;
            this._href = _href;
            this._template = _template;
            this.client = $injector.get('cj');
            this._data = function () {
              var _i, _len, _ref, _results;
              _ref = this._template.data || [];
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                d = _ref[_i];
                _results.push(new TemplateDatum(d));
              }
              return _results;
            }.call(this);
          }
          Template.prototype.datum = function (key) {
            var d, _i, _len, _ref;
            _ref = this._data;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              d = _ref[_i];
              if (d.name === key) {
                return d;
              }
            }
          };
          Template.prototype.get = function (key) {
            var _ref;
            return (_ref = this.datum(key)) != null ? _ref.value : void 0;
          };
          Template.prototype.set = function (key, value) {
            var _ref;
            return (_ref = this.datum(key)) != null ? _ref.value = value : void 0;
          };
          Template.prototype.promptFor = function (key) {
            var _ref;
            return (_ref = this.datum(key)) != null ? _ref.prompt : void 0;
          };
          Template.prototype.errorsFor = function (key) {
            var _ref;
            return (_ref = this.datum(key)) != null ? _ref.errors : void 0;
          };
          Template.prototype.optionsFor = function (key) {
            var o, options, _i, _len, _ref, _results;
            options = (_ref = this.datum(key)) != null ? _ref.options : void 0;
            _results = [];
            for (_i = 0, _len = options.length; _i < _len; _i++) {
              o = options[_i];
              if (this.conditionsMatch(o.conditions)) {
                _results.push(o);
              }
            }
            return _results;
          };
          Template.prototype.conditionsMatch = function (conditions) {
            var c, match, _i, _len;
            if (!conditions || !conditions.length) {
              return true;
            }
            match = true;
            for (_i = 0, _len = conditions.length; _i < _len; _i++) {
              c = conditions[_i];
              match && (match = this.get(c.field) === c.value);
            }
            return match;
          };
          Template.prototype.href = function () {
            return this._href;
          };
          Template.prototype.form = function () {
            var d, memo, _i, _len, _ref;
            memo = {};
            _ref = this._data;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              d = _ref[_i];
              memo[d.name] = d.value;
            }
            return memo;
          };
          Template.prototype.valid = function () {
            var d, _i, _len, _ref;
            _ref = this._data;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              d = _ref[_i];
              if (!d.valid()) {
                return false;
              }
            }
            return true;
          };
          Template.prototype.submit = function () {
            return this.client(this.href, {
              method: 'POST',
              data: this.form()
            });
          };
          TemplateDatum = function () {
            var empty;
            empty = function (str) {
              return !str || str === '';
            };
            function TemplateDatum(_datum) {
              this._datum = _datum;
              this.name = this._datum.name;
              this.value = this._datum.value;
              this.prompt = this._datum.prompt;
              this.options = this._datum.options || [];
              this.errors = this._datum.errors || [];
              this.validationErrors = [];
            }
            TemplateDatum.prototype.valid = function () {
              var isError, name, _ref;
              this.validationErrors = {
                required: !this.validateRequired(),
                regexp: !this.validateRegexp()
              };
              _ref = this.validationErrors;
              for (name in _ref) {
                isError = _ref[name];
                if (isError) {
                  return false;
                }
              }
              return true;
            };
            TemplateDatum.prototype.validateRequired = function () {
              if (this._datum.required) {
                return !empty(this.value);
              } else {
                return true;
              }
            };
            TemplateDatum.prototype.validateRegexp = function () {
              if (this._datum.regexp) {
                return empty(this.value) || this.value.match(this._datum.regexp);
              } else {
                return true;
              }
            };
            return TemplateDatum;
          }();
          return Template;
        }();
      }
    ]
  };
});
angular.module('Collection').directive('cjBind', function () {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function (scope, el, attr, ctrl) {
      var datumName, expr;
      datumName = attr.cjBind;
      expr = '' + attr.ngModel + '.get(\'' + datumName + '\')';
      scope.$watch(expr, function (val, old) {
        if (ctrl.$viewValue !== val) {
          ctrl.$viewValue = val;
          return ctrl.$render();
        }
      });
      return ctrl.$parsers.push(function (val) {
        ctrl.$modelValue.set(datumName, val);
        return ctrl.$modelValue;
      });
    }
  };
});