describe "[collection](http://amundsen.com/media-types/collection/format/#objects-collection)", ->
  cj = scope = collection = data = errorData = null

  beforeEach module('Collection')

  beforeEach inject (_cj_, $rootScope, cjOriginal, cjError)->
    cj = _cj_
    data = cjOriginal
    errorData = cjError
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()
    scope = $rootScope

  it "should have a version", ->
    expect(collection.version()).toEqual data.collection.version

  it "should have an href", ->
    expect(collection.href()).toEqual data.collection.href

  it "should throw an exception with a bad version number", ->
    error = null
    cj.parse(collection: version: "1.1").catch (e) -> error = e
    scope.$digest()
    expect(error).toBeDefined("No error was returned")

  it "should throw an exception with a malformed collection", ->
    error = null
    cj.parse(version: "1.1").catch (e) -> error = e
    scope.$digest()
    expect(error).toBeDefined("No error was returned")

  it "should throw an exception with a malformed json", ->
    error = null
    cj.parse('invalid json').catch (e) -> error = e
    scope.$digest()
    expect(error).toBeDefined("No error was returned")

  it "should throw an exception when empty", ->
    error = null
    cj.parse('').catch (e) -> error = e
    scope.$digest()
    expect(error).toBeDefined("No error was returned")

  describe "[error](http://amundsen.com/media-types/collection/format/#objects-error)", ->

    it "should have an error", ->
      errorCol = null
      cj.parse(errorData).catch (e) -> errorCol = e.collection
      scope.$digest()

      error = errorCol.error
      expect(error).toBeDefined "An error was not returned"
      expect(error.title).toEqual errorData.collection.error.title
      expect(error.code).toEqual errorData.collection.error.code
      expect(error.message).toEqual errorData.collection.error.message
