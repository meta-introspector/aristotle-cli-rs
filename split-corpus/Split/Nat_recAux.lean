import Mathlib

set_option pp.all true
-- spec: Nat.recAux : forall {motive : Nat -> Sort.{u}}, (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (forall (n : Nat), (motive n) -> (motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))) -> (forall (t : Nat), motive t)
def Nat.recAux : forall {motive : Nat -> Sort.{u}}, (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (forall (n : Nat), (motive n) -> (motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))) -> (forall (t : Nat), motive t) :=
  fun {motive : Nat -> Sort.{u}} (zero : motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (succ : forall (n : Nat), (motive n) -> (motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))) (t : Nat) => Nat.rec.{u} (fun (x._@.Init.Data.Nat.Basic.1611949876._hygCtx._hyg.25 : Nat) => motive x._@.Init.Data.Nat.Basic.1611949876._hygCtx._hyg.25) zero succ t
