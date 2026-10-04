import Mathlib

set_option pp.all true
-- spec: Lean.getPPMVars : Lean.Options -> Bool
def Lean.getPPMVars : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.mvars) (Lean.Option.defValue Bool Lean.pp.mvars)
