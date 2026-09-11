import Mathlib

/-!
# The discrete half of the language: cellular automata, Life, ants and FRACTRAN

The semantics of `web/js/automata.js`, which is what the `ca`, `life`, `ant`
and `fractran` statements of a playbook mean.

Everything in this file is finite discrete arithmetic — `Nat` and `Bool` — so
unlike the analytic layers (the shader, escape time, the formula evaluator)
none of the statements here carry a floating-point assumption.  The JavaScript
runtime can be, and in `tests/node/test_automata.mjs` is, compared against
these definitions exactly.

What is proved here:

* **elementary cellular automata** — `length_elemStep` (the row keeps its
  width, so the picture is a rectangle), `elemStep_getElem` (the cell the
  runtime writes is the rule bit of the neighbourhood it read),
  `elemStep_rule_zero` / `elemStep_rule_255` (the constant rules),
  `elemStep_rule90` and `elemStep_rule30` (the two closed forms the runtime
  uses as a fast path), and `length_evolve` (a run of `g` generations really
  has `g + 1` rows, so the generation budget bounds the work);
* **Life-like rules in B/S notation** — `lifeStep_dims` (the grid keeps its
  shape), `lifeStep_empty` (an empty universe stays empty unless the rule
  births on zero neighbours), `life_block_still` and `life_blinker_period`
  (the two canonical Conway patterns, checked by evaluation);
* **Langton's ant** — `antStep_dims`, `antStep_pos_lt` (the head stays on the
  torus) and `antStep_reversible`: the ant's inverse step undoes its step, so
  a trace of the ant can be replayed backwards as well as forwards;
* **FRACTRAN** — `step_eq_some_iff` and `step_eq_none_iff` (the step really is
  "the first fraction of the program that keeps the state a whole number"),
  `run_length_le` and `run_take` (the run is a prefix-stable list bounded by
  the step budget), and `run_addition`: the one-fraction program `3/2` sends
  `2^a·3^b` to `3^(a+b)` in exactly `a` steps and then halts.
-/

namespace Hesper.Automata

/-! ## Elementary cellular automata

A row is a list of cells that wraps around, so index arithmetic is mod the
width and a row of width `0` reads as all-dead.
-/

/-- The cell at `i`, with the row read as a circle. -/
def cell (row : List Bool) (i : Nat) : Bool := row.getD (i % row.length) false

/-- The Wolfram neighbourhood code of `left`, `centre`, `right`: a number in `[0, 8)`. -/
def nbhd (l c r : Bool) : Nat :=
  (if l then 4 else 0) + (if c then 2 else 0) + (if r then 1 else 0)

theorem nbhd_lt_eight (l c r : Bool) : nbhd l c r < 8 := by
  cases l <;> cases c <;> cases r <;> simp [nbhd]

/-- One generation of the elementary rule `rule` (0 ≤ rule < 256) on a circular row. -/
def elemStep (rule : Nat) (row : List Bool) : List Bool :=
  (List.range row.length).map fun i =>
    rule.testBit (nbhd (cell row (i + row.length - 1)) (cell row i) (cell row (i + 1)))

@[simp] theorem length_elemStep (rule : Nat) (row : List Bool) :
    (elemStep rule row).length = row.length := by
  simp [elemStep]

/-- The cell the runtime writes is exactly the rule's bit for the neighbourhood it read. -/
theorem elemStep_getElem (rule : Nat) (row : List Bool) (i : Nat)
    (h : i < (elemStep rule row).length) :
    (elemStep rule row)[i] =
      rule.testBit (nbhd (cell row (i + row.length - 1)) (cell row i) (cell row (i + 1))) := by
  simp [elemStep] at h ⊢

/-- Rule 0 kills everything. -/
theorem elemStep_rule_zero (row : List Bool) :
    elemStep 0 row = List.replicate row.length false := by
  refine List.ext_getElem (by simp) ?_
  intro i h₁ h₂
  simp [elemStep]

/-- Rule 255 fills everything. -/
theorem elemStep_rule_255 (row : List Bool) :
    elemStep 255 row = List.replicate row.length true := by
  refine List.ext_getElem (by simp) ?_
  intro i h₁ h₂
  have := nbhd_lt_eight (cell row (i + row.length - 1)) (cell row i) (cell row (i + 1))
  simp only [elemStep, List.getElem_map, List.getElem_range, List.getElem_replicate]
  interval_cases h : nbhd (cell row (i + row.length - 1)) (cell row i) (cell row (i + 1)) <;>
    simp_all [Nat.testBit]

