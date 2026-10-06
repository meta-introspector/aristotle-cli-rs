import Mathlib

set_option pp.all true
-- spec: Lean.Options.insert : Lean.Options -> Lean.Name -> Lean.DataValue -> Lean.Options
def Lean.Options.insert : Lean.Options -> Lean.Name -> Lean.DataValue -> Lean.Options :=
  fun (o : Lean.Options) (k : Lean.Name) (v : Lean.DataValue) => _private.Lean.Data.Options.0.Lean.Options.mk (Lean.NameMap.insert Lean.DataValue (_private.Lean.Data.Options.0.Lean.Options.map o) k v) (Bool.or (Lean.Options.hasTrace o) (Lean.Name.isPrefixOf (Lean.Name.mkStr1 "trace") k))
