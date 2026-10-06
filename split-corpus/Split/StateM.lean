import Mathlib

set_option pp.all true
-- spec: StateM : Type.{u} -> Type.{u} -> Type.{u}
def StateM : Type.{u} -> Type.{u} -> Type.{u} :=
  fun (σ : Type.{u}) (α : Type.{u}) => StateT.{u, u} σ Id.{u} α