/-- Rule 90 is the exclusive-or of the two neighbours — the Sierpiński rule. -/
theorem elemStep_rule90 (l c r : Bool) : Nat.testBit 90 (nbhd l c r) = xor l r := by
  cases l <;> cases c <;> cases r <;> rfl

/-- Rule 30, in the closed form the runtime uses. -/
theorem elemStep_rule30 (l c r : Bool) : Nat.testBit 30 (nbhd l c r) = xor l (c || r) := by
  cases l <;> cases c <;> cases r <;> rfl

/-- Rule 110, in the closed form the runtime uses. -/
theorem elemStep_rule110 (l c r : Bool) :
    Nat.testBit 110 (nbhd l c r) = ((c || r) && !(l && c && r)) := by
  cases l <;> cases c <;> cases r <;> rfl

/-- `g` generations of a rule, oldest row first; the seed row is included. -/
def evolve (rule : Nat) (row : List Bool) : Nat → List (List Bool)
  | 0 => [row]
  | g + 1 => row :: evolve rule (elemStep rule row) g

@[simp] theorem length_evolve (rule : Nat) (row : List Bool) (g : Nat) :
    (evolve rule row g).length = g + 1 := by
  induction g generalizing row with
  | zero => simp [evolve]
  | succ g ih => simp [evolve, ih]

/-- Every row of a run has the width of the seed. -/
theorem evolve_width (rule : Nat) (row : List Bool) (g : Nat) :
    ∀ r ∈ evolve rule row g, r.length = row.length := by
  induction g generalizing row with
  | zero => simp [evolve]
  | succ g ih =>
    intro r hr
    rcases List.mem_cons.1 hr with h | h
    · simp [h]
    · simpa using ih (elemStep rule row) r h

/-! ## Life-like rules

A grid is a flat list of cells of length `w * h`, read as a torus.  A rule is
given in B/S notation: `birth` is the neighbour counts that bring a dead cell
to life, `survive` the counts a live cell survives.  Conway's Life is `B3/S23`.
-/

/-- A rectangular board of cells, read as a torus. -/
@[ext] structure Grid where
  w : Nat
  h : Nat
  cells : List Bool
  deriving Repr, DecidableEq

namespace Grid

/-- The linear index of `(x, y)` on the torus. -/
def index (g : Grid) (x y : Nat) : Nat := (y % g.h) * g.w + (x % g.w)

/-- The cell at `(x, y)`, wrapping in both directions. -/
def get (g : Grid) (x y : Nat) : Bool := g.cells.getD (g.index x y) false

/-- The board with the cell at `(x, y)` inverted. -/
def flip (g : Grid) (x y : Nat) : Grid :=
  { g with cells := g.cells.set (g.index x y) (!g.get x y) }

@[simp] theorem flip_w (g : Grid) (x y : Nat) : (g.flip x y).w = g.w := rfl
@[simp] theorem flip_h (g : Grid) (x y : Nat) : (g.flip x y).h = g.h := rfl
@[simp] theorem length_flip (g : Grid) (x y : Nat) : (g.flip x y).cells.length = g.cells.length := by
  simp [flip]

/-- Inverting the same cell twice is the identity. -/
@[simp] theorem flip_flip (g : Grid) (x y : Nat) : (g.flip x y).flip x y = g := by
  have hidx : (g.flip x y).index x y = g.index x y := rfl
  rcases lt_or_ge (g.index x y) g.cells.length with hlt | hge
  · have hget : (g.flip x y).get x y = !g.get x y := by
      show (g.flip x y).cells.getD ((g.flip x y).index x y) false = _
      rw [hidx]
      show (g.cells.set (g.index x y) (!g.get x y)).getD (g.index x y) false = _
      rw [List.getD_eq_getElem _ _ (by simpa using hlt), List.getElem_set_self]
    ext1
    · rfl
    · rfl
    · show ((g.cells.set (g.index x y) (!g.get x y)).set ((g.flip x y).index x y)
          (!(g.flip x y).get x y)) = g.cells
      rw [hidx, hget, List.set_set, Bool.not_not, get, List.getD_eq_getElem _ _ hlt,
        List.set_getElem_self]
  · have h1 : g.cells.set (g.index x y) (!g.get x y) = g.cells :=
      List.set_eq_of_length_le hge
    ext1
    · rfl
    · rfl
    · show ((g.cells.set (g.index x y) (!g.get x y)).set ((g.flip x y).index x y)
          (!(g.flip x y).get x y)) = g.cells
      rw [hidx, h1, List.set_eq_of_length_le hge]

