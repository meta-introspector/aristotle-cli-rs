import RequestProject.Gvcs.Static.Torsion

/-!
# Shearing: how the LifeTrac's metal gets cut rather than stretched

Bending and twisting are not the only ways a welded steel machine fails.  The
other one is *shear*: the metal slides across itself.  It happens in three
places on a LifeTrac and this file treats all three.

* **Direct shear** — a pin or a bolt cut across its shank.  A pin in *double*
  shear (a clevis, i.e. a lug between two ears) sees half the stress of the
  same pin in single shear.
* **Transverse shear in a beam** — the loader arm carries its tip load by a
  shear force running down the web of the tube.  The stress is not uniform: it
  is `τ = V Q / (I b)`, peaking at the neutral axis.  We compute the first
  moment `Q` of the square tube and prove that the peak really does exceed the
  crude average `V / A`, which is why the average is not a safe check.
* **The joint as a whole** — a pinned joint can fail three ways: the pin
  shears, the plate crushes in bearing under the pin, or the metal between the
  hole and the edge tears out.  The capacity of the joint is the least of the
  three, and we prove exactly that.

Units are SI throughout: metres, newtons, pascals.
-/

namespace LifeTrac

open Real

noncomputable section

/-! ## Direct shear -/

/-- Average shear stress on a cut of area `A` carrying a shear force `V`. -/
def directShearStress (V A : ℝ) : ℝ := V / A

/-- Force a cut of area `A` carries at an allowable shear stress `tau`. -/
def directShearCapacity (A tau : ℝ) : ℝ := A * tau

theorem directShearStress_le_iff {V A tau : ℝ} (hA : 0 < A) :
    directShearStress V A ≤ tau ↔ V ≤ directShearCapacity A tau := by
  unfold directShearStress directShearCapacity
  rw [div_le_iff₀ hA, mul_comm]

/-- Shear stress in a round pin of radius `r` carrying `V` across `n` planes:
`n = 1` is single shear, `n = 2` the double shear of a clevis. -/
def pinShearStress (n : ℕ) (r V : ℝ) : ℝ := V / (n * (π * r ^ 2))

/-- **A pin in double shear is worked half as hard.** -/
theorem pinShearStress_double {r V : ℝ} (hr : 0 < r) :
    pinShearStress 2 r V = pinShearStress 1 r V / 2 := by
  have h : (0:ℝ) < π * r ^ 2 := by positivity
  unfold pinShearStress
  push_cast
  field_simp

/-- The pin shear check agrees with the shear capacity of `n` planes computed
in `RequestProject.Structure`. -/
theorem pinShearStress_le_iff {n : ℕ} {r V tau : ℝ} (hn : 0 < n) (hr : 0 < r) :
    pinShearStress n r V ≤ tau ↔ V ≤ shearCapacity n r tau := by
  have hn' : (0:ℝ) < n := by exact_mod_cast hn
  have h : (0:ℝ) < n * (π * r ^ 2) := by positivity
  unfold pinShearStress shearCapacity
  rw [div_le_iff₀ h]
  constructor <;> intro hle <;> nlinarith [hle]

/-! ## Transverse shear in a beam -/

/-- Jourawski's formula: the shear stress at a level of a bent beam where the
first moment of the area beyond that level is `Q`, the width of the section is
`b` and the second moment of area is `I`. -/
def transverseShearStress (V Q I b : ℝ) : ℝ := V * Q / (I * b)

/-- The shear flow `q = V Q / I` carried across a level of the section; this is
the force per unit length that the welds along that line must carry. -/
def shearFlow (V Q I : ℝ) : ℝ := V * Q / I

theorem shearFlow_eq_stress_mul_width {V Q I b : ℝ} (hI : I ≠ 0) (hb : b ≠ 0) :
    shearFlow V Q I = transverseShearStress V Q I b * b := by
  unfold shearFlow transverseShearStress
  field_simp

namespace SquareTube

variable (u : SquareTube)

/-- First moment about the neutral axis of the half of the square tube above
it, `Q = (w³ - wᵢ³)/8`. -/
def firstMoment : ℝ := (u.width ^ 3 - u.innerWidth ^ 3) / 8

theorem firstMoment_pos : 0 < u.firstMoment := by
  have h1 := u.innerWidth_pos
  have h2 := u.innerWidth_lt_width
  have hwp := u.width_pos
  have key : 0 < (u.width - u.innerWidth) *
      (u.width ^ 2 + u.width * u.innerWidth + u.innerWidth ^ 2) :=
    mul_pos (sub_pos.2 h2) (by positivity)
  unfold firstMoment
  nlinarith [key]

/-- Both walls of the tube are cut when it is sheared across, so the width
resisting the shear is `2t`. -/
def webWidth : ℝ := 2 * u.wall

