import Mathlib

set_option pp.all true
-- spec: instReprProdOfReprTuple : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Init.Data.Repr.1024841849._hygCtx._hyg.11 : Repr.{u_1} α] [inst._@.Init.Data.Repr.1024841849._hygCtx._hyg.14 : ReprTuple.{u_2} β], Repr.{max u_2 u_1} (Prod.{u_1, u_2} α β)
def instReprProdOfReprTuple : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Init.Data.Repr.1024841849._hygCtx._hyg.11 : Repr.{u_1} α] [inst._@.Init.Data.Repr.1024841849._hygCtx._hyg.14 : ReprTuple.{u_2} β], Repr.{max u_2 u_1} (Prod.{u_1, u_2} α β) :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Init.Data.Repr.1024841849._hygCtx._hyg.11 : Repr.{u_1} α] [inst._@.Init.Data.Repr.1024841849._hygCtx._hyg.14 : ReprTuple.{u_2} β] => Repr.mk.{max u_1 u_2} (Prod.{u_1, u_2} α β) (Prod.repr.{u_1, u_2} α β inst._@.Init.Data.Repr.1024841849._hygCtx._hyg.11 inst._@.Init.Data.Repr.1024841849._hygCtx._hyg.14)
