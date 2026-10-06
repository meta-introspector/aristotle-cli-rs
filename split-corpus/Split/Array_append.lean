import Mathlib

set_option pp.all true
-- spec: Array.append : forall {α : Type.{u}}, (Array.{u} α) -> (Array.{u} α) -> (Array.{u} α)
def Array.append : forall {α : Type.{u}}, (Array.{u} α) -> (Array.{u} α) -> (Array.{u} α) :=
  fun {α : Type.{u}} (as : Array.{u} α) (bs : Array.{u} α) => Array.foldl.{u, u} α (Array.{u} α) (fun (xs : Array.{u} α) (v : α) => Array.push.{u} α xs v) as bs (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{u} α bs)
