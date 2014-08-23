angular.module('Collection').provider 'Link', ->
  $get: ($injector) ->
    class Link
      constructor: (@_link, @_cache)->
        # delay the dependency
        @client = $injector.get 'cj'

      href: ->
        @_link.href

      rel: ->
        @_link.rel

      prompt: ->
        @_link.prompt

      name: ->
        @_link.name

      follow: (options) ->
        options = angular.extend {cache: @_cache}, options
        @client @href(), options
