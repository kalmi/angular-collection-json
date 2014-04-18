describe "cjBind directive", ->
  el = scope = $compile = null

  beforeEach module('Collection')

  beforeEach inject (Template, $rootScope, _$compile_)->
    $compile = _$compile_
    el = angular.element '''
    <input type="text" ng-model="template" cj-bind="search.firstName" />
    '''
    scope = $rootScope.$new()
    scope.template = new Template(
      'http://example.com/foo',
      data: [
        { name: 'search[firstName]' }
      ]
    )
    $compile(el)(scope)
    scope.$digest()

  it 'defaults to empty', ->
    expect(el.val()).toEqual ''

  it 'reads set value', ->
    scope.template.set 'search.firstName', 'xx'
    scope.$digest()
    expect(el.val()).toEqual 'xx'

  it 'sets the input value', ->
    el.val 'zz'
    el.triggerHandler 'change'
    scope.$digest()
    expect(scope.template.get 'search.firstName').toEqual 'zz'

  it 'sets the name of the input', ->
    expect(el.attr 'name').toEqual 'search[firstName]'

  it 'sets the id of the input', ->
    id = el.attr 'id'
    expect(id).toContain scope.$id
    expect(id).toContain 'search[firstName]'

  describe 'existing input name and id', ->
    beforeEach ->
      el = angular.element '''
      <input type="text" id="oId" name="oName" ng-model="template" cj-bind="firstName" />
      '''
      $compile(el)(scope)

    it 'wont overwrite the name', ->
      expect(el.attr 'name').toEqual 'oName'

    it 'wont overwrite the id', ->
      expect(el.attr 'id').toEqual 'oId'

