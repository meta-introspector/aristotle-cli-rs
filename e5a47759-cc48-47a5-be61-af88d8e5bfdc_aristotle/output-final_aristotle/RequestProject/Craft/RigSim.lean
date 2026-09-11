import RequestProject.Craft.RigDesign

/-!
# The test track — driving a rig, tick by tick

A design is only worth something once it has been *tested*: dropped on a track and
driven to the finish.  This file is the rule book of that test.

Everything is a natural number and every operation is one an `i32` machine can do,
because the same rules are compiled to WebAssembly in `RequestProject/RigKernel.lean`
and run in the browser.  Velocities are stored **biased**: a stored `vx` means a
real velocity of `vx - vBias`, so nothing ever goes negative and the whole state
is a handful of small naturals.

What is proved:

* the state stays in range for ever — speeds inside `vCap` of the bias, the rig
  never leaves the track, height and fuel bounded (`Inv`, `step_inv`, `run_inv`);
* fuel never rises, distance never falls, the clock always advances by one, and a
  crashed rig stays crashed and frozen (`step_fuel_le`, `step_dist_le`,
  `step_tick`, `step_crashed`);
* a rig with no engine burns no fuel and a rig that is never touched keeps its
  fuel (`fuel_const_of_idle`);
* running is replay: playing a run of inputs and then another is the same as
  playing the concatenation (`run_append`), so a recorded run reproduces exactly;
* the score of a run is bounded by an explicit function of the design
  (`score_le`).
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Rig

/-! ## Constants -/

/-- Sub-cell resolution: sixteen steps to one block. -/
def unit : Nat := 16

/-- Velocities are stored with this added, so they are never negative. -/
def vBias : Nat := 1024

/-- Fastest the rig may go, in sixteenths of a block per tick. -/
def vCap : Nat := 48

/-- Number of columns in a track. -/
def trackLen : Nat := 128

/-- Furthest right the rig may get, in sixteenths. -/
def maxX : Nat := trackLen * unit - 1

/-- Highest the rig may get, in sixteenths: the ceiling of the play area. -/
def maxY : Nat := 15 * unit

/-- Downward pull per tick. -/
def gravity : Nat := 2

/-- Score lost for wrecking the rig. -/
def crashPenalty : Nat := 60

/-- Running into a wall at or above this speed wrecks the rig; slower than this it
is only a bump. -/
def smashSpeed : Nat := 24

/-! ## What the sim needs to know about a design -/

/-- The handful of numbers the physics reads off a design. -/
structure Params where
  mass : Nat
  thrust : Nat
  lift : Nat
  fuel : Nat
  payload : Nat
deriving DecidableEq, Repr, Inhabited

/-- The parameters of a design.  The mass is at least one so that the divisions
below are honest. -/
def Params.of (d : Design) : Params :=
  { mass := max 1 (Design.mass d)
    thrust := Design.thrust d
    lift := Design.lift d
    fuel := Design.fuel d
    payload := Design.payload d }

theorem Params.of_mass_pos (d : Design) : 0 < (Params.of d).mass := by
  simp [Params.of]

/-! ## Tracks -/

/-- A test track: a name, the ground height of each column, and where the finish is. -/
structure Track where
  name : String
  heights : List Nat
  finish : Nat
deriving Repr, Inhabited

/-- The ground height of a column, in blocks. -/
def Track.ground (t : Track) (c : Nat) : Nat := (t.heights[c]?).getD 0

/-- A track is usable when it covers every column and never rises above the sky. -/
structure Track.WF (t : Track) : Prop where
  len : t.heights.length = trackLen
  low : ∀ h ∈ t.heights, h < 16
  finish_le : t.finish ≤ maxX

theorem Track.ground_lt {t : Track} (h : t.WF) (c : Nat) : t.ground c < 16 := by
  unfold Track.ground
  cases hc : t.heights[c]? with
  | none => simp
  | some v => simpa [hc] using h.low v (List.getElem?_eq_some_iff.mp hc |>.choose_spec ▸
      List.getElem_mem _)

/-- Build a track from a column function; the ground is always between one and
twelve blocks high, so it is always inside the grid. -/
def mkTrack (name : String) (f : Nat → Nat) (finish : Nat) : Track :=
  { name := name
    heights := (List.range trackLen).map (fun c => f c % 12 + 1)
    finish := min maxX finish }

