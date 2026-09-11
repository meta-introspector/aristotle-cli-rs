import RequestProject.Nix.NixWars.Nested.Tower
import RequestProject.Nix.NixWars.Scene3D

/-!
# The nest in the voxel world

`Nested/Tower.lean` says what a nest of worlds *is*; this file says where it
**stands**.  Every world of the nest is a `16 × 16 × 16` room, drawn as cubes
like every other room of the project.  The floor of a room is divided into
sixteen `4 × 4` cabinet cells, and the miniature world one level down is drawn
*inside the cell of the cabinet it stands in*, at a quarter of the size.  So the
game inside the game is not a separate screen: it is a small box of cubes on the
floor of the big one, and you can see it moving from outside.

Everything is measured in the finest unit the nest uses, so that the whole
picture is one grid of cubes: a cube of the world `k` levels down is
`unit t k = 4 ^ (depth - 1 - k)` fine units across.

What is proved:

* **a world is drawn inside its own box** (`place_in_box`): whatever the state
  of its database, no cube of the world `k` levels down leaves the box allotted
  to level `k`;
* **the miniature world sits exactly in the cabinet it stands in**
  (`box_succ_in_cell`): level `k + 1`'s box is the cell of level `k`'s floor
  belonging to its slot, and a cabinet cell is inside its room
  (`cell_in_box`) — so, by induction, **every cube of every level of the nest
  is inside the outermost world** (`box_in_box_zero`, `nestVoxels_in_picture`);
* **the little world never draws over its neighbours**
  (`cells_disjoint`, `inner_avoids_siblings`): a cube of the game inside the
  game can never land on another cabinet of the room it stands in;
* **playing moves the cubes, not the rooms** (`place_playAt`): trading at any
  depth leaves the whole floor plan of the nest exactly where it was.
-/

set_option maxRecDepth 4000

namespace NixWars

namespace Nested

open Scene3D

/-! ## The floor plan of a nest -/

/-- A cabinet cell is four cells of the room's floor across. -/
def cellSide : Nat := 4

/-- A room's floor holds `cells * cells = 16` cabinet cells. -/
def cells : Nat := 4

/-- Which cabinet of the world above the world `k` levels down stands in. -/
def slotAt (t : Tower) (k : Nat) : Nat := ((t.levels[k]?).map (·.slot)).getD 0

/-- How many fine units one cube of the world `k` levels down is across: the
outermost world is drawn largest, and each world inside a cabinet is a quarter
of the size of the world it stands in. -/
def unit (t : Tower) (k : Nat) : Nat := cellSide ^ (t.depth - 1 - k)

theorem unit_pos (t : Tower) (k : Nat) : 0 < unit t k :=
  pow_pos (by norm_num [cellSide]) _

/-- Each world inside a cabinet is a quarter of the size of its host. -/
theorem unit_succ (t : Tower) (k : Nat) (hk : k + 1 < t.depth) :
    unit t k = cellSide * unit t (k + 1) := by
  have hexp : t.depth - 1 - k = (t.depth - 1 - (k + 1)) + 1 := by omega
  simp only [unit, hexp, pow_succ]
  ring

/-- Where the box of the world `k` levels down starts, along the first axis. -/
def originX (t : Tower) : Nat → Nat
  | 0 => 0
  | k + 1 => originX t k + unit t k * (cellSide * (slotAt t (k + 1) % cells))

/-- Where the box of the world `k` levels down starts, along the third axis. -/
def originZ (t : Tower) : Nat → Nat
  | 0 => 0
  | k + 1 => originZ t k + unit t k * (cellSide * (slotAt t (k + 1) / cells))

/-- A cube of the world `k` levels down, drawn in the picture of the whole
nest. -/
def place (t : Tower) (k : Nat) (v : Voxel) : Voxel :=
  ⟨originX t k + unit t k * v.x, unit t k * v.y, originZ t k + unit t k * v.z, v.colour⟩

/-- A cube inside a world's own `16 × 16 × 16` room. -/
def InRoom (v : Voxel) : Prop := v.x < arena ∧ v.y < arena ∧ v.z < arena

/-- A cube inside the box the world `k` levels down is drawn in. -/
def InBox (t : Tower) (k : Nat) (v : Voxel) : Prop :=
  originX t k ≤ v.x ∧ v.x < originX t k + arena * unit t k ∧
  v.y < arena * unit t k ∧
  originZ t k ≤ v.z ∧ v.z < originZ t k + arena * unit t k

/-- A cube inside cabinet cell `s` of the floor of the world `k` levels down. -/
def InCell (t : Tower) (k s : Nat) (v : Voxel) : Prop :=
  originX t k + unit t k * (cellSide * (s % cells)) ≤ v.x ∧
  v.x < originX t k + unit t k * (cellSide * (s % cells)) + cellSide * unit t k ∧
  v.y < cellSide * unit t k ∧
  originZ t k + unit t k * (cellSide * (s / cells)) ≤ v.z ∧
  v.z < originZ t k + unit t k * (cellSide * (s / cells)) + cellSide * unit t k

