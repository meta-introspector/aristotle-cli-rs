import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.instInhabitedSynthM : forall {α : Type}, Inhabited.{1} (Lean.Meta.SynthInstance.SynthM α)
def Lean.Meta.SynthInstance.instInhabitedSynthM : forall {α : Type}, Inhabited.{1} (Lean.Meta.SynthInstance.SynthM α) :=
  fun {α : Type} => Inhabited.mk.{1} (Lean.Meta.SynthInstance.SynthM α) (fun (x._@.Lean.Meta.SynthInstance.2141975192._hygCtx._hyg.17 : Lean.Meta.SynthInstance.Context) (x._@.Lean.Meta.SynthInstance.2141975192._hygCtx._hyg.19 : ST.Ref IO.RealWorld Lean.Meta.SynthInstance.State) => Inhabited.default.{1} (Lean.Meta.MetaM α) (Lean.Meta.instInhabitedMetaM α))
