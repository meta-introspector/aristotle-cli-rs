import Mathlib

-- spec: theorem Fin.isLt : forall {n : Nat} (self : Fin n), LT.lt.{0} Nat instLTNat (Fin.val n self) n
theorem Fin.isLt : forall {n : Nat} (self : Fin n), LT.lt.{0} Nat instLTNat (Fin.val n self) n :=
  fun (n : Nat) (self : Fin n) => self.2
