import Mathlib

set_option pp.all true
-- spec: Lean.getPPBeta : Lean.Options -> Bool
def Lean.getPPBeta : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.beta) (Lean.Option.defValue Bool Lean.pp.beta)
