import Mathlib

set_option pp.all true
-- spec: InductiveFunction.SelfReferencing.elim : forall {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction), (Eq.{1} Nat (InductiveFunction.ctorIdx t) 2) -> (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.SelfReferencing a._@._internal._hyg.0)) -> (motive t)
def InductiveFunction.SelfReferencing.elim : forall {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction), (Eq.{1} Nat (InductiveFunction.ctorIdx t) 2) -> (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.SelfReferencing a._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction) (h : Eq.{1} Nat (InductiveFunction.ctorIdx t) 2) (SelfReferencing : forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.SelfReferencing a._@._internal._hyg.0)) => InductiveFunction.ctorElim.{u} motive 2 t (Eq.symm.{1} Nat (InductiveFunction.ctorIdx t) 2 h) (PULift.up.{u, u} (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.SelfReferencing a._@._internal._hyg.0)) SelfReferencing)
