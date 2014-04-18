angular.module('Collection').provider('Template', ->
  $get: ($injector) ->
    class Template
      constructor: (@_href, @_template)->
        # delay the dependency
        @client = $injector.get 'cj'

        @_data = {}

        for d in (@_template.data || [])
          @_data[d.name] = new TemplateDatum d

      datum: (key)->
        @_data[key]

      get: (key)->
        @datum(key)?.value

      set: (key, value)->
        @datum(key)?.value = value

      promptFor: (key)->
        @datum(key)?.prompt

      errorsFor: (key)->
        @datum(key)?.errors

      optionsFor: (key)->
        options = @datum(key)?.options
        o for o in options when @conditionsMatch(o.conditions)

      conditionsMatch: (conditions) ->
        return true if !conditions || !conditions.length

        match = true
        for c in conditions
          match &&= @get(c.field) == c.value
        match

      href: ->
        @_href

      form: ->
        memo = {}
        memo[datum.name] = datum.value for key, datum of @_data
        memo

      valid: ->
        for key, datum of @_data
          return false if !datum.valid()
        true

      submit: ->
        @client @href, method: 'POST', data: @form()


      class TemplateDatum
        empty = (str) ->
          !str || str == ""

        constructor: (@_datum) ->
          @name = @_datum.name
          @value = @_datum.value
          @prompt = @_datum.prompt
          @options = @_datum.options || []
          @errors = @_datum.errors || []
          @validationErrors = []

        valid: ->
          @validationErrors =
            required: !@validateRequired()
            regexp: !@validateRegexp()

          for name, isError of @validationErrors
            return false if isError
          true

        validateRequired: ->
          if @_datum.required
            !empty @value
          else
            true

        validateRegexp: ->
          if @_datum.regexp
            empty(@value) || @value.match @_datum.regexp
          else
            true
)
