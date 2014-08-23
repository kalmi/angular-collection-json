describe "[queries](http://amundsen.com/media-types/collection/format/#arrays-queries)", ->
  cj = collection = data = null

  beforeEach module('Collection')

  beforeEach inject (_cj_, $rootScope, cjOriginal)->
    cj = _cj_
    data = cjOriginal
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()

  it "should iterate queries", ->
    for query in collection.queries()
      orig = _.find data.collection.queries, (q)-> q.rel is query.rel()
      expect(query.href()).toEqual orig.href
      expect(query.rel()).toEqual orig.rel
      expect(query.prompt()).toEqual orig.prompt

  it "should be able to set values", ->
    searchQuery = collection.query "search"
    searchQuery.set "search", "Testing"
    expect(searchQuery.get("search")).toEqual "Testing"

  it "should get a query by rel", ->
    for orig in data.collection.queries
      searchQuery = collection.query orig.rel
      expect(searchQuery.href()).toEqual orig.href
      expect(searchQuery.rel()).toEqual orig.rel
      expect(searchQuery.prompt()).toEqual orig.prompt
