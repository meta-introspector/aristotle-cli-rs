import Mathlib

-- spec: theorem Nat.add_le_add_iff_right : forall {m : Nat} {k : Nat} {n : Nat}, Iff (LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k n)) (LE.le.{0} Nat instLENat m k)
theorem Nat.add_le_add_iff_right : forall {m : Nat} {k : Nat} {n : Nat}, Iff (LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k n)) (LE.le.{0} Nat instLENat m k) :=
  fun {m : Nat} {k : Nat} {n : Nat} => Iff.intro (LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k n)) (LE.le.{0} Nat instLENat m k) (Nat.le_of_add_le_add_right m n k) (fun (h : LE.le.{0} Nat instLENat m k) => Nat.add_le_add_right m k h n)
