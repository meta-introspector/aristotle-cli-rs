import RequestProject.Nix.NixWars.Monster.World

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

/-!
# Putting the irreps into the world

Every row of `irreps_sum.tsv` is a point of the world of `World.lean`: read the
fifteen `p`-adic exponents from the largest prime down, and take the exponent
along the prime `p` as the coordinate along the axis of length `p`, reduced into
the axis (`coords`, `place`).  Truncating that coordinate vector after `d`
entries places the row in the `d`-dimensional grid (`place`), and `voxel d r` is
the index of the cell it lands in.

The point of the hierarchy is resolution, and the table shows it happening.
The 194 rows fall into

```
level  0  1  2  3  4  5  6  7  8  9 10  11  12  13  14  15
cells  1  2  4  8 15 21 30 45 65 86 117 141 164 169 170 170
```

distinct voxels (`occupancy_table`), a number that can only grow as axes are
added (`occupancy_le_succ`), because a coarse voxel is exactly the parent of the
fine one (`voxel_parent`).  At the three-dimensional level `71 × 59 × 47` the
whole table sits in eight cells out of `196883` — the eight corners, since the
exponents of `71`, `59` and `47` are all `0` or `1` (`place_three_le_one`).  At
full resolution the world separates the rows as far as the table itself does:
`170` voxels for the `170` distinct exponent vectors (`occupancy_fifteen`,
`distinct_exps`), so no two different exponent vectors are conflated by the
reduction into the axes, and the only collisions left are rows of the table that
carry literally the same vector.
-/

namespace NixWars

namespace Monster

/-! ## Pointwise domination as a decision procedure -/

/-- `ltAll a L` is `true` when `a` is a valid address for the level with axes `L`. -/
def ltAll : List Nat → List Nat → Bool
  | [], [] => true
  | x :: xs, y :: ys => decide (x < y) && ltAll xs ys
  | _, _ => false

theorem valid_of_ltAll : ∀ {a L : List Nat}, ltAll a L = true → Valid L a
  | [], [], _ => List.Forall₂.nil
  | x :: xs, y :: ys, h => by
      simp only [ltAll, Bool.and_eq_true, decide_eq_true_eq] at h
      exact List.Forall₂.cons h.1 (valid_of_ltAll h.2)
  | [], _ :: _, h => by simp [ltAll] at h
  | _ :: _, [], h => by simp [ltAll] at h

/-! ## Coordinates -/

/-- The fifteen world coordinates of a row: the `p`-adic exponents read from the
largest prime down, each reduced into its axis. -/
def coords (r : IrrepRow) : List Nat :=
  r.exps.reverse.zipWith (fun e p => e % p) worldAxes

/-- The address of a row in the `d`-dimensional grid. -/
def place (d : Nat) (r : IrrepRow) : List Nat := (coords r).take d

/-- The index of the cell of the `d`-dimensional grid that the row lands in. -/
def voxel (d : Nat) (r : IrrepRow) : Nat := encode (level d) (place d r)

theorem worldAxes_pos : ∀ p ∈ worldAxes, 0 < p := by decide

theorem zipWith_mod_valid : ∀ (a L : List Nat), a.length = L.length → (∀ p ∈ L, 0 < p) →
    Valid L (a.zipWith (fun e p => e % p) L)
  | [], [], _, _ => List.Forall₂.nil
  | x :: xs, y :: ys, h, hp => by
      refine List.Forall₂.cons (Nat.mod_lt _ (hp y (by simp))) ?_
      exact zipWith_mod_valid xs ys (by simpa using h) (fun p hpm => hp p (by simp [hpm]))
  | [], _ :: _, h, _ => by simp at h
  | _ :: _, [], h, _ => by simp at h

theorem coords_length {r : IrrepRow} (h : r.exps.length = 15) : (coords r).length = 15 := by
  simp [coords, h, worldAxes_length]

/-- The full coordinate vector is a valid address of the finest grid. -/
theorem coords_valid {r : IrrepRow} (h : r.exps.length = 15) : Valid worldAxes (coords r) :=
  zipWith_mod_valid _ _ (by simp [h, worldAxes_length]) (fun p hp => worldAxes_pos p hp)

theorem valid_take : ∀ {L a : List Nat}, Valid L a → ∀ d, Valid (L.take d) (a.take d) := by
  intro L a h
  induction h with
  | nil => intro d; simp
  | @cons x y xs ys hxy _ ih =>
    intro d
    cases d with
    | zero => simp
    | succ e => exact List.Forall₂.cons hxy (ih e)

/-- A row's `d`-dimensional address is a valid address of the `d`-dimensional grid. -/
theorem place_valid {r : IrrepRow} (h : r.exps.length = 15) (d : Nat) :
    Valid (level d) (place d r) :=
  valid_take (coords_valid h) d

theorem place_length {r : IrrepRow} (h : r.exps.length = 15) {d : Nat} (hd : d ≤ 15) :
    (place d r).length = d := by
  simp [place, coords_length h, Nat.min_eq_left hd]

/-- Every row lands in a cell of the grid. -/
theorem voxel_lt {r : IrrepRow} (h : r.exps.length = 15) (d : Nat) : voxel d r < cells d :=
  encode_lt (place_valid h d)

/-! ## The levels are overlaid: a coarse voxel is the parent of the fine one -/

