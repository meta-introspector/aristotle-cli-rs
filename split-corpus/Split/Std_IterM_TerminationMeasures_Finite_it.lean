import Mathlib

set_option pp.all true
-- spec: Std.IterM.TerminationMeasures.Finite.it : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.773134760._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.IterM.TerminationMeasures.Finite.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.773134760._hygCtx._hyg.7) -> (Std.IterM.{w, w'} α m β)
def Std.IterM.TerminationMeasures.Finite.it : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.773134760._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.IterM.TerminationMeasures.Finite.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.773134760._hygCtx._hyg.7) -> (Std.IterM.{w, w'} α m β) :=
  fun (α : Type.{w}) (m : Type.{w} -> Type.{w'}) (β : Type.{w}) [inst._@.Init.Data.Iterators.Basic.773134760._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] (self : Std.IterM.TerminationMeasures.Finite.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.773134760._hygCtx._hyg.7) => self.1
