import Mathlib

set_option pp.all true
-- spec: Std.Iterators.FinitenessRelation.Rel : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.1207942287._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.Iterators.FinitenessRelation.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.1207942287._hygCtx._hyg.7) -> (Std.IterM.{w, w'} α m β) -> (Std.IterM.{w, w'} α m β) -> Prop
def Std.Iterators.FinitenessRelation.Rel : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.1207942287._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β], (Std.Iterators.FinitenessRelation.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.1207942287._hygCtx._hyg.7) -> (Std.IterM.{w, w'} α m β) -> (Std.IterM.{w, w'} α m β) -> Prop :=
  fun (α : Type.{w}) (m : Type.{w} -> Type.{w'}) (β : Type.{w}) [inst._@.Init.Data.Iterators.Basic.1207942287._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] (self : Std.Iterators.FinitenessRelation.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.1207942287._hygCtx._hyg.7) => self.1
