import Mathlib

set_option pp.all true
-- spec: Lean.Option.set : forall {α : Type} [inst._@.Lean.Data.Options.3103831427._hygCtx._hyg.14 : Lean.KVMap.Value α], Lean.Options -> (Lean.Option α) -> α -> Lean.Options
def Lean.Option.set : forall {α : Type} [inst._@.Lean.Data.Options.3103831427._hygCtx._hyg.14 : Lean.KVMap.Value α], Lean.Options -> (Lean.Option α) -> α -> Lean.Options :=
  fun {α : Type} [inst._@.Lean.Data.Options.3103831427._hygCtx._hyg.14 : Lean.KVMap.Value α] (opts : Lean.Options) (opt : Lean.Option α) (val : α) => Lean.Options.set α inst._@.Lean.Data.Options.3103831427._hygCtx._hyg.14 opts (Lean.Option.name α opt) val
