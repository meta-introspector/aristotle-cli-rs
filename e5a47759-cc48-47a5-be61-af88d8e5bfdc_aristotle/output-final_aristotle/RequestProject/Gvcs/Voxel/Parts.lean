import RequestProject.Gvcs.Voxel.Core

/-!
# The LifeTrac, voxel by voxel

Every part of the machine is a *function*.  A fixed part is a function
`Vox → Bool`; a moving part is a function of the machine's controls,
`ℤ → Vox → Bool`; and the machine is the union of its parts, i.e. the
composition of those functions with `Solid.unions`.

The unit of length is one voxel = 5 cm, so the machine below is 48 voxels long
(2.4 m), 35 wide (1.75 m) and about 30 tall.  The frame of reference is
`x` forward, `y` to the left, `z` up, with `z = 0` the voxel resting on the
ground and the ground itself everything with `z ≤ -1`.

What is proved here is how the parts *interact*:

* the loader arm is a digital line whose tip rises monotonically with the lift
  command (`armTipZ_mono`, `arm_tip_mem`), and whose consecutive cells share a
  face, so the arm is one connected body (`arm_cells_touch`);
* the arm rides clear of the engine deck and of the operator at every lift the
  machine allows (`arm_apart_powerUnit`, `arm_apart_station`);
* the lift cylinders are barrel plus rod; the rod stays on the bore axis, never
  re-enters the barrel, grows with the command and pushes on the underside of
  the arm at every lift (`rod_apart_barrel`, `rod_within_bore`, `cylRod_mono`,
  `rod_touches_arm`);
* the wheels do not interpenetrate each other or the frame rails
  (`wheels_apart_left_right`, `wheels_apart_front_rear`, `wheel_apart_rail`);
* no part of the machine is buried in the ground and the wheels rest on it
  (`machine_apart_ground`, `wheel_touches_ground`);
* driving the machine forward translates the whole assembly
  (`machine_travel`), which is the composability of the representation.
-/

namespace LifeTrac
namespace Voxel

open Solid

/-! ## Configuration -/

/-- The state of the machine's controls: how far the loader is lifted (0 to
`liftMax` voxels of cylinder stroke) and how far the machine has driven
forward, both in voxels. -/
structure Config where
  /-- Lift command: exposed rod length of the loader cylinders, in voxels. -/
  lift : ℤ
  /-- Forward travel, in voxels. -/
  travel : ℤ
deriving Repr, DecidableEq

/-- The largest lift the loader cylinders allow. -/
def liftMax : ℤ := 26

/-- A configuration the machine can actually be in. -/
def Config.Valid (c : Config) : Prop := 0 ≤ c.lift ∧ c.lift ≤ liftMax

/-- The machine parked, loader down. -/
def nominal : Config := ⟨0, 0⟩

/-- The machine parked, loader all the way up. -/
def raised : Config := ⟨liftMax, 0⟩

theorem nominal_valid : nominal.Valid := by
  constructor <;> simp [nominal, liftMax]

theorem raised_valid : raised.Valid := by
  constructor <;> simp [raised, liftMax]

/-! ## Stock shapes: tube, plate, disc -/

/-- Bound on a coordinate from a bound on its square: the disc test. -/
theorem abs_le_of_mul_self_le {a r : ℤ} (h : a * a ≤ r * r) (hr : 0 ≤ r) :
    -r ≤ a ∧ a ≤ r := by
  constructor <;> nlinarith

/-- A square tube running along `x`, hollow between the ends: the outer box
less an inner box shrunk by the wall thickness in `y` and `z`. -/
def tubeX (lo hi : Vox) (wall : ℤ) : Solid :=
  sub (box lo hi) (box (lo.x, lo.y + wall, lo.z + wall) (hi.x, hi.y - wall, hi.z - wall))

/-- A square tube running along `y`. -/
def tubeY (lo hi : Vox) (wall : ℤ) : Solid :=
  sub (box lo hi) (box (lo.x + wall, lo.y, lo.z + wall) (hi.x - wall, hi.y, hi.z - wall))

/-- A square tube running along `z`. -/
def tubeZ (lo hi : Vox) (wall : ℤ) : Solid :=
  sub (box lo hi) (box (lo.x + wall, lo.y + wall, lo.z) (hi.x - wall, hi.y - wall, hi.z))

theorem tubeX_sub_box (lo hi : Vox) (wall : ℤ) : Sub (tubeX lo hi wall) (box lo hi) := by
  intro v hv
  simp only [tubeX, sub_apply, Bool.and_eq_true] at hv
  exact hv.1

theorem tubeY_sub_box (lo hi : Vox) (wall : ℤ) : Sub (tubeY lo hi wall) (box lo hi) := by
  intro v hv
  simp only [tubeY, sub_apply, Bool.and_eq_true] at hv
  exact hv.1

theorem tubeZ_sub_box (lo hi : Vox) (wall : ℤ) : Sub (tubeZ lo hi wall) (box lo hi) := by
  intro v hv
  simp only [tubeZ, sub_apply, Bool.and_eq_true] at hv
  exact hv.1

/-- A solid disc of radius `r` in a plane of constant `y`, extruded `w` voxels
along `y` from `c` — a wheel blank, or a cylinder barrel seen end on. -/
def discY (c : Vox) (r w : ℤ) : Solid := fun v =>
  decide ((v.x - c.x) * (v.x - c.x) + (v.z - c.z) * (v.z - c.z) ≤ r * r ∧
    c.y ≤ v.y ∧ v.y ≤ c.y + w - 1)

theorem discY_within_x (c : Vox) (r w : ℤ) (hr : 0 ≤ r) :
    Within Vox.x (c.x - r) (c.x + r) (discY c r w) := by
  intro v hv
  simp only [discY, decide_eq_true_eq] at hv
  obtain ⟨h1, -, -⟩ := hv
  have h2 : (v.x - c.x) * (v.x - c.x) ≤ r * r := by nlinarith [mul_self_nonneg (v.z - c.z)]
  obtain ⟨hl, hu⟩ := abs_le_of_mul_self_le h2 hr
  exact ⟨by omega, by omega⟩

