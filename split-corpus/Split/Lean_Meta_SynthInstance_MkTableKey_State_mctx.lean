import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.MkTableKey.State.mctx : Lean.Meta.SynthInstance.MkTableKey.State -> Lean.MetavarContext
def Lean.Meta.SynthInstance.MkTableKey.State.mctx : Lean.Meta.SynthInstance.MkTableKey.State -> Lean.MetavarContext :=
  fun (self : Lean.Meta.SynthInstance.MkTableKey.State) => self.4
