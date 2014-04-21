angular.module('Collection').service 'nameFormatter', ->
  dotted: (str) ->
    segments = str.split /[\]\[]/
    nonempty = (s for s in segments when s != '')
    nonempty.join '.'

  bracketed: (str, base) ->
    if base && str.indexOf(base) == -1
      str = "#{base}.#{str}"
    segments = str.split /\./
    nonempty = (s for s in segments when s != '')
    for i in [1 ... nonempty.length]
      nonempty[i] = "[#{nonempty[i]}]"
    nonempty.join ''

  base: (str) ->
    @dotted(str)?.split('.')[0]

  keys: (str, short) ->
    @dotted(str)?.split('.')[1...]

  key: (str) ->
    segments = @dotted(str)?.split('.')
    segments.slice(-1)[0]