end Grid

/-- A Life-like rule in B/S notation. -/
structure LifeRule where
  birth : List Nat
  survive : List Nat
  deriving Repr, DecidableEq

/-- Conway's Life: `B3/S23`. -/
def conway : LifeRule := { birth := [3], survive := [2, 3] }

/-- HighLife: `B36/S23`. -/
def highLife : LifeRule := { birth := [3, 6], survive := [2, 3] }

/-- The eight Moore-neighbourhood offsets, as (dx, dy) with the coordinates
    already shifted by the width and height to keep them natural. -/
def mooreOffsets : List (Nat × Nat) :=
  [(0, 0), (1, 0), (2, 0), (0, 1), (2, 1), (0, 2), (1, 2), (2, 2)]

/-- How many of the eight neighbours of `(x, y)` are alive. -/
def neighbours (g : Grid) (x y : Nat) : Nat :=
  (mooreOffsets.filter fun o => g.get (x + g.w + o.1 - 1) (y + g.h + o.2 - 1)).length

theorem neighbours_le_eight (g : Grid) (x y : Nat) : neighbours g x y ≤ 8 := by
  have := List.length_filter_le (fun o => g.get (x + g.w + o.1 - 1) (y + g.h + o.2 - 1)) mooreOffsets
  simpa [neighbours, mooreOffsets] using this

/-- The next state of one cell under a B/S rule. -/
def lifeCell (r : LifeRule) (alive : Bool) (n : Nat) : Bool :=
  if alive then r.survive.contains n else r.birth.contains n

/-- One generation of a Life-like rule. -/
def lifeStep (r : LifeRule) (g : Grid) : Grid :=
  { g with cells := (List.range (g.w * g.h)).map fun k =>
      lifeCell r (g.get (k % g.w) (k / g.w)) (neighbours g (k % g.w) (k / g.w)) }

@[simp] theorem lifeStep_w (r : LifeRule) (g : Grid) : (lifeStep r g).w = g.w := rfl
@[simp] theorem lifeStep_h (r : LifeRule) (g : Grid) : (lifeStep r g).h = g.h := rfl

/-- A step keeps the board rectangular and of the declared size. -/
theorem lifeStep_dims (r : LifeRule) (g : Grid) :
    (lifeStep r g).w = g.w ∧ (lifeStep r g).h = g.h ∧
      (lifeStep r g).cells.length = g.w * g.h := by
  refine ⟨rfl, rfl, ?_⟩
  simp [lifeStep]

/-- An empty universe stays empty, unless the rule births on no neighbours. -/
theorem lifeStep_empty (r : LifeRule) (w h : Nat) (hr : ¬ (0 ∈ r.birth)) :
    lifeStep r ⟨w, h, List.replicate (w * h) false⟩
      = ⟨w, h, List.replicate (w * h) false⟩ := by
  set g : Grid := ⟨w, h, List.replicate (w * h) false⟩ with hg
  have hdead : ∀ x y, g.get x y = false := by
    intro x y
    simp only [hg, Grid.get, List.getD_eq_getElem?_getD, List.getElem?_replicate]
    split <;> rfl
  have hn : ∀ x y, neighbours g x y = 0 := by
    intro x y
    simp [neighbours, mooreOffsets, hdead]
  ext1
  · rfl
  · rfl
  · show ((List.range (g.w * g.h)).map fun k =>
        lifeCell r (g.get (k % g.w) (k / g.w)) (neighbours g (k % g.w) (k / g.w)))
      = List.replicate (w * h) false
    refine List.ext_getElem (by simp [hg]) ?_
    intro i h₁ h₂
    simp only [List.getElem_map, List.getElem_range, List.getElem_replicate]
    rw [hdead, hn]
    simpa [lifeCell] using hr

/-- `n` generations of a Life-like rule. -/
def lifeRun (r : LifeRule) (g : Grid) : Nat → Grid
  | 0 => g
  | n + 1 => lifeRun r (lifeStep r g) n

