describe "[template validation](https://github.com/mustmodify/collection-json.rb#template-validation)", ->
  beforeEach module('Collection')

  cj = collection = template = data = errorData = null
  beforeEach inject (_cj_, cjExtended, $rootScope)->
    cj = _cj_
    data = cjExtended
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()
    template = collection.template()


  it "is invalid when data is invalid", ->
    expect(template.valid()).toBeFalsy()

  it "is valid when data is invalid", ->
    template.set 'blog', 'cool'
    template.set 'email', 'foo@example.com'
    expect(template.valid()).toBeTruthy()

  describe "datum", ->
    describe "no validations", ->
      it "is valid", ->
        expect(template.datum('full-name').valid()).toBeTruthy()

    describe "required", ->
      datum = null
      beforeEach -> datum = template.datum('blog')

      it "is invalid when undefined", ->
        template.set 'blog', undefined
        expect(datum.valid()).toBeFalsy()
        expect(datum.validationErrors.required).toBe true

      it "is invalid when empty", ->
        template.set 'blog', ''
        expect(datum.valid()).toBeFalsy()
        expect(datum.validationErrors.required).toBe true

      it "is valid when not empty", ->
        template.set 'blog', 'hello'
        expect(datum.valid()).toBeTruthy()
        expect(datum.validationErrors.required).toBeFalsy()

    describe "regexp", ->
      datum = null
      beforeEach -> datum = template.datum('email')

      it "is valid when undefined", ->
        template.set 'email', undefined
        expect(datum.valid()).toBeTruthy()

      it "is valid when empty", ->
        template.set 'email', ''
        expect(datum.valid()).toBeTruthy()

      it "is valid when matching", ->
        template.set 'email', 'foo@example.com'
        expect(datum.valid()).toBeTruthy()
        expect(datum.validationErrors.regexp).toBeFalsy()

      it "is invalid when not matching", ->
        template.set 'email', 'nomatch'
        expect(datum.valid()).toBeFalsy()
        expect(datum.validationErrors.regexp).toBe true
