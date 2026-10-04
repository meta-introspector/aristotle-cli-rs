import Mathlib

set_option pp.all true
-- spec: instReprTrinity : Repr.{0} Trinity
def instReprTrinity : Repr.{0} Trinity :=
  Repr.mk.{0} Trinity instReprTrinity.repr
