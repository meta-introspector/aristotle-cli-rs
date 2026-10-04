import Mathlib

set_option pp.all true
-- spec: Lean.NameGenerator.curr : Lean.NameGenerator -> Lean.Name
def Lean.NameGenerator.curr : Lean.NameGenerator -> Lean.Name :=
  fun (g : Lean.NameGenerator) => Lean.Name.mkNum (Lean.NameGenerator.namePrefix g) (Lean.NameGenerator.idx g)
