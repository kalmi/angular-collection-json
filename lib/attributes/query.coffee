angular.module('Collection').provider('Query', ->
  $get: ($injector) ->
    class Query
      constructor: (@_query, @form={})->
        # delay the dependency
        @client = $injector.get 'cj'
        _query = @_query
        _form = @form

        for datum in _query.data
          _form[datum.name] = datum.value if not _form[datum.name]?

      datum: (key)->
        for d in (@_query.data || [])
          return angular.extend {}, d if d.name == key

      get: (key)->
        @form[key]

      set: (key, value)->
        @form[key] = value

      promptFor: (key)->
        @datum(key)?.prompt

      href: ()-> @_query.href
      rel: ()-> @_query.rel
      prompt: ()-> @_query.prompt

      submit: (done=()->)->
        @client @href(), params: @form
)
