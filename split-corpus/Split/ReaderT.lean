import Mathlib

set_option pp.all true
-- spec: ReaderT : Type.{u} -> (Type.{u} -> Type.{v}) -> Type.{u} -> Type.{max u v}
def ReaderT : Type.{u} -> (Type.{u} -> Type.{v}) -> Type.{u} -> Type.{max u v} :=
  fun (ρ : Type.{u}) (m : Type.{u} -> Type.{v}) (α : Type.{u}) => ρ -> (m α)
