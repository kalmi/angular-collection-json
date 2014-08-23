describe "[collection](http://amundsen.com/media-types/collection/format/#objects-collection)", ->
  cj = scope = collection = data = errorData = null

  beforeEach module('Collection')

  beforeEach inject (_cj_, $rootScope, cjEmbedded)->
    cj = _cj_
    data = cjEmbedded
    cj.parse(data).then(
      (c) -> collection = c
      (e) -> throw e
    )
    $rootScope.$digest()
    scope = $rootScope

  it 'uses embedded collections when following root links', ->
    result = null
    collection.link('root_actors').follow().then (c) -> result = c
    scope.$digest()
    expect(result.href()).toEqual data.collection.embedded[0].collection.href

  it 'uses embedded collections when following item links', ->
    result = null
    collection.items()[0].link('actors').follow().then (c) -> result = c
    scope.$digest()
    expect(result.href()).toEqual data.collection.embedded[0].collection.href
