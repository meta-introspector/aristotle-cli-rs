import RequestProject.Gvcs.Cylinder

/-!
# Structural sizing of the LifeTrac frame and loader

The LifeTrac is welded from square steel tube, with round bar for the pins and
the cylinder rods.  This file formalizes the strength calculations a builder
has to make when choosing those sections:

* the geometry of a square hollow section — cross-sectional area, second moment
  of area and section modulus, and how they grow with the size of the tube;
* bending of a cantilever loader arm: the stress it sees, the load at which the
  steel yields and the deflection at its tip;
* Euler buckling of a round rod, applied to the rod of a loader cylinder: the
  supply pressure at which the rod becomes unstable;
* the shear capacity of a bolted or pinned joint;
* factors of safety.

All the quantities are real numbers in coherent SI units (metres, newtons,
pascals).
-/

namespace LifeTrac

open Real

noncomputable section

/-! ## Square hollow section -/

/-- A square hollow structural section: an outer width `width` and a wall
thickness `wall`, with the two walls not meeting in the middle. -/
structure SquareTube where
  /-- Outer width of the square section. -/
  width : ℝ
  /-- Wall thickness. -/
  wall : ℝ
  wall_pos : 0 < wall
  wall_lt_half_width : 2 * wall < width

namespace SquareTube

variable (t : SquareTube)

theorem width_pos : 0 < t.width :=
  lt_trans (by linarith [t.wall_pos]) t.wall_lt_half_width

/-- Width of the square hole down the middle of the tube. -/
def innerWidth : ℝ := t.width - 2 * t.wall

theorem innerWidth_pos : 0 < t.innerWidth := by
  have := t.wall_lt_half_width
  unfold innerWidth; linarith

theorem innerWidth_lt_width : t.innerWidth < t.width := by
  have := t.wall_pos
  unfold innerWidth; linarith

/-- Cross-sectional area of the steel: the outer square less the hole. -/
def area : ℝ := t.width ^ 2 - t.innerWidth ^ 2

/-- The area of a square tube is `4 · wall · (width − wall)`. -/
theorem area_eq : t.area = 4 * t.wall * (t.width - t.wall) := by
  unfold area innerWidth; ring

theorem area_pos : 0 < t.area := by
  have h1 := t.innerWidth_pos
  have h2 := t.innerWidth_lt_width
  unfold area; nlinarith

/-- Second moment of area of the section about a centroidal axis parallel to a
side: `(a⁴ − b⁴)/12` for outer width `a` and inner width `b`. -/
def inertia : ℝ := (t.width ^ 4 - t.innerWidth ^ 4) / 12

theorem inertia_pos : 0 < t.inertia := by
  have h1 := t.innerWidth_pos
  have h2 := t.innerWidth_lt_width
  have : t.innerWidth ^ 4 < t.width ^ 4 := by
    exact pow_lt_pow_left₀ h2 h1.le (by norm_num)
  unfold inertia; linarith

/-- Elastic section modulus: the second moment of area divided by the distance
from the neutral axis to the extreme fibre, `width/2`. -/
def sectionModulus : ℝ := 2 * t.inertia / t.width

theorem sectionModulus_pos : 0 < t.sectionModulus := by
  have := t.inertia_pos
  have := t.width_pos
  unfold sectionModulus; positivity

/-- **Thicker walls stiffen the tube.**  At the same outside size, a heavier
wall gives a larger second moment of area. -/
theorem inertia_mono_wall (t₁ t₂ : SquareTube) (hw : t₁.width = t₂.width)
    (h : t₁.wall ≤ t₂.wall) : t₁.inertia ≤ t₂.inertia := by
  have h2 : t₂.innerWidth ≤ t₁.innerWidth := by
    unfold innerWidth; rw [hw]; linarith
  have h0 : 0 ≤ t₂.innerWidth := t₂.innerWidth_pos.le
  have : t₂.innerWidth ^ 4 ≤ t₁.innerWidth ^ 4 := by
    exact pow_le_pow_left₀ h0 h2 4
  unfold inertia; rw [hw]; linarith

