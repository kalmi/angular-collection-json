angular.module('Collection').service 'sealNested', ->
  sealNested = (obj, keys) ->
    [head, tail...] = keys
    if angular.isObject obj
      Object.seal obj
      sealNested obj[head], tail
