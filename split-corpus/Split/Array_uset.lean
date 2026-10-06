import Mathlib

set_option pp.all true
-- spec: Array.uset : forall {α : Type.{u}} (xs : Array.{u} α) (i : USize), α -> (LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) -> (Array.{u} α)
def Array.uset : forall {α : Type.{u}} (xs : Array.{u} α) (i : USize), α -> (LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) -> (Array.{u} α) :=
  fun {α : Type.{u}} (xs : Array.{u} α) (i : USize) (v : α) (h : LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) => Array.set.{u} α xs (USize.toNat i) v h
