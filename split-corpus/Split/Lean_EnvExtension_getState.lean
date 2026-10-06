import Mathlib

-- spec: opaque Lean.EnvExtension.getState : forall {σ : Type} [inst._@.Lean.Environment.2699548092._hygCtx._hyg.3 : Inhabited.{1} σ] (ext : Lean.EnvExtension σ), Lean.Environment -> (optParam.{1} Lean.EnvExtension.AsyncMode (Lean.EnvExtension.asyncMode σ ext)) -> (optParam.{1} Lean.Name Lean.Name.anonymous) -> σ
opaque Lean.EnvExtension.getState : forall {σ : Type} [inst._@.Lean.Environment.2699548092._hygCtx._hyg.3 : Inhabited.{1} σ] (ext : Lean.EnvExtension σ), Lean.Environment -> (optParam.{1} Lean.EnvExtension.AsyncMode (Lean.EnvExtension.asyncMode σ ext)) -> (optParam.{1} Lean.Name Lean.Name.anonymous) -> σ :=
  fun {σ : Type} [inst._@.Lean.Environment.2699548092._hygCtx._hyg.3 : Inhabited.{1} σ] (ext : Lean.EnvExtension σ) (env : Lean.Environment) (asyncMode : Lean.EnvExtension.AsyncMode) (asyncDecl : Lean.Name) => Inhabited.default.{1} σ inst._@.Lean.Environment.2699548092._hygCtx._hyg.3
