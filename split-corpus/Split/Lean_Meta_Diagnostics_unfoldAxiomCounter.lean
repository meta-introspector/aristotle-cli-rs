import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Diagnostics.unfoldAxiomCounter : Lean.Meta.Diagnostics -> (Lean.PHashMap.{0, 0} Lean.Name Nat Lean.Name.instBEq Lean.instHashableName)
def Lean.Meta.Diagnostics.unfoldAxiomCounter : Lean.Meta.Diagnostics -> (Lean.PHashMap.{0, 0} Lean.Name Nat Lean.Name.instBEq Lean.instHashableName) :=
  fun (self : Lean.Meta.Diagnostics) => self.2
