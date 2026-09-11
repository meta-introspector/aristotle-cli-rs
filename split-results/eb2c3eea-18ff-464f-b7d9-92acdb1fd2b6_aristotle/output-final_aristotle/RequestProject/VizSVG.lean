import RequestProject.Viz

/-!
# An explicit, verified SVG generator for the animated layout

This module answers the "vector 1" follow-up to the layout-safety work in
`RequestProject.Viz`: it builds a concrete **SVG string generator** in Lean that emits the
animated movie frames, with the emitted geometry pinned to the *exact same* rational
coordinate map (`nodeToBox`) that `branchGraph_layout_clean` already certified to be
collision-free.

The generator is therefore not a separate, un-trusted renderer: the very list of boxes that
is turned into `<rect>` elements is the list whose pairwise spatial disjointness is proved
below (`frameBoxes_pairwise_disjoint`).  In other words, *what we draw is exactly what we
proved is non-overlapping*.

All coordinates are exact rationals (`ℚ`), so the renderer is fully computable and the
non-overlap statement is decidable and discharged by `native_decide`.
-/

namespace RequestProject.Compute.Viz

/-! ## The list of boxes that drives the renderer -/

/-- The ordered list of bounding boxes for a frame: box `i` is `nodeToBox i frame`.
This is the single source of truth shared by the renderer and the proof. -/
def frameBoxes (numNodes frame : ℕ) : List BoundingBox :=
  (List.range numNodes).map (fun i => nodeToBox i frame)

@[simp] theorem frameBoxes_length (numNodes frame : ℕ) :
    (frameBoxes numNodes frame).length = numNodes := by
  simp [frameBoxes]

/-- Every box actually rendered for a frame comes from the certified coordinate map. -/
theorem mem_frameBoxes_iff {numNodes frame : ℕ} {B : BoundingBox} :
    B ∈ frameBoxes numNodes frame ↔ ∃ i < numNodes, nodeToBox i frame = B := by
  simp [frameBoxes, List.mem_map, List.mem_range]

/-! ## SVG string emission -/

/-- Render one bounding box as an SVG `<rect>` element (exact rational coordinates). -/
def rectSVG (B : BoundingBox) : String :=
  "<rect x=\"" ++ toString B.x ++ "\" y=\"" ++ toString B.y ++
  "\" width=\"" ++ toString B.w ++ "\" height=\"" ++ toString B.h ++
  "\" fill=\"none\" stroke=\"black\"/>"

/-- The SVG opening tag sized to comfortably contain the whole grid. -/
def svgHeader : String :=
  "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"1200\" height=\"400\">"

/-- The SVG closing tag. -/
def svgFooter : String := "</svg>"

/-- Render a single animation frame to a complete SVG document string. -/
def renderFrame (numNodes frame : ℕ) : String :=
  svgHeader ++ String.join ((frameBoxes numNodes frame).map rectSVG) ++ svgFooter

/-- Render the whole movie: one SVG document per frame. -/
def renderMovie (numNodes numFrames : ℕ) : List String :=
  (List.range numFrames).map (fun f => renderFrame numNodes f)

@[simp] theorem renderMovie_length (numNodes numFrames : ℕ) :
    (renderMovie numNodes numFrames).length = numFrames := by
  simp [renderMovie]

/-! ## Soundness: the emitted geometry is exactly the certified collision-free geometry -/

/-- The boxes feeding the renderer are pairwise spatially disjoint in every one of the 13
movie frames.  This is the list-level restatement of `branchGraph_layout_clean`, phrased
directly about the data the SVG generator consumes, and certified by the kernel. -/
theorem frameBoxes_pairwise_disjoint :
    ∀ f < 13, (frameBoxes 14 f).Pairwise DisjointBoxes := by
  native_decide

/-- Each generated frame draws exactly one `<rect>` per node, i.e. one per certified box. -/
theorem renderFrame_box_count (numNodes frame : ℕ) :
    ((frameBoxes numNodes frame).map rectSVG).length = numNodes := by
  simp

-- A couple of concrete renders, for inspection.
-- (Frame 0 is the un-animated grid; frame 5 shows the per-frame offset applied.)
/-- info: 14 -/
#guard_msgs in
#eval (frameBoxes 14 0).length

#eval renderFrame 14 0
#eval renderFrame 14 5

end RequestProject.Compute.Viz
