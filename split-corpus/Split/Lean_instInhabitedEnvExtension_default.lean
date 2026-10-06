import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedEnvExtension.default : forall {a._@.Lean.Environment.319799107._hygCtx._hyg.28 : Type}, Lean.EnvExtension a._@.Lean.Environment.319799107._hygCtx._hyg.28
def Lean.instInhabitedEnvExtension.default : forall {a._@.Lean.Environment.319799107._hygCtx._hyg.28 : Type}, Lean.EnvExtension a._@.Lean.Environment.319799107._hygCtx._hyg.28 :=
  fun {a._@.Lean.Environment.319799107._hygCtx._hyg.28 : Type} => _private.Lean.Environment.0.Lean.EnvExtension.mk a._@.Lean.Environment.319799107._hygCtx._hyg.28 (Inhabited.default.{1} Nat instInhabitedNat) (Inhabited.default.{1} (IO a._@.Lean.Environment.319799107._hygCtx._hyg.28) (instInhabitedEIO IO.Error a._@.Lean.Environment.319799107._hygCtx._hyg.28 instInhabitedError)) (Inhabited.default.{1} Lean.EnvExtension.AsyncMode Lean.EnvExtension.instInhabitedAsyncMode) (Inhabited.default.{1} (Option.{0} (Lean.ReplayFn a._@.Lean.Environment.319799107._hygCtx._hyg.28)) (instInhabitedOption.{0} (Lean.ReplayFn a._@.Lean.Environment.319799107._hygCtx._hyg.28)))
