import Mathlib

set_option pp.all true
-- spec: ST : Type -> Type -> Type
def ST : Type -> Type -> Type :=
  fun (σ : Type) (α : Type) => (Void σ) -> (ST.Out σ α)
