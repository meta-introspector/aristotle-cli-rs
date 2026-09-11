import RequestProject.Gvcs.Traction

/-!
# Longitudinal dynamics of the LifeTrac tractor

Accelerating, braking and pushing all transfer load between the axles: the
inertial force acts at the centre of mass, a height `h` above the ground, and
its moment about the contact patches is balanced by a change of the axle loads.
This file works out

* the load transfer `m a h / L` and the fact that the total load is unchanged;
* the wheelie condition — the front axle lifts exactly when the acceleration
  reaches `g · comToRear / h`;
* the friction limit on acceleration, `a ≤ μ g`, independent of the mass, and
  the resulting criterion telling which of the two happens first;
* braking: the stopping distance `v² / (2 μ g)`, obtained both from the
  equation of motion and from the work–energy balance.
-/

namespace LifeTrac

open Real

noncomputable section

namespace SideView

variable (s : SideView)

/-- Load transferred from the front axle to the rear axle when the machine
accelerates forward at `a`, its centre of mass being at height `hcom`.  Here
`g` is the gravitational acceleration, so `s.weight / g` is the mass. -/
def loadTransfer (g hcom a : ℝ) : ℝ := (s.weight / g) * a * hcom / s.wheelbase

/-- Front axle load while accelerating. -/
def frontAxleLoadAccel (g hcom a : ℝ) : ℝ :=
  s.frontAxleLoad - s.loadTransfer g hcom a

/-- Rear axle load while accelerating. -/
def rearAxleLoadAccel (g hcom a : ℝ) : ℝ :=
  s.rearAxleLoad + s.loadTransfer g hcom a

/-- **Load transfer conserves the total load.**  Accelerating moves weight from
the front axle to the rear one but does not change their sum. -/
theorem axleLoadAccel_add (g hcom a : ℝ) :
    s.frontAxleLoadAccel g hcom a + s.rearAxleLoadAccel g hcom a = s.weight := by
  unfold frontAxleLoadAccel rearAxleLoadAccel
  rw [show s.frontAxleLoad - s.loadTransfer g hcom a
      + (s.rearAxleLoad + s.loadTransfer g hcom a)
      = s.frontAxleLoad + s.rearAxleLoad by ring]
  exact s.axleLoad_add

/-- Braking (negative acceleration) transfers load onto the front axle
instead. -/
theorem frontAxleLoadAccel_gt_of_braking {g hcom a : ℝ} (hg : 0 < g)
    (hh : 0 < hcom) (ha : a < 0) :
    s.frontAxleLoad < s.frontAxleLoadAccel g hcom a := by
  have hw := s.wheelbase_pos
  have hW := s.weight_pos
  have h : s.loadTransfer g hcom a < 0 := by
    unfold loadTransfer
    apply div_neg_of_neg_of_pos _ hw
    have h0 : 0 < s.weight / g := div_pos hW hg
    exact mul_neg_of_neg_of_pos (mul_neg_of_pos_of_neg h0 ha) hh
  unfold frontAxleLoadAccel
  linarith

/-- **Wheelie condition.**  The front wheels stay on the ground exactly as long
as the forward acceleration does not exceed `g · comToRear / hcom`; again the
mass drops out. -/
theorem front_wheels_grounded_iff {g hcom a : ℝ} (hg : 0 < g) (hh : 0 < hcom) :
    0 ≤ s.frontAxleLoadAccel g hcom a ↔ a ≤ g * s.comToRear / hcom := by
  have hw := s.wheelbase_pos
  have hW := s.weight_pos
  have hM : 0 < s.weight / g := div_pos hW hg
  have hWg : s.weight / g * g = s.weight := div_mul_cancel₀ _ hg.ne'
  have key : 0 ≤ s.frontAxleLoadAccel g hcom a ↔
      s.weight / g * a * hcom ≤ s.weight * s.comToRear := by
    rw [frontAxleLoadAccel, frontAxleLoad, loadTransfer, sub_nonneg,
      div_le_div_iff₀ hw hw]
    constructor <;> intro h <;> nlinarith
  rw [key, le_div_iff₀ hh]
  constructor
  · intro h
    have h' : s.weight / g * (a * hcom) ≤ s.weight / g * (g * s.comToRear) := by
      calc s.weight / g * (a * hcom) = s.weight / g * a * hcom := by ring
        _ ≤ s.weight * s.comToRear := h
        _ = s.weight / g * (g * s.comToRear) := by rw [← mul_assoc, hWg]
    exact le_of_mul_le_mul_left h' hM
  · intro h
    calc s.weight / g * a * hcom = s.weight / g * (a * hcom) := by ring
      _ ≤ s.weight / g * (g * s.comToRear) := mul_le_mul_of_nonneg_left h hM.le
      _ = s.weight * s.comToRear := by rw [← mul_assoc, hWg]

