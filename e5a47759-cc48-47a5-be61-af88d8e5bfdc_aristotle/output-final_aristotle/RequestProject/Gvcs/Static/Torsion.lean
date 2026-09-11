import RequestProject.Gvcs.Structure

/-!
# Twisting of the LifeTrac's metal: torsion of shafts and of the frame tube

The frame of a LifeTrac is a welded box of square steel tube, and the loader
arms hang off it at the ends.  Whenever the two loader arms are loaded
unequally — one arm digging, the wheels at different heights, a load picked up
off centre — the cross member between them is *twisted* rather than bent, and
the axles and pins are twisted as well.  This file develops the static theory
of that twisting:

* the round shaft (solid or hollow): polar second moment of area, the shear
  stress `τ = T r / J` on its surface, the angle of twist `θ = T L / (G J)`,
  the torque it can carry before the steel shears, and how those grow with the
  size of the bar;
* why a tube is a better use of steel than a bar of the same outside size:
  `J / A` — torsional stiffness bought per unit of metal — strictly increases
  with the bore;
* the *closed thin-walled square tube*, i.e. the frame member itself, through
  Bredt's formula `τ = T / (2 Aₘ t)` and the torsion constant `Jt = a³ t`;
* the quantitative reason a frame is built from closed tube and not from open
  channel: the closed section is stiffer in torsion by the factor `3a²/(4t²)`.

Everything is in coherent SI units (metres, newtons, pascals, radians).
-/

namespace LifeTrac

open Real

noncomputable section

/-! ## Round shafts: axles, pins and cylinder rods -/

/-- A round shaft of outer radius `outer` and bore radius `inner`; `inner = 0`
is a solid bar. -/
structure Shaft where
  /-- Outside radius. -/
  outer : ℝ
  /-- Radius of the bore; zero for a solid bar. -/
  inner : ℝ
  inner_nonneg : 0 ≤ inner
  inner_lt_outer : inner < outer

namespace Shaft

variable (s : Shaft)

theorem outer_pos : 0 < s.outer :=
  lt_of_le_of_lt s.inner_nonneg s.inner_lt_outer

/-- Cross-sectional area of metal, `π (rₒ² - rᵢ²)`. -/
def area : ℝ := π * (s.outer ^ 2 - s.inner ^ 2)

theorem area_pos : 0 < s.area := by
  have h := s.inner_lt_outer
  have h0 := s.inner_nonneg
  have hlt : s.inner ^ 2 < s.outer ^ 2 := by nlinarith
  unfold area
  have hd : (0:ℝ) < s.outer ^ 2 - s.inner ^ 2 := by linarith
  positivity

/-- Polar second moment of area `J = π (rₒ⁴ - rᵢ⁴) / 2`, the quantity that
plays for twisting the role the second moment of area plays for bending. -/
def polarInertia : ℝ := π * (s.outer ^ 4 - s.inner ^ 4) / 2

theorem polarInertia_pos : 0 < s.polarInertia := by
  have h := s.inner_lt_outer
  have h0 := s.inner_nonneg
  have h4 : s.inner ^ 4 < s.outer ^ 4 := by
    have h2 : s.inner ^ 2 < s.outer ^ 2 := by nlinarith
    nlinarith [sq_nonneg s.inner, sq_nonneg s.outer]
  unfold polarInertia
  have hd : (0:ℝ) < s.outer ^ 4 - s.inner ^ 4 := by linarith
  positivity

/-- The torsional section modulus `J / rₒ`: the torque carried per unit of
surface shear stress. -/
def torsionModulus : ℝ := s.polarInertia / s.outer

theorem torsionModulus_pos : 0 < s.torsionModulus :=
  div_pos s.polarInertia_pos s.outer_pos

/-- Shear stress at the surface of the shaft under a torque `T`,
`τ = T rₒ / J`. -/
def shearStress (T : ℝ) : ℝ := T * s.outer / s.polarInertia

theorem shearStress_eq_div_modulus (T : ℝ) :
    s.shearStress T = T / s.torsionModulus := by
  have h := s.outer_pos
  have hJ := s.polarInertia_pos
  unfold shearStress torsionModulus
  field_simp

/-- Shear stress at radius `r` inside the wall: it grows linearly from the
axis, which is why the metal near the axis carries little of the torque. -/
def shearStressAt (T r : ℝ) : ℝ := T * r / s.polarInertia

theorem shearStressAt_outer (T : ℝ) :
    s.shearStressAt T s.outer = s.shearStress T := rfl

theorem shearStressAt_zero (T : ℝ) : s.shearStressAt T 0 = 0 := by
  unfold shearStressAt; simp

