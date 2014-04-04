
http = require "../http"
client = require "../client"

Collection = require "./collection"

module.exports = class Link
  constructor: (@_link)->
    console.log @_link
    @href = @_link.href
    @rel = @_link.rel
    @prompt = @_link.prompt

  follow: (done=()->)->
    options = {}

    http.get @_link.href, options, (error, collection)->
      return done error if error
      client.parse collection, done
