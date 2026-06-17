import Split.Pure_pure
import Split.Monad_toApplicative
import Split.MonadLiftT_monadLift
import Split.instMonadLiftT
import Split.Std_IterM_toIter
import Split.Std_Iter_toIterM
import Split.Id
import Split.Applicative_toPure
import Split.Std_Iterator
import Split.Std_Iterators_instMonadPostconditionT
import Split.Std_Iter
import Split.Std_Iterators_Types_Map
import Split.Applicative_toFunctor
import Split.Std_Iterators_PostconditionT
import Split.Id_instMonad
import Split.Std_IterM_map

-- Std.Iter.map from environment
-- def Std.Iter.map : forall {α : Type.{w}} {β : Type.{w}} {γ : Type.{w}} [inst._@.Init.Data.Iterators.Combinators.FilterMap.3880878766._hygCtx._hyg.5 : Std.Iterator.{w, w} α Id.{w} β] (f : β -> γ), (Std.Iter.{w} α β) -> (Std.Iter.{w} (Std.Iterators.Types.Map.{w, w, w} α β γ Id.{w} Id.{w} (fun {{x._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.41 : Type.{w}}} => MonadLiftT.monadLift.{w, w, w} Id.{w} Id.{w} (instMonadLiftT.{w, w} Id.{w}) x._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.41) (Applicative.toFunctor.{w, w} Id.{w} (Monad.toApplicative.{w, w} Id.{w} Id.instMonad.{w})) (fun (b : β) => Pure.pure.{w, w} (Std.Iterators.PostconditionT.{w, w} Id.{w}) (Applicative.toPure.{w, w} (Std.Iterators.PostconditionT.{w, w} Id.{w}) (Monad.toApplicative.{w, w} (Std.Iterators.PostconditionT.{w, w} Id.{w}) (Std.Iterators.instMonadPostconditionT.{w, w} Id.{w} Id.instMonad.{w}))) γ (f b))) γ)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.Iter.map`.
-- In a full split, the body would be extracted from the environment.
