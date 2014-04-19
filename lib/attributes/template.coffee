angular.module('Collection').provider('Template', ->
  $get: ($injector, nameFormatter) ->
    class Template
      constructor: (@_href, @_template, @_baseName)->
        # delay the dependency
        @client = $injector.get 'cj'

        @_data = {}

        @options = {}

        for d in (@_template.data || [])
          @_data[d.name] = new TemplateDatum d
          do (d) =>
            key = (if @_baseName then nameFormatter.key d.name else d.name)
            Object.defineProperty @, key,
              get: -> @get(key)
              set: (value) ->
                @set(key, value)

            that = @
            Object.defineProperty @options, key, do (that) =>
              __val = null
              get: -> __val || __val = that.optionsFor(key)


      datum: (key)->
        formatted = nameFormatter.bracketed key, @_baseName
        @_data[formatted]

      get: (key)->
        @datum(key)?.value

      set: (key, value)->
        @datum(key)?.value = value

      promptFor: (key, selected)->
        if !selected
          @datum(key)?.prompt
        else

      errorsFor: (key)->
        @datum(key)?.errors

      optionsFor: (key, applyConditions = true)->
        options = @datum(key)?.options
        if !applyConditions then options else o for o in options when @conditionsMatch(o.conditions)

      conditionsMatch: (conditions) ->
        return true if !conditions || !conditions.length

        match = true
        for c in conditions
          match &&= @get(c.field) == c.value
        match

      selectedOption: (key)->
        options = @optionsFor key, false
        val = @get(key)
        optionVal = options.filter (option) -> option.value == val
        optionVal?[0]

      selectedOptionPrompt: (key)->
        @selectedOption(key)?.prompt

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
