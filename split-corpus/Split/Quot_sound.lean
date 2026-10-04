import Mathlib

-- spec: axiom Quot.sound : forall {α : Sort.{u}} {r : α -> α -> Prop} {a : α} {b : α}, (r a b) -> (Eq.{u} (Quot.{u} α r) (Quot.mk.{u} α r a) (Quot.mk.{u} α r b))
axiom Quot.sound : forall {α : Sort.{u}} {r : α -> α -> Prop} {a : α} {b : α}, (r a b) -> (Eq.{u} (Quot.{u} α r) (Quot.mk.{u} α r a) (Quot.mk.{u} α r b))
