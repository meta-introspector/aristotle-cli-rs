import Mathlib

set_option pp.all true
-- spec: Fin.val : forall {n : Nat}, (Fin n) -> Nat
def Fin.val : forall {n : Nat}, (Fin n) -> Nat :=
  fun (n : Nat) (self : Fin n) => self.1
