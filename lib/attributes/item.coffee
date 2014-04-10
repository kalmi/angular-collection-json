angular.module('Collection').provider('Item', ->
  $get: (Link, Template, $injector) ->
    class Item
      constructor: (@_item, @_template)->
        # delay the dependency
        @client = $injector.get 'cj'
        @_links = {}
        @_data = null

      href: ()-> @_item.href

      datum: (key)->
        datum = _.find @_item.data, (item)-> item.name is key
        # So they don't edit it
        _.clone datum

      get: (key)->
        @datum(key)?.value

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
