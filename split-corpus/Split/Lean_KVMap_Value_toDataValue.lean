import Mathlib

set_option pp.all true
-- spec: Lean.KVMap.Value.toDataValue : forall {α : Type} [self : Lean.KVMap.Value α], α -> Lean.DataValue
def Lean.KVMap.Value.toDataValue : forall {α : Type} [self : Lean.KVMap.Value α], α -> Lean.DataValue :=
  fun (α : Type) [self : Lean.KVMap.Value α] => self.1
