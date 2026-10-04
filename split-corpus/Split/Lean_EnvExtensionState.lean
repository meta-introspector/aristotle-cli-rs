import Mathlib

set_option pp.all true
-- spec: Lean.EnvExtensionState : Type
def Lean.EnvExtensionState : Type :=
  Sigma.fst.{1, 0} Type (fun (α : Type) => Inhabited.{1} α) Lean.EnvExtensionStateSpec
