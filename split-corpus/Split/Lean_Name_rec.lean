import Mathlib

-- spec: recursor Lean.Name.rec : forall {motive : Lean.Name -> Sort.{u}}, (motive Lean.Name.anonymous) -> (forall (pre : Lean.Name) (str : String), (motive pre) -> (motive (Lean.Name.str pre str))) -> (forall (pre : Lean.Name) (i : Nat), (motive pre) -> (motive (Lean.Name.num pre i))) -> (forall (t : Lean.Name), motive t)
