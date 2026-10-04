import Mathlib

set_option pp.all true
-- spec: Std.IterM.IsPlausibleStep : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3667085596._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.IterM.{w, w'} α m β) -> (Std.IterStep.{succ w, succ w} (Std.IterM.{w, w'} α m β) β) -> Prop
def Std.IterM.IsPlausibleStep : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3667085596._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.IterM.{w, w'} α m β) -> (Std.IterStep.{succ w, succ w} (Std.IterM.{w, w'} α m β) β) -> Prop :=
  fun {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.3667085596._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] => Std.Iterator.IsPlausibleStep.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.3667085596._hygCtx._hyg.7
