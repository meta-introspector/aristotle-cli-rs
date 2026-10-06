import Mathlib

set_option pp.all true
-- spec: Lean.Options.getInPattern : Lean.Options -> Bool
def Lean.Options.getInPattern : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Name.mkStr1 "_inPattern") Bool.false
