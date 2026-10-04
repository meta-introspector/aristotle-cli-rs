import Mathlib

set_option pp.all true
-- spec: Std.IterM.casesOn : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} {motive : (Std.IterM.{w, w'} α m β) -> Sort.{u}} (t : Std.IterM.{w, w'} α m β), (forall (internalState : α), motive (Std.IterM.mk.{w, w'} α m β internalState)) -> (motive t)
def Std.IterM.casesOn : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} {motive : (Std.IterM.{w, w'} α m β) -> Sort.{u}} (t : Std.IterM.{w, w'} α m β), (forall (internalState : α), motive (Std.IterM.mk.{w, w'} α m β internalState)) -> (motive t) :=
  fun {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} {motive : (Std.IterM.{w, w'} α m β) -> Sort.{u}} (t : Std.IterM.{w, w'} α m β) (mk : forall (internalState : α), motive (Std.IterM.mk.{w, w'} α m β internalState)) => Std.IterM.rec.{u, w, w'} α m β motive (fun (internalState : α) => mk internalState) t
