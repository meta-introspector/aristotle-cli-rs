import Mathlib

set_option pp.all true
-- spec: Lean.SMap.findD : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.4 : BEq.{u} α] [inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.7 : Hashable.{succ u} α], (Lean.SMap.{u, v} α β inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.4 inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.7) -> α -> β -> β
def Lean.SMap.findD : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.4 : BEq.{u} α] [inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.7 : Hashable.{succ u} α], (Lean.SMap.{u, v} α β inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.4 inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.7) -> α -> β -> β :=
  fun {α : Type.{u}} {β : Type.{v}} [inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.4 : BEq.{u} α] [inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.7 : Hashable.{succ u} α] (m : Lean.SMap.{u, v} α β inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.4 inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.7) (a : α) (b₀ : β) => Option.getD.{v} β (Lean.SMap.find?.{u, v} α β inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.4 inst._@.Lean.Data.SMap.1264785090._hygCtx._hyg.7 m a) b₀
