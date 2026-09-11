import Mathlib

/-!
# Colour ramps

The formal counterpart of `HesperDeck.rampLookup` (`web/js/deck.js`), the
sampler behind the `palette` playbook statement: the stops of a palette are
spread evenly over `[0, 1]` and neighbouring stops are interpolated linearly.
The runtime applies it to each colour channel, so a ramp here is a list of
reals.

What is proved: the ramp hits its first stop at `0` and its last at `1`, it
only ever sees a clamped parameter, the mixing weight is a genuine weight, and
— the property the studio relies on when it writes bytes into a frame — the
value never leaves the range the stops themselves lie in, so a ramp of bytes
produces bytes.

`tests/node/test_deck.mjs` checks the shipped JavaScript against the same
statements.
-/

namespace Hesper.Palette

/-- Clamp into `[0, 1]`. -/
noncomputable def clamp01 (u : ℝ) : ℝ := max 0 (min 1 u)

theorem clamp01_of_mem {u : ℝ} (h0 : 0 ≤ u) (h1 : u ≤ 1) : clamp01 u = u := by
  simp [clamp01, min_eq_right h1, max_eq_right h0]

theorem clamp01_nonneg (u : ℝ) : 0 ≤ clamp01 u := le_max_left _ _

theorem clamp01_le_one (u : ℝ) : clamp01 u ≤ 1 := max_le zero_le_one (min_le_left _ _)

@[simp] theorem clamp01_zero : clamp01 0 = 0 := by simp [clamp01]

@[simp] theorem clamp01_one : clamp01 1 = 1 := by simp [clamp01]

/-- The stop below the sample: the ramp mixes stops `i` and `i + 1`. -/
noncomputable def rampIdx (n : ℕ) (u : ℝ) : ℕ := min (n - 2) ⌊clamp01 u * ((n : ℝ) - 1)⌋₊

/-- How far the sample sits between stops `i` and `i + 1`. -/
noncomputable def rampFrac (n : ℕ) (u : ℝ) : ℝ :=
  clamp01 u * ((n : ℝ) - 1) - (rampIdx n u : ℝ)

/-- Sample the ramp `stops` at `u`, clamped into `[0, 1]`: the stops are
spread evenly over the unit interval, and the two neighbouring ones are mixed
linearly.  An empty ramp is `0`; a one-stop ramp is constant. -/
noncomputable def ramp (stops : List ℝ) (u : ℝ) : ℝ :=
  if stops.length ≤ 1 then stops.headI
  else
    stops.getD (rampIdx stops.length u) 0
      + (stops.getD (rampIdx stops.length u + 1) 0 - stops.getD (rampIdx stops.length u) 0)
        * rampFrac stops.length u

@[simp] theorem ramp_nil (u : ℝ) : ramp [] u = 0 := by
  simp only [ramp, List.length_nil, Nat.zero_le, if_pos]
  rfl

@[simp] theorem ramp_singleton (a u : ℝ) : ramp [a] u = a := by simp [ramp]

/-- The ramp only ever sees a clamped parameter. -/
theorem ramp_clamp (stops : List ℝ) (u : ℝ) : ramp stops u = ramp stops (clamp01 u) := by
  have h : clamp01 (clamp01 u) = clamp01 u :=
    clamp01_of_mem (clamp01_nonneg u) (clamp01_le_one u)
  simp only [ramp, rampIdx, rampFrac, h]

@[simp] theorem rampIdx_zero (n : ℕ) : rampIdx n 0 = 0 := by simp [rampIdx]

@[simp] theorem rampFrac_zero (n : ℕ) : rampFrac n 0 = 0 := by simp [rampFrac]

/-- At `0` the ramp is its first stop. -/
@[simp] theorem ramp_zero (stops : List ℝ) : ramp stops 0 = stops.headI := by
  by_cases h : stops.length ≤ 1
  · simp [ramp, h]
  · have h1 : 0 < stops.length := by omega
    simp only [ramp, if_neg h, rampIdx_zero, rampFrac_zero, mul_zero, add_zero]
    rw [List.getD_eq_getElem _ _ h1]
    cases stops with
    | nil => simp at h1
    | cons a l => simp

/-- At `1` the ramp is its last stop. -/
theorem ramp_one {stops : List ℝ} (h : 2 ≤ stops.length) :
    ramp stops 1 = stops.getD (stops.length - 1) 0 := by
  have hcast : ((stops.length : ℝ) - 1) = ((stops.length - 1 : ℕ) : ℝ) := by
    have h1 : (1:ℕ) ≤ stops.length := by omega
    push_cast [Nat.cast_sub h1]; ring
  have hidx : rampIdx stops.length 1 = stops.length - 2 := by
    have hfl : ⌊(1:ℝ) * ((stops.length : ℝ) - 1)⌋₊ = stops.length - 1 := by
      rw [one_mul, hcast, Nat.floor_natCast]
    simp only [rampIdx, clamp01_one, hfl]
    omega
  have hfrac : rampFrac stops.length 1 = 1 := by
    have hc2 : ((stops.length - 2 : ℕ) : ℝ) = (stops.length : ℝ) - 2 := by
      push_cast [Nat.cast_sub h]; ring
    simp only [rampFrac, hidx, clamp01_one, one_mul, hc2]
    ring
  have hlast : stops.length - 2 + 1 = stops.length - 1 := by omega
  rw [ramp, if_neg (by omega : ¬ stops.length ≤ 1), hidx, hfrac, mul_one, hlast]
  ring

