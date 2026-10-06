import Mathlib

set_option pp.all true
-- spec: UInt32.decLt : forall (a : UInt32) (b : UInt32), Decidable (LT.lt.{0} UInt32 instLTUInt32 a b)
def UInt32.decLt : forall (a : UInt32) (b : UInt32), Decidable (LT.lt.{0} UInt32 instLTUInt32 a b) :=
  fun (a : UInt32) (b : UInt32) => UInt32.decLt._aux_1 a b