/-- **The friction limit on acceleration.**  With all four wheels driven, the
forward acceleration of a machine on ground of friction coefficient `mu` is at
most `mu * g`, whatever its mass. -/
theorem accel_le_of_friction {g mu a : ℝ} (hg : 0 < g)
    (h : (s.weight / g) * a ≤ frictionLimit mu s.weight) : a ≤ mu * g := by
  have hW := s.weight_pos
  rw [frictionLimit] at h
  have hpos : 0 < s.weight / g := div_pos hW hg
  have h2 : s.weight / g * a ≤ s.weight / g * (mu * g) := by
    have : s.weight / g * (mu * g) = mu * s.weight := by field_simp
    rw [this]; exact h
  exact le_of_mul_le_mul_left h2 hpos

/-- **Slip or wheelie?**  On ground poor enough that `mu < comToRear / hcom`,
the wheels break traction before the front axle can lift: any acceleration the
ground allows keeps the front wheels down. -/
theorem no_wheelie_of_friction_small {g mu hcom a : ℝ} (hg : 0 < g)
    (hh : 0 < hcom) (hmu : mu ≤ s.comToRear / hcom)
    (hfric : (s.weight / g) * a ≤ frictionLimit mu s.weight) :
    0 ≤ s.frontAxleLoadAccel g hcom a := by
  rw [s.front_wheels_grounded_iff hg hh]
  have h1 : a ≤ mu * g := s.accel_le_of_friction hg hfric
  have h2 : mu * g ≤ s.comToRear / hcom * g :=
    mul_le_mul_of_nonneg_right hmu hg.le
  have h3 : s.comToRear / hcom * g = g * s.comToRear / hcom := by ring
  linarith [h3 ▸ h2]

end SideView

/-! ### Braking -/

/-- Position of a machine braking at constant deceleration `a` from speed `v`
at time `t` (valid until it stops). -/
def brakingPos (v a t : ℝ) : ℝ := v * t - a * t ^ 2 / 2

/-- Speed while braking. -/
def brakingSpeed (v a t : ℝ) : ℝ := v - a * t

/-- The speed is the derivative of the position. -/
theorem hasDerivAt_brakingPos (v a t : ℝ) :
    HasDerivAt (fun s => brakingPos v a s) (brakingSpeed v a t) t := by
  have h : HasDerivAt (fun s : ℝ => v * s - a * s ^ 2 / 2)
      (v * 1 - a * (2 * t ^ 1) / 2) t :=
    ((hasDerivAt_id t).const_mul v).sub
      (((hasDerivAt_pow 2 t).const_mul a).div_const 2)
  simp only [brakingPos, brakingSpeed]
  convert h using 1
  ring

/-- The machine comes to rest after `v / a`. -/
theorem brakingSpeed_stop {v a : ℝ} (ha : a ≠ 0) : brakingSpeed v a (v / a) = 0 := by
  unfold brakingSpeed
  field_simp
  ring

/-- Stopping distance at deceleration `a` from speed `v`. -/
def stoppingDistance (v a : ℝ) : ℝ := v ^ 2 / (2 * a)

/-- **The stopping distance is `v²/(2a)`**: the distance covered by the braking
motion up to the instant the machine stops. -/
theorem brakingPos_stop {v a : ℝ} (ha : a ≠ 0) :
    brakingPos v a (v / a) = stoppingDistance v a := by
  unfold brakingPos stoppingDistance
  field_simp
  ring

/-- **Work–energy balance.**  The stopping distance is exactly the distance
over which the friction force does work equal to the kinetic energy: with
`a = mu * g` the machine stops in `v² / (2 μ g)`, independently of its mass. -/
theorem stoppingDistance_friction {m v g mu : ℝ} (hm : 0 < m) (hg : 0 < g)
    (hmu : 0 < mu) :
    m * v ^ 2 / 2 = frictionLimit mu (m * g) * stoppingDistance v (mu * g) := by
  have h1 : (2 : ℝ) * (mu * g) ≠ 0 := by positivity
  unfold frictionLimit stoppingDistance
  field_simp

/-- Braking harder shortens the stopping distance; going faster lengthens it
quadratically. -/
theorem stoppingDistance_antitone {v a₁ a₂ : ℝ} (h₁ : 0 < a₁) (h : a₁ ≤ a₂) :
    stoppingDistance v a₂ ≤ stoppingDistance v a₁ := by
  unfold stoppingDistance
  exact div_le_div_of_nonneg_left (by positivity) (by linarith) (by linarith)

end

end LifeTrac