/-- The 2×2 block on a 4×4 torus is a still life under Conway's rule. -/
theorem life_block_still :
    lifeStep conway ⟨4, 4, [false, false, false, false,
                            false, true,  true,  false,
                            false, true,  true,  false,
                            false, false, false, false]⟩
      = ⟨4, 4, [false, false, false, false,
                false, true,  true,  false,
                false, true,  true,  false,
                false, false, false, false]⟩ := by
  decide

/-- The blinker on a 5×5 torus has period two under Conway's rule. -/
theorem life_blinker_period :
    lifeRun conway ⟨5, 5, [false, false, false, false, false,
                           false, false, true,  false, false,
                           false, false, true,  false, false,
                           false, false, true,  false, false,
                           false, false, false, false, false]⟩ 2
      = ⟨5, 5, [false, false, false, false, false,
                false, false, true,  false, false,
                false, false, true,  false, false,
                false, false, true,  false, false,
                false, false, false, false, false]⟩ := by
  decide

/-! ## Langton's ant

The same board with a moving head.  A turmite is the general form: a table
saying, for each (state, colour), what colour to write, how to turn and what
state to enter.  Langton's ant is the two-colour, one-state case.
-/

/-- A head on the torus: a position and a direction (0 = north, 1 = east, 2 = south, 3 = west). -/
@[ext] structure Head where
  x : Nat
  y : Nat
  dir : Nat
  deriving Repr, DecidableEq

/-- The board together with its head. -/
@[ext] structure AntState where
  grid : Grid
  head : Head
  deriving Repr, DecidableEq

/-- Move one cell in the head's direction, wrapping on the torus. -/
def Head.forward (hd : Head) (w h : Nat) : Head :=
  match hd.dir % 4 with
  | 0 => { hd with y := (hd.y + h - 1) % h }
  | 1 => { hd with x := (hd.x + 1) % w }
  | 2 => { hd with y := (hd.y + 1) % h }
  | _ => { hd with x := (hd.x + w - 1) % w }

/-- Move one cell against the head's direction, keeping the heading. -/
def Head.backward (hd : Head) (w h : Nat) : Head :=
  let back := ({ hd with dir := (hd.dir + 2) % 4 }).forward w h
  { back with dir := hd.dir }

@[simp] theorem Head.forward_dir (hd : Head) (w h : Nat) : (hd.forward w h).dir = hd.dir := by
  unfold Head.forward; split <;> rfl

/-- Stepping one cell back and one cell down on the torus. -/
private theorem succ_pred_mod (y h : Nat) (hy : y < h) : ((y + h - 1) % h + 1) % h = y := by
  rcases Nat.eq_zero_or_pos y with rfl | hy0
  · have h1 : (0 + h - 1) % h = h - 1 := by
      rw [Nat.zero_add]; exact Nat.mod_eq_of_lt (by omega)
    rw [h1, show h - 1 + 1 = h by omega, Nat.mod_self]
  · have h1 : (y + h - 1) % h = y - 1 := by
      rw [show y + h - 1 = (y - 1) + h by omega, Nat.add_mod_right]
      exact Nat.mod_eq_of_lt (by omega)
    rw [h1, show y - 1 + 1 = y by omega, Nat.mod_eq_of_lt hy]

private theorem pred_succ_mod (y h : Nat) (hy : y < h) : ((y + 1) % h + h - 1) % h = y := by
  rcases Nat.lt_or_ge (y + 1) h with hlt | hge
  · rw [Nat.mod_eq_of_lt hlt, show y + 1 + h - 1 = y + h by omega, Nat.add_mod_right,
      Nat.mod_eq_of_lt hy]
  · have hyh : y + 1 = h := by omega
    rw [hyh, Nat.mod_self, Nat.zero_add, Nat.mod_eq_of_lt (by omega)]
    omega

/-- On the torus, a step back undoes a step forward. -/
theorem Head.backward_forward (hd : Head) (w h : Nat) (hx : hd.x < w) (hy : hd.y < h) :
    (hd.forward w h).backward w h = hd := by
  obtain ⟨x, y, dir⟩ := hd
  have h4 : dir % 4 = 0 ∨ dir % 4 = 1 ∨ dir % 4 = 2 ∨ dir % 4 = 3 := by omega
  simp only at hx hy
  rcases h4 with h0 | h0 | h0 | h0 <;>
    simp only [Head.forward, Head.backward, h0] <;>
    [ (have h2 : (dir + 2) % 4 = 2 := by omega);
      (have h2 : (dir + 2) % 4 = 3 := by omega);
      (have h2 : (dir + 2) % 4 = 0 := by omega);
      (have h2 : (dir + 2) % 4 = 1 := by omega) ] <;>
    simp only [h2] <;> ext <;>
    simp [succ_pred_mod, pred_succ_mod, hx, hy]

