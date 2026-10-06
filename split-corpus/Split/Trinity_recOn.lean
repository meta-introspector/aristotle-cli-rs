import Mathlib

set_option pp.all true
-- spec: Trinity.recOn : forall {motive : Trinity -> Sort.{u}} (t : Trinity), (motive Trinity.Three) -> (forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something) (a_2._@._internal._hyg.0 : Something), motive (Trinity.DisjointUnion a._@._internal._hyg.0 a_1._@._internal._hyg.0 a_2._@._internal._hyg.0)) -> (motive t)
def Trinity.recOn : forall {motive : Trinity -> Sort.{u}} (t : Trinity), (motive Trinity.Three) -> (forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something) (a_2._@._internal._hyg.0 : Something), motive (Trinity.DisjointUnion a._@._internal._hyg.0 a_1._@._internal._hyg.0 a_2._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : Trinity -> Sort.{u}} (t : Trinity) (Three : motive Trinity.Three) (DisjointUnion : forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something) (a_2._@._internal._hyg.0 : Something), motive (Trinity.DisjointUnion a._@._internal._hyg.0 a_1._@._internal._hyg.0 a_2._@._internal._hyg.0)) => Trinity.rec.{u} motive Three DisjointUnion t
