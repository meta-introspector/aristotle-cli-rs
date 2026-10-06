import Mathlib

set_option pp.all true
-- spec: Array.toArrayLit : forall {α : Type.{u_1}} (xs : Array.{u_1} α) (n : Nat), (Eq.{1} Nat (Array.size.{u_1} α xs) n) -> (Array.{u_1} α)
def Array.toArrayLit : forall {α : Type.{u_1}} (xs : Array.{u_1} α) (n : Nat), (Eq.{1} Nat (Array.size.{u_1} α xs) n) -> (Array.{u_1} α) :=
  fun {α : Type.{u_1}} (xs : Array.{u_1} α) (n : Nat) (hsz : Eq.{1} Nat (Array.size.{u_1} α xs) n) => List.toArray.{u_1} α (Array.toListLitAux.{u_1} α xs n hsz n (Array.toArrayLit._proof_1.{u_1} α xs n hsz) (List.nil.{u_1} α))
