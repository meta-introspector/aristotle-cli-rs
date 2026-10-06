import Mathlib

-- spec: constructor Nat.le.below.step : forall {n : Nat} {motive : forall (a._@._internal._hyg.0 : Nat), (Nat.le n a._@._internal._hyg.0) -> Prop} {m : Nat} (a._@._internal._hyg.0 : Nat.le n m), (Nat.le.below n motive m a._@._internal._hyg.0) -> (motive m a._@._internal._hyg.0) -> (Nat.le.below n motive (Nat.succ m) (Nat.le.step n m a._@._internal._hyg.0))
