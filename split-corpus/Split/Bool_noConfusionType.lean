import Mathlib

set_option pp.all true
-- spec: Bool.noConfusionType : Sort.{u} -> Bool -> Bool -> Sort.{u}
def Bool.noConfusionType : Sort.{u} -> Bool -> Bool -> Sort.{u} :=
  fun (P : Sort.{u}) (t : Bool) (t' : Bool) => Bool.casesOn.{succ u} (fun (t : Bool) => Sort.{u}) t (Bool.casesOn.{succ u} (fun (t : Bool) => Sort.{u}) t' (P -> P) P) (Bool.casesOn.{succ u} (fun (t : Bool) => Sort.{u}) t' P (P -> P))
