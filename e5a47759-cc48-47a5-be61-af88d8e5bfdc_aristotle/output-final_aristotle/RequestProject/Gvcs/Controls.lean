import RequestProject.Gvcs.Kinematics

/-!
# The driver's controls

A LifeTrac is driven with two levers, but it is convenient to describe the
driver's intention by a pair of normalised commands: `u` for "go forward" and
`r` for "turn right", each between `-1` and `1`.  The control mixer turns that
pair into a speed demand for each side of the machine,

```
left  = vmax (u - r) / s,    right = vmax (u + r) / s,   s = max 1 (|u| + |r|)
```

the divisor `s` being the saturation: when the driver asks for more than the
wheels can deliver, both sides are scaled back by the same factor.

We prove that the mixer never asks a wheel for more than `vmax`, that below
saturation it passes the commands through untouched, that the resulting body
velocity is `vmax u / s` forward and `2 vmax r / (s · track)` in yaw — so a pure
forward command drives straight and a pure turn command spins the machine on
the spot — that the velocity envelope of `Kinematics.lean` is always respected,
and, the point of scaling both sides equally, that **saturation slows the
machine down without changing the path it drives**.
-/

namespace LifeTrac

open Real

noncomputable section

namespace Chassis

variable (c : Chassis)

/-- The saturation divisor of the mixer. -/
def mixScale (u r : ℝ) : ℝ := max 1 (|u| + |r|)

theorem one_le_mixScale (u r : ℝ) : 1 ≤ mixScale u r := le_max_left _ _

theorem mixScale_pos (u r : ℝ) : 0 < mixScale u r :=
  lt_of_lt_of_le one_pos (one_le_mixScale u r)

theorem abs_add_le_mixScale (u r : ℝ) : |u| + |r| ≤ mixScale u r :=
  le_max_right _ _

/-- Speed demanded of the left side. -/
def mixL (vmax u r : ℝ) : ℝ := vmax * (u - r) / mixScale u r

/-- Speed demanded of the right side. -/
def mixR (vmax u r : ℝ) : ℝ := vmax * (u + r) / mixScale u r

/-- **The mixer never over-drives a wheel.** -/
theorem abs_mixL_le {vmax : ℝ} (hv : 0 ≤ vmax) (u r : ℝ) :
    |mixL vmax u r| ≤ vmax := by
  have hs := mixScale_pos u r
  have h1 : |u - r| ≤ |u| + |r| := abs_sub _ _
  have h2 : |u| + |r| ≤ mixScale u r := abs_add_le_mixScale u r
  rw [mixL, abs_div, abs_of_pos hs, div_le_iff₀ hs, abs_mul, abs_of_nonneg hv]
  nlinarith [abs_nonneg (u - r)]

theorem abs_mixR_le {vmax : ℝ} (hv : 0 ≤ vmax) (u r : ℝ) :
    |mixR vmax u r| ≤ vmax := by
  have hs := mixScale_pos u r
  have h1 : |u + r| ≤ |u| + |r| := abs_add_le _ _
  have h2 : |u| + |r| ≤ mixScale u r := abs_add_le_mixScale u r
  rw [mixR, abs_div, abs_of_pos hs, div_le_iff₀ hs, abs_mul, abs_of_nonneg hv]
  nlinarith [abs_nonneg (u + r)]

/-- **Below saturation the commands pass through untouched.** -/
theorem mixScale_eq_one {u r : ℝ} (h : |u| + |r| ≤ 1) : mixScale u r = 1 :=
  max_eq_left h

theorem mixL_of_unsaturated {vmax u r : ℝ} (h : |u| + |r| ≤ 1) :
    mixL vmax u r = vmax * (u - r) := by
  rw [mixL, mixScale_eq_one h, div_one]

theorem mixR_of_unsaturated {vmax u r : ℝ} (h : |u| + |r| ≤ 1) :
    mixR vmax u r = vmax * (u + r) := by
  rw [mixR, mixScale_eq_one h, div_one]

/-- Forward speed produced by the mixer. -/
theorem linVel_mix (vmax u r : ℝ) :
    c.linVel (mixL vmax u r) (mixR vmax u r) = vmax * u / mixScale u r := by
  have hs := (mixScale_pos u r).ne'
  unfold linVel mixL mixR
  field_simp
  ring

/-- Yaw rate produced by the mixer. -/
theorem angVel_mix (vmax u r : ℝ) :
    c.angVel (mixL vmax u r) (mixR vmax u r)
      = 2 * vmax * r / (mixScale u r * c.track) := by
  have hs := (mixScale_pos u r).ne'
  have ht := c.track_pos.ne'
  unfold angVel mixL mixR
  field_simp
  ring

