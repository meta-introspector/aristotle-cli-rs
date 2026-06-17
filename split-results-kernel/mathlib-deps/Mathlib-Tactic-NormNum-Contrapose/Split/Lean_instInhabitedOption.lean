import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedOption : forall {a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 : Type} [inst._@.Lean.Data.Options.509071815._hygCtx._hyg.12 : Inhabited.{1} a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38], Inhabited.{1} (Lean.Option a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38)
def Lean.instInhabitedOption : forall {a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 : Type} [inst._@.Lean.Data.Options.509071815._hygCtx._hyg.12 : Inhabited.{1} a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38], Inhabited.{1} (Lean.Option a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38) :=
  fun {a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 : Type} [inst._@.Lean.Data.Options.509071815._hygCtx._hyg.12 : Inhabited.{1} a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38] => Inhabited.mk.{1} (Lean.Option a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38) (Lean.instInhabitedOption.default a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 inst._@.Lean.Data.Options.509071815._hygCtx._hyg.12)
