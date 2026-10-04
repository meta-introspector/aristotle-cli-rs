import Mathlib

set_option pp.all true
-- spec: Unit.unit : Unit
def Unit.unit : Unit :=
  PUnit.unit.{1}
