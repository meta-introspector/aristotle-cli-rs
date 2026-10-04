import Mathlib

set_option pp.all true
-- spec: String.Pos.Raw.casesOn : forall {motive : String.Pos.Raw -> Sort.{u}} (t : String.Pos.Raw), (forall (byteIdx : Nat), motive (String.Pos.Raw.mk byteIdx)) -> (motive t)
def String.Pos.Raw.casesOn : forall {motive : String.Pos.Raw -> Sort.{u}} (t : String.Pos.Raw), (forall (byteIdx : Nat), motive (String.Pos.Raw.mk byteIdx)) -> (motive t) :=
  fun {motive : String.Pos.Raw -> Sort.{u}} (t : String.Pos.Raw) (mk : forall (byteIdx : Nat), motive (String.Pos.Raw.mk byteIdx)) => String.Pos.Raw.rec.{u} motive (fun (byteIdx : Nat) => mk byteIdx) t
