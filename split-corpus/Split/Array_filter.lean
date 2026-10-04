import Mathlib

set_option pp.all true
-- spec: Array.filter : forall {α : Type.{u}}, (α -> Bool) -> (forall (as : Array.{u} α), (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (Array.size.{u} α as)) -> (Array.{u} α))
def Array.filter : forall {α : Type.{u}}, (α -> Bool) -> (forall (as : Array.{u} α), (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (Array.size.{u} α as)) -> (Array.{u} α)) :=
  fun {α : Type.{u}} (p : α -> Bool) (as : Array.{u} α) (start : Nat) (stop : Nat) => Array.foldl.{u, u} α (Array.{u} α) (fun (acc : Array.{u} α) (a : α) => ite.{succ u} (Array.{u} α) (Eq.{1} Bool (p a) Bool.true) (instDecidableEqBool (p a) Bool.true) (Array.push.{u} α acc a) acc) (List.toArray.{u} α (List.nil.{u} α)) as start stop
