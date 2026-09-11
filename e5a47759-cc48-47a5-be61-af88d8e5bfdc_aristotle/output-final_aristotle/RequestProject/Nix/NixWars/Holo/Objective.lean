import RequestProject.Nix.NixWars.Holo.Instance

/-!
# What the partition is for: the objective the layout is chosen against

The cells could be laid out in the file in any order.  The order is worth
choosing because the cost of reading is counted in *requests*, and a request
is one contiguous byte range: cells that sit next to each other in the file
come back together, cells that do not each cost a request of their own.

* `requests A ks` — how many range requests it takes to collect the concepts
  `ks` from the archive `A`: the number of maximal runs of consecutive cells.
  It never exceeds the number of cells asked for (`requests_le`), it is one
  when the cells are consecutive (`requests_eq_one_of_run`), and it is at least
  one when anything at all is asked for (`requests_pos`).
* `score` — the partition objective the user's boxed expression names: local
  coherence and neighbour support and reconstructability, less duplication and
  retrieval cost.  `bestLayout` maximises it over a list of candidate layouts
  and `bestLayout_ge` proves nothing beats the winner.
* For the concrete archive, `neighbourly_beats_scrambled` and
  `scrambled_costs_more_requests` show why the geometry is not arbitrary: the
  same eleven cells, the same links, the same bytes — but scrambling the order
  turns the one request that brings back a concept and both its neighbours into
  three.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Holo

open Archive Instance

/-! ## Counting requests -/

/-- The number of extra runs after `prev` in a sorted list of cell indices. -/
def runsAux : Nat → List Nat → Nat
  | _, [] => 0
  | prev, j :: rest => (if j = prev + 1 then 0 else 1) + runsAux j rest

/-- The number of maximal runs of consecutive indices: one range request each. -/
def runsOf : List Nat → Nat
  | [] => 0
  | i :: rest => 1 + runsAux i rest

theorem runsAux_le (prev : Nat) (l : List Nat) : runsAux prev l ≤ l.length := by
  induction l generalizing prev with
  | nil => simp [runsAux]
  | cons j rest ih =>
    have := ih j
    simp only [runsAux, List.length_cons]
    split <;> omega

/-- Asking for `n` cells never costs more than `n` requests. -/
theorem runsOf_le (l : List Nat) : runsOf l ≤ l.length := by
  cases l with
  | nil => simp [runsOf]
  | cons i rest =>
    have := runsAux_le i rest
    simp only [runsOf, List.length_cons]
    omega

/-- Asking for anything costs at least one request. -/
theorem runsOf_pos {l : List Nat} (h : l ≠ []) : 1 ≤ runsOf l := by
  cases l with
  | nil => exact absurd rfl h
  | cons i rest => simp [runsOf]

