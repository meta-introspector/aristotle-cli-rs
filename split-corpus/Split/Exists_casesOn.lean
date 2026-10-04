import Mathlib

set_option pp.all true
-- spec: Exists.casesOn : forall {α : Sort.{u}} {p : α -> Prop} {motive : (Exists.{u} α p) -> Prop} (t : Exists.{u} α p), (forall (w : α) (h : p w), motive (Exists.intro.{u} α p w h)) -> (motive t)
def Exists.casesOn : forall {α : Sort.{u}} {p : α -> Prop} {motive : (Exists.{u} α p) -> Prop} (t : Exists.{u} α p), (forall (w : α) (h : p w), motive (Exists.intro.{u} α p w h)) -> (motive t) :=
  fun {α : Sort.{u}} {p : α -> Prop} {motive : (Exists.{u} α p) -> Prop} (t : Exists.{u} α p) (intro : forall (w : α) (h : p w), motive (Exists.intro.{u} α p w h)) => Exists.rec.{u} α p motive (fun (w : α) (h : p w) => intro w h) t
