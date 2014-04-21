// Generated by CoffeeScript 1.6.2
(function() {
  describe("cjBind directive", function() {
    var $compile, el, scope;

    el = scope = $compile = null;
    beforeEach(module('Collection'));
    beforeEach(inject(function(Template, $rootScope, _$compile_) {
      $compile = _$compile_;
      el = angular.element('<input type="text" ng-model="template" cj-bind="search.firstName" />');
      scope = $rootScope.$new();
      scope.template = new Template('http://example.com/foo', {
        data: [
          {
            name: 'search[firstName]'
          }
        ]
      });
      $compile(el)(scope);
      return scope.$digest();
    }));
    it('defaults to empty', function() {
      return expect(el.val()).toEqual('');
    });
    it('reads set value', function() {
      scope.template.set('search.firstName', 'xx');
      scope.$digest();
      return expect(el.val()).toEqual('xx');
    });
    it('sets the input value', function() {
      el.val('zz');
      el.triggerHandler('change');
      scope.$digest();
      return expect(scope.template.get('search.firstName')).toEqual('zz');
    });
    it('sets the name of the input', function() {
      return expect(el.attr('name')).toEqual('search[firstName]');
    });
    it('sets the id of the input', function() {
      var id;

      id = el.attr('id');
      expect(id).toContain(scope.$id);
      return expect(id).toContain('search[firstName]');
    });
    return describe('existing input name and id', function() {
      beforeEach(function() {
        el = angular.element('<input type="text" id="oId" name="oName" ng-model="template" cj-bind="firstName" />');
        return $compile(el)(scope);
      });
      it('wont overwrite the name', function() {
        return expect(el.attr('name')).toEqual('oName');
      });
      return it('wont overwrite the id', function() {
        return expect(el.attr('id')).toEqual('oId');
      });
    });
  });

}).call(this);