theorem webWidth_pos : 0 < u.webWidth := by
  have := u.wall_pos
  unfold webWidth; linarith

/-- Peak shear stress in the walls of a square tube carrying a shear force
`V`, at the neutral axis. -/
def webShearStress (V : ℝ) : ℝ :=
  transverseShearStress V u.firstMoment u.inertia u.webWidth

/-- **The average is not a safe check.** The peak shear stress at the neutral
axis of a square tube always exceeds the naive `V / A`, so sizing a member on
the average shear stress underestimates how hard the steel is working. -/
theorem average_le_webShearStress {V : ℝ} (hV : 0 ≤ V) :
    directShearStress V u.area ≤ u.webShearStress V := by
  have hw := u.wall_pos
  have hi := u.innerWidth_pos
  have hlt := u.innerWidth_lt_width
  have hA := u.area_pos
  have hI := u.inertia_pos
  have hb := u.webWidth_pos
  have hIb : 0 < u.inertia * u.webWidth := mul_pos hI hb
  have hwall : u.width - u.innerWidth = 2 * u.wall := by
    unfold SquareTube.innerWidth; ring
  -- `Q · A ≥ I · b`, i.e. the peak is at least the average
  have hkey : u.inertia * u.webWidth ≤ u.firstMoment * u.area := by
    unfold firstMoment SquareTube.area SquareTube.inertia webWidth
    rw [← hwall]
    have hd : 0 < u.width - u.innerWidth := sub_pos.2 hlt
    have hgap : 0 < (u.width - u.innerWidth) ^ 2 * (u.width + u.innerWidth) *
        (4 * u.width ^ 2 + 12 * u.width * u.innerWidth + 4 * u.innerWidth ^ 2) / 96 := by
      have h1 : 0 < (u.width - u.innerWidth) ^ 2 := pow_pos hd 2
      have h2 : 0 < u.width + u.innerWidth := by linarith
      have h3 : 0 < 4 * u.width ^ 2 + 12 * u.width * u.innerWidth + 4 * u.innerWidth ^ 2 := by
        nlinarith
      positivity
    nlinarith [hgap]
  unfold directShearStress webShearStress transverseShearStress
  rw [div_le_div_iff₀ hA hIb]
  nlinarith [hkey, hV]

theorem webShearStress_le_iff {V tau : ℝ} :
    u.webShearStress V ≤ tau ↔ V * u.firstMoment ≤ tau * (u.inertia * u.webWidth) := by
  have hIb : 0 < u.inertia * u.webWidth := mul_pos u.inertia_pos u.webWidth_pos
  unfold webShearStress transverseShearStress
  rw [div_le_iff₀ hIb]

end SquareTube

/-! ## The pinned joint: three ways to fail -/

/-- A pinned or bolted joint: `count` pins of radius `pinRadius` through a
plate of thickness `plate`, each hole at a distance `edge` from the edge of the
plate; the pin shears at `pinShear`, the plate crushes at `bearing` and tears
out at `plateShear`. -/
structure PinnedJoint where
  /-- Number of pins. -/
  count : ℕ
  /-- Radius of one pin. -/
  pinRadius : ℝ
  /-- Thickness of the plate the pin bears against. -/
  plate : ℝ
  /-- Distance from the centre of the hole to the edge of the plate. -/
  edge : ℝ
  /-- Number of shear planes per pin: 1 for single shear, 2 for a clevis. -/
  planes : ℕ
  /-- Shear strength of the pin material. -/
  pinShear : ℝ
  /-- Bearing (crushing) strength of the plate. -/
  bearing : ℝ
  /-- Shear strength of the plate material. -/
  plateShear : ℝ
  count_pos : 0 < count
  planes_pos : 0 < planes
  pinRadius_pos : 0 < pinRadius
  plate_pos : 0 < plate
  edge_gt : pinRadius < edge
  pinShear_pos : 0 < pinShear
  bearing_pos : 0 < bearing
  plateShear_pos : 0 < plateShear

namespace PinnedJoint

variable (j : PinnedJoint)

/-- Load at which the pins shear off. -/
def shearLimit : ℝ := j.count * j.planes * (π * j.pinRadius ^ 2) * j.pinShear

/-- Load at which the plate crushes under the pins; the projected bearing area
of one pin is `2 r · t`. -/
def bearingLimit : ℝ := j.count * (2 * j.pinRadius * j.plate) * j.bearing

/-- Load at which the metal between a hole and the edge tears out: two shear
planes of length `e - r` and thickness `t` per pin. -/
def tearOutLimit : ℝ := j.count * (2 * (j.edge - j.pinRadius) * j.plate) * j.plateShear

