angular.module('Collection').service 'defineNested', ->
  defineNested = (obj, keys, prop) ->
    [head, tail...] = keys
    if !tail.length
      Object.defineProperty obj, head, prop
    else
      next = obj[head] ||= {}
      defineNested next, tail, prop
