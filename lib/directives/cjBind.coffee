angular.module('Collection').directive 'cjBind', ->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, el, attr, ctrl) ->
    datumName = attr.cjBind
    expr = "#{attr.ngModel}.get('#{datumName}')"
    scope.$watch expr, (val, old) ->
      if ctrl.$viewValue != val
        ctrl.$viewValue = val
        ctrl.$render()

    ctrl.$parsers.push (val) ->
      ctrl.$modelValue.set datumName, val
      ctrl.$modelValue

