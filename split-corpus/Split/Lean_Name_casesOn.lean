import Mathlib

set_option pp.all true
-- spec: Lean.Name.casesOn : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (motive Lean.Name.anonymous) -> (forall (pre : Lean.Name) (str : String), motive (Lean.Name.str pre str)) -> (forall (pre : Lean.Name) (i : Nat), motive (Lean.Name.num pre i)) -> (motive t)
def Lean.Name.casesOn : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (motive Lean.Name.anonymous) -> (forall (pre : Lean.Name) (str : String), motive (Lean.Name.str pre str)) -> (forall (pre : Lean.Name) (i : Nat), motive (Lean.Name.num pre i)) -> (motive t) :=
  fun {motive : Lean.Name -> Sort.{u}} (t : Lean.Name) (anonymous : motive Lean.Name.anonymous) (str : forall (pre : Lean.Name) (str : String), motive (Lean.Name.str pre str)) (num : forall (pre : Lean.Name) (i : Nat), motive (Lean.Name.num pre i)) => Lean.Name.rec.{u} motive anonymous (fun (pre : Lean.Name) (str_1 : String) (pre_ih : motive pre) => str pre str_1) (fun (pre : Lean.Name) (i : Nat) (pre_ih : motive pre) => num pre i) t
