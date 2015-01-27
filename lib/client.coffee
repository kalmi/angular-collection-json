angular.module('Collection', []).provider 'cj', ->
  urlTransform = angular.identity
  strictVersion = true
  strictTemplate = false;

  setUrlTransform: (transform) -> urlTransform = transform
  setStrictVersion: (strict) -> strictVersion = strict
  setStrictTemplate: (template) -> strictTemplate = template

  $get: (Collection, $http, $q) ->
    client = (href, options) ->
      config = angular.extend {url: urlTransform(href)}, options
      $http(config).then(
        (res) -> client.parse res.data
        (res) ->
          client.parse(res.data).then (collection) ->
            e = new Error 'request failed'
            e.response = res
            e.collection = collection
            $q.reject e
      )

    client.parse = (source) ->

      if !source
        return $q.reject new Error 'source is empty'

      if angular.isString source
        try
          source = JSON.parse source
        catch e
          return $q.reject e

      if !angular.isObject source.collection
        return $q.reject new Error "Source 'collection' is not an object"

      if strictVersion && source.collection?.version isnt "1.0"
        return $q.reject new Error "Collection does not conform to Collection+JSON 1.0 Spec"

      collectionObj = new Collection source.collection, { strictTemplate: strictTemplate }

      if collectionObj.error
        e = new Error('Parsed collection contains errors')
        e.collection = collectionObj
        $q.reject e
      else
        $q.when collectionObj

    client
