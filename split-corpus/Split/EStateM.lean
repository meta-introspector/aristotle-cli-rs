import Mathlib

set_option pp.all true
-- spec: EStateM : Type.{u} -> Type.{u} -> Type.{u} -> Type.{u}
def EStateM : Type.{u} -> Type.{u} -> Type.{u} -> Type.{u} :=
  fun (ε : Type.{u}) (σ : Type.{u}) (α : Type.{u}) => σ -> (EStateM.Result.{u} ε σ α)
