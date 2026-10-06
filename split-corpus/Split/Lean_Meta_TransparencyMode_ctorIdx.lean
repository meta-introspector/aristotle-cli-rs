import Mathlib

set_option pp.all true
-- spec: Lean.Meta.TransparencyMode.ctorIdx : Lean.Meta.TransparencyMode -> Nat
def Lean.Meta.TransparencyMode.ctorIdx : Lean.Meta.TransparencyMode -> Nat :=
  fun (x : Lean.Meta.TransparencyMode) => Lean.Meta.TransparencyMode.casesOn.{1} (fun (x : Lean.Meta.TransparencyMode) => Nat) x 0 1 2 3 4
