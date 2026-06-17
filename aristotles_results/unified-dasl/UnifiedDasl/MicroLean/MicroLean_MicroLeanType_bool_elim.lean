import Mathlib

set_option pp.all true
-- spec: MicroLean.MicroLeanType.bool.elim : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 1) -> (motive MicroLean.MicroLeanType.bool) -> (motive t)
def MicroLean.MicroLeanType.bool.elim : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 1) -> (motive MicroLean.MicroLeanType.bool) -> (motive t) :=
  fun {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType) (h : Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 1) (bool : motive MicroLean.MicroLeanType.bool) => MicroLean.MicroLeanType.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 1 h) (PULift.up.{u, u} (motive MicroLean.MicroLeanType.bool) bool)
