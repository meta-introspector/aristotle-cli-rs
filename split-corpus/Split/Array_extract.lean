import Mathlib

set_option pp.all true
-- spec: Array.extract : forall {α : Type.{u_1}} (as : Array.{u_1} α), (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (Array.size.{u_1} α as)) -> (Array.{u_1} α)
def Array.extract : forall {α : Type.{u_1}} (as : Array.{u_1} α), (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (Array.size.{u_1} α as)) -> (Array.{u_1} α) :=
  fun {α : Type.{u_1}} (as : Array.{u_1} α) (start : Nat) (stop : Nat) => have sz' : Nat := Nat.sub (Min.min.{0} ([mdata borrowed:1 Nat]) instMinNat stop (Array.size.{u_1} α as)) start; Array.extract.loop.{u_1} α as sz' start (Array.emptyWithCapacity.{u_1} α sz')
