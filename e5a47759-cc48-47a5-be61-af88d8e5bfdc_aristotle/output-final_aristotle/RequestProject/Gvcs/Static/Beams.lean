import RequestProject.Gvcs.Structure

/-!
# Load-bearing spans: the frame rails between the axles

`RequestProject.Structure` treats the loader arm as a cantilever — held at one
end and loaded at the other.  The frame rails of the tractor are the other
standard case: a beam *supported at both ends*, carrying the weight of the
machine and its payload between the wheels.  This file adds that case:

* the two reactions of a simply supported beam under a central load, and the
  fact that they add up to the load;
* the maximum bending moment `F L / 4` under a central point load, and
  `w L² / 8` under a load spread evenly along the span;
* the mid-span deflection `F L³ / (48 E I)`;
* the two comparisons a builder cares about: supporting a member at both ends
  rather than cantilevering it cuts the moment by four and the deflection by
  sixteen, and spreading a given weight along the span instead of hanging it
  all at the middle halves the moment.
-/

namespace LifeTrac

open Real

noncomputable section

/-- Reaction at each support of a simply supported beam under a load `F` at
mid-span. -/
def centralReaction (F : ℝ) : ℝ := F / 2

/-- **Statics of the span**: the two reactions carry the load between them. -/
theorem centralReaction_add (F : ℝ) : centralReaction F + centralReaction F = F := by
  unfold centralReaction; ring

/-- Maximum bending moment (at mid-span) of a simply supported beam of span
`L` under a central point load `F`. -/
def simplySupportedMoment (F L : ℝ) : ℝ := F * L / 4

/-- Maximum bending moment of a simply supported beam of span `L` under a load
of `w` newtons per metre spread evenly along it. -/
def uniformLoadMoment (w L : ℝ) : ℝ := w * L ^ 2 / 8

/-- **Spreading the weight out halves the moment.** A total weight `W`
distributed evenly along the span produces exactly half the bending moment it
would produce hung at mid-span. -/
theorem uniformLoadMoment_eq_half {W L : ℝ} (hL : L ≠ 0) :
    uniformLoadMoment (W / L) L = simplySupportedMoment W L / 2 := by
  unfold uniformLoadMoment simplySupportedMoment
  field_simp
  ring

/-- **Support both ends and the moment falls by four.**  The same member with
the same load, cantilevered over the same length, sees four times the bending
moment. -/
theorem simplySupportedMoment_eq_quarter (F L : ℝ) :
    simplySupportedMoment F L = SquareTube.cantileverMoment F L / 4 := by
  unfold simplySupportedMoment SquareTube.cantileverMoment; ring

/-- Deflection at mid-span of a simply supported beam. -/
def centralDeflection (E I F L : ℝ) : ℝ := F * L ^ 3 / (48 * E * I)

/-- **… and the deflection by sixteen.** -/
theorem centralDeflection_eq {E I F L : ℝ} (hE : E ≠ 0) (hI : I ≠ 0) :
    centralDeflection E I F L = F * L ^ 3 / (3 * E * I) / 16 := by
  unfold centralDeflection
  field_simp
  ring

theorem simplySupportedMoment_nonneg {F L : ℝ} (hF : 0 ≤ F) (hL : 0 ≤ L) :
    0 ≤ simplySupportedMoment F L := by
  unfold simplySupportedMoment; positivity

/-- A longer span is a bigger moment: the reason a frame is cross-braced. -/
theorem simplySupportedMoment_mono {F L₁ L₂ : ℝ} (hF : 0 ≤ F) (h : L₁ ≤ L₂) :
    simplySupportedMoment F L₁ ≤ simplySupportedMoment F L₂ := by
  unfold simplySupportedMoment
  apply div_le_div_of_nonneg_right _ (by norm_num : (0:ℝ) ≤ 4)
  exact mul_le_mul_of_nonneg_left h hF

namespace SquareTube

variable (u : SquareTube)

/-- Bending stress in a frame rail of span `L` carrying `F` at mid-span. -/
def spanStress (F L : ℝ) : ℝ := u.bendingStress (simplySupportedMoment F L)

/-- Greatest central load a rail of span `L` may carry at a yield strength
`sy`. -/
def spanCapacity (sy L : ℝ) : ℝ := 4 * sy * u.sectionModulus / L

/-- **The design check for a loaded span.** -/
theorem spanStress_le_iff {sy F L : ℝ} (hL : 0 < L) :
    u.spanStress F L ≤ sy ↔ F ≤ u.spanCapacity sy L := by
  have hS := u.sectionModulus_pos
  unfold spanStress SquareTube.bendingStress simplySupportedMoment spanCapacity
  rw [div_le_iff₀ hS, le_div_iff₀ hL]
  constructor <;> intro h <;> nlinarith [h]

/-- **A supported member carries four times what a cantilever does.** -/
theorem spanCapacity_eq_four_mul_maxTipLoad (sy L : ℝ) :
    u.spanCapacity sy L = 4 * u.maxTipLoad sy L := by
  unfold spanCapacity SquareTube.maxTipLoad; ring

end SquareTube

end

end LifeTrac
