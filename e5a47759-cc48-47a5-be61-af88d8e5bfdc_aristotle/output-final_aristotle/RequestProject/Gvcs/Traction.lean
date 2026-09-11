import RequestProject.Gvcs.Hydraulics
import RequestProject.Gvcs.Stability

/-!
# Traction, gradeability and skid steering of the LifeTrac tractor

The hydraulics of the previous file bound the force the drive train can
*produce*; the ground bounds the force it can *transmit*.  With a Coulomb
friction model, a wheel carrying a normal load `N` on ground of friction
coefficient `mu` can transmit at most `mu * N`.

We prove here

* the traction-limited drawbar pull, `min` of what the hydraulics offer and
  what the ground can take;
* the no-slip gradeability criterion `tan θ ≤ mu`, with `arctan mu` the
  limiting grade, and its combination with the tipping criterion of
  `Stability.lean`: a slope is safe exactly when `tan θ ≤ min mu (d/h)`;
* the yaw moment that must be overcome to skid-steer a four-wheeled machine,
  and the resulting condition on the difference of the tractive forces of the
  two sides.
-/

namespace LifeTrac

open Real

noncomputable section

/-! ### Friction limit and drawbar pull -/

/-- Maximum force a contact of normal load `N` can transmit on ground of
friction coefficient `mu` (Coulomb's law). -/
def frictionLimit (mu N : ℝ) : ℝ := mu * N

/-- The force actually developed at the wheels: whatever the drive train
offers, capped by the friction limit. -/
def drawbarPull (mu N F : ℝ) : ℝ := min F (frictionLimit mu N)

theorem drawbarPull_le_drive (mu N F : ℝ) : drawbarPull mu N F ≤ F :=
  min_le_left _ _

theorem drawbarPull_le_friction (mu N F : ℝ) :
    drawbarPull mu N F ≤ frictionLimit mu N := min_le_right _ _

/-- If the ground is good enough, the machine is limited by its hydraulics and
delivers the full drive force. -/
theorem drawbarPull_eq_drive {mu N F : ℝ} (h : F ≤ frictionLimit mu N) :
    drawbarPull mu N F = F := min_eq_left h

/-- On slippery ground the machine is traction limited: it spins its wheels at
the friction limit and extra pump pressure buys nothing. -/
theorem drawbarPull_eq_friction {mu N F : ℝ} (h : frictionLimit mu N ≤ F) :
    drawbarPull mu N F = frictionLimit mu N := min_eq_right h

/-- More weight on the driven wheels means more pull (up to the hydraulic
limit): the reason tractors are ballasted. -/
theorem drawbarPull_mono_load {mu N₁ N₂ F : ℝ} (hmu : 0 ≤ mu) (h : N₁ ≤ N₂) :
    drawbarPull mu N₁ F ≤ drawbarPull mu N₂ F :=
  min_le_min_left F (mul_le_mul_of_nonneg_left h hmu)

/-- Better ground (a larger friction coefficient) means more pull, up to the
hydraulic limit. -/
theorem drawbarPull_mono_friction {mu₁ mu₂ N F : ℝ} (hN : 0 ≤ N)
    (h : mu₁ ≤ mu₂) : drawbarPull mu₁ N F ≤ drawbarPull mu₂ N F :=
  min_le_min_left F (mul_le_mul_of_nonneg_right h hN)

/-- **The pressure at which one side of the tractor starts to spin its
wheels.**  The hydraulics reach the friction limit of the load `N` carried by
that side exactly when the pressure difference across the motors reaches
`2π r μ N / (count · D · η)`. -/
theorem Drive.friction_limit_le_sideForce_iff (d : Drive) (mu N Δp : ℝ) :
    frictionLimit mu N ≤ d.sideForce Δp ↔
      2 * π * d.wheelRadius * (mu * N)
        / (d.count * d.motor.disp * d.motor.mechEff) ≤ Δp := by
  have hr := d.wheelRadius_pos
  have hpi := pi_pos
  have hd := d.motor.disp_pos
  have he := d.motor.mechEff_pos
  have hc : (0:ℝ) < d.count := by exact_mod_cast d.count_pos
  have hden : 0 < (d.count : ℝ) * d.motor.disp * d.motor.mechEff := by positivity
  rw [Drive.sideForce_eq, frictionLimit, le_div_iff₀ (by positivity),
    div_le_iff₀ hden]
  constructor
  · intro h; nlinarith
  · intro h; nlinarith

/-- Once that pressure is reached, extra pressure produces no extra pull: the
machine is traction limited. -/
theorem Drive.drawbarPull_of_pressure_ge (d : Drive) {mu N Δp : ℝ}
    (h : 2 * π * d.wheelRadius * (mu * N)
        / (d.count * d.motor.disp * d.motor.mechEff) ≤ Δp) :
    drawbarPull mu N (d.sideForce Δp) = frictionLimit mu N :=
  drawbarPull_eq_friction ((d.friction_limit_le_sideForce_iff mu N Δp).2 h)

/-! ### Climbing a slope -/

/-- Component of the weight `W` along a slope of inclination `theta`: the force
the drive train must produce to hold the machine on the grade. -/
def gradeResistance (W theta : ℝ) : ℝ := W * sin theta

/-- Normal load on the slope. -/
def slopeNormalLoad (W theta : ℝ) : ℝ := W * cos theta

/-- **No-slip gradeability.**  A machine of weight `W` can hold or climb a
slope of inclination `theta ∈ [0, π/2)` without slipping exactly when
`tan theta ≤ mu`.  Remarkably the criterion does not involve the weight. -/
theorem climb_no_slip_iff {W mu theta : ℝ} (hW : 0 < W) (hθ₀ : 0 ≤ theta)
    (hθ₁ : theta < π / 2) :
    gradeResistance W theta ≤ frictionLimit mu (slopeNormalLoad W theta) ↔
      tan theta ≤ mu := by
  have hc : 0 < cos theta := cos_pos_of_mem_Ioo ⟨by linarith [pi_pos], hθ₁⟩
  rw [gradeResistance, frictionLimit, slopeNormalLoad, tan_eq_sin_div_cos,
    div_le_iff₀ hc]
  constructor
  · intro h; nlinarith
  · intro h; nlinarith

/-- The steepest grade the machine can hold is `arctan mu`, where the available
friction is exactly used up. -/
theorem critical_grade_angle (W mu : ℝ) :
    gradeResistance W (arctan mu)
      = frictionLimit mu (slopeNormalLoad W (arctan mu)) := by
  have hc : 0 < cos (arctan mu) := cos_arctan_pos _
  have ht : tan (arctan mu) = mu := tan_arctan _
  rw [tan_eq_sin_div_cos, div_eq_iff hc.ne'] at ht
  rw [gradeResistance, frictionLimit, slopeNormalLoad, ht]
  ring

/-- **The safe operating envelope on a side slope.**  Taking both failure modes
into account — sliding (needs `tan θ ≤ mu`) and tipping about the downhill
wheels (needs `tan θ ≤ d / h`) — a slope of inclination `theta ∈ [0, π/2)` is
safe exactly when `tan theta ≤ min mu (d / h)`. -/
theorem safe_slope_iff {m g d h mu theta : ℝ} (hm : 0 < m) (hg : 0 < g)
    (hh : 0 < h) (hθ₀ : 0 ≤ theta) (hθ₁ : theta < π / 2) :
    (gradeResistance (m * g) theta
        ≤ frictionLimit mu (slopeNormalLoad (m * g) theta) ∧
      overturningMoment m g h theta ≤ restoringMoment m g d theta) ↔
      tan theta ≤ min mu (d / h) := by
  rw [climb_no_slip_iff (mul_pos hm hg) hθ₀ hθ₁,
    stable_on_slope_iff hm hg hh hθ₀ hθ₁, le_min_iff]

/-! ### Skid steering

A four-wheeled skid-steer machine turns by driving the two sides at different
speeds; the wheels must scrub sideways, and the friction resisting that scrub
produces a yaw moment that the difference of the tractive forces has to
overcome. -/

/-- Yaw moment resisting a skid turn of a four-wheeled machine of weight `W`
and wheelbase `L`, each wheel carrying a quarter of the weight and scrubbing at
longitudinal distance `L / 2` from the centre. -/
def skidResistingMoment (mu W L : ℝ) : ℝ := 4 * (mu * (W / 4) * (L / 2))

theorem skidResistingMoment_eq (mu W L : ℝ) :
    skidResistingMoment mu W L = mu * W * L / 2 := by
  unfold skidResistingMoment; ring

/-- Yaw moment produced by a difference `FR - FL` between the tractive forces
of the right and the left side of a machine of track width `track`. -/
def steerMoment (FL FR track : ℝ) : ℝ := (FR - FL) * (track / 2)

/-- **Skid-steer criterion.**  The machine turns (to the left, say) exactly
when the difference of the tractive forces of the two sides is at least
`mu * W * L / track`. -/
theorem can_skid_steer_iff {mu W L FL FR track : ℝ} (htrack : 0 < track) :
    skidResistingMoment mu W L ≤ steerMoment FL FR track ↔
      mu * W * L / track ≤ FR - FL := by
  rw [skidResistingMoment_eq, steerMoment, div_le_iff₀ htrack]
  constructor
  · intro h; nlinarith
  · intro h; nlinarith

/-- A wider track makes skid steering easier: the force difference needed to
turn falls off inversely with the track width. -/
theorem skid_force_needed_antitone {mu W L : ℝ} (hmu : 0 ≤ mu) (hW : 0 ≤ W)
    (hL : 0 ≤ L) {t₁ t₂ : ℝ} (h₁ : 0 < t₁) (h : t₁ ≤ t₂) :
    mu * W * L / t₂ ≤ mu * W * L / t₁ :=
  div_le_div_of_nonneg_left (by positivity) h₁ h

/-- A long machine (large wheelbase relative to track) is hard to skid-steer:
the required force difference grows linearly with the wheelbase. -/
theorem skid_force_needed_mono_wheelbase {mu W track : ℝ} (hmu : 0 ≤ mu)
    (hW : 0 ≤ W) (htrack : 0 < track) {L₁ L₂ : ℝ} (h : L₁ ≤ L₂) :
    mu * W * L₁ / track ≤ mu * W * L₂ / track := by
  gcongr

/-- **The skid-steer force difference is itself traction limited.**  Since each
side can transmit at most `mu * W / 2`, the largest available force difference
is `mu * W`, so a four-wheeled skid-steer machine can turn on the spot only if
its wheelbase does not exceed its track width. -/
theorem skid_steer_needs_wheelbase_le_track {mu W L FL FR track : ℝ}
    (hmu : 0 < mu) (hW : 0 < W) (htrack : 0 < track)
    (hFL : -(mu * W / 2) ≤ FL) (hFR : FR ≤ mu * W / 2)
    (hturn : skidResistingMoment mu W L ≤ steerMoment FL FR track) :
    L ≤ track := by
  rw [can_skid_steer_iff htrack, div_le_iff₀ htrack] at hturn
  have h : mu * W * L ≤ mu * W * track := by nlinarith
  have hmw : 0 < mu * W := mul_pos hmu hW
  exact le_of_mul_le_mul_left h hmw

end

end LifeTrac
