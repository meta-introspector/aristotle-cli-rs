import Mathlib

set_option pp.all true
-- spec: Lean.Name.lt : Lean.Name -> Lean.Name -> Bool
def Lean.Name.lt : Lean.Name -> Lean.Name -> Bool :=
  fun (x : Lean.Name) (y : Lean.Name) => BEq.beq.{0} Ordering (instBEqOfDecidableEq.{0} Ordering instDecidableEqOrdering) (Lean.Name.cmp x y) Ordering.lt