/-- The mixing weight is a genuine weight: it lies in `[0, 1]`, so a sample is
a convex combination of two neighbouring stops. -/
theorem rampFrac_mem {n : ℕ} (hn : 2 ≤ n) (u : ℝ) :
    0 ≤ rampFrac n u ∧ rampFrac n u ≤ 1 := by
  set s : ℝ := clamp01 u * ((n : ℝ) - 1) with hs
  have hn1 : (1:ℝ) ≤ (n : ℝ) - 1 := by
    have : (2:ℝ) ≤ n := by exact_mod_cast hn
    linarith
  have hs0 : 0 ≤ s := mul_nonneg (clamp01_nonneg u) (by linarith)
  have hsn : s ≤ (n : ℝ) - 1 := by
    have h1 := clamp01_le_one u
    nlinarith [clamp01_nonneg u]
  rcases Nat.lt_or_ge (n - 2) ⌊s⌋₊ with hgt | hle
  · -- the sample sits in the last cell, at its very end
    have hidx : rampIdx n u = n - 2 := by
      simp only [rampIdx, ← hs]; omega
    have hfl : (n : ℝ) - 1 ≤ s := by
      have h1 : (n - 1 : ℕ) ≤ ⌊s⌋₊ := by omega
      have h2 : ((n - 1 : ℕ) : ℝ) ≤ s := le_trans (by exact_mod_cast h1) (Nat.floor_le hs0)
      have hc : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
        have : (1:ℕ) ≤ n := by omega
        push_cast [Nat.cast_sub this]; ring
      linarith [hc ▸ h2]
    have hseq : s = (n : ℝ) - 1 := le_antisymm hsn hfl
    have hc2 : ((n - 2 : ℕ) : ℝ) = (n : ℝ) - 2 := by
      push_cast [Nat.cast_sub hn]; ring
    rw [rampFrac, ← hs, hidx, hc2, hseq]
    constructor <;> linarith
  · have hidx : rampIdx n u = ⌊s⌋₊ := by
      simp only [rampIdx, ← hs]; omega
    rw [rampFrac, ← hs, hidx]
    exact ⟨sub_nonneg.mpr (Nat.floor_le hs0), by linarith [Nat.lt_floor_add_one s]⟩

/-- The two stops the ramp mixes are stops of the palette. -/
theorem rampIdx_lt {stops : List ℝ} (h : 2 ≤ stops.length) (u : ℝ) :
    rampIdx stops.length u + 1 < stops.length := by
  have : rampIdx stops.length u ≤ stops.length - 2 := min_le_left _ _
  omega

/-- A ramp never rises above its stops.  In particular a ramp of bytes stays a
byte, which is what the studio writes into a frame. -/
theorem ramp_le {stops : List ℝ} {M : ℝ} (hM : ∀ c ∈ stops, c ≤ M) (hne : stops ≠ [])
    (u : ℝ) : ramp stops u ≤ M := by
  by_cases h : stops.length ≤ 1
  · have h1 : stops.length = 1 := by
      cases stops with
      | nil => exact absurd rfl hne
      | cons a l => simp at h ⊢; omega
    cases stops with
    | nil => exact absurd rfl hne
    | cons a l =>
      have : l = [] := List.eq_nil_of_length_eq_zero (by simpa using h1)
      subst this
      simpa using hM a (by simp)
  · have hn : 2 ≤ stops.length := by omega
    obtain ⟨hf0, hf1⟩ := rampFrac_mem hn u
    have hi1 := rampIdx_lt hn u
    have hia : stops.getD (rampIdx stops.length u) 0 ≤ M := hM _ (by
      rw [List.getD_eq_getElem _ _ (by omega)]; exact List.getElem_mem _)
    have hib : stops.getD (rampIdx stops.length u + 1) 0 ≤ M := hM _ (by
      rw [List.getD_eq_getElem _ _ hi1]; exact List.getElem_mem _)
    rw [ramp, if_neg h]
    nlinarith

/-- A ramp never falls below its stops. -/
theorem le_ramp {stops : List ℝ} {m : ℝ} (hm : ∀ c ∈ stops, m ≤ c) (hne : stops ≠ [])
    (u : ℝ) : m ≤ ramp stops u := by
  by_cases h : stops.length ≤ 1
  · have h1 : stops.length = 1 := by
      cases stops with
      | nil => exact absurd rfl hne
      | cons a l => simp at h ⊢; omega
    cases stops with
    | nil => exact absurd rfl hne
    | cons a l =>
      have : l = [] := List.eq_nil_of_length_eq_zero (by simpa using h1)
      subst this
      simpa using hm a (by simp)
  · have hn : 2 ≤ stops.length := by omega
    obtain ⟨hf0, hf1⟩ := rampFrac_mem hn u
    have hi1 := rampIdx_lt hn u
    have hia : m ≤ stops.getD (rampIdx stops.length u) 0 := hm _ (by
      rw [List.getD_eq_getElem _ _ (by omega)]; exact List.getElem_mem _)
    have hib : m ≤ stops.getD (rampIdx stops.length u + 1) 0 := hm _ (by
      rw [List.getD_eq_getElem _ _ hi1]; exact List.getElem_mem _)
    rw [ramp, if_neg h]
    nlinarith

end Hesper.Palette
