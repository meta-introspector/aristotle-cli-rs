import Mathlib

set_option pp.all true
-- spec: Lean.SimpleScopedEnvExtension : Type -> Type -> Type
def Lean.SimpleScopedEnvExtension : Type -> Type -> Type :=
  fun (α : Type) (σ : Type) => Lean.ScopedEnvExtension α α σ
