import Mathlib

set_option pp.all true
-- spec: UInt64.decLt : forall (a : UInt64) (b : UInt64), Decidable (LT.lt.{0} UInt64 instLTUInt64 a b)
def UInt64.decLt : forall (a : UInt64) (b : UInt64), Decidable (LT.lt.{0} UInt64 instLTUInt64 a b) :=
  fun (a : UInt64) (b : UInt64) => UInt64.decLt._aux_1 a b
