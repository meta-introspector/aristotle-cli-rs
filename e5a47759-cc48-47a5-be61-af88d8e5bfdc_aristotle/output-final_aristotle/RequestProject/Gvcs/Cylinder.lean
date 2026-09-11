import RequestProject.Gvcs.Hydraulics

/-!
# Hydraulic cylinders and the loader linkage of the LifeTrac tractor

Besides the wheel motors, a LifeTrac carries double-acting hydraulic cylinders:
they raise the loader arms, dump the bucket and operate the quick attach.  A
double-acting cylinder is an asymmetric device: on the cap side the pressure
acts on the full bore area, on the rod side only on the annulus left free by
the piston rod.  This asymmetry is the origin of the two standard facts about
loader cylinders,

* the machine pushes harder than it pulls, and
* it retracts faster than it extends,

both at the same supply pressure and the same flow.  We prove them here,
together with the exact energy balance `F · v = Δp · Q` of an ideal cylinder,
the stroke timing, and the moment balance of the loader linkage that converts
cylinder force into lifting force at the bucket.
-/

namespace LifeTrac

open Real

noncomputable section

/-- A double-acting hydraulic cylinder, described by the radius of its bore and
the radius of its piston rod. -/
structure Cylinder where
  /-- Radius of the bore (of the piston). -/
  bore : ℝ
  /-- Radius of the piston rod. -/
  rod : ℝ
  /-- Stroke: the travel of the piston from end to end. -/
  stroke : ℝ
  rod_pos : 0 < rod
  rod_lt_bore : rod < bore
  stroke_pos : 0 < stroke

namespace Cylinder

variable (c : Cylinder)

theorem bore_pos : 0 < c.bore := lt_trans c.rod_pos c.rod_lt_bore

/-- Effective piston area on the cap (full bore) side. -/
def capArea : ℝ := π * c.bore ^ 2

/-- Effective piston area on the rod side: the bore area less the cross section
of the rod. -/
def rodArea : ℝ := π * (c.bore ^ 2 - c.rod ^ 2)

theorem capArea_pos : 0 < c.capArea := by
  have := c.bore_pos
  have := pi_pos
  unfold capArea; positivity

theorem rodArea_pos : 0 < c.rodArea := by
  have h1 := c.rod_pos
  have h2 := c.rod_lt_bore
  have h3 := pi_pos
  have : c.rod ^ 2 < c.bore ^ 2 := by nlinarith
  unfold rodArea
  nlinarith

/-- The rod-side area is strictly smaller than the cap-side area. -/
theorem rodArea_lt_capArea : c.rodArea < c.capArea := by
  have h1 := c.rod_pos
  have h3 := pi_pos
  have h4 : 0 < π * c.rod ^ 2 := by positivity
  unfold rodArea capArea
  nlinarith [h4]

/-! ### Forces -/

/-- Force developed while extending (pressure on the cap side). -/
def extendForce (Δp : ℝ) : ℝ := Δp * c.capArea

/-- Force developed while retracting (pressure on the rod side). -/
def retractForce (Δp : ℝ) : ℝ := Δp * c.rodArea

/-- **A cylinder pushes harder than it pulls.**  At the same supply pressure
the extending force strictly exceeds the retracting force. -/
theorem retractForce_lt_extendForce {Δp : ℝ} (hp : 0 < Δp) :
    c.retractForce Δp < c.extendForce Δp := by
  unfold retractForce extendForce
  exact mul_lt_mul_of_pos_left c.rodArea_lt_capArea hp

theorem extendForce_mono {p₁ p₂ : ℝ} (h : p₁ ≤ p₂) :
    c.extendForce p₁ ≤ c.extendForce p₂ :=
  mul_le_mul_of_nonneg_right h c.capArea_pos.le

/-! ### Speeds -/

/-- Extension speed of the rod under a supply flow `Q`. -/
def extendSpeed (Q : ℝ) : ℝ := Q / c.capArea

/-- Retraction speed of the rod under a supply flow `Q`. -/
def retractSpeed (Q : ℝ) : ℝ := Q / c.rodArea

/-- **A cylinder retracts faster than it extends** at the same supply flow. -/
theorem extendSpeed_lt_retractSpeed {Q : ℝ} (hQ : 0 < Q) :
    c.extendSpeed Q < c.retractSpeed Q :=
  div_lt_div_of_pos_left hQ c.rodArea_pos c.rodArea_lt_capArea

/-- The ratio of extension force to retraction force equals the ratio of
retraction speed to extension speed: the cylinder is a lossless transformer. -/
theorem force_speed_ratio {Δp Q : ℝ} (hp : Δp ≠ 0) (hQ : Q ≠ 0) :
    c.extendForce Δp / c.retractForce Δp
      = c.retractSpeed Q / c.extendSpeed Q := by
  have h1 := c.capArea_pos.ne'
  have h2 := c.rodArea_pos.ne'
  unfold extendForce retractForce extendSpeed retractSpeed
  field_simp

/-! ### Energy balance -/

/-- **Energy balance of an ideal cylinder, extending.**  The mechanical power
delivered by the rod equals the hydraulic power supplied. -/
theorem extend_power (Δp Q : ℝ) :
    c.extendForce Δp * c.extendSpeed Q = hydPower Δp Q := by
  have h1 := c.capArea_pos.ne'
  unfold extendForce extendSpeed hydPower
  field_simp

