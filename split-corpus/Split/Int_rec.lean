import Mathlib

-- spec: recursor Int.rec : forall {motive : Int -> Sort.{u}}, (forall (a._@._internal._hyg.0 : Nat), motive (Int.ofNat a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : Nat), motive (Int.negSucc a._@._internal._hyg.0)) -> (forall (t : Int), motive t)