theorem discY_within_z (c : Vox) (r w : ℤ) (hr : 0 ≤ r) :
    Within Vox.z (c.z - r) (c.z + r) (discY c r w) := by
  intro v hv
  simp only [discY, decide_eq_true_eq] at hv
  obtain ⟨h1, -, -⟩ := hv
  have h2 : (v.z - c.z) * (v.z - c.z) ≤ r * r := by nlinarith [mul_self_nonneg (v.x - c.x)]
  obtain ⟨hl, hu⟩ := abs_le_of_mul_self_le h2 hr
  exact ⟨by omega, by omega⟩

theorem discY_within_y (c : Vox) (r w : ℤ) :
    Within Vox.y c.y (c.y + w - 1) (discY c r w) := by
  intro v hv
  simp only [discY, decide_eq_true_eq] at hv
  exact ⟨hv.2.1, hv.2.2⟩

/-! ## The frame -/

/-- Left main rail: 15 cm square tube, 2.4 m long. -/
def railL : Solid := tubeX (0, 11, 8) (47, 13, 10) 1

/-- Right main rail. -/
def railR : Solid := tubeX (0, -13, 8) (47, -11, 10) 1

/-- Rear cross member. -/
def crossRear : Solid := tubeY (2, -13, 8) (4, 13, 10) 1

/-- Front cross member. -/
def crossFront : Solid := tubeY (43, -13, 8) (45, 13, 10) 1

/-- The loader tower on the left: an upright carrying the arm pivot. -/
def towerL : Solid := tubeZ (10, 11, 11) (12, 13, 21) 1

/-- The loader tower on the right. -/
def towerR : Solid := tubeZ (10, -13, 11) (12, -11, 21) 1

/-- The welded frame: two rails, two cross members and the two loader
towers. -/
def frame : Solid := unions [railL, railR, crossRear, crossFront, towerL, towerR]

/-! ## Wheels -/

/-- Wheel radius, in voxels (40 cm). -/
def wheelR : ℤ := 8

/-- Wheel width, in voxels (20 cm). -/
def wheelW : ℤ := 4

/-- A wheel at hub centre `c`: a tyre — an annulus two voxels thick — and a hub
disc. -/
def wheel (c : Vox) : Solid :=
  cup (sub (discY c wheelR wheelW) (discY c (wheelR - 2) wheelW)) (discY c 3 wheelW)

/-- Left rear wheel. -/
def wheelRL : Solid := wheel (8, 14, 8)
/-- Left front wheel. -/
def wheelFL : Solid := wheel (39, 14, 8)
/-- Right rear wheel. -/
def wheelRR : Solid := wheel (8, -17, 8)
/-- Right front wheel. -/
def wheelFR : Solid := wheel (39, -17, 8)

theorem wheel_within_y (c : Vox) : Within Vox.y c.y (c.y + wheelW - 1) (wheel c) := by
  refine Within.cup ?_ (discY_within_y c 3 wheelW)
  exact (discY_within_y c wheelR wheelW).of_sub (fun v hv => by
    simp only [sub_apply, Bool.and_eq_true] at hv; exact hv.1)

theorem wheel_within_x (c : Vox) : Within Vox.x (c.x - wheelR) (c.x + wheelR) (wheel c) := by
  refine Within.cup ?_ ((discY_within_x c 3 wheelW (by norm_num)).mono ?_ ?_)
  · exact (discY_within_x c wheelR wheelW (by norm_num [wheelR])).of_sub (fun v hv => by
      simp only [sub_apply, Bool.and_eq_true] at hv; exact hv.1)
  · simp only [wheelR]; omega
  · simp only [wheelR]; omega

theorem wheel_within_z (c : Vox) : Within Vox.z (c.z - wheelR) (c.z + wheelR) (wheel c) := by
  refine Within.cup ?_ ((discY_within_z c 3 wheelW (by norm_num)).mono ?_ ?_)
  · exact (discY_within_z c wheelR wheelW (by norm_num [wheelR])).of_sub (fun v hv => by
      simp only [sub_apply, Bool.and_eq_true] at hv; exact hv.1)
  · simp only [wheelR]; omega
  · simp only [wheelR]; omega

/-- The left and right wheels are on opposite sides of the machine and cannot
interpenetrate. -/
theorem wheels_apart_left_right : Apart wheelFL wheelFR :=
  apart_of_slab_sep (wheel_within_y _) (wheel_within_y _)
    (by simp [wheelW, Vox.y])

/-- The front and rear wheels of a side cannot interpenetrate. -/
theorem wheels_apart_front_rear : Apart wheelRL wheelFL :=
  apart_of_slab_sep (wheel_within_x _) (wheel_within_x _)
    (by simp [wheelR, Vox.x])

/-- The wheels are outboard of the frame rails, so a wheel never fouls the
frame. -/
theorem wheel_apart_rail : Apart wheelFL railL :=
  apart_of_slab_sep (wheel_within_y _)
    ((within_box_y (0, 11, 8) (47, 13, 10)).of_sub (tubeX_sub_box _ _ _))
    (by simp [wheelW, Vox.y])

/-! ## Power unit and operator's station -/

/-- The deck plate the power unit is bolted to. -/
def deckPlate : Solid := box (14, -10, 11) (30, 10, 11)

/-- The engine. -/
def engine : Solid := box (16, -6, 12) (26, 6, 19)

/-- The fuel tank. -/
def fuelTank : Solid := box (27, -9, 12) (30, -1, 17)

/-- The hydraulic reservoir. -/
def hydraulicTank : Solid := box (27, 1, 12) (30, 9, 17)

/-- Engine, pump, tanks and the deck they sit on. -/
def powerUnit : Solid := unions [deckPlate, engine, fuelTank, hydraulicTank]

/-- The operator's seat. -/
def seat : Solid := box (2, -5, 11) (8, 5, 13)

/-- The seat back. -/
def seatBack : Solid := box (1, -5, 14) (2, 5, 20)

/-- The control column carrying the two spool valves. -/
def column : Solid := box (9, -2, 11) (10, 2, 18)

/-- The operator's station. -/
def station : Solid := unions [seat, seatBack, column]

