import Mathlib

set_option pp.all true
-- spec: Pi.instInhabited : forall {α : Sort.{u}} {β : α -> Sort.{v}} [inst._@.Init.Prelude.4037808124._hygCtx._hyg.6 : forall (a : α), Inhabited.{v} (β a)], Inhabited.{imax u v} (forall (a : α), β a)
def Pi.instInhabited : forall {α : Sort.{u}} {β : α -> Sort.{v}} [inst._@.Init.Prelude.4037808124._hygCtx._hyg.6 : forall (a : α), Inhabited.{v} (β a)], Inhabited.{imax u v} (forall (a : α), β a) :=
  fun {α : Sort.{u}} {β : α -> Sort.{v}} [inst._@.Init.Prelude.4037808124._hygCtx._hyg.6 : forall (a : α), Inhabited.{v} (β a)] => Inhabited.mk.{imax u v} (forall (a : α), β a) (fun (x._@.Init.Prelude.4037808124._hygCtx._hyg.26 : α) => Inhabited.default.{v} (β x._@.Init.Prelude.4037808124._hygCtx._hyg.26) (inst._@.Init.Prelude.4037808124._hygCtx._hyg.6 x._@.Init.Prelude.4037808124._hygCtx._hyg.26))
