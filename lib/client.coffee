angular.module('Collection', []).provider 'cj', ->
  urlTransform = angular.identity
  strictVersion = true

  setUrlTransform: (transform) -> urlTransform = transform
  setStrictVersion: (strict) -> strictVersion = strict

  $get: (Collection, $http, $q) ->
    client = (href, options) ->
      config = angular.extend {url: urlTransform(href)}, options
      console.log config.url, config.params
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
      if angular.isString source
        try
          source = JSON.parse source
        catch e
          return $q.reject e

      if strictVersion && source.collection?.version isnt "1.0"
        return $q.reject new Error "Collection does not conform to Collection+JSON 1.0 Spec"

      collectionObj = new Collection source.collection

      if collectionObj.error
        e = new Error('Parsed collection contains errors')
        e.collection = collectionObj
        $q.reject e
      else
        $q.when collectionObj

    client
