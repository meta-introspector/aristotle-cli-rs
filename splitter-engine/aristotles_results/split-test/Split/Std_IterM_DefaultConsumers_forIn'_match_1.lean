import Split.Subtype_casesOn
import Split.ForInStep_done
import Split.Subtype
import Split.ForInStep
import Split.Subtype_mk
import Split.ForInStep_casesOn
import Split.ForInStep_yield

-- Std.IterM.DefaultConsumers.forIn'.match_1 from environment
-- def Std.IterM.DefaultConsumers.forIn'.match_1 : forall {β : Type.{u_3}} (γ : Type.{u_1}) (PlausibleForInStep : β -> γ -> (ForInStep.{u_1} γ) -> Prop) (acc : γ) (out : β) (motive : (Subtype.{succ u_1} (ForInStep.{u_1} γ) (PlausibleForInStep out acc)) -> Sort.{u_2}) (__do_lift._@.Init.Data.Iterators.Consumers.Monadic.Loop.4042975923._hygCtx.152.0.Init.Data.Iterators.Consumers.Monadic.Loop.4042975923._hygCtx._hyg.213 : Subtype.{succ u_1} (ForInStep.{u_1} γ) (PlausibleForInStep out acc)), (forall (c : γ) (h' : PlausibleForInStep out acc (ForInStep.yield.{u_1} γ c)), motive (Subtype.mk.{succ u_1} (ForInStep.{u_1} γ) (PlausibleForInStep out acc) (ForInStep.yield.{u_1} γ c) h')) -> (forall (c : γ) (h : PlausibleForInStep out acc (ForInStep.done.{u_1} γ c)), motive (Subtype.mk.{succ u_1} (ForInStep.{u_1} γ) (PlausibleForInStep out acc) (ForInStep.done.{u_1} γ c) h)) -> (motive __do_lift._@.Init.Data.Iterators.Consumers.Monadic.Loop.4042975923._hygCtx.152.0.Init.Data.Iterators.Consumers.Monadic.Loop.4042975923._hygCtx._hyg.213)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IterM.DefaultConsumers.forIn'.match_1`.
-- In a full split, the body would be extracted from the environment.
