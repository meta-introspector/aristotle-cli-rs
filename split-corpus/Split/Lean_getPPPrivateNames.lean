import Mathlib

set_option pp.all true
-- spec: Lean.getPPPrivateNames : Lean.Options -> Bool
def Lean.getPPPrivateNames : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.privateNames) (Lean.getPPAll o)
