import Mathlib

set_option pp.all true
-- spec: Lean.ScopedEnvExtension.instInhabitedScopedEntries : forall {a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29 : Type}, Inhabited.{1} (Lean.ScopedEnvExtension.ScopedEntries a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29)
def Lean.ScopedEnvExtension.instInhabitedScopedEntries : forall {a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29 : Type}, Inhabited.{1} (Lean.ScopedEnvExtension.ScopedEntries a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29) :=
  fun {a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29 : Type} => Inhabited.mk.{1} (Lean.ScopedEnvExtension.ScopedEntries a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29) (Lean.ScopedEnvExtension.instInhabitedScopedEntries.default a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29)
