import Mathlib

set_option pp.all true
-- spec: Lean.Level.instOfNat : forall (n : Nat), OfNat.{0} Lean.Level n
def Lean.Level.instOfNat : forall (n : Nat), OfNat.{0} Lean.Level n :=
  fun (n : Nat) => OfNat.mk.{0} Lean.Level n (Lean.Level.ofNat n)
