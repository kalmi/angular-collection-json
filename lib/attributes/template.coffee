angular.module('Collection').provider('Template', ->
  $get: ($injector, nameFormatter) ->
    class Template


      constructor: (@_href, @_template, @_baseName)->
        # delay the dependency
        @client = $injector.get 'cj'

        @_data = {}

        @options = {}
        @prompt = {}

        for d in (@_template.data || [])
          @_data[d.name] = new TemplateDatum d
          defineBase = @
          defineOptions = @options
          definePrompt = @prompt
          do (d, defineBase, defineOptions, definePrompt) =>
            keys = (if @_baseName then nameFormatter.keys d.name else key = d.name)
            if @_baseName && keys.length > 1
              keys.forEach (name, idx) ->
                if name != keys[-1..][0]
                  if name not of defineBase
                    defineBase[name] = {}
                    defineOptions[name] = {}
                    definePrompt[name] = {}
                  defineBase = defineBase[name]
                  defineOptions = defineOptions[name]
                  definePrompt = definePrompt[name]
                key = name
            else if angular.isArray(keys)
              key = keys[0]

            that = @
            Object.defineProperty defineBase, key, do (that, keys) ->
              get: -> that.get(keys.join('.'))
              set: (value) -> that.set(keys.join('.'), value)
            Object.defineProperty defineOptions, key, do (that, keys) ->
              __val = null
              get: -> __val || __val = that.optionsFor(keys.join('.'))
            Object.defineProperty definePrompt, key, do (that, keys) ->
              __val = null
              get: -> __val || __val = that.promptFor(keys.join('.'))


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
