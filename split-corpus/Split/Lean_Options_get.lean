import Mathlib

set_option pp.all true
-- spec: Lean.Options.get : forall {α : Type} [inst._@.Lean.Data.Options.1017806716._hygCtx._hyg.3 : Lean.KVMap.Value α], Lean.Options -> Lean.Name -> α -> α
def Lean.Options.get : forall {α : Type} [inst._@.Lean.Data.Options.1017806716._hygCtx._hyg.3 : Lean.KVMap.Value α], Lean.Options -> Lean.Name -> α -> α :=
  fun {α : Type} [inst._@.Lean.Data.Options.1017806716._hygCtx._hyg.3 : Lean.KVMap.Value α] (o : Lean.Options) (k : Lean.Name) (defVal : α) => Option.getD.{0} α (Lean.Options.get? α inst._@.Lean.Data.Options.1017806716._hygCtx._hyg.3 o k) defVal
