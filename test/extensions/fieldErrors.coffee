describe "[field specific errors](https://github.com/mustmodify/collection-json.rb#field-specific-errors)", ->
  beforeEach module('Collection')

  cj = collection = data = errorData = null
  beforeEach inject (_cj_, cjExtended, $rootScope)->
    cj = _cj_
    data = cjExtended
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()

  template = null
  beforeEach -> template = collection.template()

  it "exposes errors for a given field", ->
    expect(template.errorsFor 'full-name').toEqual data.collection.template.data[0].errors
    expect(template.errors['full-name']).toEqual data.collection.template.data[0].errors

  it "returns empty when no errors exist for a field", ->
    expect(template.errorsFor 'email').toEqual []

