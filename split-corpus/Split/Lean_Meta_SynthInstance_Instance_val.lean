import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.Instance.val : Lean.Meta.SynthInstance.Instance -> Lean.Expr
def Lean.Meta.SynthInstance.Instance.val : Lean.Meta.SynthInstance.Instance -> Lean.Expr :=
  fun (self : Lean.Meta.SynthInstance.Instance) => self.1
