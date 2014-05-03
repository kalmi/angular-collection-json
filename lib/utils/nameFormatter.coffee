angular.module('Collection').service 'nameFormatter', ->

  # Needs to be executed using _nestedAssign.call to have a handle on the correct values
  _nestedAssign = (obj, segments, value) ->
    [head, tail...] = segments
    if tail.length
      obj[head] ||= {}
      _nestedAssign(obj[head], tail, value)
    else
      obj[head] = value
      obj

  notEmpty = (s) -> s != ''


  bracketedSegments: (str) ->
    str.split(/[\]\[]/).filter notEmpty
  dottedSegments: (str) ->
    str.split('.').filter notEmpty

  dotted: (str) ->
    return str unless str
    segments = @bracketedSegments str
    segments.join '.'

  bracketed: (str) ->
    return str unless str
    segments = @dottedSegments str
    for i in [1 ... segments.length]
      segments[i] = "[#{segments[i]}]"
    segments.join ''

  _nestedAssign: _nestedAssign

