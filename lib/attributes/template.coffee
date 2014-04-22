angular.module('Collection').provider('Template', ->
  $get: ($injector, nameFormatter, defineNested, sealNested) ->
    class Template
      constructor: (@_href, @_template)->
        # delay the dependency
        @client = $injector.get 'cj'

        @_data = {}

        @options = {}
        @prompts = {}
        @errors = {}

        for d in (@_template.data || []) then do =>
          datum = @_data[d.name] = new TemplateDatum d
          segments = nameFormatter.bracketedSegments d.name
          defineNested @, segments,
            get: -> datum.value
            set: (v)-> datum.value = v

          defineNested @options, segments, get: -> datum.options

          defineNested @prompts, segments, get: -> datum.prompt

          defineNested @errors, segments, get: -> datum.errors

        for d in (@_template.data || [])
          segments = nameFormatter.bracketedSegments d.name
          sealNested @, segments

      datum: (key)->
        formatted = nameFormatter.bracketed key
        @_data[formatted]

      get: (key)->
        @datum(key)?.value

      set: (key, value)->
        @datum(key)?.value = value

      promptFor: (key)->
        @datum(key)?.prompt

      errorsFor: (key)->
        @datum(key)?.errors

      optionsFor: (key, applyConditions = true)->
        options = @datum(key)?.options
        if !applyConditions then options else o for o in options when @conditionsMatch(o.conditions)

      conditionsMatch: (conditions) ->
        return true if !conditions || !conditions.length

        conditions.every (c) => @get(c.field) == c.value

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
