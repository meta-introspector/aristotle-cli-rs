import Mathlib

-- spec: recursor String.Pos.Raw.rec : forall {motive : String.Pos.Raw -> Sort.{u}}, (forall (byteIdx : Nat), motive (String.Pos.Raw.mk byteIdx)) -> (forall (t : String.Pos.Raw), motive t)
