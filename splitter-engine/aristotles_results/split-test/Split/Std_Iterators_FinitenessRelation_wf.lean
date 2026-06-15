import Split.Std_Iterators_FinitenessRelation
import Split.Std_Iterator
import Split.Std_Iterators_FinitenessRelation_Rel
import Split.Std_IterM
import Split.WellFounded

-- Std.Iterators.FinitenessRelation.wf from environment
-- theorem Std.Iterators.FinitenessRelation.wf : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Basic.1207942287._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] (self : Std.Iterators.FinitenessRelation.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.1207942287._hygCtx._hyg.7), WellFounded.{succ w} (Std.IterM.{w, w'} α m β) (Std.Iterators.FinitenessRelation.Rel.{w, w'} α m β inst._@.Init.Data.Iterators.Basic.1207942287._hygCtx._hyg.7 self)

-- Stub: this file represents the declaration `Std.Iterators.FinitenessRelation.wf`.
-- In a full split, the body would be extracted from the environment.