/-- The capacity of the joint is the least of its three failure loads. -/
def capacity : ℝ := min j.shearLimit (min j.bearingLimit j.tearOutLimit)

theorem shearLimit_pos : 0 < j.shearLimit := by
  have h1 : (0:ℝ) < j.count := by exact_mod_cast j.count_pos
  have h2 : (0:ℝ) < j.planes := by exact_mod_cast j.planes_pos
  have h3 := j.pinRadius_pos
  have h4 := j.pinShear_pos
  unfold shearLimit; positivity

theorem bearingLimit_pos : 0 < j.bearingLimit := by
  have h1 : (0:ℝ) < j.count := by exact_mod_cast j.count_pos
  have h3 := j.pinRadius_pos
  have h4 := j.plate_pos
  have h5 := j.bearing_pos
  unfold bearingLimit; positivity

theorem tearOutLimit_pos : 0 < j.tearOutLimit := by
  have h1 : (0:ℝ) < j.count := by exact_mod_cast j.count_pos
  have h2 : 0 < j.edge - j.pinRadius := sub_pos.2 j.edge_gt
  have h4 := j.plate_pos
  have h5 := j.plateShear_pos
  unfold tearOutLimit; positivity

theorem capacity_pos : 0 < j.capacity := by
  unfold capacity
  exact lt_min j.shearLimit_pos (lt_min j.bearingLimit_pos j.tearOutLimit_pos)

theorem capacity_le_shearLimit : j.capacity ≤ j.shearLimit := min_le_left _ _

theorem capacity_le_bearingLimit : j.capacity ≤ j.bearingLimit :=
  le_trans (min_le_right _ _) (min_le_left _ _)

theorem capacity_le_tearOutLimit : j.capacity ≤ j.tearOutLimit :=
  le_trans (min_le_right _ _) (min_le_right _ _)

/-- **A joint is safe exactly when it is safe against all three modes.** -/
theorem safe_iff {F : ℝ} :
    F ≤ j.capacity ↔ F ≤ j.shearLimit ∧ F ≤ j.bearingLimit ∧ F ≤ j.tearOutLimit := by
  unfold capacity
  simp

/-- **The weakest mode governs**: the capacity is attained by one of the three
failure modes, so improving any other one alone buys nothing. -/
theorem capacity_eq_one_of :
    j.capacity = j.shearLimit ∨ j.capacity = j.bearingLimit ∨
      j.capacity = j.tearOutLimit := by
  unfold capacity
  rcases min_cases j.shearLimit (min j.bearingLimit j.tearOutLimit) with ⟨h, _⟩ | ⟨h, _⟩
  · exact Or.inl h
  · rcases min_cases j.bearingLimit j.tearOutLimit with ⟨h2, _⟩ | ⟨h2, _⟩
    · exact Or.inr (Or.inl (h.trans h2))
    · exact Or.inr (Or.inr (h.trans h2))

/-- The edge distance at which tear-out stops being the governing failure
mode, for a plate of the same steel as the pin. -/
def minEdgeDistance : ℝ :=
  j.pinRadius + j.planes * (π * j.pinRadius ^ 2) / (2 * j.plate)

/-- **The edge-distance rule.** With plate and pin of the same steel, the metal
beyond the hole is stronger than the pin exactly when the hole is at least
`minEdgeDistance` from the edge. -/
theorem tearOut_not_governing_iff {j : PinnedJoint} (h : j.plateShear = j.pinShear) :
    j.shearLimit ≤ j.tearOutLimit ↔ j.minEdgeDistance ≤ j.edge := by
  have hc : (0:ℝ) < j.count := by exact_mod_cast j.count_pos
  have hr := j.pinRadius_pos
  have hplt := j.plate_pos
  have hs := j.pinShear_pos
  have hcs : (0:ℝ) < (j.count : ℝ) * j.pinShear := by positivity
  have step1 : j.shearLimit ≤ j.tearOutLimit ↔
      (j.planes : ℝ) * (π * j.pinRadius ^ 2)
        ≤ 2 * (j.edge - j.pinRadius) * j.plate := by
    unfold shearLimit tearOutLimit
    rw [h]
    constructor <;> intro hle <;> nlinarith [hle, hcs]
  have step2 : ((j.planes : ℝ) * (π * j.pinRadius ^ 2)
        ≤ 2 * (j.edge - j.pinRadius) * j.plate) ↔ j.minEdgeDistance ≤ j.edge := by
    unfold minEdgeDistance
    rw [← le_sub_iff_add_le', div_le_iff₀ (by positivity : (0:ℝ) < 2 * j.plate)]
    constructor <;> intro hle <;> nlinarith [hle]
  exact step1.trans step2

end PinnedJoint

end

end LifeTrac