/-- **Energy balance of an ideal cylinder, retracting.** -/
theorem retract_power (Δp Q : ℝ) :
    c.retractForce Δp * c.retractSpeed Q = hydPower Δp Q := by
  have h1 := c.rodArea_pos.ne'
  unfold retractForce retractSpeed hydPower
  field_simp

/-! ### Stroke volumes and timing -/

/-- Oil volume needed for a full extension stroke. -/
def extendVolume : ℝ := c.capArea * c.stroke

/-- Oil volume expelled during a full extension stroke (returned from the rod
side); equivalently the volume needed to retract. -/
def retractVolume : ℝ := c.rodArea * c.stroke

theorem retractVolume_lt_extendVolume : c.retractVolume < c.extendVolume := by
  have := c.stroke_pos
  unfold retractVolume extendVolume
  exact mul_lt_mul_of_pos_right c.rodArea_lt_capArea c.stroke_pos

/-- Time for a full extension stroke at supply flow `Q`. -/
def extendTime (Q : ℝ) : ℝ := c.extendVolume / Q

/-- Time for a full retraction stroke at supply flow `Q`. -/
def retractTime (Q : ℝ) : ℝ := c.retractVolume / Q

/-- The stroke time is the stroke length divided by the rod speed. -/
theorem extendTime_eq {Q : ℝ} (hQ : 0 < Q) :
    c.extendTime Q = c.stroke / c.extendSpeed Q := by
  have h1 := c.capArea_pos.ne'
  unfold extendTime extendVolume extendSpeed
  field_simp

/-- Retracting the cylinder is quicker than extending it. -/
theorem retractTime_lt_extendTime {Q : ℝ} (hQ : 0 < Q) :
    c.retractTime Q < c.extendTime Q := by
  unfold retractTime extendTime
  exact div_lt_div_of_pos_right c.retractVolume_lt_extendVolume hQ

/-! ### Feeding a cylinder from the tractor's pump -/

/-- Extension speed of the cylinder when it is fed by the pump `p` running at
`n` revolutions per unit time. -/
theorem extendSpeed_pump (p : Pump) (n : ℝ) :
    c.extendSpeed (p.flow n) = p.disp * n * p.volEff / c.capArea := by
  rw [extendSpeed, Pump.flow]

end Cylinder

/-! ### The loader linkage

The lift cylinders do not act directly on the load: they act on the loader
arms, which pivot about the frame.  Writing `cylArm` for the perpendicular
distance from the pivot to the line of action of the cylinder and `loadArm` for
the horizontal distance from the pivot to the load, the moment balance about
the pivot fixes the force available at the bucket. -/

/-- A loader arm pivoting about a frame pin, actuated by a cylinder. -/
structure LoaderArm where
  /-- Perpendicular distance from the pivot to the cylinder's line of action. -/
  cylArm : ℝ
  /-- Distance from the pivot to the point where the load is carried. -/
  loadArm : ℝ
  cylArm_pos : 0 < cylArm
  loadArm_pos : 0 < loadArm

namespace LoaderArm

variable (a : LoaderArm)

/-- Force available at the load point when the cylinder pushes with force
`F`. -/
def liftForce (F : ℝ) : ℝ := F * a.cylArm / a.loadArm

/-- **Moment balance about the pivot.** -/
theorem moment_balance (F : ℝ) : a.liftForce F * a.loadArm = F * a.cylArm := by
  have h := a.loadArm_pos.ne'
  unfold liftForce
  field_simp

/-- Mechanical advantage of the linkage. -/
def advantage : ℝ := a.cylArm / a.loadArm

theorem liftForce_eq_advantage_mul (F : ℝ) : a.liftForce F = a.advantage * F := by
  unfold liftForce advantage
  ring

/-- A linkage whose cylinder arm is shorter than the load arm — the usual case
for a loader, which trades force for reach and travel — reduces the force. -/
theorem liftForce_lt_of_cylArm_lt_loadArm {F : ℝ} (hF : 0 < F)
    (h : a.cylArm < a.loadArm) : a.liftForce F < F := by
  have h1 := a.loadArm_pos
  unfold liftForce
  rw [div_lt_iff₀ h1]
  nlinarith

/-- The load point moves faster than the cylinder rod by exactly the reciprocal
of the mechanical advantage: work is conserved. -/
theorem liftForce_mul_loadSpeed (F v : ℝ) :
    a.liftForce F * (v / a.advantage) = F * v := by
  have h1 := a.loadArm_pos.ne'
  have h2 := a.cylArm_pos.ne'
  unfold liftForce advantage
  field_simp

/-- Lifting capacity of the loader at the bucket, expressed directly in terms
of the supply pressure and the geometry of the extending cylinder. -/
theorem liftForce_extendForce (c : Cylinder) (Δp : ℝ) :
    a.liftForce (c.extendForce Δp) = Δp * π * c.bore ^ 2 * a.cylArm / a.loadArm := by
  unfold liftForce Cylinder.extendForce Cylinder.capArea
  ring

end LoaderArm

end

end LifeTrac
