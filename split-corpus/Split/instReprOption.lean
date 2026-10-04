import Mathlib

set_option pp.all true
-- spec: instReprOption : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.2560694933._hygCtx._hyg.5 : Repr.{u_1} α], Repr.{u_1} (Option.{u_1} α)
def instReprOption : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.2560694933._hygCtx._hyg.5 : Repr.{u_1} α], Repr.{u_1} (Option.{u_1} α) :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Repr.2560694933._hygCtx._hyg.5 : Repr.{u_1} α] => Repr.mk.{u_1} (Option.{u_1} α) (Option.repr.{u_1} α inst._@.Init.Data.Repr.2560694933._hygCtx._hyg.5)
