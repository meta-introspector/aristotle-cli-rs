/-
# Adapter two: *Nim*, three heaps and a partial `step`

The abstraction is not validated until a second game instantiates it
without the interface changing.  This is that second game, chosen to be
as unlike `Lights` as possible:

* moves carry data (which heap, how many) rather than an index;
* `step` is **partial** — taking more than a heap holds, or taking
  nothing, is rejected — so the runtime's "a rejected move changes
  nothing" path is exercised for real;
* the world has a turn flag, so the same click means different things in
  different states, which is why `decodeAction` takes the world.

Nothing in `Kant.Kernel.Core`, `.Runtime`, `.Share` or `.Render` changed
to accommodate it.

Proved here: the two validity bridges, that the total number of counters
strictly decreases along any legal move (`step_total_lt`, so games end),
and the illegal-move facts the runtime's rejection theorem needs.
-/
import Mathlib
import RequestProject.Kant.Kernel.Render

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Kernel.Nim

open Kant.Kernel

/-! ## The game -/

/-- Three heaps, and whose turn it is. -/
structure World where
  /-- The heap sizes. -/
  heaps : List Nat
  /-- `false` for the first player. -/
  turn : Bool
deriving DecidableEq, Repr, Inhabited

/-- The number of heaps. -/
abbrev heapCount : Nat := 3

/-- Take `take` counters from heap `heap`. -/
structure Move where
  /-- Which heap. -/
  heap : Fin heapCount
  /-- How many counters, at least one. -/
  take : Nat
deriving DecidableEq, Repr, Inhabited

/-- Remove `k` counters from position `i`. -/
def removeAt : List Nat → Nat → Nat → List Nat
  | [], _, _ => []
  | a :: as, 0, k => (a - k) :: as
  | a :: as, i + 1, k => a :: removeAt as i k

@[simp] theorem removeAt_length :
    ∀ (l : List Nat) (i k : Nat), (removeAt l i k).length = l.length
  | [], _, _ => rfl
  | _ :: _, 0, _ => rfl
  | _ :: as, i + 1, k => by simp [removeAt, removeAt_length as i k]

/-- Taking `k` from a heap that holds at least `k` reduces the total by
exactly `k`. -/
theorem removeAt_sum_add_le :
    ∀ (l : List Nat) (i k : Nat), k ≤ l.getD i 0 → (removeAt l i k).sum + k ≤ l.sum
  | [], _, k, h => by
      have hk : k = 0 := by simpa using h
      simp [removeAt, hk]
  | a :: as, 0, k, h => by
      simp only [List.getD_cons_zero] at h
      simp only [removeAt, List.sum_cons]
      omega
  | a :: as, i + 1, k, h => by
      simp only [List.getD_cons_succ] at h
      simp only [removeAt, List.sum_cons]
      have := removeAt_sum_add_le as i k h
      omega

/-- A move is legal when it takes at least one counter and no more than
the heap holds. -/
def legal (w : World) (m : Move) : Bool :=
  0 < m.take && decide (m.take ≤ (w.heaps.getD m.heap.val 0))

/-- The partial transition. -/
def stepN (w : World) (m : Move) : Option World :=
  if legal w m then some ⟨removeAt w.heaps m.heap.val m.take, !w.turn⟩ else none

/-- The seed deals three heaps of one to five counters. -/
def genN (s : SeedId) : Option World :=
  some ⟨[s % 5 + 1, (s / 5) % 5 + 1, (s / 25) % 5 + 1], false⟩

/-- Validity: three heaps. -/
def validN (w : World) : Bool := w.heaps.length == heapCount

/-- Every legal move of a world, largest heap index last. -/
def availableN (w : World) : List Move :=
  (List.finRange heapCount).flatMap fun i =>
    (List.range (w.heaps.getD i.val 0)).map fun k => ⟨i, k + 1⟩

/-- Read a move off the wire. -/
def decodeMoveN : List Nat → Option (Move × List Nat)
  | i :: k :: rest => if h : i < heapCount then some (⟨⟨i, h⟩, k⟩, rest) else none
  | _ => none

/-- The kernel. -/
def kernel : GameKernel where
  World := World
  Move := Move
  step := stepN
  gen := genN
  validB := validN
  availableMoves := availableN
  encodeMove := fun m => [m.heap.val, m.take]
  decodeMove := decodeMoveN
  decodeMove_encodeMove := by
    intro m rest
    simp only [List.cons_append, List.nil_append, decodeMoveN, dif_pos m.heap.isLt, Fin.eta]
  gen_valid := by
    intro s w h
    simp only [genN, Option.some.injEq] at h
    subst h
    simp [validN, heapCount]
  step_valid := by
    intro w m w' hv h
    simp only [stepN] at h
    by_cases hl : legal w m
    · rw [if_pos hl] at h
      simp only [Option.some.injEq] at h
      subst h
      simpa [validN] using hv
    · rw [if_neg hl] at h
      simp at h
  availableMoves_legal := by
    intro w m hm
    simp only [availableN, List.mem_flatMap, List.mem_map, List.mem_range] at hm
    obtain ⟨i, _, k, hk, rfl⟩ := hm
    have : legal w ⟨i, k + 1⟩ = true := by
      simp only [legal, Bool.and_eq_true, decide_eq_true_eq]
      exact ⟨by simp, by omega⟩
    simp [stepN, this]

