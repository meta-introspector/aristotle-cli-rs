import Mathlib

set_option pp.all true
-- spec: Lean.getPPParens : Lean.Options -> Bool
def Lean.getPPParens : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.parens) (Lean.Option.defValue Bool Lean.pp.parens)
