describe "ReadonlyCache", ->
  cache = inner = null

  beforeEach module('Collection')
  beforeEach inject (ReadonlyCache) ->
    inner = foo: 'bar'
    Object.freeze inner
    cache = new ReadonlyCache inner

  it 'retrieves from inner object', ->
    expect(cache.get 'foo').toBe inner.foo

  it 'returns set value', ->
    expect(cache.put 'foo', 'other').toBe 'other'

  it 'does nothing on put', ->
    expect(cache.put 'foo', 'other')
    expect(cache.get 'foo').toBe 'bar'

  it 'does nothing on remove', ->
    cache.remove 'foo'
    expect(cache.get 'foo').toBe 'bar'

  it 'does nothing on removeAll', ->
    cache.removeAll()
    expect(cache.get 'foo').toBe 'bar'

  it 'does nothing on destroy', ->
    cache.destroy()
    expect(cache.get 'foo').toBe 'bar'

  it 'returns info', ->
    expect(cache.info()).toEqual
      id: null
      size: 1
      readonly: true

  describe '$http', ->
    $http = $rootScope = response = null

    beforeEach inject (_$http_, _$rootScope_, ReadonlyCache) ->
      $http = _$http_
      $rootScope = _$rootScope_
      response = {cool: 'response'}
      cache = new ReadonlyCache
        'http://example.com/myfile': response

    it 'works as $http cache', ->
      called = false
      promise = $http url: 'http://example.com/myfile', cache: cache
      promise.then (res) ->
        called = true
        expect(res.data).toEqual response
      $rootScope.$digest()
      expect(called).toBeTruthy()

