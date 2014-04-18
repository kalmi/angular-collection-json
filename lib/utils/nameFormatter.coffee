angular.module('Collection').service 'nameFormatter', ->
  dotted: (str) ->
    segments = str.split /[\]\[]/
    nonempty = (s for s in segments when s != '')
    nonempty.join '.'

  bracketed: (str) ->
    segments = str.split /\./
    nonempty = (s for s in segments when s != '')
    for i in [1 ... nonempty.length]
      nonempty[i] = "[#{nonempty[i]}]"
    nonempty.join ''