theorem powerUnit_within_z : Within Vox.z 11 19 powerUnit := by
  refine Within.unions ?_
  intro s hs
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hs
  rcases hs with rfl | rfl | rfl | rfl
  · exact (within_box_z (14, -10, 11) (30, 10, 11)).mono (by norm_num) (by norm_num)
  · exact (within_box_z (16, -6, 12) (26, 6, 19)).mono (by norm_num) (by norm_num)
  · exact (within_box_z (27, -9, 12) (30, -1, 17)).mono (by norm_num) (by norm_num)
  · exact (within_box_z (27, 1, 12) (30, 9, 17)).mono (by norm_num) (by norm_num)

theorem station_within_z : Within Vox.z 11 20 station := by
  refine Within.unions ?_
  intro s hs
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hs
  rcases hs with rfl | rfl | rfl
  · exact (within_box_z (2, -5, 11) (8, 5, 13)).mono (by norm_num) (by norm_num)
  · exact (within_box_z (1, -5, 14) (2, 5, 20)).mono (by norm_num) (by norm_num)
  · exact (within_box_z (9, -2, 11) (10, 2, 18)).mono (by norm_num) (by norm_num)

/-! ## The loader arms: a digital line that is a function of the lift -/

/-- Where the arms are pinned to the towers. -/
def armX0 : ℤ := 13
/-- Height of the arm pivot. -/
def armZ0 : ℤ := 22
/-- Length of an arm, in voxels. -/
def armLen : ℤ := 26
/-- Length of an arm, as a natural number, for enumeration. -/
def armLenN : ℕ := 26

/-- How high the arm has climbed `k` voxels out from the pivot, at lift
`lift`: the digital line from the pivot to the tip. -/
def armOffset (lift k : ℤ) : ℤ := k * lift / armLen

/-- One voxel-thick slice of an arm. -/
def armCell (lift y0 k : ℤ) : Solid :=
  box (armX0 + k, y0, armZ0 + armOffset lift k)
      (armX0 + k, y0 + 2, armZ0 + armOffset lift k + 1)

/-- An arm at lift `lift`, with its inboard face at `y0`. -/
def arm (lift y0 : ℤ) : Solid :=
  unions ((List.range armLenN).map (fun k : ℕ => armCell lift y0 (k : ℤ)))

/-- The height of the tip of the arm. -/
def armTipZ (lift : ℤ) : ℤ := armZ0 + armOffset lift (armLen - 1)

theorem armOffset_nonneg {lift k : ℤ} (hl : 0 ≤ lift) (hk : 0 ≤ k) :
    0 ≤ armOffset lift k :=
  Int.ediv_nonneg (mul_nonneg hk hl) (by norm_num [armLen])

theorem armOffset_le {lift k : ℤ} (hl : 0 ≤ lift) (hk : k ≤ armLen) :
    armOffset lift k ≤ lift := by
  have hne : (armLen : ℤ) ≠ 0 := by norm_num [armLen]
  have h : k * lift ≤ armLen * lift := mul_le_mul_of_nonneg_right hk hl
  have h2 := Int.ediv_le_ediv (by norm_num [armLen] : (0:ℤ) < armLen) h
  rwa [Int.mul_ediv_cancel_left _ hne] at h2

/-- The digital line never climbs faster than it runs out: at most one voxel of
height per voxel of length. -/
theorem armOffset_le_index {lift k : ℤ} (hlm : lift ≤ armLen) (hk : 0 ≤ k) :
    armOffset lift k ≤ k := by
  have hne : (armLen : ℤ) ≠ 0 := by norm_num [armLen]
  have h : k * lift ≤ k * armLen := mul_le_mul_of_nonneg_left hlm hk
  have h2 := Int.ediv_le_ediv (by norm_num [armLen] : (0:ℤ) < armLen) h
  rwa [mul_comm k armLen, Int.mul_ediv_cancel_left _ hne] at h2

/-- The digital line climbs by at most one voxel per step, which is why the arm
is a connected body. -/
theorem armOffset_step {lift k : ℤ} (hl : 0 ≤ lift) (hlm : lift ≤ armLen) :
    armOffset lift k ≤ armOffset lift (k + 1) ∧
      armOffset lift (k + 1) ≤ armOffset lift k + 1 := by
  have hpos : (0:ℤ) < armLen := by norm_num [armLen]
  have hne : (armLen : ℤ) ≠ 0 := by norm_num [armLen]
  refine ⟨Int.ediv_le_ediv hpos (by nlinarith), ?_⟩
  have h : (k + 1) * lift ≤ k * lift + armLen := by nlinarith
  have h2 := Int.ediv_le_ediv hpos h
  calc armOffset lift (k + 1) ≤ (k * lift + armLen) / armLen := h2
    _ = k * lift / armLen + 1 := by
          rw [show k * lift + armLen = k * lift + 1 * armLen by ring,
            Int.add_mul_ediv_right _ _ hne]
    _ = armOffset lift k + 1 := rfl

/-- Commanding more lift never lowers any part of the arm. -/
theorem armOffset_mono {lift lift' k : ℤ} (hk : 0 ≤ k) (h : lift ≤ lift') :
    armOffset lift k ≤ armOffset lift' k :=
  Int.ediv_le_ediv (by norm_num [armLen]) (mul_le_mul_of_nonneg_left h hk)

/-- The tip of the loader rises monotonically with the lift command. -/
theorem armTipZ_mono {lift lift' : ℤ} (h : lift ≤ lift') : armTipZ lift ≤ armTipZ lift' := by
  have h2 := armOffset_mono (k := armLen - 1) (by norm_num [armLen]) h
  simp only [armTipZ]
  omega

/-- Lifting all the way raises the tip by 25 voxels, 1.25 m. -/
theorem armTipZ_raised : armTipZ liftMax = armZ0 + 25 := by
  norm_num [armTipZ, armOffset, armLen, liftMax, armZ0]

theorem armTipZ_down : armTipZ 0 = armZ0 := by
  norm_num [armTipZ, armOffset, armLen]

