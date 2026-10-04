import Mathlib

set_option pp.all true
-- spec: Array.set : forall {α : Type.{u_1}} (xs : Array.{u_1} α) (i : [mdata borrowed:1 Nat]), α -> (autoParam.{0} (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat i (Array.size.{u_1} α xs)) Array.set._auto_1) -> (Array.{u_1} α)
def Array.set : forall {α : Type.{u_1}} (xs : Array.{u_1} α) (i : [mdata borrowed:1 Nat]), α -> (autoParam.{0} (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat i (Array.size.{u_1} α xs)) Array.set._auto_1) -> (Array.{u_1} α) :=
  fun {α : Type.{u_1}} (xs : Array.{u_1} α) (i : Nat) (v : α) (h : LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat i (Array.size.{u_1} α xs)) => Array.mk.{u_1} α (List.set.{u_1} α (Array.toList.{u_1} α xs) i v)
