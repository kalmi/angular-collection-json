describe "[template options](https://github.com/mustmodify/collection-json.rb#options)", ->
  beforeEach module('Collection')

  cj = collection = template = data = errorData = null
  beforeEach inject (_cj_, cjExtended, $rootScope)->
    cj = _cj_
    data = cjExtended
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()
    template = collection.template()

  it "exposes options for a given field", ->
    expect(template.options.avatar).toEqual data.collection.template.data[3].options

  it "returns empty when no options exist for a field", ->
    expect(template.optionsFor 'email').toEqual []

  it "removes invalid options", ->
    options = template.optionsFor('color')
    expect(options[0].prompt).toEqual "White"
    expect(options.length).toEqual 1

  it "includes valid options", ->
    template.set 'avatar', 'rj'
    options = template.optionsFor('color')
    expect(options[1].prompt).toEqual "Red"
    expect(options.length).toEqual 2

  it "provides selected option", ->
    template.set 'color', 'white'
    option = template.selectedOptions.color
    expect(option.prompt).toEqual "White"

  it "allows setting of (single) selectedOption", ->
    template.set 'color', 'white'
    template.selectedOptions.color = template.options.color[1]
    option = template.selectedOptions.color
    expect(option.prompt).toEqual "Red"

  it "provides selected options when multiple", ->
    template.set 'color', ['white', 'red']
    options = template.selectedOptions.color
    expect(options[0].prompt).toEqual "White"
    expect(options[1].prompt).toEqual "Red"
