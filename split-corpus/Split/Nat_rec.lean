import Mathlib

-- spec: recursor Nat.rec : forall {motive : Nat -> Sort.{u}}, (motive Nat.zero) -> (forall (n : Nat), (motive n) -> (motive (Nat.succ n))) -> (forall (t : Nat), motive t)
