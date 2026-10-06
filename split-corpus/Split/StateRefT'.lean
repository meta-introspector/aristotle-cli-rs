import Mathlib

set_option pp.all true
-- spec: StateRefT' : Type -> Type -> (Type -> Type) -> Type -> Type
def StateRefT' : Type -> Type -> (Type -> Type) -> Type -> Type :=
  fun (ω : Type) (σ : Type) (m : Type -> Type) (α : Type) => ReaderT.{0, 0} (ST.Ref ω σ) m α
