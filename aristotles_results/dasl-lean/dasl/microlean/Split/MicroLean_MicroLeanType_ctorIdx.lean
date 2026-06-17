import Mathlib

set_option pp.all true
-- spec: MicroLean.MicroLeanType.ctorIdx : MicroLean.MicroLeanType -> Nat
def MicroLean.MicroLeanType.ctorIdx : MicroLean.MicroLeanType -> Nat :=
  fun (x : MicroLean.MicroLeanType) => MicroLean.MicroLeanType.casesOn.{1} (fun (x : MicroLean.MicroLeanType) => Nat) x 0 1 (fun (domain : MicroLean.MicroLeanType) (codomain : MicroLean.MicroLeanType) => 2) (fun (elem : MicroLean.MicroLeanType) => 3) (fun (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType) => 4)
