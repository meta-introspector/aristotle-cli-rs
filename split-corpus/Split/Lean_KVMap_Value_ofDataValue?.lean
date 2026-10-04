import Mathlib

set_option pp.all true
-- spec: Lean.KVMap.Value.ofDataValue? : forall {α : Type} [self : Lean.KVMap.Value α], Lean.DataValue -> (Option.{0} α)
def Lean.KVMap.Value.ofDataValue? : forall {α : Type} [self : Lean.KVMap.Value α], Lean.DataValue -> (Option.{0} α) :=
  fun (α : Type) [self : Lean.KVMap.Value α] => self.2
