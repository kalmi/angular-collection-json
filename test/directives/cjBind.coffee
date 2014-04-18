describe "cjBind directive", ->
  el = scope = null

  beforeEach module('Collection')

  beforeEach inject (Template, $rootScope, $compile)->
    el = angular.element '''
    <input type="text" ng-model="template" cj-bind="firstName" />
    '''
    scope = $rootScope.$new()
    scope.template = new Template(
      'http://example.com/foo',
      data: [
        { name: 'firstName' }
      ]
    )
    $compile(el)(scope)
    scope.$digest()

  it 'defaults to empty', ->
    expect(el.val()).toEqual ''

  it 'reads set value', ->
    scope.template.set 'firstName', 'xx'
    scope.$digest()
    expect(el.val()).toEqual 'xx'

  it 'sets the input value', ->
    el.val 'zz'
    el.triggerHandler 'change'
    scope.$digest()
    expect(scope.template.get 'firstName').toEqual 'zz'

  it 'sets the name of the field', ->
    expect(el.attr 'name').toEqual 'firstName'
