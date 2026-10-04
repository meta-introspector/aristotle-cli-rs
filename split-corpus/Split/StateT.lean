import Mathlib

set_option pp.all true
-- spec: StateT : Type.{u} -> (Type.{u} -> Type.{v}) -> Type.{u} -> Type.{max u v}
def StateT : Type.{u} -> (Type.{u} -> Type.{v}) -> Type.{u} -> Type.{max u v} :=
  fun (σ : Type.{u}) (m : Type.{u} -> Type.{v}) (α : Type.{u}) => σ -> (m (Prod.{u, u} α σ))