theorem armTipZ_nonneg {lift : ℤ} (hl : 0 ≤ lift) : armZ0 ≤ armTipZ lift := by
  have := armTipZ_mono (lift := 0) (lift' := lift) hl
  rw [armTipZ_down] at this
  exact this

/-- The tip voxel really is part of the arm. -/
theorem arm_tip_mem (lift y0 : ℤ) :
    arm lift y0 (armX0 + (armLen - 1), y0, armTipZ lift) = true := by
  rw [arm, unions_eq_true_iff]
  refine ⟨armCell lift y0 (armLen - 1), ?_, ?_⟩
  · refine List.mem_map.2 ⟨25, List.mem_range.2 (by norm_num [armLenN]), ?_⟩
    norm_num [armLen]
  · simp [armCell, armTipZ, Vox.x, Vox.y, Vox.z]

/-- Every voxel of an arm lies between the pivot and one voxel above the
commanded lift. -/
theorem arm_within_z {lift : ℤ} (hl : 0 ≤ lift) (y0 : ℤ) :
    Within Vox.z armZ0 (armZ0 + lift + 1) (arm lift y0) := by
  refine Within.unions ?_
  intro s hs
  obtain ⟨k, hk, rfl⟩ := List.mem_map.1 hs
  have hk0 : (0:ℤ) ≤ (k : ℤ) := by exact_mod_cast Nat.zero_le k
  have hkle : (k : ℤ) ≤ armLen := by
    have h1 : k < armLenN := List.mem_range.1 hk
    have h2 : (k : ℤ) < (armLenN : ℤ) := by exact_mod_cast h1
    simp only [armLenN, Nat.cast_ofNat] at h2
    simp only [armLen]
    omega
  have h1 : 0 ≤ armOffset lift (k : ℤ) := armOffset_nonneg hl hk0
  have h2 : armOffset lift (k : ℤ) ≤ lift := armOffset_le hl hkle
  intro v hv
  simp only [armCell, mem_box] at hv
  simp only [Vox.z] at *
  omega

/-- Consecutive slices of an arm share a face, so the arm is one connected
body rather than a staircase of loose blocks. -/
theorem arm_cells_touch {lift : ℤ} (hl : 0 ≤ lift) (hlm : lift ≤ armLen) (y0 k : ℤ) :
    Touches (armCell lift y0 k) (armCell lift y0 (k + 1)) := by
  obtain ⟨hstep1, hstep2⟩ := armOffset_step (k := k) hl hlm
  refine ⟨(armX0 + k, y0, armZ0 + armOffset lift (k + 1)), (1, 0, 0), ?_, ?_, Or.inl rfl⟩
  · simp only [armCell, mem_box, Vox.x, Vox.y, Vox.z]
    omega
  · simp only [armCell, mem_box, Vox.x, Vox.y, Vox.z, Prod.fst_add, Prod.snd_add]
    omega

/-- An arm is three voxels wide, from its inboard face. -/
theorem arm_within_y (lift y0 : ℤ) : Within Vox.y y0 (y0 + 2) (arm lift y0) := by
  refine Within.unions ?_
  intro s hs
  obtain ⟨k, -, rfl⟩ := List.mem_map.1 hs
  intro v hv
  simp only [armCell, mem_box, Vox.y] at hv ⊢
  omega

/-- An arm runs from the pivot to its tip and no further. -/
theorem arm_within_x (lift y0 : ℤ) :
    Within Vox.x armX0 (armX0 + armLen - 1) (arm lift y0) := by
  refine Within.unions ?_
  intro s hs
  obtain ⟨k, hk, rfl⟩ := List.mem_map.1 hs
  have hk' : k < armLenN := List.mem_range.1 hk
  have hkz : (k : ℤ) ≤ 25 := by
    have : (k : ℤ) < (armLenN : ℤ) := by exact_mod_cast hk'
    simp only [armLenN, Nat.cast_ofNat] at this
    omega
  have hk0 : (0:ℤ) ≤ (k : ℤ) := by exact_mod_cast Nat.zero_le k
  intro v hv
  simp only [armCell, mem_box, Vox.x] at hv ⊢
  simp only [armLen]
  omega

/-- A tight bound on the height of an arm: it never reaches higher than its own
length above the pivot. -/
theorem arm_within_z_tight {lift : ℤ} (hl : 0 ≤ lift) (hlm : lift ≤ armLen) (y0 : ℤ) :
    Within Vox.z armZ0 (armZ0 + armLen) (arm lift y0) := by
  refine Within.unions ?_
  intro s hs
  obtain ⟨k, hk, rfl⟩ := List.mem_map.1 hs
  have hk' : k < armLenN := List.mem_range.1 hk
  have hkz : (k : ℤ) ≤ 25 := by
    have : (k : ℤ) < (armLenN : ℤ) := by exact_mod_cast hk'
    simp only [armLenN, Nat.cast_ofNat] at this
    omega
  have hk0 : (0:ℤ) ≤ (k : ℤ) := by exact_mod_cast Nat.zero_le k
  have h1 : 0 ≤ armOffset lift (k : ℤ) := armOffset_nonneg hl hk0
  have h2 : armOffset lift (k : ℤ) ≤ (k : ℤ) := armOffset_le_index hlm hk0
  intro v hv
  simp only [armCell, mem_box, Vox.z] at hv ⊢
  simp only [armLen]
  omega

/-- The left arm. -/
def armL (lift : ℤ) : Solid := arm lift 11
/-- The right arm. -/
def armR (lift : ℤ) : Solid := arm lift (-13)

/-- The loader arms ride above the engine deck at every lift the machine
allows, so they never foul the power unit. -/
theorem arm_apart_powerUnit {lift : ℤ} (hl : 0 ≤ lift) (y0 : ℤ) :
    Apart (arm lift y0) powerUnit :=
  apart_of_slab_sep (arm_within_z hl y0) powerUnit_within_z (by norm_num [armZ0])

/-- The loader arms clear the operator's station too. -/
theorem arm_apart_station {lift : ℤ} (hl : 0 ≤ lift) (y0 : ℤ) :
    Apart (arm lift y0) station :=
  apart_of_slab_sep (arm_within_z hl y0) station_within_z (by norm_num [armZ0])

/-- The two loader arms are on opposite sides of the machine and cannot
interpenetrate, at any lift. -/
theorem arms_apart (lift : ℤ) : Apart (armL lift) (armR lift) :=
  apart_of_slab_sep (arm_within_y lift 11) (arm_within_y lift (-13)) (by norm_num)

/-! ## The bucket -/

/-- The bucket, carried on the tip of the arms: a back plate and a floor. -/
def bucket (lift : ℤ) : Solid :=
  cup (box (39, -16, armTipZ lift - 4) (41, 16, armTipZ lift + 1))
      (box (41, -16, armTipZ lift - 4) (46, 16, armTipZ lift - 3))

/-- The bucket rises with the arms: raising the loader carries the whole
bucket up by the rise of the tip. -/
theorem bucket_rises (lift lift' : ℤ) (v : Vox) :
    bucket lift v = true → bucket lift' (v + (0, 0, armTipZ lift' - armTipZ lift)) = true := by
  intro hv
  simp only [bucket, cup_apply, mem_box, Bool.or_eq_true, Vox.x, Vox.y, Vox.z,
    Prod.fst_add, Prod.snd_add] at hv ⊢
  omega

