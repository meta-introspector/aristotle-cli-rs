import Mathlib

set_option pp.all true
-- spec: Int.casesOn : forall {motive : Int -> Sort.{u}} (t : Int), (forall (a._@._internal._hyg.0 : Nat), motive (Int.ofNat a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : Nat), motive (Int.negSucc a._@._internal._hyg.0)) -> (motive t)
def Int.casesOn : forall {motive : Int -> Sort.{u}} (t : Int), (forall (a._@._internal._hyg.0 : Nat), motive (Int.ofNat a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : Nat), motive (Int.negSucc a._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : Int -> Sort.{u}} (t : Int) (ofNat : forall (a._@._internal._hyg.0 : Nat), motive (Int.ofNat a._@._internal._hyg.0)) (negSucc : forall (a._@._internal._hyg.0 : Nat), motive (Int.negSucc a._@._internal._hyg.0)) => Int.rec.{u} motive (fun (a._@._internal._hyg.0 : Nat) => ofNat a._@._internal._hyg.0) (fun (a._@._internal._hyg.0 : Nat) => negSucc a._@._internal._hyg.0) t
