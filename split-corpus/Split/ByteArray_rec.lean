import Mathlib

-- spec: recursor ByteArray.rec : forall {motive : ByteArray -> Sort.{u}}, (forall (data : Array.{0} UInt8), motive (ByteArray.mk data)) -> (forall (t : ByteArray), motive t)
