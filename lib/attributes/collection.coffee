angular.module('Collection').provider('Collection', ->
  $get: (Link, Item, Query, Template) ->
    class Collection
      constructor: (collection)->
        @_collection = collection
        @_links = null
        @_queries = null
        @_items = null
        @_template = null
        @error = @_collection.error

      href: ->
        @_collection.href

      version: ->
        @_collection.version

      links: ->
        return @_links if @_links

        @_links = (new Link l for l in (@_collection.links || []))

      link: (rel)->
        for l in @links()
          return l if l.rel() == rel

      items: ->
        return @_items if @_items

        @_items = (new Item i for i in (@_collection.items || []))

      item: (href)->
        for i in @items()
          return i if i.href() == href

      queries: ->
        new Query q for q in (@_collection.queries || [])

      query: (rel)->
        for q in @_collection.queries || []
          return new Query q if q.rel == rel

      # TODO support multiple templates:
      # https://github.com/mamund/collection-json/blob/master/extensions/templates.md

      template: ->
        new Template @_collection.href, @_collection.template

      meta: (name)->
        @_collection.meta?[name]
)
