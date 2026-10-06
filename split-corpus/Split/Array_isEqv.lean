import Mathlib

set_option pp.all true
-- spec: Array.isEqv : forall {α : Type.{u}}, (Array.{u} α) -> (Array.{u} α) -> (α -> α -> Bool) -> Bool
def Array.isEqv : forall {α : Type.{u}}, (Array.{u} α) -> (Array.{u} α) -> (α -> α -> Bool) -> Bool :=
  fun {α : Type.{u}} (xs : Array.{u} α) (ys : Array.{u} α) (p : α -> α -> Bool) => dite.{1} Bool (Eq.{1} Nat (Array.size.{u} α xs) (Array.size.{u} α ys)) (instDecidableEqNat (Array.size.{u} α xs) (Array.size.{u} α ys)) (fun (h : Eq.{1} Nat (Array.size.{u} α xs) (Array.size.{u} α ys)) => Array.isEqvAux.{u} α xs ys h p (Array.size.{u} α xs) (_private.Init.Data.Array.Basic.0.Array.isEqv._proof_1.{u} α xs)) (fun (h : Not (Eq.{1} Nat (Array.size.{u} α xs) (Array.size.{u} α ys))) => Bool.false)
