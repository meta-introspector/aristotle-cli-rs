import Split.outParam
import Split.String_Slice_Pattern_SearchStep
import Split.String_Slice
import Split.String_Slice_Pattern_ToForwardSearcher
import Split.Std_Iter

-- String.Slice.Pattern.ToForwardSearcher.toSearcher from environment
-- def String.Slice.Pattern.ToForwardSearcher.toSearcher : forall {ρ : Type} (pat : ρ) {σ : outParam.{2} (String.Slice -> Type)} [self : String.Slice.Pattern.ToForwardSearcher ρ pat σ] (s : String.Slice), Std.Iter.{0} (σ s) (String.Slice.Pattern.SearchStep s)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.Pattern.ToForwardSearcher.toSearcher`.
-- In a full split, the body would be extracted from the environment.
