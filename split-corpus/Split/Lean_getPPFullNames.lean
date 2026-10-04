import Mathlib

set_option pp.all true
-- spec: Lean.getPPFullNames : Lean.Options -> Bool
def Lean.getPPFullNames : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.fullNames) (Lean.getPPAll o)
