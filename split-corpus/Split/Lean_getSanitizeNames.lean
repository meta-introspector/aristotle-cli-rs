import Mathlib

set_option pp.all true
-- spec: Lean.getSanitizeNames : Lean.Options -> Bool
def Lean.getSanitizeNames : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Option.get Bool Lean.KVMap.instValueBool o Lean.pp.sanitizeNames