theorem mkTrack_wf (name : String) (f : Nat → Nat) (finish : Nat) :
    (mkTrack name f finish).WF where
  len := by simp [mkTrack]
  low := by
    intro h hh
    simp [mkTrack] at hh
    obtain ⟨c, _, rfl⟩ := hh
    omega
  finish_le := by simp [mkTrack]

/-- The flats: a long run with two low steps to bump over. -/
def trackFlats : Track :=
  mkTrack "the flats" (fun c => if 40 ≤ c && c < 44 then 1 else if 80 ≤ c && c < 88 then 1 else 0)
    (110 * unit)

/-- The hills: rolling ground that keeps taking the wheels off the floor. -/
def trackHills : Track :=
  mkTrack "the hills" (fun c => (c / 6) % 4) (110 * unit)

/-- The steps: walls that have to be flown over. -/
def trackSteps : Track :=
  mkTrack "the steps" (fun c => 2 * (c / 24)) (110 * unit)

/-- The three tracks of the game. -/
def tracks : List Track := [trackFlats, trackHills, trackSteps]

theorem tracks_wf : ∀ t ∈ tracks, t.WF := by
  intro t ht
  simp [tracks, trackFlats, trackHills, trackSteps] at ht
  rcases ht with rfl | rfl | rfl <;> exact mkTrack_wf _ _ _

/-! ## The state of a test run -/

/-- The rig's state on the track. -/
structure Sim where
  x : Nat
  y : Nat
  vx : Nat
  vy : Nat
  fuel : Nat
  dist : Nat
  tick : Nat
  crashed : Nat
deriving DecidableEq, Repr, Inhabited

/-- The rig at the start line, sitting on the ground of column zero. -/
def Sim.start (t : Track) (p : Params) : Sim :=
  { x := 0, y := unit * t.ground 0, vx := vBias, vy := vBias,
    fuel := p.fuel, dist := 0, tick := 0, crashed := 0 }

/-- The state is in range. -/
structure Sim.Inv (p : Params) (s : Sim) : Prop where
  x_le : s.x ≤ maxX
  y_le : s.y ≤ maxY
  vx_lo : vBias - vCap ≤ s.vx
  vx_hi : s.vx ≤ vBias + vCap
  vy_lo : vBias - vCap ≤ s.vy
  vy_hi : s.vy ≤ vBias + vCap
  fuel_le : s.fuel ≤ p.fuel
  dist_le : s.dist ≤ maxX
  crashed_le : s.crashed ≤ 1

/-! ## One tick -/

/-- Saturating subtraction — what the compiled kernel does with a `select`. -/
def subSat (a b : Nat) : Nat := a - b

/-- Keep a biased velocity inside the cap. -/
def clampV (v : Nat) : Nat := max (vBias - vCap) (min (vBias + vCap) v)

theorem clampV_lo (v : Nat) : vBias - vCap ≤ clampV v := by
  simp [clampV]

theorem clampV_hi (v : Nat) : clampV v ≤ vBias + vCap := by
  simp [clampV, vBias, vCap]

/-- How hard the wheels push this tick: nothing without fuel, and only half as hard
with the wheels off the ground. -/
def accelOf (p : Params) (s : Sim) (grounded : Bool) : Nat :=
  if s.fuel = 0 then 0
  else if grounded then min 12 (4 * p.thrust / p.mass)
  else min 6 (2 * p.thrust / p.mass)

/-- How hard the balloons pull while they are being vented, per tick.  Anything at
or below `gravity` is not enough to get off the ground. -/
def liftOf (p : Params) : Nat := min 6 (4 * p.lift / p.mass)

/-- Rolling friction: a stopped rig stays stopped, a moving one bleeds a little. -/
def drag (v : Nat) : Nat :=
  if vBias < v then v - 1 else if v < vBias then v + 1 else v

/-- Move a coordinate by a biased velocity, without leaving `[0, cap]`. -/
def advance (pos v cap : Nat) : Nat :=
  if vBias ≤ v then min cap (pos + (v - vBias)) else subSat pos (vBias - v)

theorem advance_le {pos v cap : Nat} (h : pos ≤ cap) : advance pos v cap ≤ cap := by
  unfold advance subSat
  split
  · exact min_le_left _ _
  · omega

/-- The new horizontal velocity. -/
def newVX (p : Params) (s : Sim) (inp : Nat) (grounded : Bool) : Nat :=
  let a := accelOf p s grounded
  clampV (if inp % 2 = 1 then s.vx + a
          else if inp / 2 % 2 = 1 then subSat (drag s.vx) a
          else drag s.vx)

