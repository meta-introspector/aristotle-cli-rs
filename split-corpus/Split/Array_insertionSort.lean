import Mathlib

set_option pp.all true
-- spec: Array.insertionSort : forall {α : Type.{u_1}}, (Array.{u_1} α) -> (autoParam.{succ u_1} (α -> α -> Bool) Array.insertionSort._auto_1) -> (Array.{u_1} α)
def Array.insertionSort : forall {α : Type.{u_1}}, (Array.{u_1} α) -> (autoParam.{succ u_1} (α -> α -> Bool) Array.insertionSort._auto_1) -> (Array.{u_1} α) :=
  fun {α : Type.{u_1}} (xs : Array.{u_1} α) (lt : α -> α -> Bool) => _private.Init.Data.Array.InsertionSort.0.Array.insertionSort.traverse.{u_1} α lt xs (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{u_1} α xs)
