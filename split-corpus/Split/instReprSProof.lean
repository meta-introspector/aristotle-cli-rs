import Mathlib

set_option pp.all true
-- spec: instReprSProof : Repr.{0} SProof
def instReprSProof : Repr.{0} SProof :=
  Repr.mk.{0} SProof instReprSProof.repr
