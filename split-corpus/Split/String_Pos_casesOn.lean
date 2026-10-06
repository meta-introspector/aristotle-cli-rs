import Mathlib

set_option pp.all true
-- spec: String.Pos.casesOn : forall {s : String} {motive : (String.Pos s) -> Sort.{u}} (t : String.Pos s), (forall (offset : String.Pos.Raw) (isValid : String.Pos.Raw.IsValid s offset), motive (String.Pos.mk s offset isValid)) -> (motive t)
def String.Pos.casesOn : forall {s : String} {motive : (String.Pos s) -> Sort.{u}} (t : String.Pos s), (forall (offset : String.Pos.Raw) (isValid : String.Pos.Raw.IsValid s offset), motive (String.Pos.mk s offset isValid)) -> (motive t) :=
  fun {s : String} {motive : (String.Pos s) -> Sort.{u}} (t : String.Pos s) (mk : forall (offset : String.Pos.Raw) (isValid : String.Pos.Raw.IsValid s offset), motive (String.Pos.mk s offset isValid)) => String.Pos.rec.{u} s motive (fun (offset : String.Pos.Raw) (isValid : String.Pos.Raw.IsValid s offset) => mk offset isValid) t
