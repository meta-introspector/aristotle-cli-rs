import Mathlib

set_option pp.all true
-- spec: Lean.getPPAnalyzeKnowsType : Lean.Options -> Bool
def Lean.getPPAnalyzeKnowsType : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.analyze.knowsType) (Lean.Option.defValue Bool Lean.pp.analyze.knowsType)
