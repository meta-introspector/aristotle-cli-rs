import Mathlib

set_option pp.all true
-- spec: Lean.SimplePersistentEnvExtension : Type -> Type -> Type
def Lean.SimplePersistentEnvExtension : Type -> Type -> Type :=
  fun (α : Type) (σ : Type) => Lean.PersistentEnvExtension α α (Prod.{0, 0} (List.{0} α) σ)
