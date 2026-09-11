import RequestProject.Gvcs.VoxelGame.Yard
import RequestProject.Gvcs.Voxel.Parts
import RequestProject.Gvcs.Game

/-!
# The game, seen as voxels

`RequestProject/Game.lean` is the rule book: a `GameState` is cash, a store of
material, the machines already built, fuel and a calendar, and `Build.step` is
what a move does to it.  Every one of those is a *number*, and a number is not
something a player can walk up to.  This file turns the whole state into a
world of voxels — the same 5 cm lattice the machine itself is modelled on:

| the state says | the world shows |
| --- | --- |
| `built`, driven by `Config` | the machine, voxel for voxel, as `Voxel/Parts` builds it |
| `stock` | the yard: one pile per material, one voxel to the lot |
| `built` | the shed: one column per subassembly, labelled with its name |
| `fuel` | the fuel gauge: one voxel to five litres |
| `cash` | the cash column: one voxel to a hundred |
| `hectares` | the field: one row of eight crop voxels per hectare |
| the ground | soil, with topsoil at `z = -1` |

The districts stand in slabs of their own along `y`, so nothing hides anything
else (`scene_eq_yard`, `scene_eq_shed`, `scene_eq_fuelGauge`, …), and the point
of the file is that the view is *faithful*:

* `tally_scene_stock`, `tally_scene_fuel`, `tally_scene_cash`,
  `tally_scene_crop` — counting the voxels of a kind gives back the number the
  rule book holds, to the resolution of the gauge, which `gaugeHeight_read`
  makes precise;
* `scene_shed_iff` — the shed shows exactly the machines the player owns;
* `machineWorld_ne_air_iff` — the machine district is exactly the solid the
  proofs of `Voxel/Parts.lean` are about.
-/

namespace LifeTrac
namespace VoxelGame

open Voxel
open Voxel.Solid
open Build

/-! ## Where the districts stand -/

/-- The line of the yard. -/
def yardY : ℤ := 24

/-- The line of the shed. -/
def shedY : ℤ := -24

/-- The foot of the fuel gauge. -/
def fuelFoot : Vox := (0, 30, 0)

/-- The foot of the cash column. -/
def cashFoot : Vox := (0, 34, 0)

/-- The near edge of the field. -/
def fieldY : ℤ := 40

/-- Litres of fuel to the voxel. -/
def fuelPerVoxel : ℚ := 5

/-- Money to the voxel. -/
def cashPerVoxel : ℚ := 100

theorem fuelPerVoxel_pos : 0 < fuelPerVoxel := by norm_num [fuelPerVoxel]

theorem cashPerVoxel_pos : 0 < cashPerVoxel := by norm_num [cashPerVoxel]

/-! ## The districts -/

/-- The ground: topsoil at `z = -1`, subsoil below it. -/
def terrain : World := fun v =>
  if v.z = -1 then .grass else if v.z ≤ -1 then .soil else .air

theorem terrain_air_of_nonneg {v : Vox} (h : 0 ≤ v.z) : terrain v = .air := by
  simp only [terrain]
  rw [if_neg (by omega), if_neg (by omega)]

theorem terrain_ne {d : Cell} (h1 : d ≠ .grass) (h2 : d ≠ .soil) (h3 : d ≠ .air) (v : Vox) :
    terrain v ≠ d := by
  simp only [terrain]
  split
  · exact fun h => h1 h.symm
  · split
    · exact fun h => h2 h.symm
    · exact fun h => h3 h.symm

/-- The machine, each voxel labelled with the body that owns it. -/
def machineWorld (c : Config) : World := fun v =>
  match bodies.find? (fun b => b.at c v) with
  | some b => .body b.name
  | none => .air

theorem machineWorld_cell (c : Config) (v : Vox) :
    machineWorld c v = .air ∨ ∃ nm, machineWorld c v = .body nm := by
  simp only [machineWorld]
  cases bodies.find? (fun b => b.at c v) with
  | none => exact Or.inl rfl
  | some b => exact Or.inr ⟨b.name, rfl⟩

theorem machineWorld_ne {d : Cell} (hb : ∀ nm, d ≠ .body nm) (ha : d ≠ .air) (c : Config)
    (v : Vox) : machineWorld c v ≠ d := by
  rcases machineWorld_cell c v with h | ⟨nm, h⟩ <;> rw [h]
  · exact fun hc => ha hc.symm
  · exact fun hc => hb nm hc.symm