/-- **The surface is the worst place**: nowhere inside the wall does the shear
stress exceed the surface value. -/
theorem shearStressAt_le_shearStress {T r : ℝ} (hT : 0 ≤ T) (h : r ≤ s.outer) :
    s.shearStressAt T r ≤ s.shearStress T := by
  have hJ := s.polarInertia_pos
  unfold shearStressAt shearStress
  apply div_le_div_of_nonneg_right _ hJ.le
  exact mul_le_mul_of_nonneg_left h hT

/-- The angle, in radians, through which a length `L` of shaft twists under a
torque `T`, for a material of shear modulus `G`. -/
def twistAngle (G L T : ℝ) : ℝ := T * L / (G * s.polarInertia)

/-- Torsional stiffness `G J / L`: the torque needed per radian of twist. -/
def torsionalStiffness (G L : ℝ) : ℝ := G * s.polarInertia / L

theorem torsionalStiffness_pos {G L : ℝ} (hG : 0 < G) (hL : 0 < L) :
    0 < s.torsionalStiffness G L :=
  div_pos (mul_pos hG s.polarInertia_pos) hL

theorem twistAngle_eq_div_stiffness {G L : ℝ} (hG : 0 < G) (hL : 0 < L) (T : ℝ) :
    s.twistAngle G L T = T / s.torsionalStiffness G L := by
  have hJ := s.polarInertia_pos
  have hG' := hG.ne'
  have hL' := hL.ne'
  unfold twistAngle torsionalStiffness
  field_simp

/-- **Twist is proportional to torque** (linear elasticity). -/
theorem twistAngle_smul (G L T k : ℝ) :
    s.twistAngle G L (k * T) = k * s.twistAngle G L T := by
  unfold twistAngle; ring

/-- **Twist is proportional to length**: two lengths of the same shaft in
series twist by the sum of their angles. -/
theorem twistAngle_add_length (G L₁ L₂ T : ℝ) :
    s.twistAngle G (L₁ + L₂) T = s.twistAngle G L₁ T + s.twistAngle G L₂ T := by
  unfold twistAngle; ring

/-- The largest torque that keeps the surface shear stress at or below the
allowable shear stress `tau`. -/
def torqueCapacity (tau : ℝ) : ℝ := tau * s.torsionModulus

/-- **The design check for a twisted shaft.** -/
theorem shearStress_le_iff {T tau : ℝ} :
    s.shearStress T ≤ tau ↔ T ≤ s.torqueCapacity tau := by
  have hW := s.torsionModulus_pos
  rw [s.shearStress_eq_div_modulus, div_le_iff₀ hW, torqueCapacity, mul_comm]

theorem torqueCapacity_pos {tau : ℝ} (h : 0 < tau) : 0 < s.torqueCapacity tau :=
  mul_pos h s.torsionModulus_pos

/-- **A solid bar of twice the diameter carries eight times the torque.** -/
theorem torqueCapacity_double_radius {s₁ s₂ : Shaft} (h₁ : s₁.inner = 0)
    (h₂ : s₂.inner = 0) (h : s₂.outer = 2 * s₁.outer) (tau : ℝ) :
    s₂.torqueCapacity tau = 8 * s₁.torqueCapacity tau := by
  have hr := s₁.outer_pos
  unfold torqueCapacity torsionModulus polarInertia
  rw [h₁, h₂, h]
  field_simp
  ring

/-- **… and is sixteen times as stiff.** -/
theorem polarInertia_double_radius {s₁ s₂ : Shaft} (h₁ : s₁.inner = 0)
    (h₂ : s₂.inner = 0) (h : s₂.outer = 2 * s₁.outer) :
    s₂.polarInertia = 16 * s₁.polarInertia := by
  unfold polarInertia
  rw [h₁, h₂, h]; ring

/-- A thicker-walled shaft of the same outside diameter carries more torque. -/
theorem torqueCapacity_mono_bore {s₁ s₂ : Shaft} {tau : ℝ} (htau : 0 ≤ tau)
    (ho : s₁.outer = s₂.outer) (hi : s₁.inner ≤ s₂.inner) :
    s₂.torqueCapacity tau ≤ s₁.torqueCapacity tau := by
  have h0 := s₁.inner_nonneg
  have hpos := s₁.outer_pos
  have h4 : s₁.inner ^ 4 ≤ s₂.inner ^ 4 := pow_le_pow_left₀ h0 hi 4
  unfold torqueCapacity torsionModulus polarInertia
  rw [ho] at hpos ⊢
  apply mul_le_mul_of_nonneg_left _ htau
  apply div_le_div_of_nonneg_right _ hpos.le
  have hpi := Real.pi_pos
  nlinarith

