import Mathlib

set_option pp.all true
-- spec: Lean.KVMap.instValueDataValue : Lean.KVMap.Value Lean.DataValue
def Lean.KVMap.instValueDataValue : Lean.KVMap.Value Lean.DataValue :=
  Lean.KVMap.Value.mk Lean.DataValue (id.{1} Lean.DataValue) (Option.some.{0} Lean.DataValue)
