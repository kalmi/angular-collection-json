angular.module('Collection').directive 'cjBind', (nameFormatter) ->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, el, attr, ctrl) ->
    datumName = attr.cjBind
    bracketedName = nameFormatter.bracketed datumName
    expr = "#{attr.ngModel}.get('#{datumName}')"

    el.attr('name', bracketedName) unless attr.name
    el.attr('id', "#{scope.$id}-#{bracketedName}") unless attr.id

    scope.$watch expr, (val, old) ->
      if ctrl.$viewValue != val
        ctrl.$viewValue = val
        ctrl.$render()

    ctrl.$parsers.push (val) ->
      ctrl.$modelValue.set datumName, val
      ctrl.$modelValue

