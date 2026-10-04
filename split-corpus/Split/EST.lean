import Mathlib

set_option pp.all true
-- spec: EST : Type -> Type -> Type -> Type
def EST : Type -> Type -> Type -> Type :=
  fun (ε : Type) (σ : Type) (α : Type) => (Void σ) -> (EST.Out ε σ α)
