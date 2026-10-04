import Mathlib

set_option pp.all true
-- spec: Std.IterM.step : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.2479753423._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] (it : Std.IterM.{w, w'} α m β), m (Std.Shrink.{w} (Std.IterM.Step.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.2479753423._hygCtx._hyg.7 it))
def Std.IterM.step : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.2479753423._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] (it : Std.IterM.{w, w'} α m β), m (Std.Shrink.{w} (Std.IterM.Step.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.2479753423._hygCtx._hyg.7 it)) :=
  fun {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.2479753423._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] (it : Std.IterM.{w, w'} α m β) => Std.Iterator.step.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.2479753423._hygCtx._hyg.7 it