/-- Langton's ant: on white turn right, on black turn left; flip the cell, then step. -/
def antStep (s : AntState) : AntState :=
  let c := s.grid.get s.head.x s.head.y
  let dir := if c then (s.head.dir + 3) % 4 else (s.head.dir + 1) % 4
  let g := s.grid.flip s.head.x s.head.y
  { grid := g, head := ({ s.head with dir := dir }).forward g.w g.h }

/-- The inverse of `antStep`: step back, then unturn using the colour written there.
    The colour read is the one *after* the flip, so the turn is the other way round. -/
def antStepInv (s : AntState) : AntState :=
  let hd := s.head.backward s.grid.w s.grid.h
  let c := s.grid.get hd.x hd.y
  let dir := if c then (hd.dir + 3) % 4 else (hd.dir + 1) % 4
  { grid := s.grid.flip hd.x hd.y, head := { hd with dir := dir } }

theorem antStep_dims (s : AntState) :
    (antStep s).grid.w = s.grid.w ∧ (antStep s).grid.h = s.grid.h ∧
      (antStep s).grid.cells.length = s.grid.cells.length := by
  refine ⟨rfl, rfl, ?_⟩
  simp [antStep]

/-- A step of the head stays on the torus. -/
theorem Head.forward_lt (hd : Head) (w h : Nat) (hw : 0 < w) (hh : 0 < h)
    (hx : hd.x < w) (hy : hd.y < h) :
    (hd.forward w h).x < w ∧ (hd.forward w h).y < h := by
  unfold Head.forward
  split
  · exact ⟨hx, Nat.mod_lt _ hh⟩
  · exact ⟨Nat.mod_lt _ hw, hy⟩
  · exact ⟨hx, Nat.mod_lt _ hh⟩
  · exact ⟨Nat.mod_lt _ hw, hy⟩

/-- The ant never leaves the board. -/
theorem antStep_pos_lt (s : AntState) (hw : 0 < s.grid.w) (hh : 0 < s.grid.h)
    (hx : s.head.x < s.grid.w) (hy : s.head.y < s.grid.h) :
    (antStep s).head.x < s.grid.w ∧ (antStep s).head.y < s.grid.h :=
  Head.forward_lt
    { s.head with dir := if s.grid.get s.head.x s.head.y
        then (s.head.dir + 3) % 4 else (s.head.dir + 1) % 4 }
    s.grid.w s.grid.h hw hh hx hy

/-- On a board whose cells cover its area, every torus index is in range. -/
theorem index_lt (g : Grid) (hw : 0 < g.w) (hh : 0 < g.h) (x y : Nat) :
    g.index x y < g.w * g.h := by
  have h1 : x % g.w < g.w := Nat.mod_lt _ hw
  have h2 : y % g.h < g.h := Nat.mod_lt _ hh
  calc (y % g.h) * g.w + x % g.w < (y % g.h) * g.w + g.w := by omega
    _ = ((y % g.h) + 1) * g.w := by ring
    _ ≤ g.h * g.w := Nat.mul_le_mul_right g.w (by omega)
    _ = g.w * g.h := Nat.mul_comm _ _

/-- On a well-formed board the flip really does change the cell it names. -/
theorem get_flip_self (g : Grid) (hw : 0 < g.w) (hh : 0 < g.h)
    (hlen : g.cells.length = g.w * g.h) (x y : Nat) :
    (g.flip x y).get x y = !g.get x y := by
  have hlt : g.index x y < g.cells.length := by
    rw [hlen]; exact index_lt g hw hh x y
  show (g.cells.set (g.index x y) (!g.get x y)).getD (g.index x y) false = _
  rw [List.getD_eq_getElem _ _ (by simpa using hlt), List.getElem_set_self]

/-- The ant is reversible: on a well-formed board its inverse step undoes its step,
    so a trace of the ant can be replayed backwards as well as forwards. -/
