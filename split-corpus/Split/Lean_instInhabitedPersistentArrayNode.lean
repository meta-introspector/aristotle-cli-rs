import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedPersistentArrayNode : forall {a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39 : Type.{u_1}}, Inhabited.{succ u_1} (Lean.PersistentArrayNode.{u_1} a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39)
def Lean.instInhabitedPersistentArrayNode : forall {a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39 : Type.{u_1}}, Inhabited.{succ u_1} (Lean.PersistentArrayNode.{u_1} a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39) :=
  fun {a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39 : Type.{u_1}} => Inhabited.mk.{succ u_1} (Lean.PersistentArrayNode.{u_1} a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39) (Lean.instInhabitedPersistentArrayNode.default.{u_1} a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39)
