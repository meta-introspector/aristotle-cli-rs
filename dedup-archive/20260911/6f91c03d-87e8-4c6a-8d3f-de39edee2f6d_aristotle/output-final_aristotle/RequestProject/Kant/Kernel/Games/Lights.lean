/-
# Adapter one: *Lights*, a five-cell lights-out row

The first instance of `GameKernel`.  Its job is to show that the generic
runtime, share codec and renderer interface survive contact with a real
game: everything below is either a field of the two records or a
game-specific theorem, and nothing in this file changes the interface.

The world is five lamps; a move presses one of them, flipping it and its
neighbours; the seed fills the row from its bits.  Every press is legal,
so this game exercises the *total* end of the interface — `Nim` next door
exercises the partial end.

Proved here:

* `validB_iff` — the `Bool` validity check means what the propositional
  reading says (§2 of the review: a browser can check it);
* `kernel_valid_of_replay` — every replayed world has five lamps;
* `renderer_exhaustive` — for this game the strong form of completeness
  holds: every legal move has a control on screen.
-/
import Mathlib
import RequestProject.Kant.Kernel.Render

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Kernel.Lights

open Kant.Kernel

/-! ## The game -/

/-- A row of lamps. -/
structure World where
  /-- The lamps, `true` for lit. -/
  cells : List Bool
deriving DecidableEq, Repr, Inhabited

/-- The row is five wide. -/
abbrev width : Nat := 5

/-- A move presses one lamp. -/
abbrev Move := Fin width

/-- Pressing lamp `i` flips it and its two neighbours. -/
def press (cells : List Bool) (i : Nat) : List Bool :=
  cells.zipIdx.map fun p => if p.2 = i ∨ p.2 + 1 = i ∨ p.2 = i + 1 then !p.1 else p.1

@[simp] theorem press_length (cells : List Bool) (i : Nat) :
    (press cells i).length = cells.length := by
  simp [press]

/-- Every press is legal. -/
def stepL (w : World) (m : Move) : Option World := some ⟨press w.cells m.val⟩

/-- The seed fills the row from its low five bits. -/
def genL (s : SeedId) : Option World :=
  some ⟨(List.range width).map fun i => (s >>> i) % 2 == 1⟩

/-- Validity: the row is the right width. -/
def validL (w : World) : Bool := w.cells.length == width

/-- Read a move off the wire. -/
def decodeMoveL : List Nat → Option (Move × List Nat)
  | [] => none
  | n :: rest => if h : n < width then some (⟨n, h⟩, rest) else none

/-- The kernel: the whole game, as the generic layer sees it. -/
def kernel : GameKernel where
  World := World
  Move := Move
  step := stepL
  gen := genL
  validB := validL
  availableMoves := fun _ => List.finRange width
  encodeMove := fun m => [m.val]
  decodeMove := decodeMoveL
  decodeMove_encodeMove := by
    intro m rest
    simp only [List.cons_append, List.nil_append, decodeMoveL, dif_pos m.isLt]
  gen_valid := by
    intro s w h
    simp only [genL, Option.some.injEq] at h
    subst h
    simp [validL, width]
  step_valid := by
    intro w m w' hv h
    simp only [stepL, Option.some.injEq] at h
    subst h
    simpa [validL] using hv
  availableMoves_legal := by
    intro w m _
    simp [stepL]

/-! ## What the game says about itself -/

/-- The `Bool` check is the propositional predicate: this is the bridge
the browser needs. -/
theorem validB_iff (w : World) : kernel.validB w = true ↔ w.cells.length = width := by
  simp [kernel, validL]

/-- Every world the runtime can display has five lamps. -/
theorem kernel_valid_of_replay {s : SeedId} {ms : List Move} {w : World}
    (h : kernel.replay s ms = some w) : w.cells.length = width :=
  (validB_iff w).mp (GameKernel.replay_valid h)

/-- The row is solved when every lamp is out. -/
def solved (w : World) : Bool := w.cells.all (fun b => !b)

/-! ## The renderer -/

/-- The label of the control for lamp `i`. -/
def cellLabel (i : Nat) : List Char := ('l' :: 'a' :: 'm' :: 'p' :: ' ' :: Codec.natChars i)

/-- One lamp as a node. -/
def cellNode (i : Nat) (b : Bool) : RenderTree :=
  .node "button".toList
    [("data-cell".toList, Codec.natChars i), ("data-on".toList, if b then ['1'] else ['0'])]
    [.text (if b then ['*'] else ['.'])]

/-- The picture of a world: the row, then a line of status. -/
def renderL (w : World) : RenderTree :=
  .node "div".toList [("class".toList, "lights".toList)]
    ((w.cells.zipIdx.map fun p => cellNode p.2 p.1) ++
      [.node "p".toList [("class".toList, "status".toList)]
        [.text (if solved w then "all out".toList else "still lit".toList)]])

/-- The controls: one per lamp. -/
def moveUIL (_ : World) : List RenderAction :=
  (List.range width).map fun i => ⟨cellLabel i, [i]⟩

/-- Reading a control back.  The world is available but this game does
not need it. -/
def decodeActionL (_ : World) (a : RenderAction) : Option Move :=
  match a.payload with
  | [n] => if h : n < width then some ⟨n, h⟩ else none
  | _ => none

/-- The renderer. -/
def renderer : GameRenderer kernel where
  render := renderL
  moveUI := moveUIL
  decodeAction := decodeActionL
  moveUI_decodes := by
    intro w a ha
    simp only [moveUIL, List.mem_map, List.mem_range] at ha
    obtain ⟨i, hi, rfl⟩ := ha
    simp only [decodeActionL, dif_pos hi]
    rfl

/-- **Strong completeness holds for this game**: every legal move has a
control on screen. -/
theorem renderer_exhaustive : Exhaustive renderer := by
  intro w m _
  refine ⟨⟨cellLabel m.val, [m.val]⟩, ?_, ?_⟩
  · simp only [renderer, moveUIL, List.mem_map, List.mem_range]
    exact ⟨m.val, m.isLt, rfl⟩
  · show decodeActionL w ⟨cellLabel m.val, [m.val]⟩ = some m
    simp only [decodeActionL, dif_pos m.isLt, Fin.eta]

end Kant.Kernel.Lights
