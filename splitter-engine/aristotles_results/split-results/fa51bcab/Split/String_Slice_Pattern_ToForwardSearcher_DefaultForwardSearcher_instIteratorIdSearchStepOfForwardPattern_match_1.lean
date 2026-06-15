import Split.Unit_unit
import Split.Std_IterStep
import Split.String_Slice_Pattern_SearchStep
import Split.String_Slice
import Split.Std_IterStep_skip
import Split.String_Slice_Pattern_SearchStep_rejected
import Split.Id
import Split.String_Slice_Pattern_ToForwardSearcher_DefaultForwardSearcher
import Split.Unit
import Split.Std_IterStep_yield
import Split.String_Slice_Pattern_SearchStep_casesOn
import Split.String_Slice_Pattern_SearchStep_matched
import Split.Std_IterStep_done
import Split.Std_IterM
import Split.String_Slice_Pos
import Split.Std_IterStep_casesOn

-- String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.instIteratorIdSearchStepOfForwardPattern.match_1 from environment
-- def String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.instIteratorIdSearchStepOfForwardPattern.match_1 : forall {ρ : Type} (pat : ρ) (s : String.Slice) (motive : (Std.IterStep.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s)) -> Sort.{u_1}) (x._@.Init.Data.String.Pattern.Basic.3329460993._hygCtx.21.Init.Data.String.Pattern.Basic.3329460993._hygCtx._hyg.36 : Std.IterStep.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s)), (forall (it' : Std.IterM.{0, 0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) Id.{0} (String.Slice.Pattern.SearchStep s)) (p₁ : String.Slice.Pos s) (p₂ : String.Slice.Pos s), motive (Std.IterStep.yield.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s) it' (String.Slice.Pattern.SearchStep.rejected s p₁ p₂))) -> (forall (it' : Std.IterM.{0, 0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) Id.{0} (String.Slice.Pattern.SearchStep s)) (p₁ : String.Slice.Pos s) (p₂ : String.Slice.Pos s), motive (Std.IterStep.yield.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s) it' (String.Slice.Pattern.SearchStep.matched s p₁ p₂))) -> (Unit -> (motive (Std.IterStep.done.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s)))) -> (forall (it._@.Init.Data.String.Pattern.Basic.3329460993._hygCtx._hyg.183 : Std.IterM.{0, 0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) Id.{0} (String.Slice.Pattern.SearchStep s)), motive (Std.IterStep.skip.{1, 1} (Std.IterM.{0, 0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) Id.{0} (String.Slice.Pattern.SearchStep s)) (String.Slice.Pattern.SearchStep s) it._@.Init.Data.String.Pattern.Basic.3329460993._hygCtx._hyg.183)) -> (motive x._@.Init.Data.String.Pattern.Basic.3329460993._hygCtx.21.Init.Data.String.Pattern.Basic.3329460993._hygCtx._hyg.36)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.instIteratorIdSearchStepOfForwardPattern.match_1`.
-- In a full split, the body would be extracted from the environment.
