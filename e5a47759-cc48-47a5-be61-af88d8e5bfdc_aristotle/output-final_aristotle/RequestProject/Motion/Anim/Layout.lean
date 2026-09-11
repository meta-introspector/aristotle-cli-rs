import Mathlib

/-!
# Cell layouts

The formal counterpart of `HesperDeck.gridCells` / `insetRect` / `placeIn`
(`web/js/deck.js`), which is what the playbook statements `columns N`,
`rows N` and `column K` are built from, and what the `table` layer uses to
place its columns.

A rectangle is fractional: `x, y` is its bottom-left corner and `w, h` its
size, with `y` growing upwards, exactly as the studio stores it before
`pixelRect` flips it for the screen.  A grid splits a rectangle into
`cols × rows` cells separated by a gap, in reading order (left to right, top
row first).

The properties proved here are the ones a layout has to satisfy for the
studio's clipping to be meaningful: every cell lies inside the rectangle it
was cut from, two different cells never overlap, cells in a row share a
baseline and cells in a column share a left edge, and with no gap the columns
exactly fill the width.  `tests/node/test_deck.mjs` checks the shipped
JavaScript against the same statements.
-/

namespace Hesper.Layout

/-- A fractional rectangle: bottom-left corner `(x, y)` and size `w × h`. -/
structure Rect where
  /-- Left edge. -/
  x : ℝ
  /-- Bottom edge (`y` grows upwards). -/
  y : ℝ
  /-- Width. -/
  w : ℝ
  /-- Height. -/
  h : ℝ

namespace Rect

/-- The whole frame. -/
def full : Rect := ⟨0, 0, 1, 1⟩

/-- Is the point `(px, py)` inside the rectangle? -/
def Mem (r : Rect) (px py : ℝ) : Prop :=
  r.x ≤ px ∧ px ≤ r.x + r.w ∧ r.y ≤ py ∧ py ≤ r.y + r.h

/-- Is `a` contained in `b`? -/
def Sub (a b : Rect) : Prop :=
  b.x ≤ a.x ∧ a.x + a.w ≤ b.x + b.w ∧ b.y ≤ a.y ∧ a.y + a.h ≤ b.y + b.h

/-- Do `a` and `b` have disjoint interiors? -/
def Disj (a b : Rect) : Prop :=
  a.x + a.w ≤ b.x ∨ b.x + b.w ≤ a.x ∨ a.y + a.h ≤ b.y ∨ b.y + b.h ≤ a.y

open scoped Classical in
/-- Shrink a rectangle by `m` on every side.  Like the runtime, an inset that
would turn the rectangle inside out collapses it to its centre instead. -/
noncomputable def inset (r : Rect) (m : ℝ) : Rect :=
  if 0 < r.w - 2 * max 0 m ∧ 0 < r.h - 2 * max 0 m then
    ⟨r.x + max 0 m, r.y + max 0 m, r.w - 2 * max 0 m, r.h - 2 * max 0 m⟩
  else
    ⟨r.x + r.w / 2, r.y + r.h / 2, 0, 0⟩

/-- Fractional point `(fx, fy)` of the frame, re-read inside a cell. -/
def placeIn (c : Rect) (fx fy : ℝ) : ℝ × ℝ := (c.x + fx * c.w, c.y + fy * c.h)

/-- Pixel rectangle of a fractional rectangle on a `width × height` frame; the
result is in screen coordinates, where `y` grows downwards. -/
def pixelRect (r : Rect) (width height : ℝ) : Rect :=
  ⟨r.x * width, (1 - r.y - r.h) * height, r.w * width, r.h * height⟩

end Rect

open Rect

/-- Size of one cell of an `n`-cell axis of length `len`, with gap `g`. -/
noncomputable def cellSize (len g : ℝ) (n : ℕ) : ℝ := (len - g * (n - 1)) / n

