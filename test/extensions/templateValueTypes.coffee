describe "[template value types](https://github.com/mustmodify/collection-json.rb#value-types)", ->
  beforeEach module('Collection')

  cj = collection = template = data = errorData = null
  beforeEach inject (_cj_, cjExtended, $rootScope)->
    cj = _cj_
    data = cjExtended
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()
    template = collection.template()

    it "exposes value type for a given field", ->
      expect(template.data.email.valueType).toEqual data.collection.template.data[1].value_type