/-- `J / A = (rₒ² + rᵢ²)/2`: the torsional stiffness bought per unit of metal
in the section. -/
theorem polarInertia_div_area (s : Shaft) :
    s.polarInertia / s.area = (s.outer ^ 2 + s.inner ^ 2) / 2 := by
  have h := s.inner_lt_outer
  have h0 := s.inner_nonneg
  have hlt : s.inner ^ 2 < s.outer ^ 2 := by nlinarith
  have hpi := Real.pi_pos
  have hA : s.area ≠ 0 := ne_of_gt s.area_pos
  unfold area at hA
  unfold polarInertia area
  have hd : s.outer ^ 2 - s.inner ^ 2 ≠ 0 := by
    intro hc; apply hA; rw [hc]; ring
  field_simp
  ring

/-- **Why axles are made of tube and not of bar.** At a fixed outside radius,
`J / A` strictly increases with the bore: hollowing a shaft out removes exactly
the metal that was doing the least work against twisting. -/
theorem hollow_better_than_solid {s₁ s₂ : Shaft} (ho : s₁.outer = s₂.outer)
    (hi : s₁.inner < s₂.inner) :
    s₁.polarInertia / s₁.area < s₂.polarInertia / s₂.area := by
  rw [polarInertia_div_area, polarInertia_div_area, ho]
  have h0 := s₁.inner_nonneg
  have : s₁.inner ^ 2 < s₂.inner ^ 2 := by nlinarith
  linarith

end Shaft

/-! ## The frame member: a closed thin-walled square tube

For a thin-walled *closed* section the shear flow `q = τ t` is constant around
the wall, and Bredt's theory gives the stress and the twist in terms of the
area `Aₘ` enclosed by the mid-line of the wall.  For a square tube of outside
width `w` and wall `t` that mid-line is a square of side `a = w - t`. -/

namespace SquareTube

variable (u : SquareTube)

/-- Side of the mid-line of the wall, `a = w - t`. -/
def midWidth : ℝ := u.width - u.wall

theorem midWidth_pos : 0 < u.midWidth := by
  have h := u.wall_lt_half_width
  have hw := u.wall_pos
  unfold midWidth
  linarith

/-- Area enclosed by the mid-line of the wall, `Aₘ = a²`. -/
def enclosedArea : ℝ := u.midWidth ^ 2

theorem enclosedArea_pos : 0 < u.enclosedArea := by
  have := u.midWidth_pos
  unfold enclosedArea; positivity

/-- Torsion constant of the closed square tube, `Jt = 4 Aₘ² t / p = a³ t`. -/
def torsionConstant : ℝ := u.midWidth ^ 3 * u.wall

/-- The torsion constant above is Bredt's `4 Aₘ² t / p` for the square
mid-line of perimeter `p = 4a`. -/
theorem torsionConstant_eq_bredt :
    u.torsionConstant = 4 * u.enclosedArea ^ 2 * u.wall / (4 * u.midWidth) := by
  have h := u.midWidth_pos
  have h' := h.ne'
  unfold torsionConstant enclosedArea
  field_simp

theorem torsionConstant_pos : 0 < u.torsionConstant := by
  have := u.midWidth_pos
  have := u.wall_pos
  unfold torsionConstant; positivity

/-- **Bredt's formula**: the shear stress in the wall of a closed tube under a
torque `T` is `τ = T / (2 Aₘ t)`. -/
def torsionShearStress (T : ℝ) : ℝ := T / (2 * u.enclosedArea * u.wall)

/-- The shear flow `q = τ t`, constant around the wall of a closed section. -/
def shearFlow (T : ℝ) : ℝ := T / (2 * u.enclosedArea)

theorem shearFlow_eq (T : ℝ) :
    u.shearFlow T = u.torsionShearStress T * u.wall := by
  have h := u.enclosedArea_pos
  have hw := u.wall_pos
  have h' := h.ne'
  have hw' := hw.ne'
  unfold shearFlow torsionShearStress
  field_simp

/-- Angle of twist of a length `L` of frame tube. -/
def torsionAngle (G L T : ℝ) : ℝ := T * L / (G * u.torsionConstant)

/-- Torque the frame member can carry at an allowable shear stress `tau`. -/
def torsionCapacity (tau : ℝ) : ℝ := 2 * u.enclosedArea * u.wall * tau

/-- **The design check for the twisted frame member.** -/
theorem torsionShearStress_le_iff {T tau : ℝ} :
    u.torsionShearStress T ≤ tau ↔ T ≤ u.torsionCapacity tau := by
  have h : 0 < 2 * u.enclosedArea * u.wall := by
    have := u.enclosedArea_pos; have := u.wall_pos; positivity
  unfold torsionShearStress torsionCapacity
  rw [div_le_iff₀ h, mul_comm]

