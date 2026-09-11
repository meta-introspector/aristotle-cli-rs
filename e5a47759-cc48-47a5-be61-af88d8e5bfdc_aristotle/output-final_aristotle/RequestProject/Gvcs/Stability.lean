import RequestProject.Gvcs.Kinematics

/-!
# Static stability of the LifeTrac tractor

LifeTrac carries a front loader, so two classical static questions matter:

* on a slope, when does the machine tip over about its downhill wheels?
* how much can the loader lift before the rear wheels come off the ground?

Both are rigid-body statics: a body of weight `W` tips about a contact edge
as soon as the overturning moment of gravity exceeds the restoring moment.
-/

namespace LifeTrac

open Real

noncomputable section

/-! ### Tipping on a slope -/

/-- Restoring moment about the downhill contact line for a machine of mass `m`
standing on a slope of inclination `theta`, whose centre of mass is at
horizontal distance `d` from that contact line. -/
def restoringMoment (m g d theta : ℝ) : ℝ := m * g * cos theta * d

/-- Overturning moment of gravity about the downhill contact line, for a centre
of mass at height `h` above the ground. -/
def overturningMoment (m g h theta : ℝ) : ℝ := m * g * sin theta * h

/-- **Slope stability criterion.**  A machine standing on a slope of
inclination `theta ∈ [0, π/2)` does not tip over its downhill contact line
exactly when `tan theta ≤ d / h`, where `d` is the horizontal distance from the
centre of mass to that contact line and `h` the height of the centre of mass. -/
theorem stable_on_slope_iff {m g d h theta : ℝ} (hm : 0 < m) (hg : 0 < g)
    (hh : 0 < h) (hθ₀ : 0 ≤ theta) (hθ₁ : theta < π / 2) :
    overturningMoment m g h theta ≤ restoringMoment m g d theta ↔
      tan theta ≤ d / h := by
  have hc : 0 < cos theta := cos_pos_of_mem_Ioo ⟨by linarith [pi_pos], hθ₁⟩
  have hmg : 0 < m * g := mul_pos hm hg
  rw [overturningMoment, restoringMoment, tan_eq_sin_div_cos,
    div_le_div_iff₀ hc hh]
  constructor
  · intro hle; nlinarith
  · intro hle; nlinarith

/-- The critical slope angle is `arctan (d / h)`: at that inclination the
restoring and overturning moments are exactly in balance. -/
theorem critical_slope_angle {m g d h : ℝ} (hh : 0 < h) :
    overturningMoment m g h (arctan (d / h))
      = restoringMoment m g d (arctan (d / h)) := by
  have hc : 0 < cos (arctan (d / h)) := cos_arctan_pos _
  have ht : tan (arctan (d / h)) = d / h := tan_arctan _
  rw [tan_eq_sin_div_cos] at ht
  have hs : sin (arctan (d / h)) = (d / h) * cos (arctan (d / h)) := by
    field_simp at ht ⊢
    linarith [ht]
  rw [overturningMoment, restoringMoment, hs]
  field_simp

/-- A machine on level ground never tips: the overturning moment vanishes,
provided the centre of mass lies inside the support polygon (`0 ≤ d`). -/
theorem stable_on_level {m g d h : ℝ} (hm : 0 ≤ m) (hg : 0 ≤ g) (hd : 0 ≤ d) :
    overturningMoment m g h 0 ≤ restoringMoment m g d 0 := by
  simp only [overturningMoment, restoringMoment, sin_zero, cos_zero, mul_one,
    mul_zero, zero_mul]
  positivity

/-! ### Loader capacity and axle loads -/

/-- A wheeled machine seen from the side: total weight `weight`, centre of mass
at horizontal distance `comToFront` behind the front axle and `comToRear` ahead
of the rear axle. -/
structure SideView where
  /-- Total weight of the machine (mass times gravity). -/
  weight : ℝ
  /-- Horizontal distance from the centre of mass to the front axle. -/
  comToFront : ℝ
  /-- Horizontal distance from the centre of mass to the rear axle. -/
  comToRear : ℝ
  weight_pos : 0 < weight
  comToFront_pos : 0 < comToFront
  comToRear_pos : 0 < comToRear

namespace SideView

variable (s : SideView)

