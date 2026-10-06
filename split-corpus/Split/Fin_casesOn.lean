import Mathlib

set_option pp.all true
-- spec: Fin.casesOn : forall {n : Nat} {motive : (Fin n) -> Sort.{u}} (t : Fin n), (forall (val : Nat) (isLt : LT.lt.{0} Nat instLTNat val n), motive (Fin.mk n val isLt)) -> (motive t)
def Fin.casesOn : forall {n : Nat} {motive : (Fin n) -> Sort.{u}} (t : Fin n), (forall (val : Nat) (isLt : LT.lt.{0} Nat instLTNat val n), motive (Fin.mk n val isLt)) -> (motive t) :=
  fun {n : Nat} {motive : (Fin n) -> Sort.{u}} (t : Fin n) (mk : forall (val : Nat) (isLt : LT.lt.{0} Nat instLTNat val n), motive (Fin.mk n val isLt)) => Fin.rec.{u} n motive (fun (val : Nat) (isLt : LT.lt.{0} Nat instLTNat val n) => mk val isLt) t
