import Mathlib

-- spec: theorem Nat.min_eq_right : forall {a : Nat} {b : Nat}, (LE.le.{0} Nat instLENat b a) -> (Eq.{1} Nat (Min.min.{0} Nat instMinNat a b) b)
theorem Nat.min_eq_right : forall {a : Nat} {b : Nat}, (LE.le.{0} Nat instLENat b a) -> (Eq.{1} Nat (Min.min.{0} Nat instMinNat a b) b) :=
  fun {a : Nat} {b : Nat} (h : LE.le.{0} Nat instLENat b a) => Eq.rec.{0, 1} Nat (Min.min.{0} Nat instMinNat b a) (fun (x._@.Init.Data.Nat.MinMax.239560948._hygCtx._hyg.20 : Nat) (h._@.Init.Data.Nat.MinMax.239560948._hygCtx._hyg.21 : Eq.{1} Nat (Min.min.{0} Nat instMinNat b a) x._@.Init.Data.Nat.MinMax.239560948._hygCtx._hyg.20) => Eq.{1} Nat x._@.Init.Data.Nat.MinMax.239560948._hygCtx._hyg.20 b) (Nat.min_eq_left b a h) (Min.min.{0} Nat instMinNat a b) (Nat.min_comm b a)
