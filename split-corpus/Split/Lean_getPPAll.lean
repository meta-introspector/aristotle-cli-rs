import Mathlib

set_option pp.all true
-- spec: Lean.getPPAll : Lean.Options -> Bool
def Lean.getPPAll : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.all) Bool.false
