import RequestProject.Motion.Anim.Space3D

/-!
# Flying the camera

The flight model of `web/js/fly.js`: stop the clock, take the stick, and the
camera becomes a little ship.  The model is a pure function — `step` returns a
new state — so its laws are laws about that function.

What is proved:

* `cos_pitch_pos`, `abs_stepPitch_le` — the pitch stop really stops: a step
  never leaves `[-pitchStop, pitchStop]`, and inside those stops the ship is
  never looking straight up or straight down, so its frame is never degenerate;
* `shipFrame_orthonormal` — the ship's frame (forward, right, up) is
  orthonormal for every yaw, every roll and every pitch inside the stops, so
  thrust along one axis never leaks into another;
* `norm_coast_le`, `norm_coast_lt` — with the stick at rest the velocity decays
  by `exp(-damping·dt)`: letting go always slows down and never speeds up, and
  strictly so while the ship is moving;
* `norm_capSpeed_le_max`, `norm_capSpeed_le` — the speed cap only ever slows the
  ship, and what comes out of it is never above the cap.

Playing a recorded flight back is ordinary keyframe sampling, so that the
playback passes through every key it kept is `Hesper.Anim.sample_key_eq` in
`RequestProject/Anim/Keyframe.lean`, not restated here.
-/

namespace Hesper.Fly

open Hesper.Space3D

noncomputable section

/-- The pitch stop of `web/js/fly.js`: never quite straight up or down. -/
def pitchStop : ℝ := Real.pi / 2 - 0.02

theorem pitchStop_lt : pitchStop < Real.pi / 2 := by
  unfold pitchStop; linarith

theorem pitchStop_pos : 0 < pitchStop := by
  unfold pitchStop
  have : (3 : ℝ) < Real.pi := by linarith [Real.pi_gt_three]
  linarith

/-- The clamp the runtime applies to the pitch. -/
def clampPitch (p : ℝ) : ℝ := max (-pitchStop) (min pitchStop p)

/-- One step of the pitch: integrate the stick, then clamp. -/
def stepPitch (turn dt stick p : ℝ) : ℝ := clampPitch (p + stick * turn * dt)

/-- The pitch stop really stops. -/
theorem abs_stepPitch_le (turn dt stick p : ℝ) : |stepPitch turn dt stick p| ≤ pitchStop := by
  have h := pitchStop_pos
  unfold stepPitch clampPitch
  refine abs_le.mpr ⟨le_max_left _ _, max_le (by linarith) (min_le_left _ _)⟩

/-- Inside the stops the ship is never looking straight up or down. -/
theorem cos_pitch_pos {p : ℝ} (h : |p| ≤ pitchStop) : 0 < Real.cos p := by
  obtain ⟨hlo, hhi⟩ := abs_le.mp h
  have hstop := pitchStop_lt
  exact Real.cos_pos_of_mem_Ioo ⟨by linarith, by linarith⟩

/-! ## The ship's frame -/

/-- Where the ship is looking. -/
def forward (yaw pitch : ℝ) : V3 :=
  ⟨Real.cos pitch * Real.cos yaw, Real.cos pitch * Real.sin yaw, Real.sin pitch⟩

/-- The unrolled right-hand axis; the runtime builds it as `unit (forward × ẑ)`. -/
def right0 (yaw : ℝ) : V3 := ⟨Real.sin yaw, -Real.cos yaw, 0⟩

/-- The unrolled up axis. -/
def up0 (yaw pitch : ℝ) : V3 := V3.cross (right0 yaw) (forward yaw pitch)

/-- The right-hand axis after rolling. -/
def right (yaw pitch roll : ℝ) : V3 :=
  V3.add (V3.smul (Real.cos roll) (right0 yaw)) (V3.smul (Real.sin roll) (up0 yaw pitch))

/-- The up axis after rolling. -/
def up (yaw pitch roll : ℝ) : V3 :=
  V3.add (V3.smul (Real.cos roll) (up0 yaw pitch)) (V3.smul (-Real.sin roll) (right0 yaw))

theorem dot_add_left (a b c : V3) : V3.dot (V3.add a b) c = V3.dot a c + V3.dot b c := by
  simp [V3.dot, V3.add]; ring

