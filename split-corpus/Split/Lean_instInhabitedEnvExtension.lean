import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedEnvExtension : forall {a._@.Lean.Environment.319799107._hygCtx._hyg.28 : Type}, Inhabited.{1} (Lean.EnvExtension a._@.Lean.Environment.319799107._hygCtx._hyg.28)
def Lean.instInhabitedEnvExtension : forall {a._@.Lean.Environment.319799107._hygCtx._hyg.28 : Type}, Inhabited.{1} (Lean.EnvExtension a._@.Lean.Environment.319799107._hygCtx._hyg.28) :=
  fun {a._@.Lean.Environment.319799107._hygCtx._hyg.28 : Type} => Inhabited.mk.{1} (Lean.EnvExtension a._@.Lean.Environment.319799107._hygCtx._hyg.28) (Lean.instInhabitedEnvExtension.default a._@.Lean.Environment.319799107._hygCtx._hyg.28)