theorem antStep_reversible (s : AntState) (hw : 0 < s.grid.w) (hh : 0 < s.grid.h)
    (hlen : s.grid.cells.length = s.grid.w * s.grid.h)
    (hx : s.head.x < s.grid.w) (hy : s.head.y < s.grid.h) (hd : s.head.dir < 4) :
    antStepInv (antStep s) = s := by
  obtain ⟨g, hd0⟩ := s
  obtain ⟨x, y, d⟩ := hd0
  simp only at hx hy hd hw hh hlen
  have hgc : (g.flip x y).get x y = !(g.get x y) := get_flip_self g hw hh hlen x y
  have hback : ∀ e : Nat, ((Head.mk x y e).forward (g.flip x y).w (g.flip x y).h).backward
      (g.flip x y).w (g.flip x y).h = Head.mk x y e := fun e =>
    Head.backward_forward _ _ _ (by simpa using hx) (by simpa using hy)
  have hgen : ∀ e : Nat,
      antStepInv ⟨g.flip x y, (Head.mk x y e).forward (g.flip x y).w (g.flip x y).h⟩
        = ⟨g, Head.mk x y (if !(g.get x y) then (e + 3) % 4 else (e + 1) % 4)⟩ := by
    intro e
    unfold antStepInv
    simp only [hback e, hgc, Grid.flip_flip]
  have hstep : antStep ⟨g, ⟨x, y, d⟩⟩ = ⟨g.flip x y,
      (Head.mk x y (if g.get x y then (d + 3) % 4 else (d + 1) % 4)).forward
        (g.flip x y).w (g.flip x y).h⟩ := rfl
  rw [hstep, hgen]
  cases hcv : g.get x y
  · show (⟨g, Head.mk x y (((d + 1) % 4 + 3) % 4)⟩ : AntState) = ⟨g, Head.mk x y d⟩
    rw [show ((d + 1) % 4 + 3) % 4 = d from by omega]
  · show (⟨g, Head.mk x y (((d + 3) % 4 + 1) % 4)⟩ : AntState) = ⟨g, Head.mk x y d⟩
    rw [show ((d + 3) % 4 + 1) % 4 = d from by omega]

/-! ## FRACTRAN

A program is a list of fractions and a state is a natural number.  One step
multiplies by the first fraction of the list that keeps the state whole; when
no fraction does, the program halts.  The formula really is the program.
-/

/-- A fraction of a FRACTRAN program. -/
structure Frac where
  num : Nat
  den : Nat
  deriving Repr, DecidableEq

/-- The one fraction, if any, that the state `n` fires. -/
def fire (f : Frac) (n : Nat) : Option Nat :=
  if f.den ≠ 0 ∧ (n * f.num) % f.den = 0 then some (n * f.num / f.den) else none

/-- One FRACTRAN step: the first fraction of the program that keeps the state whole. -/
def step (prog : List Frac) (n : Nat) : Option Nat :=
  prog.findSome? (fun f => fire f n)

theorem fire_eq_some_iff (f : Frac) (n m : Nat) :
    fire f n = some m ↔ f.den ≠ 0 ∧ m * f.den = n * f.num := by
  unfold fire
  constructor
  · intro h
    split at h
    · rename_i hc
      obtain ⟨hd, hmod⟩ := hc
      refine ⟨hd, ?_⟩
      have : m = n * f.num / f.den := by simpa using h.symm
      subst this
      exact Nat.div_mul_cancel (Nat.dvd_of_mod_eq_zero hmod)
    · exact absurd h (by simp)
  · rintro ⟨hd, hm⟩
    have hdvd : f.den ∣ n * f.num := ⟨m, by rw [← hm]; ring⟩
    have : n * f.num / f.den = m := by
      rw [← hm]
      exact Nat.mul_div_cancel _ (Nat.pos_of_ne_zero hd)
    simp [hd, Nat.mod_eq_zero_of_dvd hdvd, this]

/-- A step happens exactly when some fraction fires, and it is the first one that does. -/
theorem step_eq_some_iff (prog : List Frac) (n m : Nat) :
    step prog n = some m ↔
      ∃ pre f post, prog = pre ++ f :: post ∧ fire f n = some m ∧
        ∀ g ∈ pre, fire g n = none :=
  List.findSome?_eq_some_iff

/-- A program halts exactly when no fraction of it fires. -/
theorem step_eq_none_iff (prog : List Frac) (n : Nat) :
    step prog n = none ↔ ∀ f ∈ prog, fire f n = none := by
  simp [step, List.findSome?_eq_none_iff]

