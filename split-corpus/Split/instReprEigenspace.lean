import Mathlib

set_option pp.all true
-- spec: instReprEigenspace : Repr.{0} Eigenspace
def instReprEigenspace : Repr.{0} Eigenspace :=
  Repr.mk.{0} Eigenspace instReprEigenspace.repr