/-- The new vertical velocity. -/
def newVY (p : Params) (s : Sim) (inp : Nat) : Nat :=
  clampV (subSat (s.vy + (if inp / 4 % 2 = 1 && 0 < s.fuel then liftOf p else 0)) gravity)

/-- Advance the rig one tick.  The input is the joystick as three bits, so they can
be held together: `1` drive right, `2` drive left, `4` vent the balloons. -/
def step (t : Track) (p : Params) (inp : Nat) (s : Sim) : Sim :=
  if s.crashed = 1 then s else
  let grounded := s.y ≤ unit * t.ground (s.x / unit)
  let vx1 := newVX p s inp grounded
  let vy1 := newVY p s inp
  let x1 := advance s.x vx1 maxX
  let y1 := advance s.y vy1 maxY
  let hit := unit * t.ground (x1 / unit) > s.y + unit && vBias < vx1
  let x2 := if hit then s.x else x1
  let floorY := unit * t.ground (x2 / unit)
  let onGround := y1 < floorY
  { x := x2
    y := if onGround then floorY else y1
    vx := if hit then vBias else vx1
    vy := if onGround then vBias else vy1
    fuel := subSat s.fuel (if inp = 0 then 0 else 1)
    dist := max s.dist x2
    tick := s.tick + 1
    crashed := if hit && vBias + smashSpeed ≤ vx1 then 1 else 0 }

theorem newVX_lo (p : Params) (s : Sim) (inp : Nat) (g : Bool) :
    vBias - vCap ≤ newVX p s inp g := clampV_lo _

theorem newVX_hi (p : Params) (s : Sim) (inp : Nat) (g : Bool) :
    newVX p s inp g ≤ vBias + vCap := clampV_hi _

theorem newVY_lo (p : Params) (s : Sim) (inp : Nat) : vBias - vCap ≤ newVY p s inp := clampV_lo _

theorem newVY_hi (p : Params) (s : Sim) (inp : Nat) : newVY p s inp ≤ vBias + vCap := clampV_hi _

/-- Play a list of inputs. -/
def run (t : Track) (p : Params) : List Nat → Sim → Sim
  | [], s => s
  | i :: is, s => run t p is (step t p i s)

/-- The score of a finished run. -/
def score (t : Track) (p : Params) (s : Sim) : Nat :=
  subSat (s.dist / unit + (if t.finish ≤ s.dist then p.payload else 0) + s.fuel / 8)
    (if s.crashed = 1 then crashPenalty else 0)

/-! ## What holds of every tick -/

theorem step_tick (t : Track) (p : Params) (i : Nat) (s : Sim) (h : s.crashed ≠ 1) :
    (step t p i s).tick = s.tick + 1 := by
  simp [step, h]

theorem step_crashed (t : Track) (p : Params) (i : Nat) (s : Sim) (h : s.crashed = 1) :
    step t p i s = s := by
  simp [step, h]

theorem step_fuel_le (t : Track) (p : Params) (i : Nat) (s : Sim) :
    (step t p i s).fuel ≤ s.fuel := by
  unfold step
  split
  · exact le_refl _
  · simp [subSat]

theorem step_dist_le (t : Track) (p : Params) (i : Nat) (s : Sim) :
    s.dist ≤ (step t p i s).dist := by
  unfold step
  split
  · exact le_refl _
  · simp

theorem step_x_le (t : Track) (p : Params) (i : Nat) (s : Sim) (h : s.x ≤ maxX) :
    (step t p i s).x ≤ maxX := by
  unfold step
  split
  · exact h
  · dsimp only
    split_ifs <;> first | exact h | exact advance_le h

theorem step_inv {t : Track} (ht : t.WF) {p : Params} (i : Nat) {s : Sim}
    (h : Sim.Inv p s) : Sim.Inv p (step t p i s) := by
  have hu : unit = 16 := rfl
  have hm : maxY = 240 := rfl
  have hg : ∀ c, unit * t.ground c ≤ maxY := by
    intro c
    have := Track.ground_lt ht c
    rw [hu, hm]
    omega
  have hx := h.x_le
  have hy := h.y_le
  have hf := h.fuel_le
  have hd := h.dist_le
  have hb : vBias - vCap ≤ vBias ∧ vBias ≤ vBias + vCap :=
    ⟨Nat.sub_le _ _, Nat.le_add_right _ _⟩
  unfold step
  split
  · exact h
  · refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> dsimp only
    · split_ifs <;> first | exact hx | exact advance_le hx
    · split_ifs <;> first | exact hg _ | exact advance_le hy
    · split_ifs <;> first | exact hb.1 | exact newVX_lo _ _ _ _
    · split_ifs <;> first | exact hb.2 | exact newVX_hi _ _ _ _
    · split_ifs <;> first | exact hb.1 | exact newVY_lo _ _ _
    · split_ifs <;> first | exact hb.2 | exact newVY_hi _ _ _
    · exact le_trans (Nat.sub_le _ _) hf
    · refine max_le hd ?_
      split_ifs <;> first | exact hx | exact advance_le hx
    · split_ifs <;> simp

