import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.mutBorrow.elim : forall {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode), (Eq.{1} Nat (MicroLean.MutMode.ctorIdx t) 1) -> (motive MicroLean.MutMode.mutBorrow) -> (motive t)
def MicroLean.MutMode.mutBorrow.elim : forall {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode), (Eq.{1} Nat (MicroLean.MutMode.ctorIdx t) 1) -> (motive MicroLean.MutMode.mutBorrow) -> (motive t) :=
  fun {motive : MicroLean.MutMode -> Sort.{u}} (t : MicroLean.MutMode) (h : Eq.{1} Nat (MicroLean.MutMode.ctorIdx t) 1) (mutBorrow : motive MicroLean.MutMode.mutBorrow) => MicroLean.MutMode.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (MicroLean.MutMode.ctorIdx t) 1 h) (PULift.up.{u, u} (motive MicroLean.MutMode.mutBorrow) mutBorrow)
