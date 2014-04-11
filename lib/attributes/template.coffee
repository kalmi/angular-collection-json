angular.module('Collection').provider('Template', ->
  $get: ($injector) ->
    class Template
      constructor: (@_href, @_template)->
        # delay the dependency
        @client = $injector.get 'cj'

        @_data = (new TemplateDatum d for d in (@_template.data || []))

      datum: (key)->
        for d in @_data
          return d if d.name == key

      get: (key)->
        @datum(key)?.value

      set: (key, value)->
        @datum(key)?.value = value

      promptFor: (key)->
        @datum(key)?.prompt

      errorsFor: (key)->
        @datum(key)?.errors

      href: ->
        @_href

      form: ->
        memo = {}
        memo[d.name] = d.value for d in @_data
        memo

      submit: ->
        @client @href, method: 'POST', data: @form()


      class TemplateDatum
        constructor: (@_datum) ->
          @name = @_datum.name
          @value = @_datum.value
          @prompt = @_datum.prompt
          @errors = @_datum.errors || []


)
