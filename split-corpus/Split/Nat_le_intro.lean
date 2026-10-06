import Mathlib

-- spec: theorem Nat.le.intro : forall {n : Nat} {m : Nat} {k : Nat}, (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k) m) -> (LE.le.{0} Nat instLENat n m)
theorem Nat.le.intro : forall {n : Nat} {m : Nat} {k : Nat}, (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k) m) -> (LE.le.{0} Nat instLENat n m) :=
  fun {n : Nat} {m : Nat} {k : Nat} (h : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k) m) => Eq.rec.{0, 1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k) (fun (x._@.Init.Data.Nat.Basic.45524837._hygCtx._hyg.22 : Nat) (h._@.Init.Data.Nat.Basic.45524837._hygCtx._hyg.23 : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k) x._@.Init.Data.Nat.Basic.45524837._hygCtx._hyg.22) => LE.le.{0} Nat instLENat n x._@.Init.Data.Nat.Basic.45524837._hygCtx._hyg.22) (Nat.le_add_right n k) m h
