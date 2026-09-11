import RequestProject.Gvcs.VoxelGame.World

/-!
# Columns, gauges, the yard and the shed

The numbers a player of a build-and-farm game watches — how much steel is on
the shelf, how much fuel is in the tank, how much money is in the box, how many
hectares have been worked — are rational numbers in `RequestProject/Game.lean`.
In a voxel game they have to be *things you can look at*.  This file is how a
number becomes something to look at:

* `column p n c` — `n` voxels of `c` stacked on the voxel `p`.  Its occupancy
  is a box (`solid_column`), it holds exactly `n` voxels (`tally_column`), and
  it is confined to one line of the lattice (`column_within_x`,
  `column_within_y`), which is what keeps the districts of a scene apart.
* `gaugeHeight unit q` — how tall the column for a quantity `q` is, at `unit`
  units to the voxel.  It is monotone (`gaugeHeight_mono`), it is *readable*
  (`gaugeHeight_read`: the column's height brackets the quantity between
  `n·unit` and `(n+1)·unit`), and a column appears exactly when the player has
  a whole unit of the stuff (`gaugeHeight_eq_zero_iff`).
* `yard` — one column per material of the catalogue, side by side, each at its
  own `x`.  `region_yard` says the piles do not shadow one another: the voxels
  of the world that read `stock m` are exactly the pile of `m`.
* `shed` — one column per fabricated subassembly.  `mem_shed_iff` says the shed
  shows exactly the machines the player owns, no more and no fewer.
-/

namespace LifeTrac
namespace VoxelGame

open Voxel
open Voxel.Solid
open Build

/-! ## Columns -/

/-- The top voxel of a column of `n` voxels standing on `p`. -/
def columnTop (p : Vox) (n : ℕ) : Vox := (p.x, p.y, p.z + n - 1)

/-- A column of `n` voxels of `c` standing on `p`: the way a quantity is shown
in the world. -/
def column (p : Vox) (n : ℕ) (c : Cell) : World := World.paint (box p (columnTop p n)) c

theorem mem_columnBox {p : Vox} {n : ℕ} {v : Vox} :
    box p (columnTop p n) v = true ↔
      (v.x = p.x ∧ v.y = p.y ∧ p.z ≤ v.z ∧ v.z < p.z + n) := by
  simp only [mem_box, columnTop, Vox.x_mk, Vox.y_mk, Vox.z_mk]
  omega

theorem column_apply (p : Vox) (n : ℕ) (c : Cell) (v : Vox) :
    column p n c v =
      if (v.x = p.x ∧ v.y = p.y ∧ p.z ≤ v.z ∧ v.z < p.z + n) then c else .air := by
  simp only [column, World.paint_apply]
  by_cases h : box p (columnTop p n) v = true
  · rw [if_pos h, if_pos (mem_columnBox.1 h)]
  · simp only [Bool.not_eq_true] at h
    rw [h, if_neg (by simp), if_neg (fun hc => by
      have := mem_columnBox.2 hc; rw [h] at this; exact Bool.noConfusion this)]

@[simp] theorem column_zero (p : Vox) (c : Cell) : column p 0 c = World.empty := by
  funext v; simp [column_apply, World.empty]

/-- A column stands on one line of the lattice: away from that line there is
nothing. -/
theorem column_air_of_ne_x {p v : Vox} (h : v.x ≠ p.x) (n : ℕ) (c : Cell) :
    column p n c v = .air := by
  simp [column_apply, h]

theorem column_air_of_ne_y {p v : Vox} (h : v.y ≠ p.y) (n : ℕ) (c : Cell) :
    column p n c v = .air := by
  simp [column_apply, h]

theorem column_air_of_lt_z {p v : Vox} (h : v.z < p.z) (n : ℕ) (c : Cell) :
    column p n c v = .air := by
  simp only [column_apply]
  rw [if_neg]
  omega

