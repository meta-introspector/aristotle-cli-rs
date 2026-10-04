import Mathlib

set_option pp.all true
-- spec: Array.isEmpty : forall {α : Type.{u}}, (Array.{u} α) -> Bool
def Array.isEmpty : forall {α : Type.{u}}, (Array.{u} α) -> Bool :=
  fun {α : Type.{u}} (xs : Array.{u} α) => Decidable.decide (Eq.{1} Nat (Array.size.{u} α xs) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (instDecidableEqNat (Array.size.{u} α xs) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