/-- **Bigger tube, much stiffer.**  Scaling a section up by a factor `k`
multiplies its second moment of area by `k⁴`: stiffness is bought very cheaply
by going one tube size up. -/
theorem inertia_scale (t₁ t₂ : SquareTube) {k : ℝ}
    (hw : t₂.width = k * t₁.width) (ht : t₂.wall = k * t₁.wall) :
    t₂.inertia = k ^ 4 * t₁.inertia := by
  have hi : t₂.innerWidth = k * t₁.innerWidth := by
    unfold innerWidth; rw [hw, ht]; ring
  unfold inertia; rw [hw, hi]; ring

/-- Scaling a section up by `k` multiplies its section modulus — and hence the
bending moment it can carry — by `k³`. -/
theorem sectionModulus_scale (t₁ t₂ : SquareTube) {k : ℝ} (hk : 0 < k)
    (hw : t₂.width = k * t₁.width) (ht : t₂.wall = k * t₁.wall) :
    t₂.sectionModulus = k ^ 3 * t₁.sectionModulus := by
  have hI := inertia_scale t₁ t₂ hw ht
  have hpos := t₁.width_pos
  unfold sectionModulus
  rw [hI, hw]
  field_simp

/-! ## Bending of a cantilever -/

/-- Bending stress in the extreme fibre under a bending moment `M`. -/
def bendingStress (M : ℝ) : ℝ := M / t.sectionModulus

/-- Bending moment at the root of a cantilever of length `L` carrying a tip
load `F`. -/
def cantileverMoment (F L : ℝ) : ℝ := F * L

/-- The largest tip load a cantilever of length `L` can carry before the
extreme fibre reaches the yield stress `sy`. -/
def maxTipLoad (sy L : ℝ) : ℝ := sy * t.sectionModulus / L

/-- **Yield criterion for the loader arm.**  A cantilever of length `L` stays
below the yield stress exactly when its tip load does not exceed `maxTipLoad`.
-/
theorem bendingStress_le_yield_iff {sy F L : ℝ} (hL : 0 < L) :
    t.bendingStress (cantileverMoment F L) ≤ sy ↔ F ≤ t.maxTipLoad sy L := by
  have hS := t.sectionModulus_pos
  unfold bendingStress cantileverMoment maxTipLoad
  rw [div_le_iff₀ hS, le_div_iff₀ hL]

/-- Longer arms carry less: the maximum tip load falls off inversely with the
reach. -/
theorem maxTipLoad_antitone {sy L₁ L₂ : ℝ} (hsy : 0 ≤ sy) (h₁ : 0 < L₁)
    (h : L₁ ≤ L₂) : t.maxTipLoad sy L₂ ≤ t.maxTipLoad sy L₁ := by
  have hS := t.sectionModulus_pos
  unfold maxTipLoad
  apply div_le_div_of_nonneg_left (by positivity) h₁ h

/-- Deflection at the tip of a cantilever of length `L`, flexural modulus `E`,
under a tip load `F`: `F L³ / (3 E I)`. -/
def tipDeflection (E F L : ℝ) : ℝ := F * L ^ 3 / (3 * E * t.inertia)

/-- **Deflection grows with the cube of the reach.**  Doubling the length of
the arm makes its tip sag eight times as far. -/
theorem tipDeflection_double (E F L : ℝ) :
    t.tipDeflection E F (2 * L) = 8 * t.tipDeflection E F L := by
  unfold tipDeflection; ring

/-- A stiffer section deflects less under the same load. -/
theorem tipDeflection_antitone_inertia (t₁ t₂ : SquareTube) {E F L : ℝ}
    (hE : 0 < E) (hF : 0 ≤ F) (hL : 0 ≤ L) (h : t₁.inertia ≤ t₂.inertia) :
    t₂.tipDeflection E F L ≤ t₁.tipDeflection E F L := by
  have h1 := t₁.inertia_pos
  unfold tipDeflection
  apply div_le_div_of_nonneg_left (by positivity) (by positivity)
  nlinarith

