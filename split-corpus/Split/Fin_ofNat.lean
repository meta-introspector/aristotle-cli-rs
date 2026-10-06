import Mathlib

set_option pp.all true
-- spec: Fin.ofNat : forall (n : Nat) [inst._@.Init.Data.Fin.Basic.197636206._hygCtx._hyg.4 : NeZero.{0} Nat (Zero.ofOfNat0.{0} Nat (instOfNatNat 0)) n], Nat -> (Fin n)
def Fin.ofNat : forall (n : Nat) [inst._@.Init.Data.Fin.Basic.197636206._hygCtx._hyg.4 : NeZero.{0} Nat (Zero.ofOfNat0.{0} Nat (instOfNatNat 0)) n], Nat -> (Fin n) :=
  fun (n : Nat) [inst._@.Init.Data.Fin.Basic.197636206._hygCtx._hyg.4 : NeZero.{0} Nat (Zero.ofOfNat0.{0} Nat (instOfNatNat 0)) n] (a : Nat) => Fin.mk n (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) a n) (Fin.ofNat._proof_1 n inst._@.Init.Data.Fin.Basic.197636206._hygCtx._hyg.4 a)
