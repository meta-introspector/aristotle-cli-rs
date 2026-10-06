import Mathlib

set_option pp.all true
-- spec: Lean.PArray : Type.{u} -> Type.{u}
def Lean.PArray : Type.{u} -> Type.{u} :=
  fun (α : Type.{u}) => Lean.PersistentArray.{u} α
