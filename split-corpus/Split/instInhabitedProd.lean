import Mathlib

set_option pp.all true
-- spec: instInhabitedProd : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Init.Core.2721033736._hygCtx._hyg.15 : Inhabited.{succ u_1} α] [inst._@.Init.Core.2721033736._hygCtx._hyg.18 : Inhabited.{succ u_2} β], Inhabited.{max (succ u_2) (succ u_1)} (Prod.{u_1, u_2} α β)
def instInhabitedProd : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Init.Core.2721033736._hygCtx._hyg.15 : Inhabited.{succ u_1} α] [inst._@.Init.Core.2721033736._hygCtx._hyg.18 : Inhabited.{succ u_2} β], Inhabited.{max (succ u_2) (succ u_1)} (Prod.{u_1, u_2} α β) :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Init.Core.2721033736._hygCtx._hyg.15 : Inhabited.{succ u_1} α] [inst._@.Init.Core.2721033736._hygCtx._hyg.18 : Inhabited.{succ u_2} β] => Inhabited.mk.{max (succ u_2) (succ u_1)} (Prod.{u_1, u_2} α β) (Prod.mk.{u_1, u_2} α β (Inhabited.default.{succ u_1} α inst._@.Init.Core.2721033736._hygCtx._hyg.15) (Inhabited.default.{succ u_2} β inst._@.Init.Core.2721033736._hygCtx._hyg.18))
