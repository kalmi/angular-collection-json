describe "[template parameters](https://github.com/mustmodify/collection-json.rb#parameter)", ->
  beforeEach module('Collection')

  cj = collection = template = data = errorData = null
  beforeEach inject (_cj_, cjExtended, $rootScope)->
    cj = _cj_
    data = cjExtended
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()
    template = collection.template()

  it "serializes using 'parameter' on template", ->
    template.dish = 'icecream'
    nested = template.parametersNested()
    expect(nested.food.favorite).toEqual 'icecream'
    form = template.parameters()
    expect(form['food[favorite]']).toEqual 'icecream'

  it "falls back to 'name' when no parameter specified", ->
    template.color = 'red'
    nested = template.parametersNested()
    expect(nested.color).toEqual 'red'
    form = template.form(true)
    expect(form['color']).toEqual 'red'
