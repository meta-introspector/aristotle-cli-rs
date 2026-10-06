import Mathlib

set_option pp.all true
-- spec: Array.getLit : forall {α : Type.{u}} {n : Nat} (xs : Array.{u} α) (i : Nat), (Eq.{1} Nat (Array.size.{u} α xs) n) -> (LT.lt.{0} Nat instLTNat i n) -> α
def Array.getLit : forall {α : Type.{u}} {n : Nat} (xs : Array.{u} α) (i : Nat), (Eq.{1} Nat (Array.size.{u} α xs) n) -> (LT.lt.{0} Nat instLTNat i n) -> α :=
  fun {α : Type.{u}} {n : Nat} (xs : Array.{u} α) (i : Nat) (h₁ : Eq.{1} Nat (Array.size.{u} α xs) n) (h₂ : LT.lt.{0} Nat instLTNat i n) => have this : LT.lt.{0} Nat instLTNat i (Array.size.{u} α xs) := Array.getLit._proof_1.{u} α n xs i h₁ h₂; GetElem.getElem.{u, 0, u} (Array.{u} α) Nat α (fun (xs : Array.{u} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u} α xs)) (Array.instGetElemNatLtSize.{u} α) xs i this
