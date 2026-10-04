import Mathlib

set_option pp.all true
-- spec: ExceptT : Type.{u} -> (Type.{u} -> Type.{v}) -> Type.{u} -> Type.{v}
def ExceptT : Type.{u} -> (Type.{u} -> Type.{v}) -> Type.{u} -> Type.{v} :=
  fun (ε : Type.{u}) (m : Type.{u} -> Type.{v}) (α : Type.{u}) => m (Except.{u, u} ε α)
