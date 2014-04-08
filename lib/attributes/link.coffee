angular.module('Collection').provider('Link', ->
  $get: ->
    class Link
      constructor: (@_link)->

      href: ->
        @_link.href

      rel: ->
        @_link.rel

      prompt: ->
        @_link.prompt

      follow: (done=()->)->
        options = {}

        http.get @_link.href, options, (error, collection)->
          return done error if error
          client.parse collection, done
)