theorem dot_add_right (a b c : V3) : V3.dot a (V3.add b c) = V3.dot a b + V3.dot a c := by
  simp [V3.dot, V3.add]; ring

/-- What the runtime normalises really is `right0`, scaled by `cos pitch`. -/
theorem cross_forward_z (yaw pitch : ℝ) :
    V3.cross (forward yaw pitch) ⟨0, 0, 1⟩ = V3.smul (Real.cos pitch) (right0 yaw) := by
  unfold V3.cross V3.smul forward right0
  simp only [V3.mk.injEq]
  refine ⟨by ring, by ring, by ring⟩

theorem unit_cross_forward {yaw pitch : ℝ} (h : 0 < Real.cos pitch) :
    V3.unit (V3.cross (forward yaw pitch) ⟨0, 0, 1⟩) = right0 yaw := by
  have hy := Real.sin_sq_add_cos_sq yaw
  have hnorm : V3.norm (V3.cross (forward yaw pitch) ⟨0, 0, 1⟩) = Real.cos pitch := by
    rw [cross_forward_z]
    unfold V3.norm V3.dot V3.smul right0
    have hsq : Real.cos pitch * Real.sin yaw * (Real.cos pitch * Real.sin yaw)
        + Real.cos pitch * -Real.cos yaw * (Real.cos pitch * -Real.cos yaw)
        + Real.cos pitch * 0 * (Real.cos pitch * 0) = Real.cos pitch ^ 2 := by
      nlinarith [hy]
    rw [hsq]
    exact Real.sqrt_sq (le_of_lt h)
  unfold V3.unit
  rw [hnorm, cross_forward_z]
  simp only [(ne_of_gt h), if_false]
  unfold V3.smul right0
  simp only [V3.mk.injEq]
  have hne : Real.cos pitch ≠ 0 := ne_of_gt h
  refine ⟨by field_simp, by field_simp, by ring⟩

/-! ### The unrolled frame -/

theorem dot_forward_self (yaw pitch : ℝ) :
    V3.dot (forward yaw pitch) (forward yaw pitch) = 1 := by
  simp [V3.dot, forward]
  nlinarith [Real.sin_sq_add_cos_sq yaw, Real.sin_sq_add_cos_sq pitch]

theorem dot_right0_self (yaw : ℝ) : V3.dot (right0 yaw) (right0 yaw) = 1 := by
  simp [V3.dot, right0]
  nlinarith [Real.sin_sq_add_cos_sq yaw]

theorem dot_up0_self (yaw pitch : ℝ) : V3.dot (up0 yaw pitch) (up0 yaw pitch) = 1 := by
  have hy := Real.sin_sq_add_cos_sq yaw
  have hp := Real.sin_sq_add_cos_sq pitch
  simp only [V3.dot, up0, V3.cross, right0, forward]
  linear_combination
    (Real.sin pitch ^ 2 + Real.cos pitch ^ 2 * (Real.sin yaw ^ 2 + Real.cos yaw ^ 2 + 1)) * hy + hp

theorem dot_forward_right0 (yaw pitch : ℝ) : V3.dot (forward yaw pitch) (right0 yaw) = 0 := by
  simp [V3.dot, forward, right0]; ring

theorem dot_forward_up0 (yaw pitch : ℝ) : V3.dot (forward yaw pitch) (up0 yaw pitch) = 0 := by
  simp [V3.dot, up0, V3.cross, right0, forward]
  nlinarith [Real.sin_sq_add_cos_sq yaw]

theorem dot_right0_up0 (yaw pitch : ℝ) : V3.dot (right0 yaw) (up0 yaw pitch) = 0 := by
  simp [V3.dot, up0, V3.cross, right0, forward]; ring

