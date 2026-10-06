import Mathlib

set_option pp.all true
-- spec: Lean.getPPUniverses : Lean.Options -> Bool
def Lean.getPPUniverses : Lean.Options -> Bool :=
  fun (o : Lean.Options) => Lean.Options.get Bool Lean.KVMap.instValueBool o (Lean.Option.name Bool Lean.pp.universes) (Lean.getPPAll o)
