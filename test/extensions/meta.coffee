describe "[meta](https://github.com/mustmodify/collection-json.rb#meta)", ->
  beforeEach module('Collection')

  cj = collection = data = errorData = null
  beforeEach inject (_cj_, cjExtended, $rootScope)->
    cj = _cj_
    data = cjExtended
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()


  it "reads from meta", ->
    for name, val of data.collection.meta
      expect(collection.meta(name)).toEqual val

  it "returns undefined if meta not specified", ->
    delete collection._collection.meta
    expect(collection.meta(name)).toBeUndefined()
