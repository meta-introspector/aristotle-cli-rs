import Mathlib

/-!
# Clips and frame timing

The formal counterpart of the frame loop used by the studio's exporters
(`renderClip` in `web/js/studio.js`, mirrored by `frameCount` / `frameTime` in
`web/js/timeline.js`).

A clip has a positive duration and frame rate.  Frame `i` is rendered at time
`min (i / fps) duration`, and the clip has `max 1 (round (duration * fps))`
frames.  The lemmas record that the frame times form a non-decreasing sequence
inside `[0, duration]` that starts at `0` — i.e. an export never samples the
scene outside the interval the preview scrubs over.
-/

namespace Hesper.Anim

/-- A clip: a positive duration in seconds, and a positive frame rate. -/
structure Clip where
  /-- Length of the clip, in seconds. -/
  duration : ℝ
  /-- Frames per second. -/
  fps : ℝ
  /-- Clips have positive length. -/
  duration_pos : 0 < duration
  /-- Clips have a positive frame rate. -/
  fps_pos : 0 < fps

namespace Clip

variable (c : Clip)

/-- Number of frames in the clip: `max 1 (round (duration * fps))`. -/
noncomputable def frameCount : ℕ := max 1 ⌊c.duration * c.fps + 1 / 2⌋₊

/-- Time at which frame `i` is rendered.  Frames never run past the end. -/
noncomputable def frameTime (i : ℕ) : ℝ := min (i / c.fps) c.duration

theorem frameCount_pos : 0 < c.frameCount := by
  simp [frameCount]

theorem frameTime_nonneg (i : ℕ) : 0 ≤ c.frameTime i := by
  have h : (0:ℝ) ≤ i / c.fps := div_nonneg (Nat.cast_nonneg i) c.fps_pos.le
  exact le_min h c.duration_pos.le

theorem frameTime_le_duration (i : ℕ) : c.frameTime i ≤ c.duration :=
  min_le_right _ _

@[simp] theorem frameTime_zero : c.frameTime 0 = 0 := by
  simp [frameTime, c.duration_pos.le]

theorem frameTime_mono {i j : ℕ} (h : i ≤ j) : c.frameTime i ≤ c.frameTime j := by
  have : (i : ℝ) / c.fps ≤ (j : ℝ) / c.fps := by
    apply div_le_div_of_nonneg_right _ c.fps_pos.le
    exact_mod_cast h
  exact min_le_min this le_rfl

/-- While the clip has not ended, consecutive frames are `1 / fps` apart. -/
theorem frameTime_succ_of_lt {i : ℕ} (h : ((i : ℝ) + 1) / c.fps ≤ c.duration) :
    c.frameTime (i + 1) = c.frameTime i + 1 / c.fps := by
  have hi : (i : ℝ) / c.fps ≤ c.duration := by
    refine le_trans (div_le_div_of_nonneg_right (by linarith) c.fps_pos.le) h
  have h1 : c.frameTime (i + 1) = ((i : ℝ) + 1) / c.fps := by
    simp only [frameTime, Nat.cast_add, Nat.cast_one]
    exact min_eq_left h
  have h2 : c.frameTime i = (i : ℝ) / c.fps := min_eq_left hi
  rw [h1, h2, add_div]

/-- Every frame of the clip is sampled inside `[0, duration]`. -/
theorem frameTime_mem_Icc (i : ℕ) : c.frameTime i ∈ Set.Icc (0 : ℝ) c.duration :=
  ⟨c.frameTime_nonneg i, c.frameTime_le_duration i⟩

end Clip

end Hesper.Anim
