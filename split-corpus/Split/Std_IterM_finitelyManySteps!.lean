import Mathlib

set_option pp.all true
-- spec: Std.IterM.finitelyManySteps! : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.1839701535._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.IterM.{w, w'} α m β) -> (Std.IterM.TerminationMeasures.Finite.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.1839701535._hygCtx._hyg.7)
def Std.IterM.finitelyManySteps! : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.1839701535._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.IterM.{w, w'} α m β) -> (Std.IterM.TerminationMeasures.Finite.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.1839701535._hygCtx._hyg.7) :=
  fun {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.1839701535._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] (it : Std.IterM.{w, w'} α m β) => Std.IterM.TerminationMeasures.Finite.mk.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.1839701535._hygCtx._hyg.7 it