/-- **The machine district is the machine.**  A voxel of the world is a piece
of the tractor exactly where the solid of `Voxel/Parts.lean` says there is
material. -/
theorem machineWorld_ne_air_iff (c : Config) (v : Vox) :
    machineWorld c v ≠ .air ↔ machine c v = true := by
  simp only [machineWorld, machine, unions_eq_true_iff]
  cases hf : bodies.find? (fun b => b.at c v) with
  | none =>
      simp only [ne_eq, not_true_eq_false, false_iff, not_exists]
      rintro s ⟨hs, hsv⟩
      obtain ⟨b, hb, rfl⟩ := List.mem_map.1 hs
      have := List.find?_eq_none.1 hf b hb
      simp only at this
      exact this hsv
  | some b =>
      have hb : b ∈ bodies := List.mem_of_find?_eq_some hf
      have hbv : b.at c v = true := by
        have := List.find?_some hf
        simpa using this
      simp only [ne_eq, reduceCtorEq, not_false_eq_true, true_iff]
      exact ⟨b.at c, List.mem_map.2 ⟨b, hb, rfl⟩, hbv⟩

theorem solid_machineWorld (c : Config) : World.solid (machineWorld c) = machine c := by
  funext v
  by_cases h : machine c v = true
  · simp [World.solid, (machineWorld_ne_air_iff c v).2 h, h]
  · simp only [Bool.not_eq_true] at h
    have hair : machineWorld c v = .air := by
      by_contra hcon
      have hm := (machineWorld_ne_air_iff c v).1 hcon
      rw [h] at hm
      exact Bool.noConfusion hm
    simp [World.solid, hair, h]

/-- The machine keeps to its own slab. -/
theorem machineWorld_air_of_y {c : Config} (hc : c.Valid) {v : Vox} (h : 17 < v.y ∨ v.y < -17) :
    machineWorld c v = .air := by
  by_contra hne
  have hm := (machineWorld_ne_air_iff c v).1 hne
  have := (machine_in_envelope hc).2.1 v hm
  omega

/-- The fuel gauge. -/
def fuelGauge (q : ℚ) : World := column fuelFoot (gaugeHeight fuelPerVoxel q) .fuel

/-- The cash column. -/
def cashStack (q : ℚ) : World := column cashFoot (gaugeHeight cashPerVoxel q) .coin

/-- One row of eight crop voxels per hectare worked. -/
def cropRows (ha : ℚ) : ℕ := ⌊ha⌋₊

/-- The far corner of the field. -/
def cropCorner (ha : ℚ) : Vox := ((cropRows ha : ℤ) - 1, fieldY + 7, 0)

/-- The field. -/
def cropField (ha : ℚ) : World :=
  World.paint (box (0, fieldY, 0) (cropCorner ha)) (.crop 1)

theorem cropField_cell (ha : ℚ) (v : Vox) :
    cropField ha v = .air ∨ cropField ha v = .crop 1 := by
  simp only [cropField, World.paint_apply]
  split <;> simp

theorem cropField_ne {d : Cell} (h1 : d ≠ .crop 1) (h2 : d ≠ .air) (ha : ℚ) (v : Vox) :
    cropField ha v ≠ d := by
  rcases cropField_cell ha v with h | h <;> rw [h]
  · exact fun hc => h2 hc.symm
  · exact fun hc => h1 hc.symm

theorem cropField_air_of_y {ha : ℚ} {v : Vox} (h : v.y < fieldY ∨ fieldY + 7 < v.y) :
    cropField ha v = .air := by
  simp only [cropField, World.paint_apply]
  rw [if_neg]
  intro hb
  rw [mem_box] at hb
  simp only [cropCorner, Vox.y_mk] at hb
  omega

theorem cropField_air_of_z {ha : ℚ} {v : Vox} (h : v.z ≠ 0) : cropField ha v = .air := by
  simp only [cropField, World.paint_apply]
  rw [if_neg]
  intro hb
  rw [mem_box] at hb
  simp only [cropCorner, Vox.z_mk] at hb
  omega

/-- The shed. -/
def shed (built : List Assembly) : World := shedOf shedY 0 built

