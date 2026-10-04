import Mathlib

-- spec: recursor Fin.rec : forall {n : Nat} {motive : (Fin n) -> Sort.{u}}, (forall (val : Nat) (isLt : LT.lt.{0} Nat instLTNat val n), motive (Fin.mk n val isLt)) -> (forall (t : Fin n), motive t)
