import Split.Unit_unit
import Split.Std_IterStep
import Split.String_Slice_Pattern_SearchStep
import Split.String_Slice
import Split.Std_IterStep_skip
import Split.Id
import Split.Unit
import Split.Std_IterStep_yield
import Split.Std_IterStep_done
import Split.Std_IterM
import Split.String_Slice_Pattern_ForwardSliceSearcher
import Split.Std_IterStep_casesOn

-- String.Slice.Pattern.ForwardSliceSearcher.instIteratorIdSearchStep.match_3 from environment
-- def String.Slice.Pattern.ForwardSliceSearcher.instIteratorIdSearchStep.match_3 : forall (s : String.Slice) (motive : (Std.IterStep.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ForwardSliceSearcher s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s)) -> Sort.{u_1}) (x._@.Init.Data.String.Pattern.String.978949264._hygCtx.15.Init.Data.String.Pattern.String.978949264._hygCtx._hyg.31 : Std.IterStep.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ForwardSliceSearcher s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s)), (forall (it' : Std.IterM.{0, 0} (String.Slice.Pattern.ForwardSliceSearcher s) Id.{0} (String.Slice.Pattern.SearchStep s)) (out : String.Slice.Pattern.SearchStep s), motive (Std.IterStep.yield.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ForwardSliceSearcher s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s) it' out)) -> (forall (it' : Std.IterM.{0, 0} (String.Slice.Pattern.ForwardSliceSearcher s) Id.{0} (String.Slice.Pattern.SearchStep s)), motive (Std.IterStep.skip.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ForwardSliceSearcher s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s) it')) -> (Unit -> (motive (Std.IterStep.done.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ForwardSliceSearcher s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s)))) -> (motive x._@.Init.Data.String.Pattern.String.978949264._hygCtx.15.Init.Data.String.Pattern.String.978949264._hygCtx._hyg.31)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.Pattern.ForwardSliceSearcher.instIteratorIdSearchStep.match_3`.
-- In a full split, the body would be extracted from the environment.
