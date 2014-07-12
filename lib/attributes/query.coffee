angular.module('Collection').provider('Query', ->
  $get: ($injector, Template) ->
    class Query
      constructor: (@_query)->
        # delay the dependency
        @client = $injector.get 'cj'
        _query = @_query
        @template = new Template @_query.href, @_query

      datum: (key)->
        for d in (@_query.data || [])
          return angular.extend {}, d if d.name == key

      get: (key)->
        @template.get key

      set: (key, value)->
        @template.set key, value

      promptFor: (key)->
        @datum(key)?.prompt

      href: ()-> @_query.href
      rel: ()-> @_query.rel
      prompt: ()-> @_query.prompt

      submit: ->
        @client @href(), method: 'POST', data: @template.parametersNested()

      refresh: ->
        @client @href(), method: 'GET', params: @template.parameters()

)
