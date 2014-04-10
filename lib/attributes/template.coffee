angular.module('Collection').provider('Template', ->
  $get: ($injector) ->
    class Template
      constructor: (@_href, @_template, @form={})->
        # delay the dependency
        @client = $injector.get 'cj'
        _template = @_template
        _form = @form

        _.each _template?.data or [], (datum)->
          _form[datum.name] = datum.value if not _form[datum.name]?

      datum: (key)->
        datum = _.find @_template?.data or [], (datum)-> datum.name is key
        _.clone datum

      get: (key)->
        @form[key]

      set: (key, value)->
        @form[key] = value

      promptFor: (key)->
        @datum(key)?.prompt

      href: ->
        @_href

      submit: (done=()->)->
        @client @href, method: 'POST', data: @form

)