theorem shed_cell (built : List Assembly) (v : Vox) :
    shed built v = .air ∨ ∃ nm, shed built v = .shed nm := by
  by_cases h : shed built v = .air
  · exact Or.inl h
  · obtain ⟨a, -, ha⟩ := shedOf_locate h
    exact Or.inr ⟨a.name, ha⟩

theorem shed_ne {d : Cell} (h1 : ∀ nm, d ≠ .shed nm) (h2 : d ≠ .air) (built : List Assembly)
    (v : Vox) : shed built v ≠ d := by
  rcases shed_cell built v with h | ⟨nm, h⟩ <;> rw [h]
  · exact fun hc => h2 hc.symm
  · exact fun hc => h1 nm hc.symm

/-- Nothing of the shed stands outside the shed's line. -/
theorem shedOf_y {k : ℕ} {l : List Assembly} {v : Vox} (h : shedOf shedY k l v ≠ .air) :
    v.y = shedY := by
  induction l generalizing k with
  | nil => exact absurd rfl h
  | cons a as ih =>
      by_cases ha : column (2 * (k : ℤ), shedY, 0) 2 (Cell.shed a.name) v = .air
      · rw [shedOf, World.lay_apply, if_pos ha] at h
        exact ih h
      · by_contra hy
        exact ha (column_air_of_ne_y (by simpa using hy) _ _)

/-- Nothing of the shed is buried. -/
theorem shedOf_above_z {k : ℕ} {l : List Assembly} {v : Vox}
    (h : shedOf shedY k l v ≠ .air) : 0 ≤ v.z := by
  induction l generalizing k with
  | nil => exact absurd rfl h
  | cons a as ih =>
      by_cases ha : column (2 * (k : ℤ), shedY, 0) 2 (Cell.shed a.name) v = .air
      · rw [shedOf, World.lay_apply, if_pos ha] at h
        exact ih h
      · by_contra hz
        exact ha (column_air_of_lt_z (by simpa using hz) _ _)

theorem shed_air_of_ne_y {built : List Assembly} {v : Vox} (h : v.y ≠ shedY) :
    shed built v = .air := by
  by_contra hc
  exact h (shedOf_y hc)

/-- Nothing of the yard stands outside the yard's line. -/
theorem yard_air_of_ne_y {i : Inventory} {v : Vox} (h : v.y ≠ yardY) :
    yard yardY i v = .air := by
  by_contra hc
  obtain ⟨-, -, -, -, hy⟩ := yardOf_locate hc
  exact h hy

theorem yard_cell {i : Inventory} (v : Vox) :
    yard yardY i v = .air ∨ ∃ m, yard yardY i v = .stock m := by
  by_cases h : yard yardY i v = .air
  · exact Or.inl h
  · obtain ⟨m, -, hm, -, -⟩ := yardOf_locate h
    exact Or.inr ⟨m, hm⟩

theorem yard_ne {d : Cell} (h1 : ∀ m, d ≠ .stock m) (h2 : d ≠ .air) (i : Inventory) (v : Vox) :
    yard yardY i v ≠ d := by
  rcases yard_cell (i := i) v with h | ⟨m, h⟩ <;> rw [h]
  · exact fun hc => h2 hc.symm
  · exact fun hc => h1 m hc.symm

/-! ## The scene -/

/-- **The whole game, as a world.**  The machine first, then the yard, the
shed, the two gauges, the field and the ground. -/
def scene (s : GameState) (c : Config) : World :=
  World.stack [machineWorld c, yard yardY s.stock, shed s.built, fuelGauge s.fuel,
    cashStack s.cash, cropField s.hectares, terrain]

/-- Whatever the scene shows at a voxel, some district of it is showing. -/
theorem stack_mem_value {l : List World} {v : Vox} (h : World.stack l v ≠ .air) :
    ∃ w ∈ l, w v = World.stack l v := by
  induction l with
  | nil => exact absurd rfl h
  | cons w l ih =>
      by_cases hw : w v = .air
      · rw [World.stack_cons, World.lay_apply, if_pos hw] at h ⊢
        obtain ⟨u, hu, hu'⟩ := ih h
        exact ⟨u, List.mem_cons_of_mem _ hu, hu'⟩
      · exact ⟨w, List.mem_cons_self .., by rw [World.stack_cons, World.lay_apply, if_neg hw]⟩

