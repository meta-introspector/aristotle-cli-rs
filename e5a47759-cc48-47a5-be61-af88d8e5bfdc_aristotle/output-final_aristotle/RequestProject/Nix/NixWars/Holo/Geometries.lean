import RequestProject.Nix.NixWars.Holo.Objective

/-!
# Richer geometries: a lattice and a tree, and what a range request buys on each

The machinery of `Geometry.lean` is stated for an arbitrary link graph; what the
concrete archive exercises is a ring.  This file writes down two other
geometries as archives and proves what one range request costs on each.

* `indexArchive` — the general construction: `N` cells, cell `i` keyed by `i`,
  linked to every `j` a symmetric adjacency relates it to.  Keys distinct
  (`indexArchive_keys_nodup`), links closed (`indexArchive_links_closed`),
  neighbours mutual (`indexArchive_mutual`), and the cost of collecting a set of
  concepts is the number of maximal runs of their positions
  (`requests_indexArchive`).
* `gridArchive` — a `w × h` lattice, laid out row-major.  **A row is one
  request** (`grid_row_requests`) and **a column of `h` cells costs `h`**
  (`grid_column_requests`), so on a lattice the byte order picks a direction:
  `grid_column_costs_more`.
* `treeArchive` — a complete binary tree of depth `D`, laid out breadth-first.
  **A level is one request** (`tree_level_requests`) and so is the whole
  `l`-ball at the root (`tree_root_ball_requests`), while **a root-to-leaf path
  of `k` cells costs `k`** (`tree_path_requests`): on this layout a shell is
  cheap and a branch is dear, the opposite of what a depth-first layout gives.
-/

namespace NixWars
namespace Holo
namespace Geometries

open Archive

/-! ## Archives laid out by index -/

/-- **An archive laid out by index**: `N` cells, cell `i` keyed by `i`, holding
its own material and naming every cell the adjacency relates it to. -/
def indexArchive (N : Nat) (adj : Nat → Nat → Bool) (mat : Nat → List Nat) : Archive :=
  (List.range N).map fun i => ⟨i, mat i, (List.range N).filter fun j => adj i j⟩

variable {N : Nat} {adj : Nat → Nat → Bool} {mat : Nat → List Nat}

@[simp] theorem length_indexArchive : (indexArchive N adj mat).length = N := by
  simp [indexArchive]

@[simp] theorem getElem_indexArchive {i : Nat} (h : i < (indexArchive N adj mat).length) :
    (indexArchive N adj mat)[i] = ⟨i, mat i, (List.range N).filter fun j => adj i j⟩ := by
  simp [indexArchive]

theorem mem_indexArchive {i : Nat} (h : i < N) :
    (⟨i, mat i, (List.range N).filter fun j => adj i j⟩ : Cell) ∈ indexArchive N adj mat :=
  List.mem_map.mpr ⟨i, List.mem_range.mpr h, rfl⟩

theorem exists_index_of_mem_indexArchive {c : Cell} (hc : c ∈ indexArchive N adj mat) :
    ∃ i < N, c = ⟨i, mat i, (List.range N).filter fun j => adj i j⟩ := by
  obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hc
  exact ⟨i, List.mem_range.mp hi, rfl⟩

theorem indexArchive_keys : (indexArchive N adj mat).map Cell.key = List.range N := by
  simp [indexArchive, List.map_map, Function.comp_def]

theorem indexArchive_keys_nodup : ((indexArchive N adj mat).map Cell.key).Nodup := by
  rw [indexArchive_keys]; exact List.nodup_range

theorem indexArchive_links_closed : LinksClosed (indexArchive N adj mat) := by
  intro c hc k hk
  obtain ⟨i, _, rfl⟩ := exists_index_of_mem_indexArchive hc
  have hkN : k < N := List.mem_range.mp (List.mem_of_mem_filter hk)
  exact ⟨_, mem_indexArchive (mat := mat) (adj := adj) hkN, rfl⟩

