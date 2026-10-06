import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedPersistentEnvExtensionState : forall {α : Type} {σ : Type} [inst._@.Lean.Environment.2888327936._hygCtx._hyg.4 : Inhabited.{1} σ], Inhabited.{1} (Lean.PersistentEnvExtensionState α σ)
def Lean.instInhabitedPersistentEnvExtensionState : forall {α : Type} {σ : Type} [inst._@.Lean.Environment.2888327936._hygCtx._hyg.4 : Inhabited.{1} σ], Inhabited.{1} (Lean.PersistentEnvExtensionState α σ) :=
  fun {α : Type} {σ : Type} [inst._@.Lean.Environment.2888327936._hygCtx._hyg.4 : Inhabited.{1} σ] => Inhabited.mk.{1} (Lean.PersistentEnvExtensionState α σ) (Lean.PersistentEnvExtensionState.mk α σ (List.toArray.{0} (Array.{0} α) (List.nil.{0} (Array.{0} α))) (Inhabited.default.{1} σ inst._@.Lean.Environment.2888327936._hygCtx._hyg.4))
