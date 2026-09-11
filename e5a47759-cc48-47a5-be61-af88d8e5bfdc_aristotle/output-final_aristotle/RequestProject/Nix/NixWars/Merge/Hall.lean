import RequestProject.Nix.NixWars.Merge.World

/-!
# The hall: all fifteen cabinets standing in one voxel world

`Scene3D.lean` says how a single cabinet's state vector becomes cubes, inside a
`16 × 16 × 16` arena.  This file puts all fifteen of those arenas into **one**
room, so that a player can walk from cabinet to cabinet in the 3D voxel view
without ever leaving the world — and see the merged score standing in the same
room as the games that paid for it.

The floor plan is four cabinets to a row: cabinet `i` occupies the block of
`16 × 16` floor tiles at `(16 · (i % 4), 16 · (i / 4))`, and the shared
scoreboard stands along the back wall, one tower per game plus one for the bank.

What is proved:

* **every cabinet stays in its own block** (`cabinetVoxels_in_block`), whatever
  state it is in, so
* **no two cabinets ever overlap** (`cabinets_disjoint`): a cube drawn for one
  game can never land on a cube drawn for another, and a player always knows
  which machine they are looking at;
* **the scoreboard stands clear of the floor** (`scoreboard_disjoint`): it is
  behind every cabinet, so the merged total never hides a game;
* **the room is bounded** (`hallVoxels_in_room`): every cube of the whole hall,
  in every state of every game, lies in the `64 × 16 × 65` box the renderer
  allocates, and there are never more than `hallBound` of them
  (`hallVoxels_length_le`);
* **nothing is hidden** (`hall_shows_every_field`): every field of every one of
  the fifteen state vectors is drawn by some gadget of the cabinet that stands
  for it.
-/

set_option maxRecDepth 100000

namespace NixWars

namespace Merge

namespace Hall

open Scene3D

/-! ## The floor plan -/

/-- Cabinets stand four to a row. -/
def cols : Nat := 4

/-- The rows the cabinets occupy: fifteen cabinets, four to a row. -/
def rows : Nat := 4

/-- Where cabinet `i`'s block starts along the first axis. -/
def blockX (i : Nat) : Nat := arena * (i % cols)

/-- Where cabinet `i`'s block starts along the third axis. -/
def blockZ (i : Nat) : Nat := arena * (i / cols)

/-- The width of the hall. -/
def hallWidth : Nat := arena * cols

/-- The scoreboard stands one block behind the last row of cabinets. -/
def boardZ : Nat := arena * rows

/-! ## The cubes -/

/-- Cabinet `i`, drawn in its own block of the hall. -/
def cabinetVoxels (i : Nat) (st : List Nat) : List Voxel :=
  match doorScenes[i]? with
  | some p => (sceneVoxels p.2.2 st).map
      (fun v => ⟨v.x + blockX i, v.y, v.z + blockZ i, v.colour⟩)
  | none => []

/-- The shared scoreboard: one tower per game, its record capped to the height of
the room, and one tower for the bank, a cube to the shard. -/
def scoreboardVoxels (w : World) : List Voxel :=
  (List.range numGames).flatMap (fun i =>
    (List.range (min (purseGet w.purse i) arena)).map (fun h => ⟨i, h, boardZ, 1⟩)) ++
  (List.range (min w.bank arena)).map (fun h => ⟨numGames, h, boardZ, 2⟩)

/-- The whole hall: fifteen cabinets and the scoreboard. -/
def hallVoxels (w : World) : List Voxel :=
  (List.range numGames).flatMap (fun i => cabinetVoxels i (w.states.getD i [])) ++
    scoreboardVoxels w

/-! ## Every cabinet stays in its own block -/

theorem cabinetVoxels_in_block (i : Nat) (st : List Nat) :
    ∀ v ∈ cabinetVoxels i st,
      blockX i ≤ v.x ∧ v.x < blockX i + arena ∧ v.y < arena ∧
        blockZ i ≤ v.z ∧ v.z < blockZ i + arena := by
  intro v hv
  simp only [cabinetVoxels] at hv
  cases hp : doorScenes[i]? with
  | none => simp [hp] at hv
  | some p =>
    rw [hp] at hv
    simp only [List.mem_map] at hv
    obtain ⟨u, hu, rfl⟩ := hv
    have hmem : p ∈ doorScenes := List.mem_of_getElem? hp
    obtain ⟨hx, hy, hz⟩ := doorScene_in_arena p hmem st u hu
    refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> dsimp only <;> omega

/-- **No two cabinets ever overlap.** -/
theorem cabinets_disjoint (i j : Nat) (hij : i ≠ j)
    (sti stj : List Nat) (v w : Voxel) (hv : v ∈ cabinetVoxels i sti)
    (hw : w ∈ cabinetVoxels j stj) : v.x ≠ w.x ∨ v.z ≠ w.z := by
  obtain ⟨hx1, hx2, _, hz1, hz2⟩ := cabinetVoxels_in_block i sti v hv
  obtain ⟨hx3, hx4, _, hz3, hz4⟩ := cabinetVoxels_in_block j stj w hw
  simp only [blockX, blockZ, arena, cols] at *
  by_cases hcol : i % 4 = j % 4
  · right
    have : i / 4 ≠ j / 4 := by omega
    omega
  · left
    omega

/-- **The scoreboard stands clear of the cabinets.** -/
theorem scoreboard_disjoint (w : World) (i : Nat) (hi : i < numGames) (st : List Nat)
    (v u : Voxel) (hv : v ∈ cabinetVoxels i st) (hu : u ∈ scoreboardVoxels w) : v.z ≠ u.z := by
  obtain ⟨_, _, _, _, hz⟩ := cabinetVoxels_in_block i st v hv
  have huz : u.z = boardZ := by
    simp only [scoreboardVoxels, List.mem_append, List.mem_flatMap, List.mem_map] at hu
    rcases hu with ⟨k, _, h, _, rfl⟩ | ⟨h, _, rfl⟩ <;> rfl
  simp only [blockZ, boardZ, arena, cols, rows, numGames] at *
  omega