/-! ## What the game says about itself -/

/-- The `Bool` check is the propositional predicate. -/
theorem validB_iff (w : World) : kernel.validB w = true ↔ w.heaps.length = heapCount := by
  simp [kernel, validN]

/-- Every world the runtime can display has three heaps. -/
theorem kernel_valid_of_replay {s : SeedId} {ms : List Move} {w : World}
    (h : kernel.replay s ms = some w) : w.heaps.length = heapCount :=
  (validB_iff w).mp (GameKernel.replay_valid h)

/-- Taking nothing is refused. -/
theorem step_eq_none_of_zero (w : World) (i : Fin heapCount) :
    stepN w ⟨i, 0⟩ = none := by
  simp [stepN, legal]

/-- Taking more than the heap holds is refused. -/
theorem step_eq_none_of_too_many {w : World} {m : Move}
    (h : w.heaps.getD m.heap.val 0 < m.take) : stepN w m = none := by
  have : legal w m = false := by
    simp only [legal, Bool.and_eq_false_iff, decide_eq_false_iff_not]
    exact Or.inr (by omega)
  simp [stepN, this]

/-- The game is finite: a legal move strictly reduces the total number of
counters. -/
theorem step_total_lt {w w' : World} {m : Move} (h : stepN w m = some w') :
    w'.heaps.sum < w.heaps.sum := by
  have hl : legal w m = true := by
    by_cases hl : legal w m
    · exact hl
    · rw [stepN, if_neg hl] at h; simp at h
  rw [stepN, if_pos hl] at h
  simp only [Option.some.injEq] at h
  subst h
  simp only [legal, Bool.and_eq_true, decide_eq_true_eq] at hl
  obtain ⟨hpos, hle⟩ := hl
  have hsum := removeAt_sum_add_le w.heaps m.heap.val m.take hle
  have hlt : (removeAt w.heaps m.heap.val m.take).sum < w.heaps.sum := by omega
  simpa using hlt

/-! ## The renderer -/

/-- One heap as a row of controls. -/
def heapNode (i : Nat) (n : Nat) : RenderTree :=
  .node "div".toList
    [("class".toList, "heap".toList), ("data-heap".toList, Codec.natChars i),
      ("data-size".toList, Codec.natChars n)]
    ((List.range n).map fun k =>
      .node "button".toList [("data-take".toList, Codec.natChars (k + 1))]
        [.text ['o']])

/-- The picture of a world. -/
def renderN (w : World) : RenderTree :=
  .node "div".toList [("class".toList, "nim".toList)]
    ((w.heaps.zipIdx.map fun p => heapNode p.2 p.1) ++
      [.node "p".toList [("class".toList, "turn".toList)]
        [.text (if w.turn then "player two".toList else "player one".toList)]])

/-- The controls: every legal take, in every heap. -/
def moveUIN (w : World) : List RenderAction :=
  (List.finRange heapCount).flatMap fun i =>
    (List.range (w.heaps.getD i.val 0)).map fun k =>
      ⟨'h' :: Codec.natChars i.val ++ '-' :: Codec.natChars (k + 1), [i.val, k + 1]⟩

/-- Reading a control back. -/
def decodeActionN (_ : World) (a : RenderAction) : Option Move :=
  match a.payload with
  | [i, k] => if h : i < heapCount then some ⟨⟨i, h⟩, k⟩ else none
  | _ => none

/-- The renderer. -/
def renderer : GameRenderer kernel where
  render := renderN
  moveUI := moveUIN
  decodeAction := decodeActionN
  moveUI_decodes := by
    intro w a ha
    simp only [moveUIN, List.mem_flatMap, List.mem_map, List.mem_range] at ha
    obtain ⟨i, _, k, _, rfl⟩ := ha
    simp only [decodeActionN, dif_pos i.isLt]
    rfl

/-- Strong completeness holds here too, because the move space is
finite and small — but note it is a *theorem about this game*, not a
field of the interface. -/
theorem renderer_exhaustive : Exhaustive renderer := by
  intro w m hm
  simp only [kernel, availableN, List.mem_flatMap, List.mem_map, List.mem_range] at hm
  obtain ⟨i, _, k, hk, rfl⟩ := hm
  refine ⟨⟨'h' :: Codec.natChars i.val ++ '-' :: Codec.natChars (k + 1), [i.val, k + 1]⟩, ?_, ?_⟩
  · simp only [renderer, moveUIN, List.mem_flatMap, List.mem_map, List.mem_range]
    exact ⟨i, List.mem_finRange i, k, hk, rfl⟩
  · simp only [renderer, decodeActionN, dif_pos i.isLt, Fin.eta]

end Kant.Kernel.Nim
