import Split.Std_Iterator_mk
import Split.Monad_toApplicative
import Split.Std_Iterator
import Split.Std_Iterators_Types_Map
import Split.Applicative_toFunctor
import Split.Std_Iterators_PostconditionT
import Split.Monad

-- Std.Iterators.Types.Map.instIterator from environment
-- def Std.Iterators.Types.Map.instIterator : forall {α : Type.{w}} {β : Type.{w}} {γ : Type.{w}} {m : Type.{w} -> Type.{w'}} {n : Type.{w} -> Type.{w''}} [inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3807259526._hygCtx._hyg.11 : Monad.{w, w''} n] [inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3807259526._hygCtx._hyg.14 : Std.Iterator.{w, w'} α m β] {lift : forall {{α : Type.{w}}}, (m α) -> (n α)} {f : β -> (Std.Iterators.PostconditionT.{w, w''} n γ)}, Std.Iterator.{w, w''} (Std.Iterators.Types.Map.{w, w', w''} α β γ m n lift (Applicative.toFunctor.{w, w''} n (Monad.toApplicative.{w, w''} n inst._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3807259526._hygCtx._hyg.11)) f) n γ
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.Iterators.Types.Map.instIterator`.
-- In a full split, the body would be extracted from the environment.
