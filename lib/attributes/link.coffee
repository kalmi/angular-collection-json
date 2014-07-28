angular.module('Collection').provider 'Link', ->
  $get: ($injector) ->
    class Link
      constructor: (@_link)->
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
        @client @href(), options
