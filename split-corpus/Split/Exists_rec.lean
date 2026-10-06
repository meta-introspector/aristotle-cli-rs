import Mathlib

-- spec: recursor Exists.rec : forall {α : Sort.{u}} {p : α -> Prop} {motive : (Exists.{u} α p) -> Prop}, (forall (w : α) (h : p w), motive (Exists.intro.{u} α p w h)) -> (forall (t : Exists.{u} α p), motive t)
