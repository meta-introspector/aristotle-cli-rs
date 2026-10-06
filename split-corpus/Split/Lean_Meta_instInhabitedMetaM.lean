import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instInhabitedMetaM : forall {α : Type}, Inhabited.{1} (Lean.Meta.MetaM α)
def Lean.Meta.instInhabitedMetaM : forall {α : Type}, Inhabited.{1} (Lean.Meta.MetaM α) :=
  fun {α : Type} => Inhabited.mk.{1} (Lean.Meta.MetaM α) (fun (x._@.Lean.Meta.Basic.276457148._hygCtx._hyg.17 : Lean.Meta.Context) (x._@.Lean.Meta.Basic.276457148._hygCtx._hyg.19 : ST.Ref IO.RealWorld Lean.Meta.State) => Inhabited.default.{1} (Lean.Core.CoreM α) (Lean.Core.instInhabitedCoreM α))