/-- A cell the scene shows is shown by one of its districts. -/
theorem scene_mem_value {s : GameState} {c : Config} {v : Vox} {d : Cell} (hd : d ≠ .air)
    (h : scene s c v = d) :
    machineWorld c v = d ∨ yard yardY s.stock v = d ∨ shed s.built v = d ∨
      fuelGauge s.fuel v = d ∨ cashStack s.cash v = d ∨ cropField s.hectares v = d ∨
      terrain v = d := by
  have hne : scene s c v ≠ .air := by rw [h]; exact hd
  obtain ⟨w, hw, hval⟩ := stack_mem_value hne
  have hval' : w v = d := by rw [hval]; exact h
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hw
  rcases hw with rfl|rfl|rfl|rfl|rfl|rfl|rfl <;> simp [hval']

/-! ### Reading the scene district by district -/

theorem scene_eq_yard {s : GameState} {c : Config} (hc : c.Valid) {v : Vox}
    (hy : v.y = yardY) (hz : 0 ≤ v.z) : scene s c v = yard yardY s.stock v := by
  have h1 : machineWorld c v = .air :=
    machineWorld_air_of_y hc (by rw [hy]; left; norm_num [yardY])
  have h3 : shed s.built v = .air := shed_air_of_ne_y (by rw [hy]; norm_num [yardY, shedY])
  have h4 : fuelGauge s.fuel v = .air :=
    column_air_of_ne_y (by rw [hy]; norm_num [yardY, fuelFoot]) _ _
  have h5 : cashStack s.cash v = .air :=
    column_air_of_ne_y (by rw [hy]; norm_num [yardY, cashFoot]) _ _
  have h6 : cropField s.hectares v = .air :=
    cropField_air_of_y (by rw [hy]; left; norm_num [yardY, fieldY])
  have h7 : terrain v = .air := terrain_air_of_nonneg hz
  by_cases hyd : yard yardY s.stock v = .air
  · simp [scene, World.lay_apply, h1, h3, h4, h5, h6, h7, hyd]
  · simp [scene, World.lay_apply, h1, hyd]

theorem scene_eq_shed {s : GameState} {c : Config} (hc : c.Valid) {v : Vox}
    (hy : v.y = shedY) (hz : 0 ≤ v.z) : scene s c v = shed s.built v := by
  have h1 : machineWorld c v = .air :=
    machineWorld_air_of_y hc (by rw [hy]; right; norm_num [shedY])
  have h2 : yard yardY s.stock v = .air := yard_air_of_ne_y (by rw [hy]; norm_num [yardY, shedY])
  have h4 : fuelGauge s.fuel v = .air :=
    column_air_of_ne_y (by rw [hy]; norm_num [shedY, fuelFoot]) _ _
  have h5 : cashStack s.cash v = .air :=
    column_air_of_ne_y (by rw [hy]; norm_num [shedY, cashFoot]) _ _
  have h6 : cropField s.hectares v = .air :=
    cropField_air_of_y (by rw [hy]; left; norm_num [shedY, fieldY])
  have h7 : terrain v = .air := terrain_air_of_nonneg hz
  by_cases hs : shed s.built v = .air
  · simp [scene, World.lay_apply, h1, h2, h4, h5, h6, h7, hs]
  · simp [scene, World.lay_apply, h1, h2, hs]

theorem scene_eq_fuelGauge {s : GameState} {c : Config} (hc : c.Valid) {v : Vox}
    (hy : v.y = fuelFoot.y) (hz : 0 ≤ v.z) : scene s c v = fuelGauge s.fuel v := by
  simp only [fuelFoot, Vox.y_mk] at hy
  have h1 : machineWorld c v = .air :=
    machineWorld_air_of_y hc (by rw [hy]; left; norm_num)
  have h2 : yard yardY s.stock v = .air := yard_air_of_ne_y (by rw [hy]; norm_num [yardY])
  have h3 : shed s.built v = .air := shed_air_of_ne_y (by rw [hy]; norm_num [shedY])
  have h5 : cashStack s.cash v = .air :=
    column_air_of_ne_y (by rw [hy]; norm_num [cashFoot]) _ _
  have h6 : cropField s.hectares v = .air :=
    cropField_air_of_y (by rw [hy]; left; norm_num [fieldY])
  have h7 : terrain v = .air := terrain_air_of_nonneg hz
  by_cases hf : fuelGauge s.fuel v = .air
  · simp [scene, World.lay_apply, h1, h2, h3, h5, h6, h7, hf]
  · simp [scene, World.lay_apply, h1, h2, h3, hf]

theorem scene_eq_cashStack {s : GameState} {c : Config} (hc : c.Valid) {v : Vox}
    (hy : v.y = cashFoot.y) (hz : 0 ≤ v.z) : scene s c v = cashStack s.cash v := by
  simp only [cashFoot, Vox.y_mk] at hy
  have h1 : machineWorld c v = .air :=
    machineWorld_air_of_y hc (by rw [hy]; left; norm_num)
  have h2 : yard yardY s.stock v = .air := yard_air_of_ne_y (by rw [hy]; norm_num [yardY])
  have h3 : shed s.built v = .air := shed_air_of_ne_y (by rw [hy]; norm_num [shedY])
  have h4 : fuelGauge s.fuel v = .air :=
    column_air_of_ne_y (by rw [hy]; norm_num [fuelFoot]) _ _
  have h6 : cropField s.hectares v = .air :=
    cropField_air_of_y (by rw [hy]; left; norm_num [fieldY])
  have h7 : terrain v = .air := terrain_air_of_nonneg hz
  by_cases hcash : cashStack s.cash v = .air
  · simp [scene, World.lay_apply, h1, h2, h3, h4, h6, h7, hcash]
  · simp [scene, World.lay_apply, h1, h2, h3, h4, hcash]

theorem scene_eq_cropField {s : GameState} {c : Config} (hc : c.Valid) {v : Vox}
    (hy : fieldY ≤ v.y) (hz : 0 ≤ v.z) : scene s c v = cropField s.hectares v := by
  have h1 : machineWorld c v = .air :=
    machineWorld_air_of_y hc (by left; simp only [fieldY] at hy; omega)
  have h2 : yard yardY s.stock v = .air :=
    yard_air_of_ne_y (by simp only [yardY, fieldY] at *; omega)
  have h3 : shed s.built v = .air := shed_air_of_ne_y (by simp only [shedY, fieldY] at *; omega)
  have h4 : fuelGauge s.fuel v = .air :=
    column_air_of_ne_y (by simp only [fuelFoot, fieldY, Vox.y_mk] at *; omega) _ _
  have h5 : cashStack s.cash v = .air :=
    column_air_of_ne_y (by simp only [cashFoot, fieldY, Vox.y_mk] at *; omega) _ _
  have h7 : terrain v = .air := terrain_air_of_nonneg hz
  by_cases hcr : cropField s.hectares v = .air
  · simp [scene, World.lay_apply, h1, h2, h3, h4, h5, h7, hcr]
  · simp [scene, World.lay_apply, h1, h2, h3, h4, h5, hcr]

/-- The machine is drawn on top of everything, so it is never hidden. -/
theorem scene_eq_machineWorld {s : GameState} {c : Config} {v : Vox}
    (h : machineWorld c v ≠ .air) : scene s c v = machineWorld c v := by
  simp [scene, World.lay_apply, h]

/-! ### The view is faithful -/

/-- The voxels of the scene that read "material `m`" are exactly the pile of
`m` in the yard. -/
theorem scene_region_stock {s : GameState} {c : Config} (hc : c.Valid) (m : Material) :
    World.region (scene s c) (.stock m) = World.region (yard yardY s.stock) (.stock m) := by
  funext v
  simp only [World.region_apply]
  by_cases hy : yard yardY s.stock v = .stock m
  · have hne : yard yardY s.stock v ≠ .air := by rw [hy]; simp
    obtain ⟨-, -, -, -, hyy⟩ := yardOf_locate hne
    rw [scene_eq_yard hc hyy (yardOf_above_z hne)]
  · have hs : scene s c v ≠ .stock m := by
      intro h
      rcases scene_mem_value (by simp) h with h'|h'|h'|h'|h'|h'|h'
      · exact machineWorld_ne (by simp) (by simp) c v h'
      · exact hy h'
      · exact shed_ne (by simp) (by simp) _ v h'
      · exact column_ne (by simp) (by simp) h'
      · exact column_ne (by simp) (by simp) h'
      · exact cropField_ne (by simp) (by simp) _ v h'
      · exact terrain_ne (by simp) (by simp) (by simp) v h'
    simp [hs, hy]

/-- **The yard shows the shelf.**  Counting the voxels of `m` in the scene
gives the height of the pile the player's inventory calls for, and by
`gaugeHeight_read` that height brackets the quantity held. -/
theorem tally_scene_stock {W : Finset Vox} {s : GameState} {c : Config} (hc : c.Valid)
    (m : Material)
    (hW : columnWindow (pileFoot yardY m) (pileHeight s.stock m) ⊆ W) :
    World.tally W (scene s c) (.stock m) = pileHeight s.stock m := by
  rw [World.tally, scene_region_stock hc m, ← World.tally]
  exact tally_yard m hW

/-- The voxels of the scene that read "fuel" are exactly the fuel gauge. -/
theorem scene_region_fuel {s : GameState} {c : Config} (hc : c.Valid) :
    World.region (scene s c) .fuel = World.region (fuelGauge s.fuel) .fuel := by
  funext v
  simp only [World.region_apply]
  by_cases hf : fuelGauge s.fuel v = .fuel
  · have hne : fuelGauge s.fuel v ≠ .air := by rw [hf]; simp
    have hy : v.y = fuelFoot.y := by
      by_contra hy
      exact hne (column_air_of_ne_y hy _ _)
    have hz : 0 ≤ v.z := by
      by_contra hz
      exact hne (column_air_of_lt_z (by simpa [fuelFoot] using hz) _ _)
    rw [scene_eq_fuelGauge hc hy hz]
  · have hs : scene s c v ≠ .fuel := by
      intro h
      rcases scene_mem_value (by simp) h with h'|h'|h'|h'|h'|h'|h'
      · exact machineWorld_ne (by simp) (by simp) c v h'
      · exact yard_ne (by simp) (by simp) _ v h'
      · exact shed_ne (by simp) (by simp) _ v h'
      · exact hf h'
      · exact column_ne (by simp) (by simp) h'
      · exact cropField_ne (by simp) (by simp) _ v h'
      · exact terrain_ne (by simp) (by simp) (by simp) v h'
    simp [hs, hf]

/-- **The gauge shows the tank.** -/
theorem tally_scene_fuel {W : Finset Vox} {s : GameState} {c : Config} (hc : c.Valid)
    (hW : columnWindow fuelFoot (gaugeHeight fuelPerVoxel s.fuel) ⊆ W) :
    World.tally W (scene s c) .fuel = gaugeHeight fuelPerVoxel s.fuel := by
  rw [World.tally, scene_region_fuel hc, ← World.tally]
  exact tally_column (by simp) hW

/-- The voxels of the scene that read "coin" are exactly the cash column. -/
theorem scene_region_cash {s : GameState} {c : Config} (hc : c.Valid) :
    World.region (scene s c) .coin = World.region (cashStack s.cash) .coin := by
  funext v
  simp only [World.region_apply]
  by_cases hf : cashStack s.cash v = .coin
  · have hne : cashStack s.cash v ≠ .air := by rw [hf]; simp
    have hy : v.y = cashFoot.y := by
      by_contra hy
      exact hne (column_air_of_ne_y hy _ _)
    have hz : 0 ≤ v.z := by
      by_contra hz
      exact hne (column_air_of_lt_z (by simpa [cashFoot] using hz) _ _)
    rw [scene_eq_cashStack hc hy hz]
  · have hs : scene s c v ≠ .coin := by
      intro h
      rcases scene_mem_value (by simp) h with h'|h'|h'|h'|h'|h'|h'
      · exact machineWorld_ne (by simp) (by simp) c v h'
      · exact yard_ne (by simp) (by simp) _ v h'
      · exact shed_ne (by simp) (by simp) _ v h'
      · exact column_ne (by simp) (by simp) h'
      · exact hf h'
      · exact cropField_ne (by simp) (by simp) _ v h'
      · exact terrain_ne (by simp) (by simp) (by simp) v h'
    simp [hs, hf]

/-- **The cash column shows the cash box.** -/
theorem tally_scene_cash {W : Finset Vox} {s : GameState} {c : Config} (hc : c.Valid)
    (hW : columnWindow cashFoot (gaugeHeight cashPerVoxel s.cash) ⊆ W) :
    World.tally W (scene s c) .coin = gaugeHeight cashPerVoxel s.cash := by
  rw [World.tally, scene_region_cash hc, ← World.tally]
  exact tally_column (by simp) hW

/-- The voxels of the scene that read "crop" are exactly the field. -/
theorem scene_region_crop {s : GameState} {c : Config} (hc : c.Valid) :
    World.region (scene s c) (.crop 1) = World.region (cropField s.hectares) (.crop 1) := by
  funext v
  simp only [World.region_apply]
  by_cases hf : cropField s.hectares v = .crop 1
  · have hne : cropField s.hectares v ≠ .air := by rw [hf]; simp
    have hy : fieldY ≤ v.y := by
      by_contra hy
      exact hne (cropField_air_of_y (Or.inl (by omega)))
    have hz : 0 ≤ v.z := by
      by_contra hz
      exact hne (cropField_air_of_z (by omega))
    rw [scene_eq_cropField hc hy hz]
  · have hs : scene s c v ≠ .crop 1 := by
      intro h
      rcases scene_mem_value (by simp) h with h'|h'|h'|h'|h'|h'|h'
      · exact machineWorld_ne (by simp) (by simp) c v h'
      · exact yard_ne (by simp) (by simp) _ v h'
      · exact shed_ne (by simp) (by simp) _ v h'
      · exact column_ne (by simp) (by simp) h'
      · exact column_ne (by simp) (by simp) h'
      · exact hf h'
      · exact terrain_ne (by simp) (by simp) (by simp) v h'
    simp [hs, hf]

theorem card_fieldWindow (ha : ℚ) :
    (Finset.Icc ((0, fieldY, 0) : Vox) (cropCorner ha)).card = 8 * cropRows ha := by
  simp only [cropCorner, Finset.card_Icc_prod, Int.card_Icc]
  have h1 : ((cropRows ha : ℤ) - 1 + 1 - 0).toNat = cropRows ha := by omega
  have h2 : (fieldY + 7 + 1 - fieldY).toNat = 8 := by omega
  have h3 : ((0 : ℤ) + 1 - 0).toNat = 1 := by omega
  rw [h1, h2, h3]
  ring

/-- **The field shows the season's work**: eight crop voxels for every whole
hectare the player has worked. -/
theorem tally_scene_crop {W : Finset Vox} {s : GameState} {c : Config} (hc : c.Valid)
    (hW : Finset.Icc ((0, fieldY, 0) : Vox) (cropCorner s.hectares) ⊆ W) :
    World.tally W (scene s c) (.crop 1) = 8 * cropRows s.hectares := by
  rw [World.tally, scene_region_crop hc]
  rw [cropField, World.region_paint_self (by simp), count_box_of_subset hW, card_fieldWindow]

/-- **The shed shows exactly the machines the player owns.** -/
theorem scene_shed_iff {s : GameState} {c : Config} (hc : c.Valid) (nm : String) :
    s.hasMachine nm = true ↔ ∃ v, scene s c v = .shed nm := by
  constructor
  · intro h
    have : ∃ a ∈ s.built, a.name = nm := by
      simp only [GameState.hasMachine, List.any_eq_true, beq_iff_eq] at h
      exact h
    obtain ⟨v, hv⟩ := mem_shedOf_iff.2 this
    refine ⟨v, ?_⟩
    have hne : shed s.built v ≠ .air := by rw [shed, hv]; simp
    rw [scene_eq_shed hc (shedOf_y hne) (shedOf_above_z hne), shed, hv]
  · rintro ⟨v, hv⟩
    have hsh : shed s.built v = .shed nm := by
      rcases scene_mem_value (by simp) hv with h'|h'|h'|h'|h'|h'|h'
      · exact absurd h' (machineWorld_ne (by simp) (by simp) c v)
      · exact absurd h' (yard_ne (by simp) (by simp) _ v)
      · exact h'
      · exact absurd h' (column_ne (by simp) (by simp))
      · exact absurd h' (column_ne (by simp) (by simp))
      · exact absurd h' (cropField_ne (by simp) (by simp) _ v)
      · exact absurd h' (terrain_ne (by simp) (by simp) (by simp) v)
    obtain ⟨a, ha, hnm⟩ := mem_shedOf_iff.1 ⟨v, hsh⟩
    simp only [GameState.hasMachine, List.any_eq_true, beq_iff_eq]
    exact ⟨a, ha, hnm⟩

end VoxelGame
end LifeTrac
