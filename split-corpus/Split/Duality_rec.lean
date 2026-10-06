import Mathlib

-- spec: recursor Duality.rec : forall {motive : Duality -> Sort.{u}}, (motive Duality.Two) -> (motive Duality.Bit) -> (motive Duality.Binary) -> (motive Duality.Symmetry) -> (motive Duality.BitIsBinary) -> (motive Duality.Boolean) -> (forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something), motive (Duality.Product a._@._internal._hyg.0 a_1._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something), motive (Duality.Pair a._@._internal._hyg.0 a_1._@._internal._hyg.0)) -> (forall (t : Duality), motive t)
