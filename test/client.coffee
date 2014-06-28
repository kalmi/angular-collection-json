describe "Client", ->
  beforeEach module('Collection')
  describe "Custom Url Transform", ->
    provider = $httpBackend = $injector = null

    beforeEach ->
      angular.module('test.urlTransform', []).config (cjProvider) ->
        provider = cjProvider
      module('test.urlTransform')

    beforeEach inject (_$httpBackend_, _$injector_) ->
      $httpBackend = _$httpBackend_
      $injector = _$injector_

    it 'makes calls with transformed url', ->
      $httpBackend.expectGET('http://example.com/cool').respond(200, '{}')
      provider.setUrlTransform (orig) ->
        orig + '/cool'

      client = $injector.invoke(provider.$get)
      expect(client).toBeDefined()
      client('http://example.com')
      $httpBackend.verifyNoOutstandingExpectation()


