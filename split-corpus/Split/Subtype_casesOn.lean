import Mathlib

set_option pp.all true
-- spec: Subtype.casesOn : forall {α : Sort.{u}} {p : α -> Prop} {motive : (Subtype.{u} α p) -> Sort.{u_1}} (t : Subtype.{u} α p), (forall (val : α) (property : p val), motive (Subtype.mk.{u} α p val property)) -> (motive t)
def Subtype.casesOn : forall {α : Sort.{u}} {p : α -> Prop} {motive : (Subtype.{u} α p) -> Sort.{u_1}} (t : Subtype.{u} α p), (forall (val : α) (property : p val), motive (Subtype.mk.{u} α p val property)) -> (motive t) :=
  fun {α : Sort.{u}} {p : α -> Prop} {motive : (Subtype.{u} α p) -> Sort.{u_1}} (t : Subtype.{u} α p) (mk : forall (val : α) (property : p val), motive (Subtype.mk.{u} α p val property)) => Subtype.rec.{u_1, u} α p motive (fun (val : α) (property : p val) => mk val property) t
