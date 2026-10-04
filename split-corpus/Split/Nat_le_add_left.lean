import Mathlib

-- spec: theorem Nat.le_add_left : forall (n : Nat) (m : Nat), LE.le.{0} Nat instLENat n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n)
theorem Nat.le_add_left : forall (n : Nat) (m : Nat), LE.le.{0} Nat instLENat n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n) :=
  fun (n : Nat) (m : Nat) => Eq.rec.{0, 1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m) (fun (x._@.Init.Data.Nat.Basic.3284585893._hygCtx._hyg.18 : Nat) (h._@.Init.Data.Nat.Basic.3284585893._hygCtx._hyg.19 : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m) x._@.Init.Data.Nat.Basic.3284585893._hygCtx._hyg.18) => LE.le.{0} Nat instLENat n x._@.Init.Data.Nat.Basic.3284585893._hygCtx._hyg.18) (Nat.le_add_right n m) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n) (Nat.add_comm n m)
