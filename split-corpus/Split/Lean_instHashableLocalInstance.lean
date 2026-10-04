import Mathlib

set_option pp.all true
-- spec: Lean.instHashableLocalInstance : Hashable.{1} Lean.LocalInstance
def Lean.instHashableLocalInstance : Hashable.{1} Lean.LocalInstance :=
  Hashable.mk.{1} Lean.LocalInstance (fun (i : Lean.LocalInstance) => Hashable.hash.{1} Lean.Expr Lean.Expr.instHashable (Lean.LocalInstance.fvar i))