/-- **A symmetric adjacency makes the geometry reversible.** -/
theorem indexArchive_mutual (hsymm : ∀ i j, adj i j = adj j i) :
    MutualSupport (indexArchive N adj mat) := by
  refine mutualSupport_of_cells indexArchive_keys_nodup indexArchive_links_closed ?_
  intro c hc d hd
  obtain ⟨i, hi, rfl⟩ := exists_index_of_mem_indexArchive hc
  obtain ⟨j, hj, rfl⟩ := exists_index_of_mem_indexArchive hd
  simp only [List.mem_filter, List.mem_range, hsymm i j]
  exact ⟨fun h => ⟨hi, h.2⟩, fun h => ⟨hj, h.2⟩⟩

/-! ## What a set of concepts costs -/

theorem requests_eq_runsOf_filter (ks : List Nat) :
    requests (indexArchive N adj mat) ks =
      runsOf ((List.range N).filter fun i => decide (i ∈ ks)) := by
  unfold requests indicesOf
  congr 1
  rw [length_indexArchive]
  apply List.filter_congr
  intro i hi
  have h : i < (indexArchive N adj mat).length := by
    simpa using List.mem_range.mp hi
  rw [List.getD_eq_getElem _ _ h, getElem_indexArchive h]

/-- Filtering the whole index down to a sorted set of keys returns that set. -/
theorem filter_range_eq_of_pairwise {ks : List Nat} (hs : ks.Pairwise (· < ·))
    (hb : ∀ k ∈ ks, k < N) : (List.range N).filter (fun i => decide (i ∈ ks)) = ks := by
  have h1 : ((List.range N).filter (fun i => decide (i ∈ ks))).Pairwise (· < ·) :=
    List.pairwise_lt_range.filter _
  have hperm : ((List.range N).filter (fun i => decide (i ∈ ks))).Perm ks := by
    refine (List.perm_ext_iff_of_nodup h1.nodup hs.nodup).mpr ?_
    intro a
    simp only [List.mem_filter, List.mem_range, decide_eq_true_eq]
    exact ⟨fun h => h.2, fun h => ⟨hb a h, h⟩⟩
  exact hperm.eq_of_pairwise (fun a b _ _ hab _ => absurd hab (by omega)) h1 hs

/-- **The cost of collecting a set of concepts** from an index-laid archive is
the number of maximal runs of their positions. -/
theorem requests_indexArchive {ks : List Nat} (hs : ks.Pairwise (· < ·))
    (hb : ∀ k ∈ ks, k < N) :
    requests (indexArchive N adj mat) ks = runsOf ks := by
  rw [requests_eq_runsOf_filter, filter_range_eq_of_pairwise hs hb]

/-! ## Counting runs -/

