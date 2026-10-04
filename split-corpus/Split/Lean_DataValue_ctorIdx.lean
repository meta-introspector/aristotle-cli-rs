import Mathlib

set_option pp.all true
-- spec: Lean.DataValue.ctorIdx : Lean.DataValue -> Nat
def Lean.DataValue.ctorIdx : Lean.DataValue -> Nat :=
  fun (x : Lean.DataValue) => Lean.DataValue.casesOn.{1} (fun (x : Lean.DataValue) => Nat) x (fun (v : String) => 0) (fun (v : Bool) => 1) (fun (v : Lean.Name) => 2) (fun (v : Nat) => 3) (fun (v : Int) => 4) (fun (v : Lean.Syntax) => 5)
