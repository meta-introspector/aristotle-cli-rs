import Mathlib

set_option pp.all true
-- spec: Lean.ModuleIdx.toNat : Lean.ModuleIdx -> Nat
def Lean.ModuleIdx.toNat : Lean.ModuleIdx -> Nat :=
  fun (midx : Lean.ModuleIdx) => midx
