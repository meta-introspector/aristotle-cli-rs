import Mathlib

set_option pp.all true
-- spec: Std.Shrink : Type.{u} -> Type.{u}
def Std.Shrink : Type.{u} -> Type.{u} :=
  fun (α : Type.{u}) => Subtype.val.{succ (succ u)} (Type.{u} -> Type.{u}) (fun (f : Type.{u} -> Type.{u}) => Eq.{succ (succ u)} (Type.{u} -> Type.{u}) f (id.{succ (succ u)} Type.{u})) (_private.Init.Data.Iterators.Basic.0.Std.Internal.idOpaque.{succ (succ u)} Type.{u}) α
