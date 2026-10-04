import Mathlib

set_option pp.all true
-- spec: instReprDuality : Repr.{0} Duality
def instReprDuality : Repr.{0} Duality :=
  Repr.mk.{0} Duality instReprDuality.repr
