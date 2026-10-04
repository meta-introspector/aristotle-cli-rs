import Mathlib

set_option pp.all true
-- spec: Lean.instBEqLocalInstance : BEq.{0} Lean.LocalInstance
def Lean.instBEqLocalInstance : BEq.{0} Lean.LocalInstance :=
  BEq.mk.{0} Lean.LocalInstance (fun (i₁ : Lean.LocalInstance) (i₂ : Lean.LocalInstance) => BEq.beq.{0} Lean.Expr Lean.Expr.instBEq (Lean.LocalInstance.fvar i₁) (Lean.LocalInstance.fvar i₂))
