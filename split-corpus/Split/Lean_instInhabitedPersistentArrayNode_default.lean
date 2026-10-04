import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedPersistentArrayNode.default : forall {a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39 : Type.{u_1}}, Lean.PersistentArrayNode.{u_1} a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39
def Lean.instInhabitedPersistentArrayNode.default : forall {a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39 : Type.{u_1}}, Lean.PersistentArrayNode.{u_1} a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39 :=
  fun {a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39 : Type.{u_1}} => Lean.PersistentArrayNode.node.{u_1} a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39 (Inhabited.default.{succ u_1} (Array.{u_1} (Lean.PersistentArrayNode.{u_1} a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39)) (Array.instInhabited.{u_1} (Lean.PersistentArrayNode.{u_1} a._@.Lean.Data.PersistentArray.281732585._hygCtx._hyg.39)))
