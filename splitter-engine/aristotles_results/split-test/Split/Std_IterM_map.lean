import Split.Pure_pure
import Split.Monad_toApplicative
import Split.MonadLiftT_monadLift
import Split.instMonadLiftT
import Split.Applicative_toPure
import Split.Std_Iterator
import Split.Std_Iterators_instMonadPostconditionT
import Split.Std_Iterators_Types_Map
import Split.Applicative_toFunctor
import Split.Std_Iterators_PostconditionT
import Split.Std_IterM
import Split.Monad
import Split.Std_IterM_mapWithPostcondition

-- Std.IterM.map from environment
-- def Std.IterM.map : forall {α : Type.{w}} {β : Type.{w}} {γ : Type.{w}} {m : Type.{w} -> Type.{w'}} [inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3880878767._hygCtx._hyg.8 : Std.Iterator.{w, w'} α m β] [inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3880878767._hygCtx._hyg.13 : Monad.{w, w'} m] (f : β -> γ), (Std.IterM.{w, w'} α m β) -> (Std.IterM.{w, w'} (Std.Iterators.Types.Map.{w, w', w'} α β γ m m (fun {{x._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.41 : Type.{w}}} => MonadLiftT.monadLift.{w, w', w'} m m (instMonadLiftT.{w, w'} m) x._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.41) (Applicative.toFunctor.{w, w'} m (Monad.toApplicative.{w, w'} m inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3880878767._hygCtx._hyg.13)) (fun (b : β) => Pure.pure.{w, max w' w} (Std.Iterators.PostconditionT.{w, w'} m) (Applicative.toPure.{w, max w w'} (Std.Iterators.PostconditionT.{w, w'} m) (Monad.toApplicative.{w, max w w'} (Std.Iterators.PostconditionT.{w, w'} m) (Std.Iterators.instMonadPostconditionT.{w, w'} m inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3880878767._hygCtx._hyg.13))) γ (f b))) m γ)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IterM.map`.
-- In a full split, the body would be extracted from the environment.
