import Split.String_toSlice
import Split.String
import Split.String_Slice_Pattern_SearchStep
import Split.String_Pos_toSlice
import Split.Std_IteratorLoop
import Split.String_Slice
import Split.Id
import Split.Std_Iterator
import Split.Option_map
import Split.String_Pos_ofToSlice
import Split.String_Pos
import Split.String_Slice_Pos
import Split.String_Slice_Pos_revFind?
import Split.String_Slice_Pattern_ToBackwardSearcher
import Split.Option

-- String.Pos.revFind? from environment
-- def String.Pos.revFind? : forall {ρ : Type} {σ : String.Slice -> Type} [inst._@.Init.Data.String.Search.1083929939._hygCtx._hyg.6 : forall (s : String.Slice), Std.Iterator.{0, 0} (σ s) Id.{0} (String.Slice.Pattern.SearchStep s)] [inst._@.Init.Data.String.Search.1083929939._hygCtx._hyg.30 : forall (s : String.Slice), Std.IteratorLoop.{0, 0, 0, 0} (σ s) Id.{0} (String.Slice.Pattern.SearchStep s) (inst._@.Init.Data.String.Search.1083929939._hygCtx._hyg.6 s) Id.{0}] {s : String}, (String.Pos s) -> (forall (pattern : ρ) [inst._@.Init.Data.String.Search.1083929939._hygCtx._hyg.44 : String.Slice.Pattern.ToBackwardSearcher ρ pattern σ], Option.{0} (String.Pos s))
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Pos.revFind?`.
-- In a full split, the body would be extracted from the environment.
