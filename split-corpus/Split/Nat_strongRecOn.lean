import Mathlib

set_option pp.all true
-- spec: Nat.strongRecOn : forall {motive : Nat -> Sort.{u}} (n : Nat), (forall (n : Nat), (forall (m : Nat), (LT.lt.{0} Nat instLTNat m n) -> (motive m)) -> (motive n)) -> (motive n)
def Nat.strongRecOn : forall {motive : Nat -> Sort.{u}} (n : Nat), (forall (n : Nat), (forall (m : Nat), (LT.lt.{0} Nat instLTNat m n) -> (motive m)) -> (motive n)) -> (motive n) :=
  fun {motive : Nat -> Sort.{u}} (n : Nat) (ind : forall (n : Nat), (forall (m : Nat), (LT.lt.{0} Nat instLTNat m n) -> (motive m)) -> (motive n)) => WellFounded.fix.{1, u} Nat motive (WellFoundedRelation.rel.{1} Nat Nat.lt_wfRel) (WellFoundedRelation.wf.{1} Nat Nat.lt_wfRel) ind n
