import Mathlib

set_option pp.all true
-- spec: Lean.getPPTagAppFns : Lean.Options -> Bool
def Lean.getPPTagAppFns : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.tagAppFns) (Lean.getPPAll o)
