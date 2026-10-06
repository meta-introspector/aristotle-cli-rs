import Mathlib

set_option pp.all true
-- spec: MicroLean.MicroLeanType.prod.elim : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 4) -> (forall (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.prod fst snd)) -> (motive t)
def MicroLean.MicroLeanType.prod.elim : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 4) -> (forall (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.prod fst snd)) -> (motive t) :=
  fun {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType) (h : Eq.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 4) (prod : forall (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.prod fst snd)) => MicroLean.MicroLeanType.ctorElim.{u} motive 4 t (Eq.symm.{1} Nat (MicroLean.MicroLeanType.ctorIdx t) 4 h) (PULift.up.{u, u} (forall (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.prod fst snd)) prod)
