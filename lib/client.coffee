
angular.module('Collection', []).factory 'cj', (Collection, $http, $q)->
  ret = (href, options)->
    config = _.extend {url: href}, options
    $http(config).then(
      (res) -> ret.parse res.data
      (res) ->
        ret.parse(res.data).then (collection) ->
          e = new Error 'request failed'
          e.response = res
          e.collection = collection
          $q.reject e
    )

  ret.parse = (source)->
    if _.isString source
      try
        source = JSON.parse source
      catch e
        return $q.reject e

    if source.collection?.version isnt "1.0"
      return $q.reject new Error "Collection does not conform to Collection+JSON 1.0 Spec"

    collectionObj = new Collection source.collection

    if collectionObj.error
      e = new Error('Parsed collection contains errors')
      e.collection = collectionObj
      $q.reject e
    else
      $q.when collectionObj

  return ret
