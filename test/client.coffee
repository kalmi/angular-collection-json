describe "Client", ->
  provider = $injector = scope = null

  beforeEach module('Collection')

  beforeEach ->
    angular.module('test.client.provider', []).config (cjProvider) ->
      provider = cjProvider
    module('test.client.provider')

  beforeEach inject (_$injector_, $rootScope) ->
    $injector = _$injector_
    scope = $rootScope.$new()

  describe "strictVersion", ->
    it 'does not reject invalid version if strictVersion is off', ->
      provider.setStrictVersion false
      spy = jasmine.createSpy 'reject'
      client = $injector.invoke provider.$get
      client.parse(collection: items: []).catch spy
      scope.$digest()
      expect(spy).not.toHaveBeenCalled()

    it 'still rejects if collection is missing', ->
      provider.setStrictVersion false
      spy = jasmine.createSpy 'reject'
      client = $injector.invoke provider.$get
      client.parse(notacollection: true).catch spy
      scope.$digest()
      expect(spy).toHaveBeenCalled()

  describe "urlTransform", ->
    $httpBackend = null

    beforeEach inject (_$httpBackend_, _$injector_) ->
      $httpBackend = _$httpBackend_

    it 'makes calls with transformed url', ->
      $httpBackend.expectGET('http://example.com/cool').respond(200, '{}')
      provider.setUrlTransform (orig) ->
        orig + '/cool'

      client = $injector.invoke provider.$get 
      expect(client).toBeDefined()
      client 'http://example.com'
      $httpBackend.verifyNoOutstandingExpectation()


