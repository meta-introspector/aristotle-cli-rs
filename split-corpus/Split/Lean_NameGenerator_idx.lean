import Mathlib

set_option pp.all true
-- spec: Lean.NameGenerator.idx : Lean.NameGenerator -> Nat
def Lean.NameGenerator.idx : Lean.NameGenerator -> Nat :=
  fun (self : Lean.NameGenerator) => self.2
