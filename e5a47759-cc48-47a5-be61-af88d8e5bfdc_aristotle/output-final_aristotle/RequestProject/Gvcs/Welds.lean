import RequestProject.Gvcs.Structure

/-!
# Welds

A LifeTrac is a welded machine: every joint in the frame and the loader is a
fillet weld laid around a square tube.  This file formalizes the sizing rule
for such a joint.

A fillet weld of leg length `leg` has an effective throat `leg/√2`; a run of
length `L` in a metal of allowable shear stress `tau` carries
`(leg/√2)·L·tau`.  We prove the capacity is proportional to leg and to run
length, the length of weld a given load needs, the capacity of a weld laid all
the way round a square tube, and the criterion for such a joint to be stronger
than the tube it joins — the rule of thumb that a full fillet weld of a leg
comparable with the wall thickness develops the member.
-/

namespace LifeTrac

open Real

noncomputable section

/-- Effective throat of a fillet weld of leg length `leg`. -/
def filletThroat (leg : ℝ) : ℝ := leg / √2

theorem filletThroat_pos {leg : ℝ} (h : 0 < leg) : 0 < filletThroat leg := by
  have h2 : (0:ℝ) < √2 := Real.sqrt_pos.mpr (by norm_num)
  unfold filletThroat
  positivity

/-- Load a fillet weld of leg `leg` and run length `len` carries in a metal of
allowable shear stress `tau`. -/
def weldCapacity (leg len tau : ℝ) : ℝ := filletThroat leg * len * tau

theorem weldCapacity_nonneg {leg len tau : ℝ} (hleg : 0 ≤ leg) (hlen : 0 ≤ len)
    (htau : 0 ≤ tau) : 0 ≤ weldCapacity leg len tau := by
  have h2 : (0:ℝ) < √2 := Real.sqrt_pos.mpr (by norm_num)
  unfold weldCapacity filletThroat
  positivity

/-- **A longer run of weld carries proportionally more.** -/
theorem weldCapacity_mono_length {leg len₁ len₂ tau : ℝ} (hleg : 0 ≤ leg)
    (htau : 0 ≤ tau) (h : len₁ ≤ len₂) :
    weldCapacity leg len₁ tau ≤ weldCapacity leg len₂ tau := by
  have h2 : (0:ℝ) < √2 := Real.sqrt_pos.mpr (by norm_num)
  have hthroat : 0 ≤ filletThroat leg := by
    unfold filletThroat; positivity
  unfold weldCapacity
  exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left h hthroat) htau

/-- **A bigger leg carries proportionally more.** -/
theorem weldCapacity_mono_leg {leg₁ leg₂ len tau : ℝ} (hlen : 0 ≤ len)
    (htau : 0 ≤ tau) (h : leg₁ ≤ leg₂) :
    weldCapacity leg₁ len tau ≤ weldCapacity leg₂ len tau := by
  have h2 : (0:ℝ) < √2 := Real.sqrt_pos.mpr (by norm_num)
  have hthroat : filletThroat leg₁ ≤ filletThroat leg₂ := by
    unfold filletThroat
    exact div_le_div_of_nonneg_right h h2.le
  unfold weldCapacity
  exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right hthroat hlen) htau

/-- Doubling the leg of a fillet weld doubles what it holds. -/
theorem weldCapacity_double_leg (leg len tau : ℝ) :
    weldCapacity (2 * leg) len tau = 2 * weldCapacity leg len tau := by
  unfold weldCapacity filletThroat
  ring

/-- Length of weld needed to hold a load `F`. -/
def weldLengthNeeded (leg tau F : ℝ) : ℝ := F / (filletThroat leg * tau)

/-- **The sizing rule.**  A run of weld holds the load exactly when it is at
least as long as `weldLengthNeeded`. -/
theorem weldCapacity_ge_iff {leg len tau F : ℝ} (hleg : 0 < leg) (htau : 0 < tau) :
    F ≤ weldCapacity leg len tau ↔ weldLengthNeeded leg tau F ≤ len := by
  have ht := filletThroat_pos hleg
  unfold weldCapacity weldLengthNeeded
  rw [div_le_iff₀ (by positivity)]
  constructor <;> intro h <;> nlinarith [h]

/-- A weld laid all the way round a square tube runs four times the width of
the tube. -/
def perimeterWeld (t : SquareTube) (leg tau : ℝ) : ℝ :=
  weldCapacity leg (4 * t.width) tau

theorem perimeterWeld_eq (t : SquareTube) (leg tau : ℝ) :
    perimeterWeld t leg tau = filletThroat leg * (4 * t.width) * tau := rfl

/-- **When the weld is stronger than the member.**  A fillet weld right round a
square tube develops more shear than the tube's own cross-section carries
exactly when `wall · (width − wall) ≤ throat · width`. -/
theorem perimeterWeld_ge_section_iff {t : SquareTube} {leg tau : ℝ}
    (htau : 0 < tau) :
    t.area * tau ≤ perimeterWeld t leg tau ↔ t.wall * (t.width - t.wall)
      ≤ filletThroat leg * t.width := by
  have hw := t.width_pos
  rw [perimeterWeld_eq, t.area_eq]
  constructor
  · intro h; nlinarith [h]
  · intro h; nlinarith [h]

/-- In particular a throat at least as deep as the wall is thick makes a
full-strength joint — the familiar rule that a fillet leg of about one and a
half times the wall develops the member. -/
theorem perimeterWeld_ge_section_of_throat_ge_wall {t : SquareTube} {leg tau : ℝ}
    (htau : 0 < tau) (h : t.wall ≤ filletThroat leg) :
    t.area * tau ≤ perimeterWeld t leg tau := by
  have hw := t.width_pos
  have hwall := t.wall_pos
  rw [perimeterWeld_ge_section_iff htau]
  nlinarith

end

end LifeTrac
