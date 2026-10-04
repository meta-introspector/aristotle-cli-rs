import Mathlib

set_option pp.all true
-- spec: Lean.getPPInstantiateMVars : Lean.Options -> Bool
def Lean.getPPInstantiateMVars : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.instantiateMVars) (Lean.Option.defValue Bool Lean.pp.instantiateMVars)
