import Mathlib

set_option pp.all true
-- spec: Array.instGetElemUSizeLtNatToNatSize : forall {α : Type.{u}}, GetElem.{u, 0, u} (Array.{u} α) USize α (fun (xs : Array.{u} α) (i : USize) => LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs))
def Array.instGetElemUSizeLtNatToNatSize : forall {α : Type.{u}}, GetElem.{u, 0, u} (Array.{u} α) USize α (fun (xs : Array.{u} α) (i : USize) => LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) :=
  fun {α : Type.{u}} => GetElem.mk.{u, 0, u} (Array.{u} α) USize α (fun (xs : Array.{u} α) (i : USize) => LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) (fun (xs : Array.{u} α) (i : USize) (h : LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) => Array.uget.{u} α xs i h)
