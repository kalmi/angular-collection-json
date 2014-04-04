
_ = require "../underscore"
http = require "../http"
client = require "../client"

Collection = require "./collection"

module.exports = class Query
  constructor: (@_query, @form={})->
    _query = @_query
    _form = @form

    @href = @_query.href
    @rel = @_query.rel
    @prompt = @_query.prompt

    _.each _query.data, (datum)->
      _form[datum.name] = datum.value if not _form[datum.name]?

  datum: (key)->
    datum = _.find @_query.data or [], (datum)-> datum.name is key
    _.clone datum

  get: (key)->
    @form[key]

  set: (key, value)->
    @form[key] = value

  promptFor: (key)->
    @datum(key)?.prompt

  submit: (done=()->)->
    options =
      qs: @form

    http.get @_query.href, options, (error, collection)->
      return done error if error
      client.parse collection, done
