import Split.String_Slice_Pattern_SearchStep
import Split.String_Slice
import Split.String_Slice_SplitIterator_operating
import Split.String_Slice_Pattern_ToForwardSearcher
import Split.String_Slice_SplitIterator
import Split.String_Slice_SplitIterator_rec
import Split.Std_Iter
import Split.String_Slice_Pos
import Split.String_Slice_SplitIterator_atEnd

-- String.Slice.SplitIterator.casesOn from environment
-- def String.Slice.SplitIterator.casesOn : forall {σ : String.Slice -> Type} {ρ : Type} {pat : ρ} {s : String.Slice} [inst._@.Init.Data.String.Slice.3008739384._hygCtx._hyg.83 : String.Slice.Pattern.ToForwardSearcher ρ pat σ] {motive : (String.Slice.SplitIterator σ ρ pat s inst._@.Init.Data.String.Slice.3008739384._hygCtx._hyg.83) -> Sort.{u}} (t : String.Slice.SplitIterator σ ρ pat s inst._@.Init.Data.String.Slice.3008739384._hygCtx._hyg.83), (forall (currPos : String.Slice.Pos s) (searcher : Std.Iter.{0} (σ s) (String.Slice.Pattern.SearchStep s)), motive (String.Slice.SplitIterator.operating σ ρ pat s inst._@.Init.Data.String.Slice.3008739384._hygCtx._hyg.83 currPos searcher)) -> (motive (String.Slice.SplitIterator.atEnd σ ρ pat s inst._@.Init.Data.String.Slice.3008739384._hygCtx._hyg.83)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.SplitIterator.casesOn`.
-- In a full split, the body would be extracted from the environment.
