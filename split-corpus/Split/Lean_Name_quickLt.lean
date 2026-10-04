import Mathlib

set_option pp.all true
-- spec: Lean.Name.quickLt : Lean.Name -> Lean.Name -> Bool
def Lean.Name.quickLt : Lean.Name -> Lean.Name -> Bool :=
  fun (n₁ : Lean.Name) (n₂ : Lean.Name) => BEq.beq.{0} Ordering (instBEqOfDecidableEq.{0} Ordering instDecidableEqOrdering) (Lean.Name.quickCmp n₁ n₂) Ordering.lt
