import Mathlib

-- spec: constructor FloatSpec.mk : forall (float : Type), float -> (forall (lt : float -> float -> Prop) (le : float -> float -> Prop), (DecidableRel.{1, 1} float float lt) -> (DecidableRel.{1, 1} float float le) -> FloatSpec)