/-- The cell of a column, where there is one, is the cell it was built of. -/
theorem column_eq_cell {p : Vox} {n : ℕ} {c : Cell} {v : Vox} (h : column p n c v ≠ .air) :
    column p n c v = c := by
  by_cases hb : (v.x = p.x ∧ v.y = p.y ∧ p.z ≤ v.z ∧ v.z < p.z + n)
  · rw [column_apply, if_pos hb]
  · rw [column_apply, if_neg hb] at h; exact absurd rfl h

/-- A column shows its own cell, or nothing at all. -/
theorem column_cell_or (p : Vox) (n : ℕ) (c : Cell) (v : Vox) :
    column p n c v = .air ∨ column p n c v = c := by
  by_cases h : column p n c v = .air
  · exact Or.inl h
  · exact Or.inr (column_eq_cell h)

/-- A column never shows a cell of another kind. -/
theorem column_ne {p : Vox} {n : ℕ} {c d : Cell} {v : Vox} (hdc : d ≠ c) (hda : d ≠ .air) :
    column p n c v ≠ d := by
  rcases column_cell_or p n c v with h | h <;> rw [h]
  · exact fun hc => hda hc.symm
  · exact fun hc => hdc hc.symm

theorem solid_column {c : Cell} (hc : c ≠ .air) (p : Vox) (n : ℕ) :
    World.solid (column p n c) = box p (columnTop p n) :=
  World.solid_paint hc _

theorem column_within_x {c : Cell} (hc : c ≠ .air) (p : Vox) (n : ℕ) :
    Within Vox.x p.x p.x (World.solid (column p n c)) := by
  rw [solid_column hc]
  intro v hv
  rw [mem_columnBox] at hv
  omega

theorem column_within_y {c : Cell} (hc : c ≠ .air) (p : Vox) (n : ℕ) :
    Within Vox.y p.y p.y (World.solid (column p n c)) := by
  rw [solid_column hc]
  intro v hv
  rw [mem_columnBox] at hv
  omega

theorem column_above_z {c : Cell} (hc : c ≠ .air) (p : Vox) (n : ℕ) :
    Above Vox.z p.z (World.solid (column p n c)) := by
  rw [solid_column hc]
  intro v hv
  rw [mem_columnBox] at hv
  omega

/-- Two columns on different lines cannot interpenetrate. -/
theorem column_apart_of_ne_x {c d : Cell} (hc : c ≠ .air) (hd : d ≠ .air) {p q : Vox}
    (h : p.x ≠ q.x) (n m : ℕ) :
    Apart (World.solid (column p n c)) (World.solid (column q m d)) :=
  apart_of_slab_sep (column_within_x hc p n) (column_within_x hd q m) (by omega)

/-- The voxels of a column, as a window. -/
def columnWindow (p : Vox) (n : ℕ) : Finset Vox := Finset.Icc p (columnTop p n)

theorem card_columnWindow (p : Vox) (n : ℕ) : (columnWindow p n).card = n := by
  simp only [columnWindow, columnTop, Finset.card_Icc_prod, Int.card_Icc]
  have h1 : (p.x + 1 - p.x).toNat = 1 := by omega
  have h2 : (p.y + 1 - p.y).toNat = 1 := by omega
  have h3 : (p.z + (n : ℤ) - 1 + 1 - p.z).toNat = n := by omega
  simp only [Vox.x, Vox.y, Vox.z] at *
  rw [h1, h2, h3]
  ring

/-- Membership of a lattice box, coordinate by coordinate. -/
theorem mem_Icc_vox {lo hi v : Vox} :
    v ∈ Finset.Icc lo hi ↔
      (lo.x ≤ v.x ∧ v.x ≤ hi.x ∧ lo.y ≤ v.y ∧ v.y ≤ hi.y ∧ lo.z ≤ v.z ∧ v.z ≤ hi.z) := by
  simp only [Finset.mem_Icc, Prod.le_def, Vox.x, Vox.y, Vox.z]
  tauto

