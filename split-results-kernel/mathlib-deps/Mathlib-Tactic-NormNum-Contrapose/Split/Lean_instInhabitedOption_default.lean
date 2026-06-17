import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedOption.default : forall {a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 : Type} [inst._@.Lean.Data.Options.1498887227._hygCtx._hyg.12 : Inhabited.{1} a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38], Lean.Option a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38
def Lean.instInhabitedOption.default : forall {a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 : Type} [inst._@.Lean.Data.Options.1498887227._hygCtx._hyg.12 : Inhabited.{1} a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38], Lean.Option a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 :=
  fun {a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 : Type} [inst._@.Lean.Data.Options.1498887227._hygCtx._hyg.12 : Inhabited.{1} a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38] => Lean.Option.mk a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 (Inhabited.default.{1} Lean.Name Lean.instInhabitedName) (Inhabited.default.{1} a._@.Lean.Data.Options.3165776479._hygCtx._hyg.38 inst._@.Lean.Data.Options.1498887227._hygCtx._hyg.12)
