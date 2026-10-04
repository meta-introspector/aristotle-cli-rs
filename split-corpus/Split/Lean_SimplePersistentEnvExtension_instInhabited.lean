import Mathlib

set_option pp.all true
-- spec: Lean.SimplePersistentEnvExtension.instInhabited : forall {α : Type} {σ : Type} [inst._@.Lean.EnvExtension.4037808124._hygCtx._hyg.4 : Inhabited.{1} σ], Inhabited.{1} (Lean.SimplePersistentEnvExtension α σ)
def Lean.SimplePersistentEnvExtension.instInhabited : forall {α : Type} {σ : Type} [inst._@.Lean.EnvExtension.4037808124._hygCtx._hyg.4 : Inhabited.{1} σ], Inhabited.{1} (Lean.SimplePersistentEnvExtension α σ) :=
  fun {α : Type} {σ : Type} [inst._@.Lean.EnvExtension.4037808124._hygCtx._hyg.4 : Inhabited.{1} σ] => Inhabited.mk.{1} (Lean.SimplePersistentEnvExtension α σ) (Lean.SimplePersistentEnvExtension.instInhabited._aux_1 α σ)