/-- Counting a box inside a window that contains it. -/
theorem count_box_of_subset {W : Finset Vox} {lo hi : Vox} (h : Finset.Icc lo hi ⊆ W) :
    Solid.count W (box lo hi) = (Finset.Icc lo hi).card := by
  classical
  have hfil : W.filter (fun v => box lo hi v = true) = Finset.Icc lo hi := by
    ext v
    rw [Finset.mem_filter, mem_Icc_vox, mem_box]
    exact ⟨fun h' => h'.2, fun h' => ⟨h (mem_Icc_vox.2 h'), h'⟩⟩
  simp only [Solid.count]
  rw [hfil]

/-- **A column holds exactly the number of voxels it was built with**, in any
window that contains it. -/
theorem tally_column {W : Finset Vox} {c : Cell} (hc : c ≠ .air) {p : Vox} {n : ℕ}
    (hW : columnWindow p n ⊆ W) : World.tally W (column p n c) c = n := by
  rw [World.tally, column, World.region_paint_self hc, count_box_of_subset hW,
    ← columnWindow, card_columnWindow]

/-! ## Gauges: a number, shown as a height -/

/-- The height of the column that shows a quantity `q`, at `unit` units of the
stuff to the voxel. -/
def gaugeHeight (unit q : ℚ) : ℕ := ⌊q / unit⌋₊

@[simp] theorem gaugeHeight_zero (unit : ℚ) : gaugeHeight unit 0 = 0 := by
  simp [gaugeHeight]

/-- More of the stuff never makes a shorter column. -/
theorem gaugeHeight_mono {unit q q' : ℚ} (hu : 0 < unit) (h : q ≤ q') :
    gaugeHeight unit q ≤ gaugeHeight unit q' := by
  apply Nat.floor_mono
  gcongr

