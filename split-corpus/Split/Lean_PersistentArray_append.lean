import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.append : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> (Lean.PersistentArray.{u} α) -> (Lean.PersistentArray.{u} α)
def Lean.PersistentArray.append : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> (Lean.PersistentArray.{u} α) -> (Lean.PersistentArray.{u} α) :=
  fun {α : Type.{u}} (t₁ : Lean.PersistentArray.{u} α) (t₂ : Lean.PersistentArray.{u} α) => ite.{succ u} (Lean.PersistentArray.{u} α) (Eq.{1} Bool (Lean.PersistentArray.isEmpty.{u} α t₁) Bool.true) (instDecidableEqBool (Lean.PersistentArray.isEmpty.{u} α t₁) Bool.true) t₂ (Lean.PersistentArray.foldl.{u, u} α (Lean.PersistentArray.{u} α) t₂ (Lean.PersistentArray.push.{u} α) t₁ (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
