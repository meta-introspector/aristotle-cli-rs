import Mathlib

set_option pp.all true
-- spec: Array.empty : forall {α : Type.{u}}, Array.{u} α
def Array.empty : forall {α : Type.{u}}, Array.{u} α :=
  fun {α : Type.{u}} => Array.emptyWithCapacity.{u} α (OfNat.ofNat.{0} ([mdata borrowed:1 Nat]) 0 (instOfNatNat 0))
