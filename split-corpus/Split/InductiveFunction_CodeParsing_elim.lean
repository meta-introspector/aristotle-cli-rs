import Mathlib

set_option pp.all true
-- spec: InductiveFunction.CodeParsing.elim : forall {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction), (Eq.{1} Nat (InductiveFunction.ctorIdx t) 1) -> (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.CodeParsing a._@._internal._hyg.0)) -> (motive t)
def InductiveFunction.CodeParsing.elim : forall {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction), (Eq.{1} Nat (InductiveFunction.ctorIdx t) 1) -> (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.CodeParsing a._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction) (h : Eq.{1} Nat (InductiveFunction.ctorIdx t) 1) (CodeParsing : forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.CodeParsing a._@._internal._hyg.0)) => InductiveFunction.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (InductiveFunction.ctorIdx t) 1 h) (PULift.up.{u, u} (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.CodeParsing a._@._internal._hyg.0)) CodeParsing)
