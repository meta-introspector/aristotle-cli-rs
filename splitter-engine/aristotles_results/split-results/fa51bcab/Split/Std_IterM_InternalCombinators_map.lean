import Split.Monad_toApplicative
import Split.Option_some
import Split.Std_IterM_mk
import Split.Std_Iterator
import Split.Std_Iterators_Types_Map
import Split.Std_Iterators_Types_FilterMap_mk
import Split.Applicative_toFunctor
import Split.Std_Iterators_PostconditionT
import Split.Std_IterM
import Split.Monad
import Split.Std_Iterators_PostconditionT_map
import Split.Option

-- Std.IterM.InternalCombinators.map from environment
-- def Std.IterM.InternalCombinators.map : forall {α : Type.{w}} {β : Type.{w}} {γ : Type.{w}} {m : Type.{w} -> Type.{w'}} {n : Type.{w} -> Type.{w''}} [inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3880878766._hygCtx._hyg.11 : Monad.{w, w''} n] (lift : forall {{α : Type.{w}}}, (m α) -> (n α)) [inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3880878766._hygCtx._hyg.21 : Std.Iterator.{w, w'} α m β] (f : β -> (Std.Iterators.PostconditionT.{w, w''} n γ)), (Std.IterM.{w, w'} α m β) -> (Std.IterM.{w, w''} (Std.Iterators.Types.Map.{w, w', w''} α β γ m n lift (Applicative.toFunctor.{w, w''} n (Monad.toApplicative.{w, w''} n inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3880878766._hygCtx._hyg.11)) f) n γ)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IterM.InternalCombinators.map`.
-- In a full split, the body would be extracted from the environment.
