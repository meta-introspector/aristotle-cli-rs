import Split.String
import Split.String_Slice_Pattern_SearchStep
import Split.Std_IteratorLoop
import Split.String_Slice
import Split.Id
import Split.Std_Iterator
import Split.String_Pos_revFind?
import Split.String_endPos
import Split.String_Pos
import Split.String_Slice_Pattern_ToBackwardSearcher
import Split.Option

-- String.revFind? from environment
-- def String.revFind? : forall {ρ : Type} {σ : String.Slice -> Type} [inst._@.Init.Data.String.Search.1083929940._hygCtx._hyg.6 : forall (s : String.Slice), Std.Iterator.{0, 0} (σ s) Id.{0} (String.Slice.Pattern.SearchStep s)] [inst._@.Init.Data.String.Search.1083929940._hygCtx._hyg.30 : forall (s : String.Slice), Std.IteratorLoop.{0, 0, 0, 0} (σ s) Id.{0} (String.Slice.Pattern.SearchStep s) (inst._@.Init.Data.String.Search.1083929940._hygCtx._hyg.6 s) Id.{0}] (s : String) (pattern : ρ) [inst._@.Init.Data.String.Search.1083929940._hygCtx._hyg.43 : String.Slice.Pattern.ToBackwardSearcher ρ pattern σ], Option.{0} (String.Pos s)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.revFind?`.
-- In a full split, the body would be extracted from the environment.