/-- The run of a program from `n`, at most `fuel` steps, including the start state. -/
def run (prog : List Frac) (n : Nat) : Nat → List Nat
  | 0 => [n]
  | fuel + 1 =>
      match step prog n with
      | none => [n]
      | some m => n :: run prog m fuel

theorem run_length_le (prog : List Frac) (n fuel : Nat) :
    (run prog n fuel).length ≤ fuel + 1 := by
  induction fuel generalizing n with
  | zero => simp [run]
  | succ fuel ih =>
    unfold run
    cases h : step prog n with
    | none => simp
    | some m => simpa using Nat.succ_le_succ (ih m)

theorem run_head (prog : List Frac) (n fuel : Nat) : (run prog n fuel).head? = some n := by
  cases fuel with
  | zero => simp [run]
  | succ fuel => unfold run; cases step prog n <;> simp

/-- Running longer only extends the run: the shorter run is a prefix of the longer one. -/
theorem run_take (prog : List Frac) (n fuel : Nat) :
    (run prog n (fuel + 1)).take (fuel + 1) = run prog n fuel := by
  induction fuel generalizing n with
  | zero =>
    unfold run
    cases h : step prog n with
    | none => simp
    | some m => simp [run]
  | succ fuel ih =>
    unfold run
    cases h : step prog n with
    | none => simp
    | some m => simpa using ih m

/-- The one-fraction program `3/2` is FRACTRAN addition: it sends `2^a·3^b` to
    `2^(a-1)·3^(b+1)` while any factor of two is left. -/
theorem step_addition (a b : Nat) :
    step [⟨3, 2⟩] (2 ^ (a + 1) * 3 ^ b) = some (2 ^ a * 3 ^ (b + 1)) := by
  have h : (2 ^ (a + 1) * 3 ^ b) * 3 = 2 * (2 ^ a * 3 ^ (b + 1)) := by ring
  simp only [step, List.findSome?_cons, List.findSome?_nil]
  rw [fire]
  have hmod : (2 ^ (a + 1) * 3 ^ b * 3) % 2 = 0 := by
    rw [h]; exact Nat.mul_mod_right 2 _
  have hdiv : (2 ^ (a + 1) * 3 ^ b * 3) / 2 = 2 ^ a * 3 ^ (b + 1) := by
    rw [h]; exact Nat.mul_div_cancel_left _ (by norm_num)
  simp [hmod, hdiv]

/-- With no factor of two left, `3/2` halts. -/
theorem step_addition_halt (b : Nat) : step [⟨3, 2⟩] (3 ^ b) = none := by
  have : (3 ^ b * 3) % 2 = 1 := by
    have : (3:Nat) ^ b * 3 = 3 ^ (b + 1) := by ring
    rw [this]
    simpa using Nat.pow_mod 3 (b + 1) 2
  simp [step, fire, this]

/-- FRACTRAN addition: from `2^a·3^b` the program `3/2` reaches `3^(a+b)` in
    exactly `a` steps. -/
theorem run_addition (a b : Nat) :
    (run [⟨3, 2⟩] (2 ^ a * 3 ^ b) a).getLast? = some (3 ^ (a + b)) := by
  induction a generalizing b with
  | zero => simp [run]
  | succ a ih =>
    have hcons : run [⟨3, 2⟩] (2 ^ (a + 1) * 3 ^ b) (a + 1)
        = (2 ^ (a + 1) * 3 ^ b) :: run [⟨3, 2⟩] (2 ^ a * 3 ^ (b + 1)) a := by
      rw [show run [⟨3, 2⟩] (2 ^ (a + 1) * 3 ^ b) (a + 1)
            = (match step [⟨3, 2⟩] (2 ^ (a + 1) * 3 ^ b) with
              | none => [2 ^ (a + 1) * 3 ^ b]
              | some m => (2 ^ (a + 1) * 3 ^ b) :: run [⟨3, 2⟩] m a) from rfl,
        step_addition]
    rw [hcons, List.getLast?_cons, ih (b + 1)]
    simp [show a + (b + 1) = a + 1 + b by omega]

/-- …and then halts, so the state the studio shows is final. -/
theorem run_addition_halts (a b : Nat) : step [⟨3, 2⟩] (3 ^ (a + b)) = none :=
  step_addition_halt _

end Hesper.Automata