/-! ## Every world stays in its box -/

/-- **A world is drawn inside its own box**, whatever state its database is
in. -/
theorem place_in_box (t : Tower) (k : Nat) (v : Voxel) (h : InRoom v) :
    InBox t k (place t k v) := by
  obtain ⟨hx, hy, hz⟩ := h
  have hu : 0 < unit t k := unit_pos t k
  have hbx : unit t k * v.x < unit t k * arena := Nat.mul_lt_mul_of_pos_left hx hu
  have hby : unit t k * v.y < unit t k * arena := Nat.mul_lt_mul_of_pos_left hy hu
  have hbz : unit t k * v.z < unit t k * arena := Nat.mul_lt_mul_of_pos_left hz hu
  simp only [InBox, place, arena] at *
  refine ⟨by omega, by omega, by omega, by omega, by omega⟩

/-- **A cabinet cell is inside the room whose floor it is.** -/
theorem cell_in_box (t : Tower) (k s : Nat) (hs : s < arena) (v : Voxel)
    (h : InCell t k s v) : InBox t k v := by
  have hx : cellSide * (s % cells) + cellSide ≤ arena := by
    simp only [cellSide, cells, arena] at *
    omega
  have hz : cellSide * (s / cells) + cellSide ≤ arena := by
    simp only [cellSide, cells, arena] at *
    omega
  have hdx : unit t k * (cellSide * (s % cells) + cellSide)
      = unit t k * (cellSide * (s % cells)) + cellSide * unit t k := by ring
  have hdz : unit t k * (cellSide * (s / cells) + cellSide)
      = unit t k * (cellSide * (s / cells)) + cellSide * unit t k := by ring
  have hbx := Nat.mul_le_mul_left (unit t k) hx
  have hbz := Nat.mul_le_mul_left (unit t k) hz
  rw [hdx] at hbx
  rw [hdz] at hbz
  obtain ⟨h1, h2, h3, h4, h5⟩ := h
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> simp only [arena] at * <;> omega

/-- **The miniature world sits exactly in the cabinet it stands in.** -/
theorem box_succ_in_cell (t : Tower) (k : Nat) (hk : k + 1 < t.depth) (v : Voxel)
    (h : InBox t (k + 1) v) : InCell t k (slotAt t (k + 1)) v := by
  have hu := unit_succ t k hk
  have h16 : arena * unit t (k + 1) = cellSide * unit t k := by
    rw [hu]
    simp only [arena, cellSide]
    ring
  obtain ⟨h1, h2, h3, h4, h5⟩ := h
  simp only [originX, originZ] at h1 h2 h4 h5
  rw [h16] at h2 h3 h5
  exact ⟨h1, by omega, h3, h4, by omega⟩

/-- **Every cube of every level of the nest is inside the outermost world.** -/
theorem box_in_box_zero (t : Tower) (hslots : ∀ j, slotAt t j < arena) :
    ∀ k, k < t.depth → ∀ v, InBox t k v → InBox t 0 v := by
  intro k
  induction k with
  | zero => intro _ v h; exact h
  | succ k ih =>
      intro hk v h
      exact ih (by omega) v (cell_in_box t k (slotAt t (k + 1)) (hslots (k + 1)) v
        (box_succ_in_cell t k hk v h))

/-! ## The little world never draws over its neighbours -/

/-- One cabinet cell along is a whole cell further across the floor. -/
theorem cell_step (t : Tower) (k a b : Nat) (hab : a < b) :
    unit t k * (cellSide * a) + cellSide * unit t k ≤ unit t k * (cellSide * b) := by
  have hle : cellSide * a + cellSide ≤ cellSide * b := by
    simp only [cellSide]
    omega
  have hd : unit t k * (cellSide * a + cellSide)
      = unit t k * (cellSide * a) + cellSide * unit t k := by ring
  have hmul := Nat.mul_le_mul_left (unit t k) hle
  omega

