
_ = require "../underscore"
http = require "../http"

module.exports = class Collection
  constructor: (collection)->
    # Lets verify that it's a valid collection
    if collection?.collection?.version isnt "1.0"
      throw new Error "Collection does not conform to Collection+JSON 1.0 Spec"

    @_collection = collection.collection
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

    @_links = links = []
    Link = require "./link"

    _.each @_collection.links, (link)->
      links.push new Link link
    @_links

  link: (rel)->
    console.log @links()
    _.find @links(), (link)-> link.rel() is rel

  items: ->
    return @_items if @_items

    @_items = items = []
    Item = require "./item"

    _.each @_collection.items, (item)->
      items.push new Item item
    @_items

  item: (href)->
    _.find @items, (item)-> item.href is href

  queries: ->
    queries = []
    Query = require "./query"

    _.each @_collection.queries||[], (query)->
      queries.push new Query query
    queries

  query: (rel)->
    query = _.find @_collection.queries||[], (query)->
      query.rel is rel
    return null if not query

    Query = require "./query"
    # Don't cache it since we allow you to set parameters and submit it
    new Query query

  # TODO support multiple templates:
  # https://github.com/mamund/collection-json/blob/master/extensions/templates.md

  template: (name)->
    Template = require "./template"
    new Template @_collection.href, @_collection.template