/-- Cells more than one apart are never in the same run. -/
theorem runsAux_of_gaps {prev : Nat} {l : List Nat}
    (hp : l.Pairwise (fun a b => a + 1 < b)) (hhead : ∀ x ∈ l.head?, x ≠ prev + 1) :
    runsAux prev l = l.length := by
  induction l generalizing prev with
  | nil => simp [runsAux]
  | cons x rest ih =>
    have hx : x ≠ prev + 1 := hhead x (by simp)
    obtain ⟨hgap, hrest⟩ := List.pairwise_cons.mp hp
    have hhead' : ∀ y ∈ rest.head?, y ≠ x + 1 := by
      intro y hy
      have hmem : y ∈ rest := List.mem_of_mem_head? hy
      have := hgap y hmem
      omega
    simp only [runsAux, if_neg hx, List.length_cons]
    rw [ih hrest hhead']
    omega

/-- **Scattered cells cost one request each.** -/
theorem runsOf_of_gaps {l : List Nat} (hp : l.Pairwise (fun a b => a + 1 < b)) :
    runsOf l = l.length := by
  cases l with
  | nil => simp [runsOf]
  | cons x rest =>
    obtain ⟨hgap, hrest⟩ := List.pairwise_cons.mp hp
    have hhead : ∀ y ∈ rest.head?, y ≠ x + 1 := by
      intro y hy
      have := hgap y (List.mem_of_mem_head? hy)
      omega
    simp only [runsOf, List.length_cons]
    rw [runsAux_of_gaps hrest hhead]
    omega

/-! ## A 2-D lattice -/

/-- Two positions of a `w`-wide lattice are adjacent when they share a row and
are side by side, or share a column and are one above the other. -/
def gridAdj (w : Nat) (i j : Nat) : Bool :=
  decide ((i / w = j / w ∧ (i % w = j % w + 1 ∨ j % w = i % w + 1)) ∨
    (i % w = j % w ∧ (i / w = j / w + 1 ∨ j / w = i / w + 1)))

theorem gridAdj_symm (w i j : Nat) : gridAdj w i j = gridAdj w j i := by
  simp only [gridAdj, decide_eq_decide]
  constructor
  · rintro (⟨h1, h2 | h2⟩ | ⟨h1, h2 | h2⟩)
    · exact Or.inl ⟨h1.symm, Or.inr h2⟩
    · exact Or.inl ⟨h1.symm, Or.inl h2⟩
    · exact Or.inr ⟨h1.symm, Or.inr h2⟩
    · exact Or.inr ⟨h1.symm, Or.inl h2⟩
  · rintro (⟨h1, h2 | h2⟩ | ⟨h1, h2 | h2⟩)
    · exact Or.inl ⟨h1.symm, Or.inr h2⟩
    · exact Or.inl ⟨h1.symm, Or.inl h2⟩
    · exact Or.inr ⟨h1.symm, Or.inr h2⟩
    · exact Or.inr ⟨h1.symm, Or.inl h2⟩

/-- The lattice as an archive: `w × h` cells, laid out row by row. -/
def gridArchive (w h : Nat) : Archive :=
  indexArchive (w * h) (gridAdj w) (fun i => [i])

theorem gridArchive_keys_nodup (w h : Nat) : ((gridArchive w h).map Cell.key).Nodup :=
  indexArchive_keys_nodup

theorem gridArchive_links_closed (w h : Nat) : LinksClosed (gridArchive w h) :=
  indexArchive_links_closed

theorem gridArchive_mutual (w h : Nat) : MutualSupport (gridArchive w h) :=
  indexArchive_mutual (gridAdj_symm w)

/-- The keys of row `r`: `w` cells, consecutive in the file. -/
def rowKeys (w r : Nat) : List Nat := List.range' (r * w) w

/-- The keys of column `c`: `h` cells, `w` apart in the file. -/
def colKeys (w h c : Nat) : List Nat := (List.range h).map fun r => r * w + c

theorem colKeys_gaps {w h c : Nat} (hw : 2 ≤ w) :
    (colKeys w h c).Pairwise (fun a b => a + 1 < b) := by
  refine List.Pairwise.map _ ?_ List.pairwise_lt_range
  intro a b hab
  have h1 : (a + 1) * w ≤ b * w := Nat.mul_le_mul_right w hab
  have h2 : (a + 1) * w = a * w + w := by ring
  omega

theorem colKeys_pairwise {w h c : Nat} (hw : 2 ≤ w) : (colKeys w h c).Pairwise (· < ·) :=
  (colKeys_gaps hw).imp (by omega)

theorem colKeys_lt {w h c : Nat} (hc : c < w) : ∀ k ∈ colKeys w h c, k < w * h := by
  intro k hk
  obtain ⟨r, hr, rfl⟩ := List.mem_map.mp hk
  have hrh : r < h := List.mem_range.mp hr
  have h1 : (r + 1) * w ≤ h * w := Nat.mul_le_mul_right w hrh
  have h2 : (r + 1) * w = r * w + w := by ring
  have h3 : h * w = w * h := by ring
  omega

theorem rowKeys_lt {w h r : Nat} (hr : r < h) : ∀ k ∈ rowKeys w r, k < w * h := by
  intro k hk
  obtain ⟨i, hi, rfl⟩ := List.mem_range'.mp hk
  have h1 : (r + 1) * w ≤ h * w := Nat.mul_le_mul_right w hr
  have h2 : (r + 1) * w = r * w + w := by ring
  have h3 : h * w = w * h := by ring
  omega

/-- **A row of the lattice is one range request**: it is a contiguous window of
the file. -/
theorem grid_row_requests {w h r : Nat} (hw : 0 < w) (hr : r < h) :
    requests (gridArchive w h) (rowKeys w r) = 1 := by
  obtain ⟨m, rfl⟩ : ∃ m, w = m + 1 := ⟨w - 1, by omega⟩
  have hs : (rowKeys (m + 1) r).Pairwise (· < ·) := List.pairwise_lt_range' 1 (by omega)
  have hreq := requests_indexArchive (N := (m + 1) * h) (adj := gridAdj (m + 1))
    (mat := fun i => [i]) hs (rowKeys_lt hr)
  rw [gridArchive, hreq, rowKeys, runsOf_range']

/-- **A column of the lattice costs one request per cell.**  The same cells and
the same links; only the direction differs, and the layout has picked one. -/
theorem grid_column_requests {w h c : Nat} (hw : 2 ≤ w) (hc : c < w) :
    requests (gridArchive w h) (colKeys w h c) = h := by
  have hreq := requests_indexArchive (N := w * h) (adj := gridAdj w) (mat := fun i => [i])
    (colKeys_pairwise hw) (colKeys_lt hc)
  rw [gridArchive, hreq, runsOf_of_gaps (colKeys_gaps hw)]
  simp [colKeys]

/-- Hence on any lattice at least two wide and two tall, reading a column is
strictly dearer than reading a row. -/
theorem grid_column_costs_more {w h c r : Nat} (hw : 2 ≤ w) (hh : 2 ≤ h) (hc : c < w)
    (hr : r < h) :
    requests (gridArchive w h) (rowKeys w r) < requests (gridArchive w h) (colKeys w h c) := by
  rw [grid_row_requests (by omega) hr, grid_column_requests hw hc]
  omega

/-! ## A complete binary tree -/

/-- Parent and children in a complete binary tree laid out breadth-first. -/
def treeAdj (i j : Nat) : Bool :=
  decide (j = 2 * i + 1 ∨ j = 2 * i + 2 ∨ i = 2 * j + 1 ∨ i = 2 * j + 2)

theorem treeAdj_symm (i j : Nat) : treeAdj i j = treeAdj j i := by
  simp only [treeAdj, decide_eq_decide]
  constructor
  · rintro (h | h | h | h) <;> tauto
  · rintro (h | h | h | h) <;> tauto

/-- The complete binary tree of depth `D` as an archive: `2^D - 1` cells, laid
out breadth-first, so a level is a contiguous window of the file. -/
def treeArchive (D : Nat) : Archive :=
  indexArchive (2 ^ D - 1) treeAdj (fun i => [i])

theorem treeArchive_keys_nodup (D : Nat) : ((treeArchive D).map Cell.key).Nodup :=
  indexArchive_keys_nodup

theorem treeArchive_links_closed (D : Nat) : LinksClosed (treeArchive D) :=
  indexArchive_links_closed

theorem treeArchive_mutual (D : Nat) : MutualSupport (treeArchive D) :=
  indexArchive_mutual treeAdj_symm

/-- The keys of level `l`: the `2^l` cells at depth `l` from the root. -/
def levelKeys (l : Nat) : List Nat := List.range' (2 ^ l - 1) (2 ^ l)

/-- The keys of the ball of radius `l` at the root: every cell down to level
`l`. -/
def rootBallKeys (l : Nat) : List Nat := List.range' 0 (2 ^ (l + 1) - 1)

/-- The keys on the path from the child of the root down `k` levels. -/
def pathKeys (k : Nat) : List Nat := (List.range' 1 k).map fun t => 2 ^ t - 1

theorem levelKeys_lt {D l : Nat} (hl : l < D) : ∀ k ∈ levelKeys l, k < 2 ^ D - 1 := by
  intro k hk
  obtain ⟨i, hi, rfl⟩ := List.mem_range'.mp hk
  have h1 : 2 ^ (l + 1) ≤ 2 ^ D := Nat.pow_le_pow_right (by omega) (by omega)
  have h2 : 2 ^ (l + 1) = 2 ^ l + 2 ^ l := by ring
  have h3 : 0 < 2 ^ l := Nat.two_pow_pos l
  omega

theorem rootBallKeys_lt {D l : Nat} (hl : l < D) : ∀ k ∈ rootBallKeys l, k < 2 ^ D - 1 := by
  intro k hk
  obtain ⟨i, hi, rfl⟩ := List.mem_range'.mp hk
  have h1 : 2 ^ (l + 1) ≤ 2 ^ D := Nat.pow_le_pow_right (by omega) (by omega)
  omega

/-- **A level of the tree is one range request.** -/
theorem tree_level_requests {D l : Nat} (hl : l < D) :
    requests (treeArchive D) (levelKeys l) = 1 := by
  have hpos : 0 < 2 ^ l := Nat.two_pow_pos l
  obtain ⟨m, hm⟩ : ∃ m, 2 ^ l = m + 1 := ⟨2 ^ l - 1, by omega⟩
  have hs : (levelKeys l).Pairwise (· < ·) := List.pairwise_lt_range' 1 (by omega)
  have hreq := requests_indexArchive (N := 2 ^ D - 1) (adj := treeAdj) (mat := fun i => [i])
    hs (levelKeys_lt hl)
  rw [treeArchive, hreq, levelKeys, hm, runsOf_range']

/-- **And so is the whole `l`-ball at the root**: on a breadth-first layout the
first `l+1` levels are a prefix of the file. -/
theorem tree_root_ball_requests {D l : Nat} (hl : l < D) :
    requests (treeArchive D) (rootBallKeys l) = 1 := by
  have hpos : 2 ≤ 2 ^ (l + 1) := by
    calc 2 = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ (l + 1) := Nat.pow_le_pow_right (by omega) (by omega)
  obtain ⟨m, hm⟩ : ∃ m, 2 ^ (l + 1) - 1 = m + 1 := ⟨2 ^ (l + 1) - 2, by omega⟩
  have hs : (rootBallKeys l).Pairwise (· < ·) := List.pairwise_lt_range' 1 (by omega)
  have hreq := requests_indexArchive (N := 2 ^ D - 1) (adj := treeAdj) (mat := fun i => [i])
    hs (rootBallKeys_lt hl)
  rw [treeArchive, hreq, rootBallKeys, hm, runsOf_range']

theorem pathKeys_gaps (k : Nat) : (pathKeys k).Pairwise (fun a b => a + 1 < b) := by
  rw [pathKeys, List.pairwise_map]
  refine List.Pairwise.imp_of_mem ?_ (List.pairwise_lt_range' 1 (by omega))
  intro a b ha _ hab
  have ha1 : 1 ≤ a := by
    obtain ⟨i, _, rfl⟩ := List.mem_range'.mp ha
    omega
  have h2 : 2 ^ (a + 1) ≤ 2 ^ b := Nat.pow_le_pow_right (by omega) (by omega)
  have h3 : 2 ^ (a + 1) = 2 ^ a + 2 ^ a := by ring
  have h4 : 2 ^ 1 ≤ 2 ^ a := Nat.pow_le_pow_right (by omega) ha1
  have h5 : (2 : Nat) ^ 1 = 2 := by norm_num
  omega

theorem pathKeys_pairwise (k : Nat) : (pathKeys k).Pairwise (· < ·) :=
  (pathKeys_gaps k).imp (by omega)

theorem pathKeys_lt {D k : Nat} (hk : k < D) : ∀ x ∈ pathKeys k, x < 2 ^ D - 1 := by
  intro x hx
  obtain ⟨t, ht, rfl⟩ := List.mem_map.mp hx
  obtain ⟨i, hi, rfl⟩ := List.mem_range'.mp ht
  have h1 : 2 ^ (1 + 1 * i) < 2 ^ D := Nat.pow_lt_pow_right (by omega) (by omega)
  have h2 : 0 < 2 ^ (1 + 1 * i) := Nat.two_pow_pos _
  omega

/-- **A branch is dear where a shell is cheap.**  A root-to-leaf path of `k`
cells costs `k` requests on the breadth-first layout, while the whole ball that
contains it costs one. -/
theorem tree_path_requests {D k : Nat} (hk : k < D) :
    requests (treeArchive D) (pathKeys k) = k := by
  have hreq := requests_indexArchive (N := 2 ^ D - 1) (adj := treeAdj) (mat := fun i => [i])
    (pathKeys_pairwise k) (pathKeys_lt hk)
  rw [treeArchive, hreq, runsOf_of_gaps (pathKeys_gaps k)]
  simp [pathKeys]

end Geometries
end Holo
end NixWars
