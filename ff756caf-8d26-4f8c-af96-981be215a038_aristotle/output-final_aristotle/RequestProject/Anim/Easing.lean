import Mathlib

/-!
# Easing curves

The formal counterpart of `web/js/timeline.js`.

An easing curve reparametrises the unit interval: it is used to shape the
interpolation between two keyframes.  For the studio's timeline to behave
predictably, every easing must

* start at `0` and end at `1` (so keyframes are hit exactly), and
* stay inside `[0, 1]` on `[0, 1]` (so an interpolated channel never leaves the
  interval spanned by the two surrounding key values).

`Easing` bundles a function with exactly those obligations, and this file
supplies the curves offered by the studio, each with its proof.
-/

namespace Hesper.Anim

/-- An easing curve: a reparametrisation of the unit interval that fixes both
endpoints and does not leave `[0, 1]`. -/
structure Easing where
  /-- The underlying function. -/
  toFun : ℝ → ℝ
  /-- Easings start at `0`. -/
  map_zero : toFun 0 = 0
  /-- Easings end at `1`. -/
  map_one : toFun 1 = 1
  /-- Easings map the unit interval into itself. -/
  mem_unit : ∀ u : ℝ, 0 ≤ u → u ≤ 1 → 0 ≤ toFun u ∧ toFun u ≤ 1

namespace Easing

instance : CoeFun Easing (fun _ => ℝ → ℝ) := ⟨Easing.toFun⟩

@[simp] theorem coe_mk (f : ℝ → ℝ) (h0 h1 h2) : ((⟨f, h0, h1, h2⟩ : Easing) : ℝ → ℝ) = f := rfl

theorem nonneg (e : Easing) {u : ℝ} (h0 : 0 ≤ u) (h1 : u ≤ 1) : 0 ≤ e u :=
  (e.mem_unit u h0 h1).1

theorem le_one (e : Easing) {u : ℝ} (h0 : 0 ≤ u) (h1 : u ≤ 1) : e u ≤ 1 :=
  (e.mem_unit u h0 h1).2

noncomputable section

/-- The identity easing. -/
def linear : Easing where
  toFun u := u
  map_zero := rfl
  map_one := rfl
  mem_unit _ h0 h1 := ⟨h0, h1⟩

/-- Quadratic ease-in, `u ↦ u²`. -/
def quadIn : Easing where
  toFun u := u ^ 2
  map_zero := by norm_num
  map_one := by norm_num
  mem_unit u h0 h1 := ⟨by positivity, by nlinarith⟩

/-- Quadratic ease-out, `u ↦ u (2 - u)`. -/
def quadOut : Easing where
  toFun u := u * (2 - u)
  map_zero := by norm_num
  map_one := by norm_num
  mem_unit u h0 h1 := ⟨by nlinarith, by nlinarith⟩

/-- Symmetric quadratic ease-in-out. -/
def inOut : Easing where
  toFun u := if u < 1 / 2 then 2 * u ^ 2 else 1 - 2 * (1 - u) ^ 2
  map_zero := by norm_num
  map_one := by norm_num
  mem_unit u h0 h1 := by
    by_cases h : u < 1 / 2
    · simp only [h, if_true]
      constructor <;> nlinarith
    · simp only [h, if_false]
      push_neg at h
      constructor <;> nlinarith

/-- The classic smoothstep `u ↦ u² (3 - 2u)`. -/
def smooth : Easing where
  toFun u := u ^ 2 * (3 - 2 * u)
  map_zero := by norm_num
  map_one := by norm_num
  mem_unit u h0 h1 := ⟨by nlinarith, by nlinarith [sq_nonneg (1 - u), sq_nonneg u]⟩

/-- Perlin's quintic smootherstep `u ↦ u³ (u (6u - 15) + 10)`. -/
def smoother : Easing where
  toFun u := u ^ 3 * (u * (6 * u - 15) + 10)
  map_zero := by norm_num
  map_one := by norm_num
  mem_unit u h0 h1 := by
    have hquad : (0:ℝ) < 6 * u ^ 2 - 15 * u + 10 := by nlinarith [sq_nonneg (4 * u - 5)]
    have hcube : (0:ℝ) ≤ u ^ 3 := by positivity
    have hupper : 1 - u ^ 3 * (u * (6 * u - 15) + 10) = (1 - u) ^ 3 * (6 * u ^ 2 + 3 * u + 1) := by
      ring
    have hrest : (0:ℝ) ≤ (1 - u) ^ 3 * (6 * u ^ 2 + 3 * u + 1) := by
      have h1' : (0:ℝ) ≤ 1 - u := by linarith
      positivity
    exact ⟨by nlinarith, by linarith [hupper ▸ hrest]⟩

/-- Sinusoidal ease `u ↦ (1 - cos (π u)) / 2`. -/
def sine : Easing where
  toFun u := 1 / 2 - Real.cos (Real.pi * u) / 2
  map_zero := by norm_num
  map_one := by simp; norm_num
  mem_unit u _ _ := by
    constructor
    · nlinarith [Real.cos_le_one (Real.pi * u)]
    · nlinarith [Real.neg_one_le_cos (Real.pi * u)]

/-- A hold: nothing happens until the next key is reached. -/
def step : Easing where
  toFun u := if u < 1 then 0 else 1
  map_zero := by norm_num
  map_one := by norm_num
  mem_unit u _ _ := by
    by_cases h : u < 1 <;> simp [h]

/-- A damped oscillation settling on `1`. -/
def bounce : Easing where
  toFun u := 1 - (1 - u) * |Real.cos (3.5 * Real.pi * u)|
  map_zero := by norm_num
  map_one := by norm_num
  mem_unit u h0 h1 := by
    have habs : |Real.cos (3.5 * Real.pi * u)| ≤ 1 := Real.abs_cos_le_one _
    have hpos : (0:ℝ) ≤ |Real.cos (3.5 * Real.pi * u)| := abs_nonneg _
    have hu : 0 ≤ 1 - u := by linarith
    constructor
    · nlinarith
    · nlinarith

/-- Every easing curve of the studio, addressed by the name used in a playbook. -/
def ofName (s : String) : Easing :=
  match s with
  | "in" => quadIn
  | "cubicIn" => quadIn
  | "out" => quadOut
  | "cubicOut" => quadOut
  | "inOut" => inOut
  | "smooth" => smooth
  | "smoother" => smoother
  | "sine" => sine
  | "step" => step
  | "hold" => step
  | "bounce" => bounce
  | _ => linear

end

end Easing

end Hesper.Anim
