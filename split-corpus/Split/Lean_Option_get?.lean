import Mathlib

set_option pp.all true
-- spec: Lean.Option.get? : forall {α : Type} [inst._@.Lean.Data.Options.1378944499._hygCtx._hyg.14 : Lean.KVMap.Value α], Lean.Options -> (Lean.Option α) -> (Option.{0} α)
def Lean.Option.get? : forall {α : Type} [inst._@.Lean.Data.Options.1378944499._hygCtx._hyg.14 : Lean.KVMap.Value α], Lean.Options -> (Lean.Option α) -> (Option.{0} α) :=
  fun {α : Type} [inst._@.Lean.Data.Options.1378944499._hygCtx._hyg.14 : Lean.KVMap.Value α] (opts : Lean.Options) (opt : Lean.Option α) => Lean.Options.get? α inst._@.Lean.Data.Options.1378944499._hygCtx._hyg.14 opts (Lean.Option.name α opt)
