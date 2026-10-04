import Mathlib

set_option pp.all true
-- spec: Lean.getPPMVarsAnonymous : Lean.Options -> Bool
def Lean.getPPMVarsAnonymous : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.mvars.anonymous) (Bool.and (Lean.Option.defValue Bool Lean.pp.mvars.anonymous) (Lean.getPPMVars o))
