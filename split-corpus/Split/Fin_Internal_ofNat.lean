import Mathlib

set_option pp.all true
-- spec: Fin.Internal.ofNat : forall (n : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) -> Nat -> (Fin n)
def Fin.Internal.ofNat : forall (n : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) -> Nat -> (Fin n) :=
  fun (n : Nat) (hn : LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) (a : Nat) => Fin.mk n (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) a n) (Nat.mod_lt a n hn)
