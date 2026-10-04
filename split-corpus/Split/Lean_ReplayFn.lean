import Mathlib

set_option pp.all true
-- spec: Lean.ReplayFn : Type -> Type
def Lean.ReplayFn : Type -> Type :=
  fun (σ : Type) => σ -> σ -> (List.{0} Lean.Name) -> σ -> σ
