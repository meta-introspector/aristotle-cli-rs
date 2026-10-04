import Mathlib

set_option pp.all true
-- spec: Lean.Options.set : forall {α : Type} [inst._@.Lean.Data.Options.3103831426._hygCtx._hyg.3 : Lean.KVMap.Value α], Lean.Options -> Lean.Name -> α -> Lean.Options
def Lean.Options.set : forall {α : Type} [inst._@.Lean.Data.Options.3103831426._hygCtx._hyg.3 : Lean.KVMap.Value α], Lean.Options -> Lean.Name -> α -> Lean.Options :=
  fun {α : Type} [inst._@.Lean.Data.Options.3103831426._hygCtx._hyg.3 : Lean.KVMap.Value α] (o : Lean.Options) (k : Lean.Name) (v : α) => Lean.Options.insert o k (Lean.KVMap.Value.toDataValue α inst._@.Lean.Data.Options.3103831426._hygCtx._hyg.3 v)
