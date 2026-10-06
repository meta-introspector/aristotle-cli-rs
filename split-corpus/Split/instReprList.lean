import Mathlib

set_option pp.all true
-- spec: instReprList : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.2696493749._hygCtx._hyg.5 : Repr.{u_1} α], Repr.{u_1} (List.{u_1} α)
def instReprList : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.2696493749._hygCtx._hyg.5 : Repr.{u_1} α], Repr.{u_1} (List.{u_1} α) :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Repr.2696493749._hygCtx._hyg.5 : Repr.{u_1} α] => Repr.mk.{u_1} (List.{u_1} α) (List.repr.{u_1} α inst._@.Init.Data.Repr.2696493749._hygCtx._hyg.5)
