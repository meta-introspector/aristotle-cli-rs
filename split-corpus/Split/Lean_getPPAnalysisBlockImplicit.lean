import Mathlib

set_option pp.all true
-- spec: Lean.getPPAnalysisBlockImplicit : Lean.Options -> Bool
def Lean.getPPAnalysisBlockImplicit : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Name.mkStr3 "pp" "analysis" "blockImplicit") Bool.false
