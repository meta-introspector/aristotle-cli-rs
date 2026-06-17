import Split.Pure_pure
import Split.PSigma_snd
import Split.Std_IterM_DefaultConsumers_forIn'_match_1
import Split.Std_Shrink
import Split.Monad_toApplicative
import Split.InvImage
import Split.Std_IterM_IsPlausibleStep
import Split.ForInStep_done
import Split.Std_IterStep_skip
import Split.Subtype
import Split.Std_IteratorLoop_rel
import Split.Prod_mk
import Split.Std_IterM_DefaultConsumers_forIn'_match_3
import Split.Applicative_toPure
import Split.Std_IterM_IsPlausibleIndirectOutput
import Split.ForInStep
import Split.Std_Iterator
import Split.Std_IterM_step
import Split.Std_Shrink_inflate
import Split.Std_IterStep_yield
import Split.WellFounded_extrinsicFix₃
import Split.PSigma_mk
import Split.Std_IterM_Step
import Split.Std_IterStep_done
import Split.Monad_toBind
import Split.Std_IterM
import Split.Bind_bind
import Split.PSigma_fst
import Split.Prod
import Split.Monad
import Split.PSigma
import Split.ForInStep_yield

-- Std.IterM.DefaultConsumers.forIn' from environment
-- def Std.IterM.DefaultConsumers.forIn' : forall {m : Type.{w} -> Type.{w'}} {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.4042975923._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] {n : Type.{x} -> Type.{x'}} [inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.4042975923._hygCtx._hyg.15 : Monad.{x, x'} n], (forall (γ : Type.{w}) (δ : Type.{x}), (γ -> (n δ)) -> (m γ) -> (n δ)) -> (forall (γ : Type.{x}) (PlausibleForInStep : β -> γ -> (ForInStep.{x} γ) -> Prop) (it : Std.IterM.{w, w'} α m β), γ -> (forall (P : β -> Prop), (forall (b : β), (Std.IterM.IsPlausibleIndirectOutput.{w, w'} α β m inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.4042975923._hygCtx._hyg.7 it b) -> (P b)) -> (forall (b : β), (P b) -> (forall (c : γ), n (Subtype.{succ x} (ForInStep.{x} γ) (PlausibleForInStep b c)))) -> (n γ)))
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IterM.DefaultConsumers.forIn'`.
-- In a full split, the body would be extracted from the environment.
