
http = require "../http"

Collection = require "./collection"

module.exports = class Link
  constructor: (@_link)->

  href: ()->
    @_link.href

  follow: (done=()->)->
    options = {}

    http.get @_link.href, options, (error, collection)->
      done error if error
      done null, new Collection collection