/-- `n` cells and the `n - 1` gaps between them exactly fill the axis. -/
theorem cellSize_fill (len g : ℝ) {n : ℕ} (hn : 0 < n) :
    n * cellSize len g n + g * (n - 1) = len := by
  have hc : (0:ℝ) < n := by exact_mod_cast hn
  rw [cellSize]
  field_simp
  ring

/-- A cell has non-negative size as soon as the gaps fit on the axis. -/
theorem cellSize_nonneg (len g : ℝ) {n : ℕ} (hn : 0 < n) (hfit : g * (n - 1) ≤ len) :
    0 ≤ cellSize len g n := by
  have hc : (0:ℝ) < n := by exact_mod_cast hn
  exact div_nonneg (by linarith) hc.le

/-- Offset of cell `k` along an axis. -/
noncomputable def cellOffset (len g : ℝ) (n k : ℕ) : ℝ := k * (cellSize len g n + g)

/-- Cell `k` starts inside the axis and ends before it does. -/
theorem cellOffset_bounds (len g : ℝ) {n k : ℕ} (hn : 0 < n) (hg : 0 ≤ g)
    (hfit : g * (n - 1) ≤ len) (hk : k < n) :
    0 ≤ cellOffset len g n k ∧ cellOffset len g n k + cellSize len g n ≤ len := by
  have hcw : 0 ≤ cellSize len g n := cellSize_nonneg len g hn hfit
  have hfl := cellSize_fill len g hn
  have hk1 : (k : ℝ) + 1 ≤ n := by exact_mod_cast hk
  have hk0 : (0:ℝ) ≤ k := Nat.cast_nonneg k
  refine ⟨mul_nonneg hk0 (by linarith), ?_⟩
  have : (k : ℝ) * (cellSize len g n + g) + cellSize len g n
      ≤ (n : ℝ) * cellSize len g n + g * (n - 1) := by nlinarith
  simpa [cellOffset, hfl] using this.trans_eq hfl

/-- Consecutive cells never overlap: cell `a` ends before cell `b` starts. -/
theorem cellOffset_sep (len g : ℝ) {n a b : ℕ} (hn : 0 < n) (hg : 0 ≤ g)
    (hfit : g * (n - 1) ≤ len) (hab : a < b) :
    cellOffset len g n a + cellSize len g n ≤ cellOffset len g n b := by
  have hcw : 0 ≤ cellSize len g n := cellSize_nonneg len g hn hfit
  have hab' : (a : ℝ) + 1 ≤ b := by exact_mod_cast hab
  have : (a : ℝ) * (cellSize len g n + g) + cellSize len g n
      ≤ (b : ℝ) * (cellSize len g n + g) := by nlinarith
  simpa [cellOffset] using this

/-- The cell in column `c` and row `row` (row `0` is the top one) of a
`cols × rows` grid over `r`, with gap `g`. -/
noncomputable def cell (r : Rect) (cols rows : ℕ) (g : ℝ) (c row : ℕ) : Rect :=
  ⟨r.x + cellOffset r.w g cols c,
   r.y + cellOffset r.h g rows (rows - 1 - row),
   cellSize r.w g cols,
   cellSize r.h g rows⟩

/-- The cells of a grid, in reading order: entry `row * cols + c` is the cell
in column `c` of row `row`. -/
noncomputable def gridCells (r : Rect) (cols rows : ℕ) (g : ℝ) : List Rect :=
  (List.range (rows * cols)).map fun i => cell r cols rows g (i % cols) (i / cols)

@[simp] theorem gridCells_length (r : Rect) (cols rows : ℕ) (g : ℝ) :
    (gridCells r cols rows g).length = rows * cols := by
  simp [gridCells]

