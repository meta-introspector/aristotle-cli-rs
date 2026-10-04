import Mathlib

set_option pp.all true
-- spec: Dynamic : Type
def Dynamic : Type :=
  NonemptyType.type.{0} _private.Init.Dynamic.0.DynamicPointed
