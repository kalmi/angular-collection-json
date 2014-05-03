describe "nameFormatter service", ->
  formatter = null

  beforeEach module('Collection')

  beforeEach inject (nameFormatter) ->
    formatter = nameFormatter

  it 'formats a bracketed name as dotted', ->
    result = formatter.dotted 'foo[bar]'
    expect(result).toEqual 'foo.bar'

  it 'leaves a dotted name as dotted', ->
    result = formatter.dotted 'foo.bar.baz'
    expect(result).toEqual 'foo.bar.baz'

  it 'formats a dotted name as bracketed', ->
    result = formatter.bracketed 'foo.bar'
    expect(result).toEqual 'foo[bar]'

  it 'leaves a bracketed name as bracketed', ->
    result = formatter.bracketed 'foo[bar][baz]'
    expect(result).toEqual 'foo[bar][baz]'

  it 'goes full circle', ->
    original = 'foo.bar.baz'
    bracketed = formatter.bracketed original
    dotted = formatter.dotted bracketed
    expect(dotted).toEqual original

  it 'handles undefined', ->
    original = undefined
    dotted = formatter.dotted original
    dottedSegs = formatter.dottedSegments original
    bracketed = formatter.bracketed original
    bracketedSegs = formatter.bracketedSegments original
    expect(dotted).toEqual original
    expect(bracketed).toEqual original
    expect(dottedSegs).toEqual []
    expect(bracketedSegs).toEqual []
