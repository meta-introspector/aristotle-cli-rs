import Mathlib

set_option pp.all true
-- spec: Lean.getDiag : Lean.Options -> Bool
def Lean.getDiag : Lean.Options -> Bool :=
  fun (opts : Lean.Options) => Lean.Option.get Bool Lean.KVMap.instValueBool opts Lean.diagnostics
