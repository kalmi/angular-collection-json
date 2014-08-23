describe "[Recursive Templates](https://github.com/mustmodify/collection-json.rb#template-recursion-in-sequence)", ->
  beforeEach module('Collection')

  collection = data = errorData = null
  beforeEach inject (_cj_, cjRecursiveTemplate, $rootScope)->
    cj = _cj_
    data = cjRecursiveTemplate
    cj.parse(data).then((c) -> collection = c)
    $rootScope.$digest()

  it "reads templates recursively", ->
    template = collection.template()
    expect(template.data.sports.template.rugby).toEqual 'All Blacks'

  it "serializes using just name", ->
    template = collection.template()
    nested = template.parameters()
    expect(nested.rugby).toEqual 'All Blacks'

  it "serializes using parameter", ->
    template = collection.template()
    nested = template.parametersNested()
    expect(nested.quiz.sports.nfl).toEqual 'Saints'
