angular.module('Collection').service 'nameFormatter', ->
  bracketedSegments: (str) ->
    str.split(/[\]\[]/).filter (s) -> s != ''
  dottedSegments: (str) ->
    str.split('.').filter (s) -> s != ''

  dotted: (str) ->
    segments = @bracketedSegments str
    segments.join '.'

  bracketed: (str) ->
    segments = @dottedSegments str
    for i in [1 ... segments.length]
      segments[i] = "[#{segments[i]}]"
    segments.join ''

