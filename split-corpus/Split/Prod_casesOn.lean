import Mathlib

set_option pp.all true
-- spec: Prod.casesOn : forall {α : Type.{u}} {β : Type.{v}} {motive : (Prod.{u, v} α β) -> Sort.{u_1}} (t : Prod.{u, v} α β), (forall (fst : α) (snd : β), motive (Prod.mk.{u, v} α β fst snd)) -> (motive t)
def Prod.casesOn : forall {α : Type.{u}} {β : Type.{v}} {motive : (Prod.{u, v} α β) -> Sort.{u_1}} (t : Prod.{u, v} α β), (forall (fst : α) (snd : β), motive (Prod.mk.{u, v} α β fst snd)) -> (motive t) :=
  fun {α : Type.{u}} {β : Type.{v}} {motive : (Prod.{u, v} α β) -> Sort.{u_1}} (t : Prod.{u, v} α β) (mk : forall (fst : α) (snd : β), motive (Prod.mk.{u, v} α β fst snd)) => Prod.rec.{u_1, u, v} α β motive (fun (fst : α) (snd : β) => mk fst snd) t
