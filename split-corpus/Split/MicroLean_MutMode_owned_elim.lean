import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.owned.elim : forall {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode), (Eq.{1} Nat (MicroLean.MutMode.ctorIdx t) 2) -> (motive MicroLean.MutMode.owned) -> (motive t)
def MicroLean.MutMode.owned.elim : forall {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode), (Eq.{1} Nat (MicroLean.MutMode.ctorIdx t) 2) -> (motive MicroLean.MutMode.owned) -> (motive t) :=
  fun {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode) (h : Eq.{1} Nat (MicroLean.MutMode.ctorIdx t) 2) (owned : motive MicroLean.MutMode.owned) => MicroLean.MutMode.ctorElim.{u} motive 2 t (Eq.symm.{1} Nat (MicroLean.MutMode.ctorIdx t) 2 h) (PULift.up.{u, u} (motive MicroLean.MutMode.owned) owned)
