import Mathlib

set_option pp.all true
-- spec: MicroLean.MicroLeanType.nat.elim : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 0) -> (motive MicroLean.MicroLeanType.nat) -> (motive t)
def MicroLean.MicroLeanType.nat.elim : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 0) -> (motive MicroLean.MicroLeanType.nat) -> (motive t) :=
  fun {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType) (h : Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 0) (nat : motive MicroLean.MicroLeanType.nat) => MicroLean.MicroLeanType.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 0 h) (PULift.up.{u, u} (motive MicroLean.MicroLeanType.nat) nat)
