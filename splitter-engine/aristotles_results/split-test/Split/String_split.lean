import Split.Pure_pure
import Split.String_toSlice
import Split.String_Slice_Subslice
import Split.String_Slice_Subslice_toSlice
import Split.Monad_toApplicative
import Split.String
import Split.MonadLiftT_monadLift
import Split.String_Slice_Pattern_SearchStep
import Split.instMonadLiftT
import Split.String_Slice
import Split.String_Slice_Pattern_ToForwardSearcher
import Split.String_Slice_split
import Split.Id
import Split.Applicative_toPure
import Split.Std_Iterator
import Split.String_Slice_SplitIterator
import Split.Std_Iterators_instMonadPostconditionT
import Split.Std_Iter
import Split.Std_Iterators_Types_Map
import Split.Applicative_toFunctor
import Split.Std_Iterators_PostconditionT
import Split.Id_instMonad

-- String.split from environment
-- def String.split : forall {ρ : Type} {σ : String.Slice -> Type} [inst._@.Init.Data.String.Search.2230260967._hygCtx._hyg.6 : forall (s : String.Slice), Std.Iterator.{0, 0} (σ s) Id.{0} (String.Slice.Pattern.SearchStep s)] (s : String) (pat : ρ) [inst._@.Init.Data.String.Search.2230260967._hygCtx._hyg.43 : String.Slice.Pattern.ToForwardSearcher ρ pat σ], Std.Iter.{0} (Std.Iterators.Types.Map.{0, 0, 0} (String.Slice.SplitIterator σ ρ pat (String.toSlice s) inst._@.Init.Data.String.Search.2230260967._hygCtx._hyg.43) (String.Slice.Subslice (String.toSlice s)) String.Slice Id.{0} Id.{0} (fun {{x._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.41 : Type}} => MonadLiftT.monadLift.{0, 0, 0} Id.{0} Id.{0} (instMonadLiftT.{0, 0} Id.{0}) x._@.Init.Data.Iterators.Combinators.Monadic.FilterMap.3113823789._hygCtx._hyg.41) (Applicative.toFunctor.{0, 0} Id.{0} (Monad.toApplicative.{0, 0} Id.{0} Id.instMonad.{0})) (fun (b : String.Slice.Subslice (String.toSlice s)) => Pure.pure.{0, 0} (Std.Iterators.PostconditionT.{0, 0} Id.{0}) (Applicative.toPure.{0, 0} (Std.Iterators.PostconditionT.{0, 0} Id.{0}) (Monad.toApplicative.{0, 0} (Std.Iterators.PostconditionT.{0, 0} Id.{0}) (Std.Iterators.instMonadPostconditionT.{0, 0} Id.{0} Id.instMonad.{0}))) String.Slice (String.Slice.Subslice.toSlice (String.toSlice s) b))) String.Slice
-- (definition body omitted)

-- Stub: this file represents the declaration `String.split`.
-- In a full split, the body would be extracted from the environment.