/-! ## The room is bounded -/

theorem scoreboardVoxels_in_room (w : World) :
    ∀ v ∈ scoreboardVoxels w, v.x ≤ numGames ∧ v.y < arena ∧ v.z = boardZ := by
  intro v hv
  simp only [scoreboardVoxels, List.mem_append, List.mem_flatMap, List.mem_map,
    List.mem_range] at hv
  rcases hv with ⟨k, hk, h, hh, rfl⟩ | ⟨h, hh, rfl⟩
  · refine ⟨?_, ?_, rfl⟩ <;> dsimp only <;> omega
  · refine ⟨?_, ?_, rfl⟩ <;> dsimp only <;> omega

/-- **The whole hall fits in the box the renderer allocates.** -/
theorem hallVoxels_in_room (w : World) :
    ∀ v ∈ hallVoxels w, v.x < hallWidth ∧ v.y < arena ∧ v.z ≤ boardZ := by
  intro v hv
  simp only [hallVoxels, List.mem_append, List.mem_flatMap, List.mem_range] at hv
  rcases hv with ⟨i, hi, hmem⟩ | hmem
  · obtain ⟨_, hx, hy, _, hz⟩ := cabinetVoxels_in_block i _ v hmem
    simp only [blockX, blockZ, hallWidth, boardZ, arena, cols, rows, numGames] at *
    exact ⟨by omega, hy, by omega⟩
  · obtain ⟨hx, hy, hz⟩ := scoreboardVoxels_in_room w v hmem
    simp only [hallWidth, arena, cols, numGames] at *
    exact ⟨by omega, hy, by omega⟩

/-- How many cubes the hall can need at once. -/
def hallBound : Nat := numGames * (arena * 20) + (numGames + 1) * arena

/-- No cabinet's scene has more than twenty gadgets. -/
theorem doorScenes_gadget_count : ∀ p ∈ doorScenes, p.2.2.length ≤ 20 := by decide

theorem cabinetVoxels_length_le (i : Nat) (st : List Nat) :
    (cabinetVoxels i st).length ≤ arena * 20 := by
  simp only [cabinetVoxels]
  cases hp : doorScenes[i]? with
  | none => simp [arena]
  | some p =>
    have hmem : p ∈ doorScenes := List.mem_of_getElem? hp
    have hle := doorScene_size p hmem st
    have hlen : p.2.2.length ≤ 20 := doorScenes_gadget_count p hmem
    simp only [List.length_map]
    exact Nat.le_trans hle (Nat.mul_le_mul_left arena hlen)

theorem scoreboardVoxels_length_le (w : World) :
    (scoreboardVoxels w).length ≤ (numGames + 1) * arena := by
  simp only [scoreboardVoxels, List.length_append, List.length_map, List.length_flatMap]
  have h1 : ((List.range numGames).map
      (fun i => (List.range (min (purseGet w.purse i) arena)).length)).sum ≤ numGames * arena := by
    have : ∀ x ∈ (List.range numGames).map
        (fun i => (List.range (min (purseGet w.purse i) arena)).length), x ≤ arena := by
      intro x hx
      simp only [List.mem_map, List.mem_range, List.length_range] at hx
      obtain ⟨i, _, rfl⟩ := hx
      exact Nat.min_le_right _ _
    calc ((List.range numGames).map
            (fun i => (List.range (min (purseGet w.purse i) arena)).length)).sum
        ≤ ((List.range numGames).map (fun _ => arena)).length * arena := by
          simpa using List.sum_le_card_nsmul _ arena this
      _ = numGames * arena := by simp
  have h2 : (List.range (min w.bank arena)).length ≤ arena := by
    simp
  simp only [List.length_range, numGames, arena] at *
  omega

/-- The renderer never has to draw more than `hallBound` cubes. -/
theorem hallVoxels_length_le (w : World) : (hallVoxels w).length ≤ hallBound := by
  simp only [hallVoxels, List.length_append, List.length_flatMap, hallBound]
  have h1 : ((List.range numGames).map
      (fun i => (cabinetVoxels i (w.states.getD i [])).length)).sum ≤ numGames * (arena * 20) := by
    have hall : ∀ x ∈ (List.range numGames).map
        (fun i => (cabinetVoxels i (w.states.getD i [])).length), x ≤ arena * 20 := by
      intro x hx
      simp only [List.mem_map, List.mem_range] at hx
      obtain ⟨i, _, rfl⟩ := hx
      exact cabinetVoxels_length_le i _
    calc ((List.range numGames).map
            (fun i => (cabinetVoxels i (w.states.getD i [])).length)).sum
        ≤ ((List.range numGames).map (fun _ => arena * 20)).length * (arena * 20) := by
          simpa using List.sum_le_card_nsmul _ (arena * 20) hall
      _ = numGames * (arena * 20) := by simp
  have h2 := scoreboardVoxels_length_le w
  omega

/-- **Nothing is hidden**: every field of every cabinet's state vector is drawn
by some gadget of the scene that stands in that cabinet's block. -/
theorem hall_shows_every_field :
    ∀ i < numGames, ∀ p, doorScenes[i]? = some p → ∀ f ∈ List.range p.2.1,
      f ∈ sceneFields p.2.2 := by
  intro i _ p hp f hf
  exact doorScenes_cover_fields p (List.mem_of_getElem? hp) f hf

end Hall

end Merge

end NixWars