/-- The frame is orthonormal, for every yaw and roll and every pitch inside the stops. -/
theorem shipFrame_orthonormal (yaw pitch roll : ℝ) :
    V3.dot (forward yaw pitch) (forward yaw pitch) = 1 ∧
      V3.dot (right yaw pitch roll) (right yaw pitch roll) = 1 ∧
      V3.dot (up yaw pitch roll) (up yaw pitch roll) = 1 ∧
      V3.dot (forward yaw pitch) (right yaw pitch roll) = 0 ∧
      V3.dot (forward yaw pitch) (up yaw pitch roll) = 0 ∧
      V3.dot (right yaw pitch roll) (up yaw pitch roll) = 0 := by
  have hr := Real.sin_sq_add_cos_sq roll
  have hff := dot_forward_self yaw pitch
  have hrr := dot_right0_self yaw
  have huu := dot_up0_self yaw pitch
  have hfr := dot_forward_right0 yaw pitch
  have hfu := dot_forward_up0 yaw pitch
  have hru := dot_right0_up0 yaw pitch
  have hur : V3.dot (up0 yaw pitch) (right0 yaw) = 0 := by rw [V3.dot_comm]; exact hru
  refine ⟨hff, ?_, ?_, ?_, ?_, ?_⟩ <;>
    simp only [right, up, dot_add_left, dot_add_right, V3.dot_smul_left, V3.dot_smul_right,
      hrr, huu, hfr, hfu, hru, hur] <;>
    nlinarith [hr]

/-! ## Speed -/

theorem norm_smul (k : ℝ) (v : V3) : V3.norm (V3.smul k v) = |k| * V3.norm v := by
  unfold V3.norm V3.dot V3.smul
  have h : k * v.x * (k * v.x) + k * v.y * (k * v.y) + k * v.z * (k * v.z)
      = k ^ 2 * (v.x * v.x + v.y * v.y + v.z * v.z) := by ring
  rw [h, Real.sqrt_mul (by positivity), Real.sqrt_sq_eq_abs]

/-- The velocity after one step with the stick at rest. -/
def coast (damping dt : ℝ) (v : V3) : V3 := V3.smul (Real.exp (-(damping * dt))) v

/-- Letting go of everything never speeds the ship up. -/
theorem norm_coast_le {damping dt : ℝ} (hd : 0 ≤ damping) (hdt : 0 ≤ dt) (v : V3) :
    V3.norm (coast damping dt v) ≤ V3.norm v := by
  have hexp : Real.exp (-(damping * dt)) ≤ 1 := Real.exp_le_one_iff.mpr (by nlinarith)
  have hpos : 0 < Real.exp (-(damping * dt)) := Real.exp_pos _
  rw [coast, norm_smul, abs_of_pos hpos]
  nlinarith [V3.norm_nonneg v]

/-- And while it is moving it really does slow down. -/
theorem norm_coast_lt {damping dt : ℝ} (hd : 0 < damping) (hdt : 0 < dt) {v : V3}
    (hv : 0 < V3.norm v) : V3.norm (coast damping dt v) < V3.norm v := by
  have hexp : Real.exp (-(damping * dt)) < 1 := Real.exp_lt_one_iff.mpr (by nlinarith)
  have hpos : 0 < Real.exp (-(damping * dt)) := Real.exp_pos _
  rw [coast, norm_smul, abs_of_pos hpos]
  nlinarith

/-- The speed cap of the flight model. -/
def capSpeed (maxSpeed : ℝ) (v : V3) : V3 :=
  if maxSpeed < V3.norm v then V3.smul (maxSpeed / V3.norm v) v else v

/-- The cap only ever slows the ship. -/
theorem norm_capSpeed_le {maxSpeed : ℝ} (hm : 0 ≤ maxSpeed) (v : V3) :
    V3.norm (capSpeed maxSpeed v) ≤ V3.norm v := by
  unfold capSpeed
  split
  · rename_i hgt
    have hn : 0 < V3.norm v := lt_of_le_of_lt hm hgt
    rw [norm_smul, abs_of_nonneg (by positivity)]
    rw [div_mul_eq_mul_div, mul_div_assoc, div_self (ne_of_gt hn), mul_one]
    exact le_of_lt hgt
  · exact le_rfl

/-- What comes out of the cap is never above it. -/
theorem norm_capSpeed_le_max {maxSpeed : ℝ} (hm : 0 ≤ maxSpeed) (v : V3) :
    V3.norm (capSpeed maxSpeed v) ≤ max maxSpeed (V3.norm v) := by
  unfold capSpeed
  split
  · rename_i hgt
    have hn : 0 < V3.norm v := lt_of_le_of_lt hm hgt
    rw [norm_smul, abs_of_nonneg (by positivity)]
    rw [div_mul_eq_mul_div, mul_div_assoc, div_self (ne_of_gt hn), mul_one]
    exact le_max_left _ _
  · exact le_max_right _ _

end

end Hesper.Fly
