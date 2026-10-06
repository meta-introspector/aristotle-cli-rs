import Mathlib

set_option pp.all true
-- spec: Lean.Name.below : forall {motive : Lean.Name -> Sort.{u}}, Lean.Name -> Sort.{max 1 u}
def Lean.Name.below : forall {motive : Lean.Name -> Sort.{u}}, Lean.Name -> Sort.{max 1 u} :=
  fun {motive : Lean.Name -> Sort.{u}} (t : Lean.Name) => Lean.Name.rec.{succ (max 1 u)} (fun (t : Lean.Name) => Sort.{max 1 u}) PUnit.{max 1 u} (fun (pre : Lean.Name) (str : String) (pre_ih : Sort.{max 1 u}) => PProd.{u, max 1 u} (motive pre) pre_ih) (fun (pre : Lean.Name) (i : Nat) (pre_ih : Sort.{max 1 u}) => PProd.{u, max 1 u} (motive pre) pre_ih) t
