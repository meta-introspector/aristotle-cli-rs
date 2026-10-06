import Mathlib

set_option pp.all true
-- spec: Lean.EnvExtension.asyncMode : forall {σ : Type}, (Lean.EnvExtension σ) -> Lean.EnvExtension.AsyncMode
def Lean.EnvExtension.asyncMode : forall {σ : Type}, (Lean.EnvExtension σ) -> Lean.EnvExtension.AsyncMode :=
  fun (σ : Type) (self : Lean.EnvExtension σ) => self.3
