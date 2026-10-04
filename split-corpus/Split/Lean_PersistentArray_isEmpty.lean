import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.isEmpty : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> Bool
def Lean.PersistentArray.isEmpty : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> Bool :=
  fun {α : Type.{u}} (a : Lean.PersistentArray.{u} α) => BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) (Lean.PersistentArray.size.{u} α a) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
