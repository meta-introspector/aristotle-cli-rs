import Mathlib

-- spec: recursor Std.IterM.rec : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} {motive : (Std.IterM.{w, w'} α m β) -> Sort.{u}}, (forall (internalState : α), motive (Std.IterM.mk.{w, w'} α m β internalState)) -> (forall (t : Std.IterM.{w, w'} α m β), motive t)
