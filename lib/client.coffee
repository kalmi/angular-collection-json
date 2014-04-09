
angular.module('Collection', []).factory('cj', (Collection, $http, $q)->
  ret = (href, options, done)->
    if typeof options is 'function'
      done = options
      options = {}

    $http.get(href, options).then(
      (res) -> ret.parse(res.data)
    )

  # Expose parse
  ret.parse = (source)->
    deferred = $q.defer()
    try
      collectionObj = new Collection source
      deferred.resolve collectionObj
    catch e
      deferred.reject e

    #error = null
    #if _error = collectionObj.error
      #error = new Error
      #error.title = _error.title
      #error.message = _error.message
      #error.code = _error.code
      #error.body = JSON.stringify source

    deferred.promise

  return ret

)
