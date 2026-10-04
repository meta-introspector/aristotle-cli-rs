import Mathlib

set_option pp.all true
-- spec: Lean.BinderInfo.ctorIdx : Lean.BinderInfo -> Nat
def Lean.BinderInfo.ctorIdx : Lean.BinderInfo -> Nat :=
  fun (x : Lean.BinderInfo) => Lean.BinderInfo.casesOn.{1} (fun (x : Lean.BinderInfo) => Nat) x 0 1 2 3
