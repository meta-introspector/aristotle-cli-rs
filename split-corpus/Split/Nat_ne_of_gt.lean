import Mathlib

-- spec: theorem Nat.ne_of_gt : forall {a : Nat} {b : Nat}, (LT.lt.{0} Nat instLTNat b a) -> (Ne.{1} Nat a b)
theorem Nat.ne_of_gt : forall {a : Nat} {b : Nat}, (LT.lt.{0} Nat instLTNat b a) -> (Ne.{1} Nat a b) :=
  fun {a : Nat} {b : Nat} (h : LT.lt.{0} Nat instLTNat b a) => Ne.symm.{1} Nat b a (Nat.ne_of_lt b a h)
