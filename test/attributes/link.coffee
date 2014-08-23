describe "[links](http://amundsen.com/media-types/collection/format/#arrays-links)", ->
  cj = collection = data = null

  beforeEach module('Collection')

  beforeEach inject (_cj_, $rootScope, cjOriginal)->
    cj = _cj_
    data = cjOriginal
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()

  it "should get iterate the links", ->
    for link in collection.links()
      orig = _.find data.collection.links, (_link)-> _link.rel == link.rel()
      expect(link.href()).toEqual orig.href
      expect(link.rel()).toEqual orig.rel
      expect(link.prompt()).toEqual orig.prompt
      expect(link.name()).toEqual orig.name

  it "should get a link by rel", ->
    for orig in data.collection.links
      link = collection.link(orig.rel)
      expect(link.href()).toEqual orig.href
      expect(link.rel()).toEqual orig.rel
      expect(link.prompt()).toEqual orig.prompt
