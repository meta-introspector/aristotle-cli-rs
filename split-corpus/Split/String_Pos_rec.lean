import Mathlib

-- spec: recursor String.Pos.rec : forall {s : String} {motive : (String.Pos s) -> Sort.{u}}, (forall (offset : String.Pos.Raw) (isValid : String.Pos.Raw.IsValid s offset), motive (String.Pos.mk s offset isValid)) -> (forall (t : String.Pos s), motive t)
