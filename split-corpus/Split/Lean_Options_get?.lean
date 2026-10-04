import Mathlib

set_option pp.all true
-- spec: Lean.Options.get? : forall {α : Type} [inst._@.Lean.Data.Options.1378944498._hygCtx._hyg.3 : Lean.KVMap.Value α], Lean.Options -> Lean.Name -> (Option.{0} α)
def Lean.Options.get? : forall {α : Type} [inst._@.Lean.Data.Options.1378944498._hygCtx._hyg.3 : Lean.KVMap.Value α], Lean.Options -> Lean.Name -> (Option.{0} α) :=
  fun {α : Type} [inst._@.Lean.Data.Options.1378944498._hygCtx._hyg.3 : Lean.KVMap.Value α] (o : Lean.Options) (k : Lean.Name) => Option.bind.{0, 0} Lean.DataValue α (Lean.NameMap.find? Lean.DataValue (_private.Lean.Data.Options.0.Lean.Options.map o) k) (Lean.KVMap.Value.ofDataValue? α inst._@.Lean.Data.Options.1378944498._hygCtx._hyg.3)
