describe "Attributes", ->
  cj = scope = null
  beforeEach module('Collection')

  beforeEach inject (_cj_, $rootScope)->
    cj = _cj_
    scope = $rootScope.$new()

  describe "[Original](http://amundsen.com/media-types/collection/)", ->

    collection = data = errorData = null
    beforeEach inject (cjOriginal, cjError)->
      data = cjOriginal
      errorData = cjError
      cj.parse(data).then((c) -> collection = c)
      scope.$digest()

    describe "[collection](http://amundsen.com/media-types/collection/format/#objects-collection)", ->

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


    describe "[template](http://amundsen.com/media-types/collection/format/#objects-template)", ->

      it "should iterate properties template", ->
        template = collection.template()
        for key, value of template.form
          orig = _.find data.collection.template.data, (datum)-> datum.name is key
          expect(key).toEqual orig.name
          expect(value).toEqual orig.value
          expect(template.promptFor(key)).toEqual orig.prompt

      it "should be able to set values", ->
        newItem = collection.template()
        name = "Joe Test"
        email = "test@test.com"
        blog = "joe.blogger.com"
        avatar = "http://www.gravatar.com/avatar/dafd213c94afdd64f9dc4fa92f9710ea?s=512"

        newItem.set "full-name", name
        newItem.set "email", email
        newItem.set "blog", blog
        newItem.set "avatar", avatar

        expect(newItem.get("full-name")).toEqual name
        expect(newItem.get("email")).toEqual email
        expect(newItem.get("blog")).toEqual blog
        expect(newItem.get("avatar")).toEqual avatar

      it "should return a datum given a name", ->
        newItem = collection.template()
        fullName = newItem.datum("full-name")
        expect(fullName.name).toEqual "full-name"
        expect(fullName.prompt).toEqual "Full Name"
        expect(fullName.value).toEqual "Joe"

    describe "[items](http://amundsen.com/media-types/collection/format/#arrays-items)", ->

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

    describe "[queries](http://amundsen.com/media-types/collection/format/#arrays-queries)", ->

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

    describe "[links](http://amundsen.com/media-types/collection/format/#arrays-links)", ->

      it "should get iterate the links", ->
        for link in collection.links
          orig = _.find data.collection.links, (_link)-> _link.rel is link.rel
          expect(link.href).toEqual orig.href
          expect(link.rel).toEqual orig.rel
          expect(link.prompt).toEqual orig.prompt

      it "should get a link by rel", ->
        for orig in data.collection.links
          link = collection.link(orig.rel)
          expect(link.href()).toEqual orig.href
          expect(link.rel()).toEqual orig.rel
          expect(link.prompt()).toEqual orig.prompt


  describe "HTTP Requests", ->

    scope = $httpBackend = data = errorData = null
    cjUrl = "http://example.com/collection.json"
    cjErrorUrl = "http://example.com/error.json"


    beforeEach inject (_$httpBackend_, cjOriginal, cjError) ->
      data = cjOriginal
      errorData = cjError
      $httpBackend = _$httpBackend_
      $httpBackend.whenGET(cjUrl).respond data
      $httpBackend.whenGET(cjErrorUrl).respond 401, errorData

    it "should parse", ->
      result = null
      cj(cjUrl).then (collection) -> result = collection
      $httpBackend.flush()
      expect(result.version()).toEqual data.collection.version

    it "should invoke error callback on failure", ->
      result = null
      cj(cjErrorUrl).catch (error) -> result = error
      $httpBackend.flush()
      expect(result.collection.version()).toEqual data.collection.version

    it "should follow links with new collections", ->
      result = null
      cj(cjUrl).then (collection) -> result = collection
      $httpBackend.flush()
      for orig in data.collection.links
        link = result.link orig.rel
        $httpBackend.whenGET(link.href()).respond data
        link.follow().then (collection) ->
          expect(collection.version()).toEqual data.collection.version
      $httpBackend.flush()

    it "should respond to query requests with new collections", ->
      result = null
      cj(cjUrl).then (collection) -> result = collection
      $httpBackend.flush()
      for orig in data.collection.queries
        query = result.query orig.rel
        $httpBackend.whenGET(new RegExp(query.href())).respond data
        query.submit().then (collection) ->
          expect(collection.version()).toEqual data.collection.version
      $httpBackend.flush()

    it "should respond to template submissions with new collections", ->
      result = null
      cj(cjUrl).then (collection) -> result = collection
      $httpBackend.flush()
      template = result.template()
      $httpBackend.whenPOST(template.href, template.form).respond data
      template.submit().then (collection) ->
        expect(collection.version()).toEqual data.collection.version
      $httpBackend.flush()

    it "should load items with new collections", ->
      result = null
      cj(cjUrl).then (collection) -> result = collection
      $httpBackend.flush()
      for orig in data.collection.items
        item = result.item orig.href
        $httpBackend.whenGET(item.href()).respond data
        item.load().then (collection) ->
          expect(collection.version()).toEqual data.collection.version
      $httpBackend.flush()

    it "should delete items with new collections", ->
      result = null
      cj(cjUrl).then (collection) -> result = collection
      $httpBackend.flush()
      for orig in data.collection.items
        item = result.item orig.href
        $httpBackend.whenDELETE(item.href()).respond data
        item.remove().then (collection) ->
          expect(collection.version()).toEqual data.collection.version
      $httpBackend.flush()

  describe "[Extensions](https://github.com/mustmodify/collection-json.rb#forked-changes)", ->
    collection = data = errorData = null
    beforeEach inject (cjExtended)->
      data = cjExtended
      cj.parse(data).then((c) -> collection = c)
      scope.$digest()

    describe "[meta](https://github.com/mustmodify/collection-json.rb#meta)", ->

      it "reads from meta", ->
        for name, val of data.collection.meta
          expect(collection.meta(name)).toEqual val

      it "returns undefined if meta not specified", ->
        delete collection._collection.meta
        expect(collection.meta(name)).toBeUndefined()


    describe "[errors](https://github.com/mamund/collection-json/blob/master/extensions/errors.md)", ->
      xit "need tests"
    describe "[inline](https://github.com/mamund/collection-json/blob/master/extensions/inline.md)", ->
      xit "need tests"
    describe "[model](https://github.com/mamund/collection-json/blob/master/extensions/model.md)", ->
      xit "need tests"
    describe "[template-validation](https://github.com/mamund/collection-json/blob/master/extensions/template-validation.md)", ->
      xit "need tests"
    describe "[templates](https://github.com/mamund/collection-json/blob/master/extensions/templates.md)", ->
      xit "need tests"
    describe "[uri-templates](https://github.com/mamund/collection-json/blob/master/extensions/uri-templates.md)", ->
      xit "need tests"
    describe "[value-types](https://github.com/mamund/collection-json/blob/master/extensions/value-types.md)", ->
      xit "need tests"
