import Split.Monad_toApplicative
import Split.MonadLiftT_monadLift
import Split.Std_IterM_InternalCombinators_map
import Split.MonadLiftT
import Split.Std_Iterator
import Split.Std_Iterators_Types_Map
import Split.Applicative_toFunctor
import Split.Std_Iterators_PostconditionT
import Split.Std_IterM
import Split.Monad

-- Std.IterM.mapWithPostcondition from environment
-- def Std.IterM.mapWithPostcondition : forall {α : Type.{w}} {β : Type.{w}} {γ : Type.{w}} {m : Type.{w} -> Type.{w'}} {n : Type.{w} -> Type.{w''}} [inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.11 : Monad.{w, w''} n] [inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.14 : MonadLiftT.{w, w', w''} m n] [inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.18 : Std.Iterator.{w, w'} α m β] (f : β -> (Std.Iterators.PostconditionT.{w, w''} n γ)), (Std.IterM.{w, w'} α m β) -> (Std.IterM.{w, w''} (Std.Iterators.Types.Map.{w, w', w''} α β γ m n (fun {{x._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.41 : Type.{w}}} => MonadLiftT.monadLift.{w, w', w''} m n inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.14 x._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.41) (Applicative.toFunctor.{w, w''} n (Monad.toApplicative.{w, w''} n inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.11)) f) n γ)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IterM.mapWithPostcondition`.
-- In a full split, the body would be extracted from the environment.
