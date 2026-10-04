import Mathlib

set_option pp.all true
-- spec: Nat.instMod : Mod.{0} Nat
def Nat.instMod : Mod.{0} Nat :=
  Mod.mk.{0} Nat Nat.mod
