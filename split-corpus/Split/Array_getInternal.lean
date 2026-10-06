import Mathlib

set_option pp.all true
-- spec: Array.getInternal : forall {α : Type.{u}} (a : [mdata borrowed:1 Array.{u} α]) (i : [mdata borrowed:1 Nat]), (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat i (Array.size.{u} α a)) -> α
def Array.getInternal : forall {α : Type.{u}} (a : [mdata borrowed:1 Array.{u} α]) (i : [mdata borrowed:1 Nat]), (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat i (Array.size.{u} α a)) -> α :=
  fun {α : Type.{u}} (a : Array.{u} α) (i : Nat) (h : LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat i (Array.size.{u} α a)) => List.get.{u} α (Array.toList.{u} α a) (Fin.mk (List.length.{u} α (Array.toList.{u} α a)) i h)
