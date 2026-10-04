import Mathlib

set_option pp.all true
-- spec: Array.mkArray4 : forall {α : Type.{u}}, α -> α -> α -> α -> (Array.{u} α)
def Array.mkArray4 : forall {α : Type.{u}}, α -> α -> α -> α -> (Array.{u} α) :=
  fun {α : Type.{u}} (a₁ : α) (a₂ : α) (a₃ : α) (a₄ : α) => Array.push.{u} α (Array.push.{u} α (Array.push.{u} α (Array.push.{u} α (Array.emptyWithCapacity.{u} α (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 4 (instOfNatNat 4))) a₁) a₂) a₃) a₄
