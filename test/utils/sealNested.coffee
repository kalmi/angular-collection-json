describe "sealNested service", ->
  sealNested = null

  beforeEach module('Collection')

  beforeEach inject (_sealNested_) ->
    sealNested = _sealNested_

  it 'seals nested properties on an object', ->
    obj =
      foo:
        bar:
          baz: 'qux'
    sealNested obj, ['foo', 'bar', 'baz']
    obj.foo.bar.zing = 'xxx'
    expect(obj.foo.bar.zing).toBeUndefined()
    obj.foo.bar.other = 'xxx'
    expect(obj.foo.bar.other).toBeUndefined()
