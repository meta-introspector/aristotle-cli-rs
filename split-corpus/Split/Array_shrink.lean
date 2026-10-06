import Mathlib

set_option pp.all true
-- spec: Array.shrink : forall {α : Type.{u}}, (Array.{u} α) -> Nat -> (Array.{u} α)
def Array.shrink : forall {α : Type.{u}}, (Array.{u} α) -> Nat -> (Array.{u} α) :=
  fun {α : Type.{u}} (xs : Array.{u} α) (n : Nat) => _private.Init.Data.Array.Basic.0.Array.shrink.loop.{u} α (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Array.size.{u} α xs) n) xs