theorem run_append (t : Track) (p : Params) (is js : List Nat) (s : Sim) :
    run t p (is ++ js) s = run t p js (run t p is s) := by
  induction is generalizing s with
  | nil => rfl
  | cons i is ih => simp [run, ih]

theorem run_inv {t : Track} (ht : t.WF) {p : Params} (is : List Nat) {s : Sim}
    (h : Sim.Inv p s) : Sim.Inv p (run t p is s) := by
  induction is generalizing s with
  | nil => exact h
  | cons i is ih => exact ih (step_inv ht i h)

theorem start_inv {t : Track} (ht : t.WF) (p : Params) : Sim.Inv p (Sim.start t p) := by
  have hg : unit * t.ground 0 ≤ maxY := by
    have := Track.ground_lt ht 0
    have hu : unit = 16 := rfl
    have hm : maxY = 240 := rfl
    rw [hu, hm]
    omega
  exact
    { x_le := Nat.zero_le _
      y_le := hg
      vx_lo := Nat.sub_le _ _
      vx_hi := Nat.le_add_right _ _
      vy_lo := Nat.sub_le _ _
      vy_hi := Nat.le_add_right _ _
      fuel_le := le_refl _
      dist_le := Nat.zero_le _
      crashed_le := Nat.zero_le _ }

theorem run_fuel_le (t : Track) (p : Params) (is : List Nat) (s : Sim) :
    (run t p is s).fuel ≤ s.fuel := by
  induction is generalizing s with
  | nil => exact le_refl _
  | cons i is ih => exact le_trans (ih _) (step_fuel_le t p i s)

theorem run_dist_le (t : Track) (p : Params) (is : List Nat) (s : Sim) :
    s.dist ≤ (run t p is s).dist := by
  induction is generalizing s with
  | nil => exact le_refl _
  | cons i is ih => exact le_trans (step_dist_le t p i s) (ih _)

/-- Coasting costs nothing. -/
theorem fuel_const_of_idle (t : Track) (p : Params) (is : List Nat) (s : Sim)
    (h : ∀ i ∈ is, i = 0) : (run t p is s).fuel = s.fuel := by
  induction is generalizing s with
  | nil => rfl
  | cons i is ih =>
      have hi : i = 0 := h i (List.mem_cons_self ..)
      have : (step t p i s).fuel = s.fuel := by
        unfold step; split
        · rfl
        · simp [hi, subSat]
      rw [run, ih _ (fun j hj => h j (List.mem_cons_of_mem _ hj)), this]

/-- A rig cannot score more than the track, its cargo and its tank allow. -/
theorem score_le (t : Track) (p : Params) {s : Sim} (h : Sim.Inv p s) :
    score t p s ≤ trackLen + p.payload + p.fuel := by
  have hd : s.dist ≤ maxX := h.dist_le
  have hf : s.fuel ≤ p.fuel := h.fuel_le
  have hu : unit = 16 := rfl
  have hx : maxX = 2047 := rfl
  have htl : trackLen = 128 := rfl
  have h1 : s.dist / unit ≤ trackLen := by
    have hle : s.dist / unit ≤ maxX / unit := Nat.div_le_div_right hd
    rw [hu, hx] at hle
    rw [hu, htl]
    omega
  have h2 : s.fuel / 8 ≤ p.fuel := le_trans (Nat.div_le_self _ _) hf
  have h3 : (if t.finish ≤ s.dist then p.payload else 0) ≤ p.payload := by
    split <;> simp
  have key : s.dist / unit + (if t.finish ≤ s.dist then p.payload else 0) + s.fuel / 8 ≤
      trackLen + p.payload + p.fuel := by omega
  unfold score subSat
  exact le_trans (Nat.sub_le _ _) key

end Rig