/-- A pure forward command drives the machine straight. -/
theorem angVel_mix_eq_zero (vmax u : ℝ) :
    c.angVel (mixL vmax u 0) (mixR vmax u 0) = 0 := by
  rw [angVel_mix]
  simp

/-- A pure turn command spins the machine on the spot. -/
theorem linVel_mix_eq_zero (vmax r : ℝ) :
    c.linVel (mixL vmax 0 r) (mixR vmax 0 r) = 0 := by
  rw [linVel_mix]
  simp

/-- **The commanded motion always lies inside the velocity envelope** of the
chassis: whatever the driver asks for, the wheels are never asked for more than
`vmax`. -/
theorem mix_velocity_envelope {vmax : ℝ} (hv : 0 ≤ vmax) (u r : ℝ) :
    |c.linVel (mixL vmax u r) (mixR vmax u r)|
        + |c.angVel (mixL vmax u r) (mixR vmax u r)| * (c.track / 2) ≤ vmax := by
  have hs := mixScale_pos u r
  have ht := c.track_pos
  have h2 : |u| + |r| ≤ mixScale u r := abs_add_le_mixScale u r
  have h1 : 1 ≤ mixScale u r := one_le_mixScale u r
  rw [linVel_mix, angVel_mix]
  have e1 : |vmax * u / mixScale u r| = vmax * |u| / mixScale u r := by
    rw [abs_div, abs_of_pos hs, abs_mul, abs_of_nonneg hv]
  have e2 : |2 * vmax * r / (mixScale u r * c.track)| * (c.track / 2)
      = vmax * |r| / mixScale u r := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < mixScale u r * c.track)]
    rw [abs_mul, abs_mul, abs_of_nonneg hv, abs_of_nonneg (by norm_num : (0:ℝ) ≤ 2)]
    field_simp
  rw [e1, e2, ← add_div, div_le_iff₀ hs]
  nlinarith [abs_nonneg u, abs_nonneg r]

/-- **Saturation does not steer the machine.**  Scaling both sides back by the
same factor changes the speed but not the curvature of the path: the yaw rate
and the forward speed stay in the ratio fixed by the driver's two commands. -/
theorem mix_curvature (vmax u r : ℝ) :
    c.linVel (mixL vmax u r) (mixR vmax u r) * (2 * r)
      = c.angVel (mixL vmax u r) (mixR vmax u r) * (u * c.track) := by
  have hs := (mixScale_pos u r).ne'
  have ht := c.track_pos.ne'
  rw [linVel_mix, angVel_mix]
  field_simp

/-- **The controls reach everything the machine can do.**  Every body velocity
inside the envelope of the chassis — every pair of a forward speed and a yaw
rate that wheel speeds bounded by `vmax` allow — is produced by an unsaturated
command `(u, r)`. -/
theorem mix_surjective {vmax : ℝ} (hv : 0 < vmax) (v w : ℝ)
    (h : |v| + |w| * (c.track / 2) ≤ vmax) :
    ∃ u r : ℝ, |u| + |r| ≤ 1 ∧
      c.linVel (mixL vmax u r) (mixR vmax u r) = v ∧
      c.angVel (mixL vmax u r) (mixR vmax u r) = w := by
  have ht := c.track_pos
  refine ⟨v / vmax, w * c.track / (2 * vmax), ?_, ?_, ?_⟩
  · have e1 : |v / vmax| = |v| / vmax := by
      rw [abs_div, abs_of_pos hv]
    have e2 : |w * c.track / (2 * vmax)| = |w| * c.track / (2 * vmax) := by
      rw [abs_div, abs_mul, abs_of_pos ht, abs_of_pos (by positivity : (0:ℝ) < 2 * vmax)]
    rw [e1, e2, div_add_div _ _ hv.ne' (by positivity : (2 : ℝ) * vmax ≠ 0),
      div_le_one (by positivity)]
    nlinarith [abs_nonneg v, abs_nonneg w]
  all_goals
    have hsat : |v / vmax| + |w * c.track / (2 * vmax)| ≤ 1 := by
      have e1 : |v / vmax| = |v| / vmax := by rw [abs_div, abs_of_pos hv]
      have e2 : |w * c.track / (2 * vmax)| = |w| * c.track / (2 * vmax) := by
        rw [abs_div, abs_mul, abs_of_pos ht,
          abs_of_pos (by positivity : (0:ℝ) < 2 * vmax)]
      rw [e1, e2, div_add_div _ _ hv.ne' (by positivity : (2 : ℝ) * vmax ≠ 0),
        div_le_one (by positivity)]
      nlinarith [abs_nonneg v, abs_nonneg w]
  · rw [linVel_mix, mixScale_eq_one hsat]
    field_simp
  · rw [angVel_mix, mixScale_eq_one hsat]
    field_simp

end Chassis

end

end LifeTrac