/-- **A gauge can be read.**  A column `n` voxels tall means the player has at
least `n` units and less than `n + 1`. -/
theorem gaugeHeight_read {unit q : ℚ} (hu : 0 < unit) (hq : 0 ≤ q) :
    (gaugeHeight unit q : ℚ) * unit ≤ q ∧ q < (gaugeHeight unit q + 1) * unit := by
  have hdiv : (0 : ℚ) ≤ q / unit := div_nonneg hq hu.le
  constructor
  · have := Nat.floor_le hdiv
    calc (gaugeHeight unit q : ℚ) * unit ≤ (q / unit) * unit := by
          exact mul_le_mul_of_nonneg_right this hu.le
      _ = q := div_mul_cancel₀ q hu.ne'
  · have := Nat.lt_floor_add_one (q / unit)
    calc q = (q / unit) * unit := (div_mul_cancel₀ q hu.ne').symm
      _ < ((gaugeHeight unit q : ℚ) + 1) * unit := by
          exact mul_lt_mul_of_pos_right this hu

/-- Nothing is shown until the player has a whole unit of the stuff. -/
theorem gaugeHeight_eq_zero_iff {unit q : ℚ} (hu : 0 < unit) (hq : 0 ≤ q) :
    gaugeHeight unit q = 0 ↔ q < unit := by
  constructor
  · intro h
    have := (gaugeHeight_read hu hq).2
    rw [h] at this
    simpa using this
  · intro h
    have : q / unit < 1 := by
      rw [div_lt_one hu]; exact h
    simpa [gaugeHeight] using Nat.floor_eq_zero.2 this

/-! ## The catalogue, laid out in the yard -/

/-- Every material of the catalogue, once. -/
def allMaterials : List Material :=
  [.steelTube4, .steelTube3, .steelTube2, .steelPlate6, .steelPlate12, .roundBar50,
   .boltM12, .nutM12, .weldWire, .hose, .fitting, .fluid, .gearPump, .wheelMotor,
   .cylinder, .controlValve, .engine, .fuelTank, .hydraulicTank, .wheelHub, .tire,
   .seat, .paint, .electricalKit]

theorem mem_allMaterials (m : Material) : m ∈ allMaterials := by
  cases m <;> decide

theorem allMaterials_nodup : allMaterials.Nodup := by decide

/-- Where in the yard the pile of a material stands. -/
def yardX : Material → ℤ
  | .steelTube4 => 0
  | .steelTube3 => 2
  | .steelTube2 => 4
  | .steelPlate6 => 6
  | .steelPlate12 => 8
  | .roundBar50 => 10
  | .boltM12 => 12
  | .nutM12 => 14
  | .weldWire => 16
  | .hose => 18
  | .fitting => 20
  | .fluid => 22
  | .gearPump => 24
  | .wheelMotor => 26
  | .cylinder => 28
  | .controlValve => 30
  | .engine => 32
  | .fuelTank => 34
  | .hydraulicTank => 36
  | .wheelHub => 38
  | .tire => 40
  | .seat => 42
  | .paint => 44
  | .electricalKit => 46

/-- No two materials share a pile. -/
theorem yardX_injective : Function.Injective yardX := by decide

/-- How much of a material one voxel of its pile stands for.  A pile is meant
to be read at a glance, so the bulky stock is one voxel to the metre and the
small parts come by the box. -/
def lotSize : Material → ℚ
  | .boltM12 => 20
  | .nutM12 => 20
  | .fluid => 5
  | .paint => 5
  | .hose => 2
  | .fitting => 10
  | .weldWire => 2
  | _ => 1

theorem lotSize_pos (m : Material) : 0 < lotSize m := by
  cases m <;> norm_num [lotSize]

/-- The height of the pile of `m` in a yard holding the inventory `i`. -/
def pileHeight (i : Inventory) (m : Material) : ℕ := gaugeHeight (lotSize m) (i m)

/-- Buying material never makes its pile shorter. -/
theorem pileHeight_mono {i j : Inventory} {m : Material} (h : i m ≤ j m) :
    pileHeight i m ≤ pileHeight j m :=
  gaugeHeight_mono (lotSize_pos m) h

/-- The line of the lattice the pile of `m` stands on. -/
def pileFoot (yardY : ℤ) (m : Material) : Vox := (yardX m, yardY, 0)

/-- The pile of one material. -/
def pile (yardY : ℤ) (i : Inventory) (m : Material) : World :=
  column (pileFoot yardY m) (pileHeight i m) (.stock m)

/-- The yard built out of a list of materials. -/
def yardOf (yardY : ℤ) (i : Inventory) : List Material → World
  | [] => World.empty
  | m :: ms => World.lay (pile yardY i m) (yardOf yardY i ms)

/-- The whole yard: one pile per material of the catalogue. -/
def yard (yardY : ℤ) (i : Inventory) : World := yardOf yardY i allMaterials

/-- Whatever is in the yard is a pile of one of its materials, standing on that
material's line. -/
theorem yardOf_locate {yardY : ℤ} {i : Inventory} {l : List Material} {v : Vox}
    (h : yardOf yardY i l v ≠ .air) :
    ∃ m ∈ l, yardOf yardY i l v = .stock m ∧ v.x = yardX m ∧ v.y = yardY := by
  induction l with
  | nil => exact absurd rfl h
  | cons m ms ih =>
      by_cases hm : pile yardY i m v = .air
      · rw [yardOf, World.lay_apply, if_pos hm] at h ⊢
        obtain ⟨m', hm', h1, h2, h3⟩ := ih h
        exact ⟨m', List.mem_cons_of_mem _ hm', h1, h2, h3⟩
      · refine ⟨m, List.mem_cons_self .., ?_, ?_, ?_⟩
        · rw [yardOf, World.lay_apply, if_neg hm]
          exact column_eq_cell hm
        · by_contra hx
          exact hm (column_air_of_ne_x hx _ _)
        · by_contra hy
          exact hm (column_air_of_ne_y hy _ _)

/-- A pile stands on the ground: nothing of the yard is buried. -/
theorem yardOf_above_z {yardY : ℤ} {i : Inventory} {l : List Material} {v : Vox}
    (h : yardOf yardY i l v ≠ .air) : 0 ≤ v.z := by
  induction l with
  | nil => exact absurd rfl h
  | cons m ms ih =>
      by_cases hm : pile yardY i m v = .air
      · rw [yardOf, World.lay_apply, if_pos hm] at h
        exact ih h
      · by_contra hz
        exact hm (column_air_of_lt_z (by simpa [pileFoot] using hz) _ _)

/-- **The piles do not shadow one another**: the voxels of the yard that read
`stock m` are exactly the pile of `m`. -/
theorem region_yardOf {yardY : ℤ} {i : Inventory} {l : List Material} (hl : l.Nodup)
    {m : Material} (hm : m ∈ l) :
    World.region (yardOf yardY i l) (.stock m) = World.solid (pile yardY i m) := by
  induction l with
  | nil => exact absurd hm (by simp)
  | cons m₀ ms ih =>
      funext v
      have hnd := List.nodup_cons.1 hl
      by_cases hair : pile yardY i m₀ v = .air
      · rw [yardOf]
        simp only [World.region_apply, World.lay_apply, if_pos hair]
        rcases List.mem_cons.1 hm with rfl | hm'
        · -- the pile of `m` is empty here, and no other pile can read `stock m`
          have hno : yardOf yardY i ms v ≠ .stock m := by
            intro hc
            have : yardOf yardY i ms v ≠ .air := by rw [hc]; simp
            obtain ⟨m', hm', h1, -, -⟩ := yardOf_locate this
            rw [hc] at h1
            exact hnd.1 (by cases h1; exact hm')
          rw [World.solid_apply, hair]
          simp [hno]
        · have := congrFun (ih hnd.2 hm') v
          simpa only [World.region_apply] using this
      · have hcell : pile yardY i m₀ v = .stock m₀ := column_eq_cell hair
        have hx : v.x = yardX m₀ := by
          by_contra hx; exact hair (column_air_of_ne_x hx _ _)
        rw [yardOf]
        simp only [World.region_apply, World.lay_apply, hcell]
        rcases List.mem_cons.1 hm with rfl | hm'
        · rw [World.solid_apply]
          simp [hair]
        · have hne : m ≠ m₀ := by rintro rfl; exact hnd.1 hm'
          have hpa : pile yardY i m v = .air := by
            refine column_air_of_ne_x ?_ _ _
            simp only [pileFoot, Vox.x_mk, hx]
            exact fun hc => hne (yardX_injective hc.symm)
          simp [hpa, Ne.symm hne]

theorem region_yard {yardY : ℤ} {i : Inventory} (m : Material) :
    World.region (yard yardY i) (.stock m) = World.solid (pile yardY i m) :=
  region_yardOf allMaterials_nodup (mem_allMaterials m)

/-- **The yard shows the shelf.**  The number of voxels of `m` a player can see
is exactly the height of the pile the inventory calls for. -/
theorem tally_yard {W : Finset Vox} {yardY : ℤ} {i : Inventory} (m : Material)
    (hW : columnWindow (pileFoot yardY m) (pileHeight i m) ⊆ W) :
    World.tally W (yard yardY i) (.stock m) = pileHeight i m := by
  have h : World.tally W (yard yardY i) (.stock m) =
      Solid.count W (box (pileFoot yardY m)
        (columnTop (pileFoot yardY m) (pileHeight i m))) := by
    rw [World.tally, region_yard, pile, solid_column (by simp)]
  rw [h, count_box_of_subset hW, ← columnWindow, card_columnWindow]

/-! ## The shed -/

/-- The shed built out of a list of subassemblies, the `k`-th standing two
voxels tall at `x = 2k`. -/
def shedOf (shedY : ℤ) (k : ℕ) : List Assembly → World
  | [] => World.empty
  | a :: as => World.lay (column (2 * k, shedY, 0) 2 (.shed a.name))
      (shedOf shedY (k + 1) as)

/-- Everything in the shed is one of the machines that were put there. -/
theorem shedOf_locate {shedY : ℤ} {k : ℕ} {l : List Assembly} {v : Vox}
    (h : shedOf shedY k l v ≠ .air) :
    ∃ a ∈ l, shedOf shedY k l v = .shed a.name := by
  induction l generalizing k with
  | nil => exact absurd rfl h
  | cons a as ih =>
      by_cases ha : column (2 * (k : ℤ), shedY, 0) 2 (Cell.shed a.name) v = .air
      · rw [shedOf, World.lay_apply, if_pos ha] at h ⊢
        obtain ⟨b, hb, h1⟩ := ih h
        exact ⟨b, List.mem_cons_of_mem _ hb, h1⟩
      · refine ⟨a, List.mem_cons_self .., ?_⟩
        rw [shedOf, World.lay_apply, if_neg ha]
        exact column_eq_cell ha

/-- The shed grows to the right: nothing of it stands to the left of the first
machine's column. -/
theorem shedOf_above_x {shedY : ℤ} {k : ℕ} {l : List Assembly} {v : Vox}
    (h : shedOf shedY k l v ≠ .air) : (2 * k : ℤ) ≤ v.x := by
  induction l generalizing k with
  | nil => exact absurd rfl h
  | cons a as ih =>
      by_cases ha : column (2 * (k : ℤ), shedY, 0) 2 (Cell.shed a.name) v = .air
      · rw [shedOf, World.lay_apply, if_pos ha] at h
        have := ih h
        push_cast at this ⊢
        omega
      · by_contra hx
        refine ha (column_air_of_ne_x ?_ _ _)
        simp only [Vox.x_mk]
        omega

/-- **The shed shows exactly the machines the player owns.** -/
theorem mem_shedOf_iff {shedY : ℤ} {k : ℕ} {l : List Assembly} {nm : String} :
    (∃ v, shedOf shedY k l v = .shed nm) ↔ ∃ a ∈ l, a.name = nm := by
  constructor
  · rintro ⟨v, hv⟩
    have h : shedOf shedY k l v ≠ .air := by rw [hv]; simp
    obtain ⟨a, ha, h1⟩ := shedOf_locate h
    rw [hv] at h1
    exact ⟨a, ha, by cases h1; rfl⟩
  · rintro ⟨a, ha, rfl⟩
    induction l generalizing k with
    | nil => exact absurd ha (by simp)
    | cons b bs ih =>
        rcases List.mem_cons.1 ha with rfl | ha'
        · refine ⟨(2 * (k : ℤ), shedY, 0), ?_⟩
          have hcol : column (2 * (k : ℤ), shedY, 0) 2 (Cell.shed a.name)
              (2 * (k : ℤ), shedY, 0) = .shed a.name := by
            rw [column_apply, if_pos]
            exact ⟨rfl, rfl, le_rfl, by simp only [Vox.z_mk]; omega⟩
          rw [shedOf, World.lay_apply, if_neg (by rw [hcol]; simp), hcol]
        · obtain ⟨v, hv⟩ := ih ha' (k := k + 1)
          refine ⟨v, ?_⟩
          have hx : (2 * (k + 1) : ℤ) ≤ v.x :=
            shedOf_above_x (by rw [hv]; simp)
          have hair : column (2 * (k : ℤ), shedY, 0) 2 (Cell.shed b.name) v = .air := by
            refine column_air_of_ne_x ?_ _ _
            simp only [Vox.x_mk]
            push_cast at hx ⊢
            omega
          rw [shedOf, World.lay_apply, if_pos hair, hv]

end VoxelGame
end LifeTrac