end SquareTube

/-! ## Euler buckling of a round rod -/

/-- Second moment of area of a solid round bar of radius `r`. -/
def roundInertia (r : ℝ) : ℝ := π * r ^ 4 / 4

theorem roundInertia_pos {r : ℝ} (hr : 0 < r) : 0 < roundInertia r := by
  unfold roundInertia; positivity

/-- Euler's critical load for a strut of modulus `E`, radius `r`, length `L`
and effective-length factor `K`. -/
def eulerLoad (E r K L : ℝ) : ℝ := π ^ 2 * E * roundInertia r / (K * L) ^ 2

theorem eulerLoad_pos {E r K L : ℝ} (hE : 0 < E) (hr : 0 < r) (hK : 0 < K)
    (hL : 0 < L) : 0 < eulerLoad E r K L := by
  have := roundInertia_pos hr
  unfold eulerLoad
  have : 0 < (K * L) ^ 2 := by positivity
  positivity

/-- **A long strut buckles far sooner.**  Doubling the free length of a rod
quarters the load it can take. -/
theorem eulerLoad_double_length {E r K L : ℝ} (hK : K ≠ 0) (hL : L ≠ 0) :
    eulerLoad E r K (2 * L) = eulerLoad E r K L / 4 := by
  unfold eulerLoad
  field_simp
  ring

/-- **A fatter rod is much stronger.**  The critical load grows with the fourth
power of the rod radius. -/
theorem eulerLoad_scale_radius {E r K L k : ℝ} :
    eulerLoad E (k * r) K L = k ^ 4 * eulerLoad E r K L := by
  unfold eulerLoad roundInertia
  ring

theorem eulerLoad_antitone {E r K L₁ L₂ : ℝ} (hE : 0 < E) (hr : 0 < r)
    (hK : 0 < K) (h₁ : 0 < L₁) (h : L₁ ≤ L₂) :
    eulerLoad E r K L₂ ≤ eulerLoad E r K L₁ := by
  have hI := roundInertia_pos hr
  unfold eulerLoad
  apply div_le_div_of_nonneg_left (by positivity) (by positivity)
  have : K * L₁ ≤ K * L₂ := by nlinarith
  nlinarith [mul_pos hK h₁]

namespace Cylinder

variable (c : Cylinder)

/-- The supply pressure at which the fully extended rod of a cylinder reaches
its Euler buckling load: the push force `Δp · capArea` equals the critical load
for a strut of the rod's radius and the stroke's length. -/
def bucklingPressure (E K : ℝ) : ℝ := eulerLoad E c.rod K c.stroke / c.capArea

/-- **Buckling criterion for a cylinder rod.**  A fully extended cylinder is
stable exactly while the supply pressure stays below `bucklingPressure`. -/
theorem extendForce_lt_eulerLoad_iff {E K Δp : ℝ} :
    c.extendForce Δp < eulerLoad E c.rod K c.stroke ↔ Δp < c.bucklingPressure E K := by
  have hA := c.capArea_pos
  unfold extendForce bucklingPressure
  rw [lt_div_iff₀ hA, mul_comm]

/-- A short-stroke cylinder tolerates more pressure before its rod buckles. -/
theorem bucklingPressure_mono_rod {E K : ℝ} (c₁ c₂ : Cylinder) (hE : 0 < E)
    (hK : 0 < K) (hb : c₁.bore = c₂.bore) (hs : c₁.stroke = c₂.stroke)
    (h : c₁.rod ≤ c₂.rod) :
    c₁.bucklingPressure E K ≤ c₂.bucklingPressure E K := by
  have h1 := c₁.rod_pos
  have hA : 0 < c₁.capArea := c₁.capArea_pos
  have hAeq : c₁.capArea = c₂.capArea := by unfold capArea; rw [hb]
  have hnum : eulerLoad E c₁.rod K c₁.stroke ≤ eulerLoad E c₂.rod K c₂.stroke := by
    unfold eulerLoad roundInertia
    rw [hs]
    have hp : (0:ℝ) < (K * c₂.stroke) ^ 2 := by
      have := c₂.stroke_pos
      positivity
    apply div_le_div_of_nonneg_right _ hp.le
    have h4 : c₁.rod ^ 4 ≤ c₂.rod ^ 4 := pow_le_pow_left₀ h1.le h 4
    have hcoef : (0:ℝ) ≤ π ^ 2 * E * π / 4 := by positivity
    nlinarith [h4, hcoef]
  unfold bucklingPressure
  rw [hAeq] at hA ⊢
  exact div_le_div_of_nonneg_right hnum hA.le