/-- **Two different cabinets of the same floor never share a cube.** -/
theorem cells_disjoint (t : Tower) (k s s' : Nat) (hne : s ≠ s') (v w : Voxel)
    (hv : InCell t k s v) (hw : InCell t k s' w) : v.x ≠ w.x ∨ v.z ≠ w.z := by
  obtain ⟨v1, v2, _, v4, v5⟩ := hv
  obtain ⟨w1, w2, _, w4, w5⟩ := hw
  simp only [cells] at *
  by_cases hmod : s % 4 = s' % 4
  · right
    have hdiv : s / 4 ≠ s' / 4 := by
      intro hc
      exact hne (by omega)
    rcases Nat.lt_or_ge (s / 4) (s' / 4) with hlt | hge
    · have hstep := cell_step t k (s / 4) (s' / 4) hlt
      omega
    · have hstep := cell_step t k (s' / 4) (s / 4) (by omega)
      omega
  · left
    rcases Nat.lt_or_ge (s % 4) (s' % 4) with hlt | hge
    · have hstep := cell_step t k (s % 4) (s' % 4) hlt
      omega
    · have hstep := cell_step t k (s' % 4) (s % 4) (by omega)
      omega

/-- **A cube of the game inside the game can never land on another cabinet of
the room it stands in.** -/
theorem inner_avoids_siblings (t : Tower) (k s : Nat) (hk : k + 1 < t.depth)
    (hne : s ≠ slotAt t (k + 1)) (v w : Voxel) (hv : InRoom v) (hw : InCell t k s w) :
    (place t (k + 1) v).x ≠ w.x ∨ (place t (k + 1) v).z ≠ w.z :=
  cells_disjoint t k s (slotAt t (k + 1)) hne w (place t (k + 1) v) hw
    (box_succ_in_cell t k hk _ (place_in_box t (k + 1) v hv)) |>.imp
    (fun h => h.symm) (fun h => h.symm)

/-! ## The cubes of a nest -/

/-- A world's own picture: one tower of cubes per account, a cube to the shard,
and the market's shelf standing at the back corner. -/
def dbVoxels (db : Db) : List Voxel :=
  (List.range arena).flatMap (fun i =>
    (List.range (min ((db.accounts.getD i default).held) arena)).map
      (fun h => ⟨i, h, 0, 3⟩)) ++
  (List.range (min db.float arena)).map (fun h => ⟨arena - 1, h, arena - 1, 4⟩)

theorem dbVoxels_in_room (db : Db) : ∀ v ∈ dbVoxels db, InRoom v := by
  intro v hv
  simp only [dbVoxels, List.mem_append, List.mem_flatMap, List.mem_map, List.mem_range] at hv
  rcases hv with ⟨i, hi, h, hh, hveq⟩ | ⟨h, hh, hveq⟩
  · subst hveq
    exact ⟨hi, by simp only [arena] at *; omega, by simp [arena]⟩
  · subst hveq
    exact ⟨by simp [arena], by simp only [arena] at *; omega, by simp [arena]⟩

/-- The whole nest as one picture: every world drawn in its own box. -/
def nestVoxels (t : Tower) : List Voxel :=
  (List.range t.depth).flatMap (fun k =>
    match dbAt t k with
    | some db => (dbVoxels db).map (place t k)
    | none => [])

/-- **The whole nest is one picture**: every cube of every world, at every
depth, stands inside the outermost world's box. -/
theorem nestVoxels_in_picture (t : Tower) (hslots : ∀ j, slotAt t j < arena) :
    ∀ v ∈ nestVoxels t, InBox t 0 v := by
  intro v hv
  simp only [nestVoxels, List.mem_flatMap, List.mem_range] at hv
  obtain ⟨k, hk, hvk⟩ := hv
  cases hdb : dbAt t k with
  | none => rw [hdb] at hvk; simp at hvk
  | some db =>
      rw [hdb] at hvk
      simp only [List.mem_map] at hvk
      obtain ⟨u, hu, rfl⟩ := hvk
      exact box_in_box_zero t hslots k hk _ (place_in_box t k u (dbVoxels_in_room db u hu))

/-! ## Playing moves the cubes, not the rooms -/

theorem slotAt_playAt (t : Tower) (k : Nat) (tx : Tx) (j : Nat) :
    slotAt (playAt t k tx) j = slotAt t j := by
  simp only [slotAt, playAt_slots]

theorem unit_playAt (t : Tower) (k : Nat) (tx : Tx) (j : Nat) :
    unit (playAt t k tx) j = unit t j := by
  simp only [unit, playAt_depth]

theorem originX_playAt (t : Tower) (k : Nat) (tx : Tx) (j : Nat) :
    originX (playAt t k tx) j = originX t j := by
  induction j with
  | zero => rfl
  | succ j ih => simp only [originX, ih, unit_playAt, slotAt_playAt]

theorem originZ_playAt (t : Tower) (k : Nat) (tx : Tx) (j : Nat) :
    originZ (playAt t k tx) j = originZ t j := by
  induction j with
  | zero => rfl
  | succ j ih => simp only [originZ, ih, unit_playAt, slotAt_playAt]

/-- **Playing moves the cubes, not the rooms.**  A trade at any depth leaves the
floor plan of the whole nest exactly where it was. -/
theorem place_playAt (t : Tower) (k : Nat) (tx : Tx) (j : Nat) (v : Voxel) :
    place (playAt t k tx) j v = place t j v := by
  simp only [place, originX_playAt, originZ_playAt, unit_playAt]

end Nested

end NixWars
