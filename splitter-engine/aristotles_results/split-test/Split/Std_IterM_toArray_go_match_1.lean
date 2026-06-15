import Split.Std_IterStep
import Split.Subtype_casesOn
import Split.Std_IterM_IsPlausibleStep
import Split.Std_IterStep_skip
import Split.Std_Iterator
import Split.Subtype_mk
import Split.Std_IterStep_yield
import Split.Std_IterM_Step
import Split.Std_IterStep_done
import Split.Std_IterM
import Split.Std_IterStep_casesOn

-- Std.IterM.toArray.go.match_1 from environment
-- def Std.IterM.toArray.go.match_1 : forall {α : Type.{u_1}} {β : Type.{u_1}} {m : Type.{u_1} -> Type.{u_2}} [inst._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.10 : Std.Iterator.{u_1, u_2} α m β] (it : Std.IterM.{u_1, u_2} α m β) (motive : (Std.IterM.Step.{u_1, u_2} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.10 it) -> Sort.{u_3}) (x._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.109 : Std.IterM.Step.{u_1, u_2} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.10 it), (forall (it' : Std.IterM.{u_1, u_2} α m β) (out : β) (h : Std.IterM.IsPlausibleStep.{u_1, u_2} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.10 it (Std.IterStep.yield.{succ u_1, succ u_1} (Std.IterM.{u_1, u_2} α m β) β it' out)), motive (Subtype.mk.{succ u_1} (Std.IterStep.{succ u_1, succ u_1} (Std.IterM.{u_1, u_2} α m β) β) (Std.IterM.IsPlausibleStep.{u_1, u_2} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.10 it) (Std.IterStep.yield.{succ u_1, succ u_1} (Std.IterM.{u_1, u_2} α m β) β it' out) h)) -> (forall (it' : Std.IterM.{u_1, u_2} α m β) (h : Std.IterM.IsPlausibleStep.{u_1, u_2} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.10 it (Std.IterStep.skip.{succ u_1, succ u_1} (Std.IterM.{u_1, u_2} α m β) β it')), motive (Subtype.mk.{succ u_1} (Std.IterStep.{succ u_1, succ u_1} (Std.IterM.{u_1, u_2} α m β) β) (Std.IterM.IsPlausibleStep.{u_1, u_2} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.10 it) (Std.IterStep.skip.{succ u_1, succ u_1} (Std.IterM.{u_1, u_2} α m β) β it') h)) -> (forall (property._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.145 : Std.IterM.IsPlausibleStep.{u_1, u_2} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.10 it (Std.IterStep.done.{succ u_1, succ u_1} (Std.IterM.{u_1, u_2} α m β) β)), motive (Subtype.mk.{succ u_1} (Std.IterStep.{succ u_1, succ u_1} (Std.IterM.{u_1, u_2} α m β) β) (Std.IterM.IsPlausibleStep.{u_1, u_2} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.10 it) (Std.IterStep.done.{succ u_1, succ u_1} (Std.IterM.{u_1, u_2} α m β) β) property._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.145)) -> (motive x._@.Init.Data.Iterators.Consumers.Monadic.Collect.3236840523._hygCtx._hyg.109)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IterM.toArray.go.match_1`.
-- In a full split, the body would be extracted from the environment.
