import Split.Unit_unit
import Split.String_Slice_Subslice
import Split.String_Slice_Pattern_SearchStep
import Split.String_Slice
import Split.Std_IterM_mk
import Split.String_Slice_SplitIterator_operating
import Split.String_Slice_Pattern_ToForwardSearcher
import Split.Id
import Split.String_Slice_SplitIterator
import Split.Unit
import Split.Std_Iter
import Split.String_Slice_SplitIterator_casesOn
import Split.Std_IterM
import Split.String_Slice_Pos
import Split.String_Slice_SplitIterator_atEnd
import Split.Std_IterM_casesOn

-- String.Slice.SplitIterator.instIteratorIdSubslice.match_5 from environment
-- def String.Slice.SplitIterator.instIteratorIdSubslice.match_5 : forall {ρ : Type} {σ : String.Slice -> Type} {pat : ρ} [inst._@.Init.Data.String.Slice.2112480873._hygCtx._hyg.42 : String.Slice.Pattern.ToForwardSearcher ρ pat σ] {s : String.Slice} (motive : (Std.IterM.{0, 0} (String.Slice.SplitIterator σ ρ pat s inst._@.Init.Data.String.Slice.2112480873._hygCtx._hyg.42) Id.{0} (String.Slice.Subslice s)) -> Sort.{u_1}) (x._@.Init.Data.String.Slice.2112480873._hygCtx.64.Init.Data.String.Slice.2112480873._hygCtx._hyg.282 : Std.IterM.{0, 0} (String.Slice.SplitIterator σ ρ pat s inst._@.Init.Data.String.Slice.2112480873._hygCtx._hyg.42) Id.{0} (String.Slice.Subslice s)), (forall (currPos : String.Slice.Pos s) (searcher : Std.Iter.{0} (σ s) (String.Slice.Pattern.SearchStep s)), motive (Std.IterM.mk.{0, 0} (String.Slice.SplitIterator σ ρ pat s inst._@.Init.Data.String.Slice.2112480873._hygCtx._hyg.42) Id.{0} (String.Slice.Subslice s) (String.Slice.SplitIterator.operating σ ρ pat s inst._@.Init.Data.String.Slice.2112480873._hygCtx._hyg.42 currPos searcher))) -> (Unit -> (motive (Std.IterM.mk.{0, 0} (String.Slice.SplitIterator σ ρ pat s inst._@.Init.Data.String.Slice.2112480873._hygCtx._hyg.42) Id.{0} (String.Slice.Subslice s) (String.Slice.SplitIterator.atEnd σ ρ pat s inst._@.Init.Data.String.Slice.2112480873._hygCtx._hyg.42)))) -> (motive x._@.Init.Data.String.Slice.2112480873._hygCtx.64.Init.Data.String.Slice.2112480873._hygCtx._hyg.282)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.SplitIterator.instIteratorIdSubslice.match_5`.
-- In a full split, the body would be extracted from the environment.
