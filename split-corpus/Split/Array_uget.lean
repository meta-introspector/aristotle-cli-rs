import Mathlib

set_option pp.all true
-- spec: Array.uget : forall {α : Type.{u}} (xs : [mdata borrowed:1 Array.{u} α]) (i : USize), (LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) -> α
def Array.uget : forall {α : Type.{u}} (xs : [mdata borrowed:1 Array.{u} α]) (i : USize), (LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) -> α :=
  fun {α : Type.{u}} (xs : Array.{u} α) (i : USize) (h : LT.lt.{0} Nat instLTNat (USize.toNat i) (Array.size.{u} α xs)) => GetElem.getElem.{u, 0, u} (Array.{u} α) Nat α (fun (xs : Array.{u} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u} α xs)) (Array.instGetElemNatLtSize.{u} α) xs (USize.toNat i) h