end Cylinder

/-! ## Pinned and bolted joints -/

/-- Shear capacity of `n` pins of radius `r` in single shear, in a material of
shear strength `tau`. -/
def shearCapacity (n : ℕ) (r tau : ℝ) : ℝ := n * (π * r ^ 2) * tau

theorem shearCapacity_pos {n : ℕ} {r tau : ℝ} (hn : 0 < n) (hr : 0 < r)
    (htau : 0 < tau) : 0 < shearCapacity n r tau := by
  have : (0:ℝ) < n := by exact_mod_cast hn
  unfold shearCapacity
  positivity

/-- **Two bolts carry twice as much as one.** -/
theorem shearCapacity_mono {n₁ n₂ : ℕ} {r tau : ℝ}
    (htau : 0 ≤ tau) (h : n₁ ≤ n₂) :
    shearCapacity n₁ r tau ≤ shearCapacity n₂ r tau := by
  have : (n₁ : ℝ) ≤ n₂ := by exact_mod_cast h
  unfold shearCapacity
  have h1 : (0:ℝ) ≤ π * r ^ 2 := by positivity
  exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right this h1) htau

/-- **Doubling the pin diameter quadruples the joint.** -/
theorem shearCapacity_double_radius (n : ℕ) (r tau : ℝ) :
    shearCapacity n (2 * r) tau = 4 * shearCapacity n r tau := by
  unfold shearCapacity; ring

/-- The pin at the loader pivot carries the sum of the cylinder force and the
load it lifts; this is the pressure at which a joint of `n` pins is exactly at
its shear capacity. -/
theorem loader_pin_ok_iff {n : ℕ} {r tau : ℝ} (a : LoaderArm) (c : Cylinder)
    {Δp : ℝ} (h : 0 < a.loadArm) :
    a.liftForce (c.extendForce Δp) ≤ shearCapacity n r tau ↔
      Δp * c.capArea * a.cylArm ≤ shearCapacity n r tau * a.loadArm := by
  unfold LoaderArm.liftForce Cylinder.extendForce
  rw [div_le_iff₀ h]

/-! ## Factors of safety -/

/-- Factor of safety: capacity divided by the load actually applied. -/
def safetyFactor (capacity load : ℝ) : ℝ := capacity / load

/-- **A design is adequate exactly when its factor of safety reaches one.** -/
theorem safetyFactor_one_le_iff {capacity load : ℝ} (hl : 0 < load) :
    1 ≤ safetyFactor capacity load ↔ load ≤ capacity := by
  unfold safetyFactor
  rw [le_div_iff₀ hl, one_mul]

/-- Designing to a factor of safety `k` means the load may not exceed
`capacity / k`. -/
theorem safetyFactor_ge_iff {capacity load k : ℝ} (hl : 0 < load) (hk : 0 < k) :
    k ≤ safetyFactor capacity load ↔ load ≤ capacity / k := by
  unfold safetyFactor
  rw [le_div_iff₀ hl, le_div_iff₀ hk, mul_comm]

/-- The factor of safety falls as the load rises. -/
theorem safetyFactor_antitone {capacity l₁ l₂ : ℝ} (hc : 0 ≤ capacity)
    (h₁ : 0 < l₁) (h : l₁ ≤ l₂) :
    safetyFactor capacity l₂ ≤ safetyFactor capacity l₁ := by
  unfold safetyFactor
  exact div_le_div_of_nonneg_left hc h₁ h

end

end LifeTrac
