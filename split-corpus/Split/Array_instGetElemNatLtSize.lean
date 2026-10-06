import Mathlib

set_option pp.all true
-- spec: Array.instGetElemNatLtSize : forall {α : Type.{u_1}}, GetElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs))
def Array.instGetElemNatLtSize : forall {α : Type.{u_1}}, GetElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) :=
  fun {α : Type.{u_1}} => GetElem.mk.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (fun (xs : Array.{u_1} α) (i : Nat) (h : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) => Array.getInternal.{u_1} α xs i h)