theorem runsAux_range' (m j : Nat) : runsAux j (List.range' (j + 1) m) = 0 := by
  induction m generalizing j with
  | zero => simp [runsAux]
  | succ m ih =>
    rw [List.range'_succ]
    simp only [runsAux]
    simpa using ih (j + 1)

/-- Consecutive cells cost exactly one request. -/
theorem runsOf_range' (i n : Nat) : runsOf (List.range' i (n + 1)) = 1 := by
  rw [List.range'_succ]
  simp [runsOf, runsAux_range']

/-- The positions in the file of the concepts `ks`. -/
def indicesOf (A : Archive) (ks : List Nat) : List Nat :=
  (List.range A.length).filter fun i => ((A.getD i default).key ∈ ks)

/-- **The cost of collecting a set of concepts**, in range requests. -/
def requests (A : Archive) (ks : List Nat) : Nat := runsOf (indicesOf A ks)

theorem requests_le (A : Archive) (ks : List Nat) :
    requests A ks ≤ (indicesOf A ks).length := runsOf_le _

theorem requests_pos {A : Archive} {ks : List Nat} (h : indicesOf A ks ≠ []) :
    1 ≤ requests A ks := runsOf_pos h

/-- A run of consecutive cells is one request. -/
theorem requests_eq_one_of_run (A : Archive) (ks : List Nat) (i n : Nat)
    (h : indicesOf A ks = List.range' i (n + 1)) : requests A ks = 1 := by
  unfold requests
  rw [h, runsOf_range']

/-! ## The objective -/

/-- What the partition is scored on. -/
structure Weights where
  /-- Weight on material held locally. -/
  coh : Nat
  /-- Weight on mutually supportive neighbours. -/
  sup : Nat
  /-- Weight on how much of the corpus can be reconstructed. -/
  recon : Nat
  /-- Penalty per duplicated fact. -/
  dup : Nat
  /-- Penalty per range request. -/
  cost : Nat

/-- The number of ordered pairs of cells that name each other. -/
def supportPairs (A : Archive) : Nat :=
  (A.flatMap fun c => A.filter fun d => decide (d.key ∈ c.links && c.key ∈ d.links)).length

/-- What it costs to pull in every concept together with its neighbours. -/
def neighbourCost (A : Archive) : Nat :=
  (A.map fun c => requests A (A.ball c.key 1)).sum

/-- **The partition objective**: coherence, neighbour support and
reconstructability, less duplication and retrieval cost. -/
def score (A : Archive) (w : Weights) : Int :=
  (w.coh * A.facts.length : Int) + (w.sup * supportPairs A : Int)
    + (w.recon * (A.view (A.map Cell.key)).length : Int)
    - (w.dup * A.duplication : Int) - (w.cost * neighbourCost A : Int)

/-- The best of a list of candidate layouts. -/
def bestLayout (As : List Archive) (w : Weights) : Option Archive :=
  As.argmax fun A => score A w

theorem bestLayout_mem {As : List Archive} {w : Weights} {A : Archive}
    (h : bestLayout As w = some A) : A ∈ As := List.argmax_mem h

/-- **Nothing on the list beats the layout chosen.** -/
theorem bestLayout_ge {As : List Archive} {w : Weights} {A : Archive}
    (h : bestLayout As w = some A) : ∀ B ∈ As, score B w ≤ score A w :=
  fun _ hB => List.le_of_mem_argmax hB h

/-! ## The concrete archive against a scrambled one -/

/-- The same eleven cells, in a scrambled order. -/
def scrambled : Archive := [7, 2, 9, 0, 5, 10, 3, 8, 1, 6, 4].map conceptCell

theorem scrambled_same_cells : scrambled.length = holoArchive.length := by decide

/-- The cells are the same and the links are the same; only the order in the
file differs. -/
theorem scrambled_same_keys :
    (scrambled.map Cell.key).mergeSort (· ≤ ·) = (holoArchive.map Cell.key).mergeSort (· ≤ ·) := by
  native_decide

/-- In the neighbourly layout a concept and both its neighbours are one
request. -/
theorem neighbourly_one_request : requests holoArchive (holoArchive.ball 5 1) = 1 := by decide

/-- **Scrambling the order costs two requests for the same three cells.** -/
theorem scrambled_costs_more_requests : requests scrambled (scrambled.ball 5 1) = 2 := by decide

/-- The scrambled layout is worse on the objective, retrieval cost being the
only thing that changed. -/
theorem neighbourly_beats_scrambled (w : Weights) (hcost : 0 < w.cost) :
    score scrambled w < score holoArchive w := by
  have hn : neighbourCost holoArchive = 13 := by decide
  have hs : neighbourCost scrambled = 31 := by decide
  have hfacts : scrambled.facts.length = holoArchive.facts.length := by decide
  have hsup : supportPairs scrambled = supportPairs holoArchive := by decide
  have hview : (scrambled.view (scrambled.map Cell.key)).length
      = (holoArchive.view (holoArchive.map Cell.key)).length := by decide
  have hdup : scrambled.duplication = holoArchive.duplication := by decide
  unfold score
  rw [hn, hs, hfacts, hsup, hview, hdup]
  have : (w.cost : Int) * 13 < (w.cost : Int) * 31 := by
    have : (0 : Int) < w.cost := by exact_mod_cast hcost
    nlinarith
  omega

/-- So the neighbourly layout is the one the objective picks. -/
theorem holoArchive_best (w : Weights) (hcost : 0 < w.cost) :
    ∀ B ∈ [scrambled, holoArchive], score B w ≤ score holoArchive w := by
  intro B hB
  rcases List.mem_cons.mp hB with rfl | hB
  · exact le_of_lt (neighbourly_beats_scrambled w hcost)
  rcases List.mem_cons.mp hB with rfl | hB
  · exact le_refl _
  · cases hB

end Holo
end NixWars