theorem take_succ_getD : ∀ (l : List Nat) {d : Nat}, d < l.length →
    l.take (d + 1) = l.take d ++ [l.getD d 0]
  | [], d, h => by simp at h
  | x :: xs, d, h => by
      cases d with
      | zero => simp
      | succ e =>
        have he : e < xs.length := by simpa using h
        simp [take_succ_getD xs he]

theorem forall₂_lt_getD : ∀ {a L : List Nat}, Valid L a → ∀ i, i < a.length →
    a.getD i 0 < L.getD i 1 := by
  intro a L h
  induction h with
  | nil => intro i hi; simp at hi
  | @cons x y xs ys hxy _ ih =>
    intro i hi
    cases i with
    | zero => simpa using hxy
    | succ j => simpa using ih j (by simpa using hi)

/-- The `d+1`-dimensional address of a row extends its `d`-dimensional one. -/
theorem place_succ {r : IrrepRow} (h : r.exps.length = 15) {d : Nat} (hd : d < 15) :
    place (d + 1) r = place d r ++ [(coords r).getD d 0] :=
  take_succ_getD (coords r) (by rw [coords_length h]; exact hd)

theorem coords_getD_lt {r : IrrepRow} (h : r.exps.length = 15) {d : Nat} (hd : d < 15) :
    (coords r).getD d 0 < axisAt d :=
  forall₂_lt_getD (coords_valid h) d (by rw [coords_length h]; exact hd)

/-- Overlaying: the level-`d` voxel of a row is the parent of its level-`d+1`
voxel.  The finer grid refines the placement; it never moves a row somewhere
else. -/
theorem voxel_parent {r : IrrepRow} (h : r.exps.length = 15) {d : Nat} (hd : d < 15) :
    voxel d r = parent d (voxel (d + 1) r) := by
  rw [voxel, voxel, place_succ h hd,
    parent_encode hd (place_length h (le_of_lt hd)) (coords_getD_lt h hd)]

/-! ## How many voxels the table occupies -/

/-- The distinct voxels of the `d`-dimensional grid that carry a row. -/
def occupied (d : Nat) : List Nat := (irrepRows.map (voxel d)).dedup

/-- How many cells of the `d`-dimensional grid the table occupies. -/
def occupancy (d : Nat) : Nat := (occupied d).length

/-- Resolution never decreases: adding an axis can only separate rows further. -/
theorem dedup_map_length_le (f : Nat → Nat) (l : List Nat) :
    (l.map f).dedup.length ≤ l.dedup.length := by
  have hsub : (l.map f).dedup ⊆ l.dedup.map f := by
    intro x hx
    obtain ⟨a, ha, rfl⟩ := List.mem_map.mp (List.mem_dedup.mp hx)
    exact List.mem_map.mpr ⟨a, List.mem_dedup.mpr ha, rfl⟩
  calc (l.map f).dedup.length ≤ (l.dedup.map f).length :=
        (List.subperm_of_subset (List.nodup_dedup _) hsub).length_le
    _ = l.dedup.length := by simp

theorem occupancy_le_succ {d : Nat} (hd : d < 15) : occupancy d ≤ occupancy (d + 1) := by
  have hmap : irrepRows.map (voxel d) = (irrepRows.map (voxel (d + 1))).map (parent d) := by
    rw [List.map_map]
    refine List.map_congr_left ?_
    intro r hr
    exact voxel_parent (exps_length r hr) hd
  simp only [occupancy, occupied, hmap]
  exact dedup_map_length_le (parent d) (irrepRows.map (voxel (d + 1)))

/-- The occupancy of every level, from the point to the finest grid. -/
theorem occupancy_table :
    (List.range 16).map occupancy
      = [1, 2, 4, 8, 15, 21, 30, 45, 65, 86, 117, 141, 164, 169, 170, 170] := by
  decide +kernel

/-- At the three-dimensional level the whole table lives in eight of the
`196883` cells. -/
theorem occupancy_three : occupancy 3 = 8 := by decide +kernel

/-- … and those eight are the corners of the box: the exponents of `71`, `59`
and `47` are all `0` or `1`. -/
theorem place_three_le_one : ∀ r ∈ irrepRows, ltAll (place 3 r) [2, 2, 2] = true := by decide +kernel

/-- At full resolution the table occupies `170` voxels. -/
theorem occupancy_fifteen : occupancy 15 = 170 := by decide +kernel

/-- The table itself has `170` distinct exponent vectors, so the finest grid
separates every pair of rows that the table distinguishes: reducing the
exponents into the axes loses nothing. -/
theorem distinct_exps : (irrepRows.map IrrepRow.exps).dedup.length = 170 := by decide +kernel

/-! ## Where the reduction into the axes is the identity -/

/-- For the eleven coarsest axes — the primes from `71` down to `11` — every
exponent is already smaller than its axis, so the coordinate *is* the exponent. -/
theorem place_eleven : ∀ r ∈ irrepRows, place 11 r = r.exps.reverse.take 11 := by decide +kernel

/-- Hence the same is true at every level up to eleven. -/
theorem place_eq_exps {d : Nat} (hd : d ≤ 11) {r : IrrepRow} (hr : r ∈ irrepRows) :
    place d r = r.exps.reverse.take d := by
  have h11 := place_eleven r hr
  have : (place 11 r).take d = (r.exps.reverse.take 11).take d := by rw [h11]
  simpa [place, List.take_take, Nat.min_eq_left hd] using this

end Monster

end NixWars
