  describe "[items](http://amundsen.com/media-types/collection/format/#arrays-items)", ->
    cj = collection = data = null

    beforeEach module('Collection')

    beforeEach inject (_cj_, $rootScope, cjOriginal)->
      cj = _cj_
      data = cjOriginal
      cj.parse(data).then((c) -> collection = c)
      $rootScope.$digest()

    it "should iterate items", ->
      for idx, item of collection.items()
        orig = data.collection.items[idx]
        expect(item.href()).toEqual orig.href

    it "should get a value", ->
      for idx, item of collection.items()
        orig = data.collection.items[idx]
        for datum in orig.data
          itemDatum = item.get(datum.name)
          expect(itemDatum).toBeDefined "Item does not have #{datum.name}"
          expect(itemDatum).toEqual datum.value

    it "should get links", ->
      for orig in data.collection.items
        item = collection.item(orig.href)
        for origLink in orig.links
          link = item.link origLink.rel
          expect(link.href()).toEqual origLink.href

    it "creates templates from item data", ->
      for orig in data.collection.items
        item = collection.item(orig.href)
        template = item.edit()
        expect(template.get 'full-name').toEqual orig.data[0].value
        expect(template.href()).toEqual item.href()

    it "creates an array of templates from all items", ->
      templates = collection.templateAll()
      templates.forEach (template, idx) ->
        item = data.collection.items[idx]
        expect(template.get 'full-name').toEqual item.data[0].value
        expect(template.href()).toEqual item.href

    it "returns undefined if no template", ->
      delete data.collection.template
      for orig in data.collection.items
        item = collection.item(orig.href)
        expect(item.edit()).toBeUndefined()
