import Mathlib

set_option pp.all true
-- spec: Lean.ScopedEnvExtension.State.state : forall {σ : Type}, (Lean.ScopedEnvExtension.State σ) -> σ
def Lean.ScopedEnvExtension.State.state : forall {σ : Type}, (Lean.ScopedEnvExtension.State σ) -> σ :=
  fun (σ : Type) (self : Lean.ScopedEnvExtension.State σ) => self.1