/-- Wheelbase: distance between the front and the rear axle. -/
def wheelbase : ℝ := s.comToFront + s.comToRear

theorem wheelbase_pos : 0 < s.wheelbase :=
  add_pos s.comToFront_pos s.comToRear_pos

/-- Static load carried by the front axle of the unloaded machine. -/
def frontAxleLoad : ℝ := s.weight * s.comToRear / s.wheelbase

/-- Static load carried by the rear axle of the unloaded machine. -/
def rearAxleLoad : ℝ := s.weight * s.comToFront / s.wheelbase

/-- The two axle loads carry the whole weight of the machine. -/
theorem axleLoad_add : s.frontAxleLoad + s.rearAxleLoad = s.weight := by
  have h := s.wheelbase_pos.ne'
  simp only [frontAxleLoad, rearAxleLoad, wheelbase] at *
  field_simp
  ring

theorem frontAxleLoad_pos : 0 < s.frontAxleLoad := by
  have h1 := s.wheelbase_pos
  have h2 := s.weight_pos
  have h3 := s.comToRear_pos
  simp only [frontAxleLoad]
  positivity

theorem rearAxleLoad_pos : 0 < s.rearAxleLoad := by
  have h1 := s.wheelbase_pos
  have h2 := s.weight_pos
  have h3 := s.comToFront_pos
  simp only [rearAxleLoad]
  positivity

/-- Load remaining on the rear axle when the loader carries a payload of weight
`p` whose centre of gravity is a distance `l` ahead of the front axle. -/
def rearAxleLoadWithPayload (p l : ℝ) : ℝ :=
  (s.weight * s.comToFront - p * l) / s.wheelbase

theorem rearAxleLoadWithPayload_zero (l : ℝ) :
    s.rearAxleLoadWithPayload 0 l = s.rearAxleLoad := by
  simp [rearAxleLoadWithPayload, rearAxleLoad]

/-- **Loader capacity.**  The rear wheels stay on the ground exactly as long as
the payload does not exceed `weight * comToFront / l`. -/
theorem rear_wheels_grounded_iff {p l : ℝ} (hl : 0 < l) :
    0 ≤ s.rearAxleLoadWithPayload p l ↔ p ≤ s.weight * s.comToFront / l := by
  have hw := s.wheelbase_pos
  rw [rearAxleLoadWithPayload, le_div_iff₀ hw, le_div_iff₀ hl]
  constructor <;> intro h <;> linarith

/-- The maximal payload the loader can lift at a given reach `l`. -/
def maxPayload (l : ℝ) : ℝ := s.weight * s.comToFront / l

/-- At maximal payload the machine is exactly on the point of tipping forward:
the rear axle load is zero. -/
theorem rearAxleLoadWithPayload_maxPayload {l : ℝ} (hl : 0 < l) :
    s.rearAxleLoadWithPayload (s.maxPayload l) l = 0 := by
  have hw := s.wheelbase_pos.ne'
  simp only [rearAxleLoadWithPayload, maxPayload]
  field_simp
  ring

/-- Reaching further out reduces the load the loader can lift. -/
theorem maxPayload_antitone {l₁ l₂ : ℝ} (h₁ : 0 < l₁) (h : l₁ ≤ l₂) :
    s.maxPayload l₂ ≤ s.maxPayload l₁ := by
  have hnum : 0 < s.weight * s.comToFront := mul_pos s.weight_pos s.comToFront_pos
  simp only [maxPayload]
  exact div_le_div_of_nonneg_left hnum.le h₁ h

/-- Adding rear ballast (which moves the centre of mass backwards, increasing
`comToFront`) increases the loader capacity. -/
theorem maxPayload_mono_comToFront {s₁ s₂ : SideView} {l : ℝ} (hl : 0 < l)
    (hw : s₁.weight ≤ s₂.weight) (hc : s₁.comToFront ≤ s₂.comToFront) :
    s₁.maxPayload l ≤ s₂.maxPayload l := by
  have h1 := s₁.weight_pos
  have h2 := s₁.comToFront_pos
  have h3 := s₂.weight_pos
  have h4 := s₂.comToFront_pos
  simp only [maxPayload]
  gcongr

end SideView

end

end LifeTrac
