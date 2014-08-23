angular.module('Collection').factory 'ReadonlyCache', ->
  class ReadonlyCache
    noop = angular.noop

    constructor: (@_inner) ->

    get: (key) ->
      @_inner[key]

    put: (key, val) ->
      val
    remove: noop
    removeAll: noop
    destroy: noop

    info: ->
      id: null
      size: Object.keys(@_inner).length
      readonly: true

