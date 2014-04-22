describe "defineNested service", ->
  defineNested = null

  beforeEach module('Collection')

  beforeEach inject (_defineNested_) ->
    defineNested = _defineNested_

  it 'defines nested properties on an object', ->
    obj = {}
    expected = 'foo'
    stored = null
    defineNested obj, ['foo', 'bar', 'baz'],
      get: -> expected
      set: (v) -> stored = v

    expect(obj.foo.bar.baz).toEqual expected
    obj.foo.bar.baz = 'zing'
    expect(stored).toEqual 'zing'

  it 'supports multiple properties with same nested root', ->
    obj = {}
    defineNested obj, ['foo', 'bar', 'baz'],
      get: -> 'one'
    defineNested obj, ['foo', 'bar', 'qux'],
      get: -> 'two'

    expect(obj.foo.bar.baz).toEqual 'one'
    expect(obj.foo.bar.qux).toEqual 'two'