/-- Reading order: entry `row * cols + c` of the list is the cell in column
`c` of row `row`. -/
theorem gridCells_get (r : Rect) {cols rows c row : ℕ} (g : ℝ)
    (hc : c < cols) (hrow : row < rows) :
    (gridCells r cols rows g)[row * cols + c]? = some (cell r cols rows g c row) := by
  have hlt : row * cols + c < rows * cols := by
    calc row * cols + c < row * cols + cols := by omega
      _ = (row + 1) * cols := by ring
      _ ≤ rows * cols := Nat.mul_le_mul_right _ (by omega)
  have hmod : (row * cols + c) % cols = c := by
    rw [Nat.mul_add_mod', Nat.mod_eq_of_lt hc]
  have hdiv : (row * cols + c) / cols = row := by
    rw [Nat.add_comm, Nat.add_mul_div_right _ _ (by omega : 0 < cols), Nat.div_eq_of_lt hc]
    omega
  simp [gridCells, hlt, hmod, hdiv]

section
variable {r : Rect} {cols rows : ℕ} {g : ℝ}

/-- Every cell lies inside the rectangle it was cut from. -/
theorem cell_sub (hcols : 0 < cols) (hrows : 0 < rows) (hg : 0 ≤ g)
    (hw : g * (cols - 1) ≤ r.w) (hh : g * (rows - 1) ≤ r.h)
    {c row : ℕ} (hc : c < cols) (hrow : row < rows) :
    Sub (cell r cols rows g c row) r := by
  obtain ⟨hx0, hx1⟩ := cellOffset_bounds r.w g hcols hg hw hc
  obtain ⟨hy0, hy1⟩ := cellOffset_bounds r.h g hrows hg hh
    (show rows - 1 - row < rows by omega)
  exact ⟨by simp [cell]; linarith, by simp [cell]; linarith,
    by simp [cell]; linarith, by simp [cell]; linarith⟩

/-- Two different cells of the same grid never overlap. -/
theorem cell_disj (hcols : 0 < cols) (hrows : 0 < rows) (hg : 0 ≤ g)
    (hw : g * (cols - 1) ≤ r.w) (hh : g * (rows - 1) ≤ r.h)
    {c₁ row₁ c₂ row₂ : ℕ} (hr₁ : row₁ < rows) (hr₂ : row₂ < rows)
    (hne : c₁ ≠ c₂ ∨ row₁ ≠ row₂) :
    Disj (cell r cols rows g c₁ row₁) (cell r cols rows g c₂ row₂) := by
  rcases hne with hc | hrne
  · rcases lt_or_gt_of_ne hc with h | h
    · exact Or.inl (by
        have := cellOffset_sep r.w g hcols hg hw h
        simp [cell]; linarith)
    · exact Or.inr (Or.inl (by
        have := cellOffset_sep r.w g hcols hg hw h
        simp [cell]; linarith))
  · -- the rows differ; the row further down the deck sits lower on the frame
    rcases lt_or_gt_of_ne hrne with h | h
    · have hlt : rows - 1 - row₂ < rows - 1 - row₁ := by omega
      exact Or.inr (Or.inr (Or.inr (by
        have := cellOffset_sep r.h g hrows hg hh hlt
        simp [cell]; linarith)))
    · have hlt : rows - 1 - row₁ < rows - 1 - row₂ := by omega
      exact Or.inr (Or.inr (Or.inl (by
        have := cellOffset_sep r.h g hrows hg hh hlt
        simp [cell]; linarith)))

/-- Cells in the same row share a baseline and a height. -/
theorem cell_row_aligned {c₁ c₂ row : ℕ} :
    (cell r cols rows g c₁ row).y = (cell r cols rows g c₂ row).y ∧
      (cell r cols rows g c₁ row).h = (cell r cols rows g c₂ row).h := ⟨rfl, rfl⟩

/-- Cells in the same column share a left edge and a width. -/
theorem cell_col_aligned {c row₁ row₂ : ℕ} :
    (cell r cols rows g c row₁).x = (cell r cols rows g c row₂).x ∧
      (cell r cols rows g c row₁).w = (cell r cols rows g c row₂).w := ⟨rfl, rfl⟩

/-- With no gap the columns exactly fill the width. -/
theorem cell_last_col (hcols : 0 < cols) {row : ℕ} :
    (cell r cols rows 0 (cols - 1) row).x + (cell r cols rows 0 (cols - 1) row).w
      = r.x + r.w := by
  have hcast : ((cols - 1 : ℕ) : ℝ) = (cols : ℝ) - 1 := by
    have : (1:ℕ) ≤ cols := hcols
    push_cast [Nat.cast_sub this]
    ring
  have hc : (0:ℝ) < cols := by exact_mod_cast hcols
  show r.x + ((cols - 1 : ℕ) : ℝ) * (cellSize r.w 0 cols + 0) + cellSize r.w 0 cols = r.x + r.w
  rw [hcast, cellSize]
  field_simp
  ring

/-- A single cell is the whole rectangle. -/
@[simp] theorem cell_one : cell r 1 1 g 0 0 = r := by
  simp [cell, cellSize, cellOffset]

end

/-- An inset rectangle is contained in the original one. -/
theorem inset_sub (r : Rect) (m : ℝ) (hw : 0 ≤ r.w) (hh : 0 ≤ r.h) :
    Sub (r.inset m) r := by
  have hm : 0 ≤ max 0 m := le_max_left _ _
  unfold Rect.inset
  split
  · rename_i hpos
    refine ⟨by simp, by simp; linarith, by simp, by simp; linarith⟩
  · exact ⟨by simp; linarith, by simp; linarith,
      by simp; linarith, by simp; linarith⟩

/-- An over-inset rectangle collapses instead of turning inside out. -/
theorem inset_nonneg (r : Rect) (m : ℝ) : 0 ≤ (r.inset m).w ∧ 0 ≤ (r.inset m).h := by
  unfold Rect.inset
  split
  · rename_i hpos; exact ⟨hpos.1.le, hpos.2.le⟩
  · exact ⟨le_rfl, le_rfl⟩

/-- Reading a fraction inside a cell lands inside that cell. -/
theorem placeIn_mem (c : Rect) {fx fy : ℝ} (hw : 0 ≤ c.w) (hh : 0 ≤ c.h)
    (hx : 0 ≤ fx) (hx1 : fx ≤ 1) (hy : 0 ≤ fy) (hy1 : fy ≤ 1) :
    c.Mem (c.placeIn fx fy).1 (c.placeIn fx fy).2 := by
  have h1 : 0 ≤ fx * c.w := mul_nonneg hx hw
  have h2 : fx * c.w ≤ c.w := by nlinarith
  have h3 : 0 ≤ fy * c.h := mul_nonneg hy hh
  have h4 : fy * c.h ≤ c.h := by nlinarith
  exact ⟨by simp [Rect.placeIn]; linarith,
    by simp [Rect.placeIn]; linarith,
    by simp [Rect.placeIn]; linarith,
    by simp [Rect.placeIn]; linarith⟩

/-- `placeIn` on the whole frame is the identity on fractions. -/
@[simp] theorem placeIn_full (fx fy : ℝ) : Rect.full.placeIn fx fy = (fx, fy) := by
  simp [Rect.placeIn, Rect.full]

/-- The frame's own rectangle covers the whole frame in pixels. -/
@[simp] theorem pixelRect_full (width height : ℝ) :
    Rect.full.pixelRect width height = ⟨0, 0, width, height⟩ := by
  simp [Rect.pixelRect, Rect.full]

/-- `pixelRect` preserves containment (with the `y` flip). -/
theorem pixelRect_sub {a b : Rect} (h : Sub a b) {width height : ℝ}
    (hw : 0 ≤ width) (hh : 0 ≤ height) :
    Sub (a.pixelRect width height) (b.pixelRect width height) := by
  obtain ⟨h1, h2, h3, h4⟩ := h
  refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [Rect.pixelRect] <;> nlinarith

end Hesper.Layout
