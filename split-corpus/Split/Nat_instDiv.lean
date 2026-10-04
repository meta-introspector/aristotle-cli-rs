import Mathlib

set_option pp.all true
-- spec: Nat.instDiv : Div.{0} Nat
def Nat.instDiv : Div.{0} Nat :=
  Div.mk.{0} Nat Nat.div
