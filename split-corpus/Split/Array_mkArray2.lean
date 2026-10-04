import Mathlib

set_option pp.all true
-- spec: Array.mkArray2 : forall {α : Type.{u}}, α -> α -> (Array.{u} α)
def Array.mkArray2 : forall {α : Type.{u}}, α -> α -> (Array.{u} α) :=
  fun {α : Type.{u}} (a₁ : α) (a₂ : α) => Array.push.{u} α (Array.push.{u} α (Array.emptyWithCapacity.{u} α (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 2 (instOfNatNat 2))) a₁) a₂
