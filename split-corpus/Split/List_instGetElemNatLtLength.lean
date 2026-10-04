import Mathlib

set_option pp.all true
-- spec: List.instGetElemNatLtLength : forall {α : Type.{u_1}}, GetElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as))
def List.instGetElemNatLtLength : forall {α : Type.{u_1}}, GetElem.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) :=
  fun {α : Type.{u_1}} => GetElem.mk.{u_1, 0, u_1} (List.{u_1} α) Nat α (fun (as : List.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) (fun (as : List.{u_1} α) (i : Nat) (h : LT.lt.{0} Nat instLTNat i (List.length.{u_1} α as)) => List.get.{u_1} α as (Fin.mk (List.length.{u_1} α as) i h))
