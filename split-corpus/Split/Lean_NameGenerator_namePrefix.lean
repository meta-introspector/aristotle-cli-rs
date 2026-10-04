import Mathlib

set_option pp.all true
-- spec: Lean.NameGenerator.namePrefix : Lean.NameGenerator -> Lean.Name
def Lean.NameGenerator.namePrefix : Lean.NameGenerator -> Lean.Name :=
  fun (self : Lean.NameGenerator) => self.1
