import Mathlib

set_option pp.all true
-- spec: Nat.casesAuxOn : forall {motive : Nat -> Sort.{u}} (t : Nat), (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (forall (n : Nat), motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> (motive t)
def Nat.casesAuxOn : forall {motive : Nat -> Sort.{u}} (t : Nat), (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (forall (n : Nat), motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> (motive t) :=
  fun {motive : Nat -> Sort.{u}} (t : Nat) (zero : motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (succ : forall (n : Nat), motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) => Nat.casesOn.{u} (fun (x._@.Init.Data.Nat.Basic.3474555824._hygCtx._hyg.22 : Nat) => motive x._@.Init.Data.Nat.Basic.3474555824._hygCtx._hyg.22) t zero succ
