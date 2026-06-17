import Mathlib

set_option pp.all true
-- spec: MicroLean.MicroLeanType.array.elim : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 3) -> (forall (elem : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.array elem)) -> (motive t)
def MicroLean.MicroLeanType.array.elim : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 3) -> (forall (elem : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.array elem)) -> (motive t) :=
  fun {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType) (h : Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 3) (array : forall (elem : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.array elem)) => MicroLean.MicroLeanType.ctorElim.{u} motive 3 t (Eq.symm.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 3 h) (PULift.up.{u, u} (forall (elem : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.array elem)) array)
