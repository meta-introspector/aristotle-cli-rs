import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.borrowed.elim : forall {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode), (Eq.{1} Nat (MicroLean.MutMode.ctorIdx t) 0) -> (motive MicroLean.MutMode.borrowed) -> (motive t)
def MicroLean.MutMode.borrowed.elim : forall {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode), (Eq.{1} Nat (MicroLean.MutMode.ctorIdx t) 0) -> (motive MicroLean.MutMode.borrowed) -> (motive t) :=
  fun {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode) (h : Eq.{1} Nat (MicroLean.MutMode.ctorIdx t) 0) (borrowed : motive MicroLean.MutMode.borrowed) => MicroLean.MutMode.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (MicroLean.MutMode.ctorIdx t) 0 h) (PULift.up.{u, u} (motive MicroLean.MutMode.borrowed) borrowed)
