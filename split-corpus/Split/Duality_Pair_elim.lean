import Mathlib

set_option pp.all true
-- spec: Duality.Pair.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 7) -> (forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something), motive (Duality.Pair a._@._internal._hyg.0 a_1._@._internal._hyg.0)) -> (motive t)
def Duality.Pair.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 7) -> (forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something), motive (Duality.Pair a._@._internal._hyg.0 a_1._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : Duality -> Sort.{u}} (t : Duality) (h : Eq.{1} Nat (Duality.ctorIdx t) 7) (Pair : forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something), motive (Duality.Pair a._@._internal._hyg.0 a_1._@._internal._hyg.0)) => Duality.ctorElim.{u} motive 7 t (Eq.symm.{1} Nat (Duality.ctorIdx t) 7 h) (PULift.up.{u, u} (forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something), motive (Duality.Pair a._@._internal._hyg.0 a_1._@._internal._hyg.0)) Pair)
