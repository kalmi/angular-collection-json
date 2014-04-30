angular.module('Collection').provider('Item', ->
  $get: (Link, Template, $injector, nameFormatter) ->
    class Item
      constructor: (@_item, @_template)->
        # delay the dependency
        @client = $injector.get 'cj'
        @_links = {}
        @_data = null

      href: ()-> @_item.href

      datum: (key)->
        for i in @_item.data
          return angular.extend({}, i) if i.name == key

      get: (key)->
        @datum(key)?.value

      fields: (href) ->
        memo = {}
        for item in @_item.data
          segments = nameFormatter.bracketedSegments item.name
          nameFormatter._nestedAssign.call @, memo, segments, item.value
        memo

      promptFor: (key)->
        @datum(key)?.prompt

      load: ->
        @client @href()

      links: ()->
        @_item.links

      link: (rel)->
        link = _.find @_item.links||[], (link)->
          link.rel is rel
        return null if not link

        @_links[rel] = new Link(link) if link
        @_links[rel]

      edit: ()->
        throw new Error("Item does not support editing") if not @_template
        template = _.clone @_template
        template.href = @_item.href
        new Template template, @data()

      remove: ()->
        @client @href(), method: 'DELETE'

)
