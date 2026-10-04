import Mathlib

set_option pp.all true
-- spec: String.Slice.Pos.ofSliceFrom : forall {s : String.Slice} {p₀ : String.Slice.Pos s}, (String.Slice.Pos (String.Slice.sliceFrom s p₀)) -> (String.Slice.Pos s)
def String.Slice.Pos.ofSliceFrom : forall {s : String.Slice} {p₀ : String.Slice.Pos s}, (String.Slice.Pos (String.Slice.sliceFrom s p₀)) -> (String.Slice.Pos s) :=
  fun {s : String.Slice} {p₀ : String.Slice.Pos s} (pos : String.Slice.Pos (String.Slice.sliceFrom s p₀)) => String.Slice.Pos.mk s (String.Pos.Raw.offsetBy (String.Slice.Pos.offset (String.Slice.sliceFrom s p₀) pos) (String.Slice.Pos.offset s p₀)) (String.Slice.Pos.ofSliceFrom._proof_1 s p₀ pos)