theorem bucket_above {lift : ℤ} (hl : 0 ≤ lift) : Above Vox.z (armZ0 - 4) (bucket lift) := by
  have ht := armTipZ_nonneg hl
  refine Above.cup ?_ ?_ <;> intro v hv <;>
    simp only [mem_box, Vox.x, Vox.y, Vox.z] at hv ⊢ <;> simp at hv ⊢ <;> omega

/-! ## The lift cylinders

The cylinders are what make the arms move, so their geometry is *coupled* to
the arms': the barrel stands on the frame, and the rod reaches from the top of
the barrel up to the underside of the arm at the station where it pushes.  That
coupling is the content of `rod_touches_arm` and `rodTop_eq`. -/

/-- The station along an arm the cylinder pushes at, counted in voxels out from
the pivot. -/
def cylStation : ℤ := 12

/-- The `x` of the cylinder, which is the `x` of that station of the arm. -/
def cylX0 : ℤ := armX0 + cylStation

/-- The barrel of a lift cylinder, standing on the frame, with its near face at
`y0`. -/
def cylBarrel (y0 : ℤ) : Solid := box (cylX0, y0, 12) (cylX0 + 1, y0 + 1, 19)

/-- How high the top of the rod reaches: one voxel below the underside of the
arm at the cylinder's station. -/
def rodTop (lift : ℤ) : ℤ := armZ0 + armOffset lift cylStation - 1

/-- The exposed rod of a lift cylinder at lift `lift`: it stands out of the
barrel and reaches the arm. -/
def cylRod (lift y0 : ℤ) : Solid := box (cylX0, y0, 20) (cylX0 + 1, y0 + 1, rodTop lift)

/-- A whole cylinder is barrel plus rod — again a function of the command. -/
def cylinder (lift y0 : ℤ) : Solid := cup (cylBarrel y0) (cylRod lift y0)

/-- The rod is never inside the barrel: the two are separated along the bore. -/
theorem rod_apart_barrel (lift y0 : ℤ) : Apart (cylRod lift y0) (cylBarrel y0) :=
  apart_of_slab_sep
    (within_box_z (cylX0, y0, 20) (cylX0 + 1, y0 + 1, rodTop lift))
    (within_box_z (cylX0, y0, 12) (cylX0 + 1, y0 + 1, 19))
    (by right; simp only [Vox.z_mk]; omega)

/-- The rod stays on the bore axis: it occupies exactly the barrel's cross
section in `x` and `y`. -/
theorem rod_within_bore (lift y0 : ℤ) :
    Within Vox.x cylX0 (cylX0 + 1) (cylRod lift y0) ∧
      Within Vox.y y0 (y0 + 1) (cylRod lift y0) := by
  constructor
  · have h := within_box_x (cylX0, y0, 20) (cylX0 + 1, y0 + 1, rodTop lift)
    simpa [cylRod] using h
  · have h := within_box_y (cylX0, y0, 20) (cylX0 + 1, y0 + 1, rodTop lift)
    simpa [cylRod] using h

/-- The exposed rod is as long as the lift makes it: the voxel at height `z` in
the bore is rod exactly when it is between the top of the barrel and the arm. -/
theorem rodLength_eq (lift y0 z : ℤ) :
    cylRod lift y0 (cylX0, y0, z) = true ↔ (20 ≤ z ∧ z ≤ rodTop lift) := by
  simp only [cylRod, mem_box, Vox.x_mk, Vox.y_mk, Vox.z_mk]
  omega

/-- The rod reaches exactly as high as the arm it pushes: its top voxel is one
below the arm's underside at that station. -/
theorem rodTop_eq (lift : ℤ) : rodTop lift + 1 = armZ0 + armOffset lift cylStation := by
  simp [rodTop]

