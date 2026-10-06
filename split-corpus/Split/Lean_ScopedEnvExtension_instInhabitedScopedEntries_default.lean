import Mathlib

set_option pp.all true
-- spec: Lean.ScopedEnvExtension.instInhabitedScopedEntries.default : forall {a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29 : Type}, Lean.ScopedEnvExtension.ScopedEntries a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29
def Lean.ScopedEnvExtension.instInhabitedScopedEntries.default : forall {a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29 : Type}, Lean.ScopedEnvExtension.ScopedEntries a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29 :=
  fun {a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29 : Type} => Lean.ScopedEnvExtension.ScopedEntries.mk a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29 (Inhabited.default.{1} (Lean.SMap.{0, 0} Lean.Name (Lean.PArray.{0} a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29) Lean.Name.instBEq Lean.instHashableName) (Lean.SMap.instInhabited.{0, 0} Lean.Name (Lean.PArray.{0} a._@.Lean.ScopedEnvExtension.4240022157._hygCtx._hyg.29) Lean.Name.instBEq Lean.instHashableName))
