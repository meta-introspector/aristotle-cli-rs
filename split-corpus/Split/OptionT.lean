import Mathlib

set_option pp.all true
-- spec: OptionT : (Type.{u} -> Type.{v}) -> Type.{u} -> Type.{v}
def OptionT : (Type.{u} -> Type.{v}) -> Type.{u} -> Type.{v} :=
  fun (m : Type.{u} -> Type.{v}) (α : Type.{u}) => m (Option.{u} α)