/-- Extending the cylinder only adds material: the rod at a smaller lift is
part of the rod at a larger one. -/
theorem cylRod_mono {lift lift' : ℤ} (h : lift ≤ lift') (y0 : ℤ) :
    Sub (cylRod lift y0) (cylRod lift' y0) := by
  have hm : rodTop lift ≤ rodTop lift' :=
    by simpa [rodTop] using armOffset_mono (k := cylStation) (by norm_num [cylStation]) h
  intro v hv
  simp only [cylRod, mem_box, Vox.x_mk, Vox.y_mk, Vox.z_mk] at hv ⊢
  omega

/-- The rod pushes on the arm: the top voxel of the rod shares a face with the
bottom voxel of the arm, at every lift, so the actuator and the arm are one
mechanism rather than two bodies that happen to move together. -/
theorem rod_touches_arm {lift : ℤ} (hl : 0 ≤ lift) (y0 : ℤ) :
    Touches (cylRod lift y0) (arm lift y0) := by
  have hoff : 0 ≤ armOffset lift cylStation :=
    armOffset_nonneg hl (by norm_num [cylStation])
  refine ⟨(cylX0, y0, rodTop lift), (0, 0, 1), ?_, ?_, by simp⟩
  · simp only [cylRod, mem_box, Vox.x_mk, Vox.y_mk, Vox.z_mk, rodTop, armZ0] at *
    omega
  · rw [arm, unions_eq_true_iff]
    refine ⟨armCell lift y0 cylStation, ?_, ?_⟩
    · refine List.mem_map.2 ⟨12, List.mem_range.2 (by norm_num [armLenN]), ?_⟩
      norm_num [cylStation]
    · simp only [armCell, mem_box, Vox.x, Vox.y, Vox.z, cylX0, rodTop, Prod.fst_add,
        Prod.snd_add]
      simp

/-- The cylinders are outboard of the engine, so a cylinder never fouls the
power unit. -/
theorem cylinder_apart_engine {y0 : ℤ} (h : 7 ≤ y0 ∨ y0 + 1 ≤ -7) (lift : ℤ) :
    Apart (cylinder lift y0) engine := by
  have hb : Within Vox.y y0 (y0 + 1) (cylBarrel y0) := within_box_y _ _
  have hr : Within Vox.y y0 (y0 + 1) (cylRod lift y0) := within_box_y _ _
  have he : Within Vox.y (-6) 6 engine := by
    have := within_box_y ((16 : ℤ), (-6 : ℤ), (12 : ℤ)) ((26 : ℤ), (6 : ℤ), (19 : ℤ))
    simpa [engine] using this
  refine apart_of_slab_sep (hb.cup hr) he ?_
  omega

/-! ## The ground -/

/-- The ground: everything below the plane the wheels rest on. -/
def ground : Solid := fun v => decide (v.z ≤ -1)

theorem ground_below : Below Vox.z (-1) ground := by
  intro v hv
  simpa [ground] using hv

/-- The wheels rest on the ground: the bottom voxel of a wheel is face-adjacent
to the top voxel of the soil. -/
theorem wheel_touches_ground : Touches wheelRL ground := by
  refine ⟨(8, 14, 0), (0, 0, -1), ?_, ?_, by simp⟩
  · simp [wheelRL, wheel, discY, wheelR, wheelW, Vox.x, Vox.y, Vox.z]
  · simp [ground, Vox.z]

/-! ## The machine -/

/-- A colour, for the renderer. -/
structure Colour where
  /-- Red, 0–255. -/
  r : ℤ
  /-- Green, 0–255. -/
  g : ℤ
  /-- Blue, 0–255. -/
  b : ℤ
deriving Repr, DecidableEq

/-- A named body of the machine: **a function** from the lift command to the
occupancy of the lattice, together with what it looks like and what it is made
of. -/
structure Body where
  /-- The name of the part. -/
  name : String
  /-- Its colour in the renderer. -/
  colour : Colour
  /-- Its material, as the bill of materials names it. -/
  material : String
  /-- The part itself: a function of the lift command. -/
  shape : ℤ → Solid

/-- The body placed for a whole configuration: the shape at that lift, driven
forward by the travel. -/
def Body.at (b : Body) (c : Config) : Solid := move (c.travel, 0, 0) (b.shape c.lift)

/-- Steel grey. -/
def steelC : Colour := ⟨130, 135, 140⟩
/-- The machine's paint. -/
def paintC : Colour := ⟨215, 80, 40⟩
/-- Rubber black. -/
def rubberC : Colour := ⟨40, 40, 45⟩
/-- Chrome, for cylinder rods. -/
def chromeC : Colour := ⟨220, 225, 230⟩

/-- Every body of the machine.  Each one is a function of the controls, and the
machine is their union. -/
def bodies : List Body :=
  [ ⟨"rail-left", paintC, "4in square tube", fun _ => railL⟩
  , ⟨"rail-right", paintC, "4in square tube", fun _ => railR⟩
  , ⟨"cross-rear", paintC, "3in square tube", fun _ => crossRear⟩
  , ⟨"cross-front", paintC, "3in square tube", fun _ => crossFront⟩
  , ⟨"tower-left", paintC, "3in square tube", fun _ => towerL⟩
  , ⟨"tower-right", paintC, "3in square tube", fun _ => towerR⟩
  , ⟨"wheel-rear-left", rubberC, "tire and hub", fun _ => wheelRL⟩
  , ⟨"wheel-rear-right", rubberC, "tire and hub", fun _ => wheelRR⟩
  , ⟨"wheel-front-left", rubberC, "tire and hub", fun _ => wheelFL⟩
  , ⟨"wheel-front-right", rubberC, "tire and hub", fun _ => wheelFR⟩
  , ⟨"deck-plate", steelC, "6mm plate", fun _ => deckPlate⟩
  , ⟨"engine", steelC, "engine", fun _ => engine⟩
  , ⟨"fuel-tank", steelC, "fuel tank", fun _ => fuelTank⟩
  , ⟨"hydraulic-tank", steelC, "hydraulic tank", fun _ => hydraulicTank⟩
  , ⟨"seat", steelC, "seat", fun _ => seat⟩
  , ⟨"seat-back", steelC, "2in square tube", fun _ => seatBack⟩
  , ⟨"control-column", steelC, "control valve", fun _ => column⟩
  , ⟨"arm-left", paintC, "3in square tube", fun l => armL l⟩
  , ⟨"arm-right", paintC, "3in square tube", fun l => armR l⟩
  , ⟨"bucket", steelC, "12mm plate", fun l => bucket l⟩
  , ⟨"cyl-barrel-left", steelC, "cylinder", fun _ => cylBarrel 10⟩
  , ⟨"cyl-barrel-right", steelC, "cylinder", fun _ => cylBarrel (-12)⟩
  , ⟨"cyl-rod-left", chromeC, "cylinder", fun l => cylRod l 10⟩
  , ⟨"cyl-rod-right", chromeC, "cylinder", fun l => cylRod l (-12)⟩ ]

/-- The whole machine at a given setting of the controls: the union of its
bodies, each of which is itself a composition of boxes, discs and
placements. -/
def machine (c : Config) : Solid := unions (bodies.map (fun b => b.at c))

/-- Placing a body for a configuration is placing it at rest and then driving
it forward. -/
theorem Body.at_travel (b : Body) (lift t : ℤ) :
    b.at ⟨lift, t⟩ = move (t, 0, 0) (b.at ⟨lift, 0⟩) := by
  have h0 : ((0:ℤ), (0:ℤ), (0:ℤ)) = (0 : Vox) := rfl
  simp only [Body.at, h0, move_zero]

/-- Driving the machine forward translates the entire assembly — the property
that makes this representation compose. -/
theorem machine_travel (lift t : ℤ) :
    machine ⟨lift, t⟩ = move (t, 0, 0) (machine ⟨lift, 0⟩) := by
  simp only [machine, move_unions, List.map_map]
  congr 1
  refine List.map_congr_left ?_
  intro b _
  exact b.at_travel lift t

/-- No part of the machine is buried: every voxel of it is on or above the
ground plane. -/
theorem machine_above_ground {c : Config} (hc : c.Valid) : Above Vox.z 0 (machine c) := by
  obtain ⟨hl, -⟩ := hc
  refine Above.unions ?_
  intro s hs
  obtain ⟨b, hb, rfl⟩ := List.mem_map.1 hs
  refine above_z_move_x ?_
  simp only [bodies, List.mem_cons, List.not_mem_nil, or_false] at hb
  have hbox : ∀ lo hi : Vox, 0 ≤ lo.z → Above Vox.z 0 (box lo hi) := by
    intro lo hi h
    exact ((within_box_z lo hi).above).mono h
  have hwheel : ∀ c' : Vox, c'.z = 8 → Above Vox.z 0 (wheel c') := by
    intro c' h
    have := (wheel_within_z c').above
    rw [h] at this
    simpa [wheelR] using this
  rcases hb with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|
    rfl|rfl|rfl|rfl|rfl
  · exact ((hbox _ _ (by norm_num [Vox.z])).of_sub (tubeX_sub_box (0, 11, 8) (47, 13, 10) 1))
  · exact ((hbox _ _ (by norm_num [Vox.z])).of_sub (tubeX_sub_box (0, -13, 8) (47, -11, 10) 1))
  · exact ((hbox _ _ (by norm_num [Vox.z])).of_sub (tubeY_sub_box (2, -13, 8) (4, 13, 10) 1))
  · exact ((hbox _ _ (by norm_num [Vox.z])).of_sub (tubeY_sub_box (43, -13, 8) (45, 13, 10) 1))
  · exact ((hbox _ _ (by norm_num [Vox.z])).of_sub (tubeZ_sub_box (10, 11, 11) (12, 13, 21) 1))
  · exact ((hbox _ _ (by norm_num [Vox.z])).of_sub (tubeZ_sub_box (10, -13, 11) (12, -11, 21) 1))
  · exact hwheel _ rfl
  · exact hwheel _ rfl
  · exact hwheel _ rfl
  · exact hwheel _ rfl
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact ((arm_within_z hl 11).above).mono (by norm_num [armZ0])
  · exact ((arm_within_z hl (-13)).above).mono (by norm_num [armZ0])
  · exact (bucket_above hl).mono (by norm_num [armZ0])
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact hbox _ _ (by norm_num [Vox.z])
  · exact hbox _ _ (by norm_num [Vox.z])

/-- The machine never digs itself into the ground: it and the soil do not
interpenetrate, at any lift and any travel. -/
theorem machine_apart_ground {c : Config} (hc : c.Valid) : Apart (machine c) ground :=
  apart_of_above_below (machine_above_ground hc) ground_below (by norm_num)

/-! ## The envelope of the machine

Every body of the machine, at every lift the loader allows, fits in a box 48
voxels long, 35 wide and 49 tall — 2.40 m × 1.75 m × 2.45 m. -/

/-- A part fits inside the machine's envelope. -/
def InEnvelope (s : Solid) : Prop :=
  Within Vox.x 0 47 s ∧ Within Vox.y (-17) 17 s ∧ Within Vox.z 0 48 s

theorem InEnvelope.of_sub {s t : Solid} (h : InEnvelope t) (hst : Sub s t) : InEnvelope s :=
  ⟨h.1.of_sub hst, h.2.1.of_sub hst, h.2.2.of_sub hst⟩

theorem envelope_box (lo hi : Vox) (hx : 0 ≤ lo.x ∧ hi.x ≤ 47) (hy : -17 ≤ lo.y ∧ hi.y ≤ 17)
    (hz : 0 ≤ lo.z ∧ hi.z ≤ 48) : InEnvelope (box lo hi) :=
  ⟨(within_box_x lo hi).mono hx.1 hx.2, (within_box_y lo hi).mono hy.1 hy.2,
    (within_box_z lo hi).mono hz.1 hz.2⟩

theorem envelope_wheel (c : Vox) (hx : 8 ≤ c.x ∧ c.x ≤ 39) (hy : -17 ≤ c.y ∧ c.y ≤ 14)
    (hz : c.z = 8) : InEnvelope (wheel c) :=
  ⟨(wheel_within_x c).mono (by simp only [wheelR]; omega) (by simp only [wheelR]; omega),
    (wheel_within_y c).mono (by omega) (by simp only [wheelW]; omega),
    (wheel_within_z c).mono (by simp only [wheelR]; omega) (by simp only [wheelR]; omega)⟩

theorem envelope_arm {lift : ℤ} (hl : 0 ≤ lift) (hlm : lift ≤ armLen) {y0 : ℤ}
    (hy : -17 ≤ y0 ∧ y0 ≤ 15) : InEnvelope (arm lift y0) :=
  ⟨(arm_within_x lift y0).mono (by simp only [armX0]; omega)
      (by simp only [armX0, armLen]; omega),
    (arm_within_y lift y0).mono (by omega) (by omega),
    (arm_within_z_tight hl hlm y0).mono (by simp only [armZ0]; omega)
      (by simp only [armZ0, armLen]; omega)⟩

theorem envelope_bucket {lift : ℤ} (hl : 0 ≤ lift) (hlm : lift ≤ armLen) :
    InEnvelope (bucket lift) := by
  have h1 : armZ0 ≤ armTipZ lift := armTipZ_nonneg hl
  have h2 : armTipZ lift ≤ armZ0 + armLen - 1 := by
    have h := armOffset_le_index (k := armLen - 1) hlm (by norm_num [armLen])
    simp only [armTipZ]
    omega
  simp only [armZ0, armLen] at h1 h2
  refine ⟨Within.cup ?_ ?_, Within.cup ?_ ?_, Within.cup ?_ ?_⟩ <;> intro v hv <;>
    simp only [mem_box, Vox.x, Vox.y, Vox.z] at hv ⊢ <;> simp at hv ⊢ <;> omega

theorem envelope_cylRod {lift : ℤ} (hlm : lift ≤ armLen) (y0 : ℤ)
    (hy : -17 ≤ y0 ∧ y0 ≤ 16) : InEnvelope (cylRod lift y0) := by
  have h : rodTop lift ≤ 33 := by
    have h2 := armOffset_le_index (k := cylStation) hlm (by norm_num [cylStation])
    simp only [rodTop, armZ0, cylStation] at *
    omega
  exact envelope_box _ _ ⟨by simp [Vox.x, cylX0, armX0, cylStation], by
      simp [Vox.x, cylX0, armX0, cylStation]⟩
    ⟨by simpa [Vox.y] using hy.1, by simp only [Vox.y_mk]; omega⟩
    ⟨by simp [Vox.z], by simpa [Vox.z] using h.trans (by norm_num)⟩

/-- Every body of the machine fits in the envelope, at every lift the loader
allows. -/
theorem body_in_envelope {lift : ℤ} (hl : 0 ≤ lift) (hlm : lift ≤ liftMax) :
    ∀ b ∈ bodies, InEnvelope (b.shape lift) := by
  have hlm' : lift ≤ armLen := by simpa [armLen, liftMax] using hlm
  intro b hb
  simp only [bodies, List.mem_cons, List.not_mem_nil, or_false] at hb
  rcases hb with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|
    rfl|rfl|rfl|rfl|rfl
  · exact (envelope_box (0, 11, 8) (47, 13, 10) (by norm_num [Vox.x]) (by norm_num [Vox.y])
      (by norm_num [Vox.z])).of_sub (tubeX_sub_box _ _ _)
  · exact (envelope_box (0, -13, 8) (47, -11, 10) (by norm_num [Vox.x]) (by norm_num [Vox.y])
      (by norm_num [Vox.z])).of_sub (tubeX_sub_box _ _ _)
  · exact (envelope_box (2, -13, 8) (4, 13, 10) (by norm_num [Vox.x]) (by norm_num [Vox.y])
      (by norm_num [Vox.z])).of_sub (tubeY_sub_box _ _ _)
  · exact (envelope_box (43, -13, 8) (45, 13, 10) (by norm_num [Vox.x]) (by norm_num [Vox.y])
      (by norm_num [Vox.z])).of_sub (tubeY_sub_box _ _ _)
  · exact (envelope_box (10, 11, 11) (12, 13, 21) (by norm_num [Vox.x]) (by norm_num [Vox.y])
      (by norm_num [Vox.z])).of_sub (tubeZ_sub_box _ _ _)
  · exact (envelope_box (10, -13, 11) (12, -11, 21) (by norm_num [Vox.x]) (by norm_num [Vox.y])
      (by norm_num [Vox.z])).of_sub (tubeZ_sub_box _ _ _)
  · exact envelope_wheel _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_wheel _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_wheel _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_wheel _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_box _ _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_box _ _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_box _ _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_box _ _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_box _ _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_box _ _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_box _ _ (by norm_num [Vox.x]) (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_arm hl hlm' (by norm_num)
  · exact envelope_arm hl hlm' (by norm_num)
  · exact envelope_bucket hl hlm'
  · exact envelope_box _ _ (by norm_num [Vox.x, cylX0, armX0, cylStation])
      (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_box _ _ (by norm_num [Vox.x, cylX0, armX0, cylStation])
      (by norm_num [Vox.y]) (by norm_num [Vox.z])
  · exact envelope_cylRod hlm' _ (by norm_num)
  · exact envelope_cylRod hlm' _ (by norm_num)

/-- The whole machine fits in a box 2.40 m long, 1.75 m wide and 2.45 m tall,
wherever it has driven to and however high the loader is. -/
theorem machine_in_envelope {c : Config} (hc : c.Valid) :
    Within Vox.x c.travel (c.travel + 47) (machine c) ∧
      Within Vox.y (-17) 17 (machine c) ∧ Within Vox.z 0 48 (machine c) := by
  obtain ⟨hl, hlm⟩ := hc
  have hb := body_in_envelope hl hlm
  refine ⟨?_, ?_, ?_⟩ <;> refine Within.unions ?_ <;> intro s hs <;>
    obtain ⟨b, hbm, rfl⟩ := List.mem_map.1 hs
  · exact (within_x_move_x (hb b hbm).1).mono (by omega) (by omega)
  · exact within_y_move_x (hb b hbm).2.1
  · exact within_z_move_x (hb b hbm).2.2

/-- The number of voxels of the envelope: 48 by 35 by 49. -/
theorem envelope_card (t : ℤ) :
    (Finset.Icc ((t, -17, 0) : Vox) ((t + 47, 17, 48) : Vox)).card = 82320 := by
  have h : (t + 47 + 1 - t).toNat = 48 := by omega
  simp [Finset.card_Icc_prod, Int.card_Icc, h]

/-- However large a window one counts in, the machine never fills more than the
82320 voxels of its envelope — at 5 cm to the voxel, 10.29 m³. -/
theorem machine_count_le_envelope (w : Finset Vox) {c : Config} (hc : c.Valid) :
    count w (machine c) ≤ 82320 := by
  have hsub : (w.filter (fun v => machine c v = true)) ⊆
      Finset.Icc ((c.travel, -17, 0) : Vox) ((c.travel + 47, 17, 48) : Vox) := by
    intro v hv
    simp only [Finset.mem_filter] at hv
    obtain ⟨-, hm⟩ := hv
    obtain ⟨hx, hy, hz⟩ := machine_in_envelope hc
    have h1 := hx v hm
    have h2 := hy v hm
    have h3 := hz v hm
    simp only [Finset.mem_Icc, Vox.x, Vox.y, Vox.z] at *
    exact ⟨⟨h1.1, h2.1, h3.1⟩, h1.2, h2.2, h3.2⟩
  calc count w (machine c)
      ≤ (Finset.Icc ((c.travel, -17, 0) : Vox) ((c.travel + 47, 17, 48) : Vox)).card :=
        Finset.card_le_card hsub
    _ = 82320 := envelope_card c.travel

end Voxel
end LifeTrac
