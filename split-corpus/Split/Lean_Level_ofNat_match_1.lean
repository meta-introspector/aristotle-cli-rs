import Mathlib

set_option pp.all true
-- spec: Lean.Level.ofNat.match_1 : forall (motive : Nat -> Sort.{u_1}) (x._@.Lean.Level.197636206._hygCtx.5.Lean.Level.197636206._hygCtx._hyg.16 : Nat), (Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) -> (forall (n : Nat), motive (Nat.succ n)) -> (motive x._@.Lean.Level.197636206._hygCtx.5.Lean.Level.197636206._hygCtx._hyg.16)
def Lean.Level.ofNat.match_1 : forall (motive : Nat -> Sort.{u_1}) (x._@.Lean.Level.197636206._hygCtx.5.Lean.Level.197636206._hygCtx._hyg.16 : Nat), (Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) -> (forall (n : Nat), motive (Nat.succ n)) -> (motive x._@.Lean.Level.197636206._hygCtx.5.Lean.Level.197636206._hygCtx._hyg.16) :=
  fun (motive : Nat -> Sort.{u_1}) (x._@.Lean.Level.197636206._hygCtx.5.Lean.Level.197636206._hygCtx._hyg.16 : Nat) (h_1 : Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) (h_2 : forall (n : Nat), motive (Nat.succ n)) => Nat.casesOn.{u_1} (fun (x : Nat) => motive x) x._@.Lean.Level.197636206._hygCtx.5.Lean.Level.197636206._hygCtx._hyg.16 (h_1 Unit.unit) (fun (n._@.Lean.Level.197636206._hygCtx._hyg.36 : Nat) => h_2 n._@.Lean.Level.197636206._hygCtx._hyg.36)
