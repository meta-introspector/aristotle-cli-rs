import Mathlib

set_option pp.all true
-- spec: Id : Type.{u} -> Type.{u}
def Id : Type.{u} -> Type.{u} :=
  fun (type : Type.{u}) => type
