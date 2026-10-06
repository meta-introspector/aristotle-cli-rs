import Mathlib

set_option pp.all true
-- spec: Lean.getPPMVarsLevels : Lean.Options -> Bool
def Lean.getPPMVarsLevels : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.mvars.levels) (Bool.and (Lean.Option.defValue Bool Lean.pp.mvars.levels) (Lean.getPPMVarsAnonymous o))