theorem torsionCapacity_pos {tau : ℝ} (h : 0 < tau) : 0 < u.torsionCapacity tau := by
  have := u.enclosedArea_pos
  have := u.wall_pos
  unfold torsionCapacity; positivity

/-- The quantity `Aₘ t = (w - t)² t` that fixes the torsional strength of a
square tube of outside width `w` grows with the wall thickness as long as the
section stays thin-walled, `3t ≤ w`.  (Past that point more metal starts to
shrink the enclosed area faster than it thickens the wall.) -/
theorem sq_mul_mono_of_thin {w t₁ t₂ : ℝ} (h0 : 0 ≤ t₁) (h : t₁ ≤ t₂)
    (hthin : 3 * t₂ ≤ w) : (w - t₁) ^ 2 * t₁ ≤ (w - t₂) ^ 2 * t₂ := by
  have ht2 : 0 ≤ t₂ := le_trans h0 h
  have hbig : 3 * t₁ ≤ w := le_trans (by linarith) hthin
  have hsq : t₁ * t₂ ≤ (w - t₁ - t₂) ^ 2 := by
    have hb : t₁ * t₂ ≤ (w / 3) ^ 2 := by nlinarith
    have hge : w / 3 ≤ w - t₁ - t₂ := by linarith
    have h0' : (0:ℝ) ≤ w / 3 := by linarith
    nlinarith
  nlinarith [mul_nonneg (sub_nonneg.2 h) (sub_nonneg.2 hsq)]

/-- **A heavier wall twists less**: at equal outside width, and as long as the
section stays thin-walled, the torsional shear stress falls as the wall
thickens. -/
theorem torsionShearStress_antitone {u₁ u₂ : SquareTube} {T : ℝ} (hT : 0 ≤ T)
    (hw : u₁.width = u₂.width) (h : u₁.wall ≤ u₂.wall)
    (hthin : 3 * u₂.wall ≤ u₂.width) :
    u₂.torsionShearStress T ≤ u₁.torsionShearStress T := by
  have h1 := u₁.midWidth_pos
  have h2 := u₂.midWidth_pos
  have hw1 := u₁.wall_pos
  have hmono := sq_mul_mono_of_thin (w := u₂.width) hw1.le h hthin
  have hden : 2 * u₁.enclosedArea * u₁.wall ≤ 2 * u₂.enclosedArea * u₂.wall := by
    unfold enclosedArea midWidth
    rw [hw]
    linarith
  unfold torsionShearStress
  refine div_le_div_of_nonneg_left hT ?_ hden
  have := u₁.enclosedArea_pos
  positivity

/-- Torsion constant of the *open* section obtained by slitting the same tube
lengthwise: a thin strip of total length `4a` and thickness `t`, for which
`J = (1/3) · 4a · t³`. -/
def openTorsionConstant : ℝ := 4 * u.midWidth * u.wall ^ 3 / 3

/-- **Why a frame is welded up from closed tube.** Slit the tube lengthwise and
its torsional stiffness drops by the factor `3a²/(4t²)`; for the LifeTrac's
4 in × ¼ in tube that is a factor of more than a hundred. -/
theorem torsionConstant_div_open :
    u.torsionConstant / u.openTorsionConstant
      = 3 * u.midWidth ^ 2 / (4 * u.wall ^ 2) := by
  have ha := u.midWidth_pos
  have hw := u.wall_pos
  have ha' := ha.ne'
  have hw' := hw.ne'
  unfold torsionConstant openTorsionConstant
  field_simp

/-- For any genuinely thin-walled tube (wall at most half the mid-line side)
the closed section really is the stiffer one. -/
theorem open_lt_closed (h : 2 * u.wall ≤ u.midWidth) :
    u.openTorsionConstant < u.torsionConstant := by
  have ha := u.midWidth_pos
  have hw := u.wall_pos
  unfold openTorsionConstant torsionConstant
  have h2 : 4 * u.wall ^ 2 ≤ u.midWidth ^ 2 := by nlinarith
  have hat : 0 < u.midWidth * u.wall := mul_pos ha hw
  have key : u.midWidth * u.wall * (4 * u.wall ^ 2)
      ≤ u.midWidth * u.wall * u.midWidth ^ 2 := mul_le_mul_of_nonneg_left h2 hat.le
  nlinarith [key, mul_pos hat (mul_pos hw hw)]

end SquareTube

end

end LifeTrac
