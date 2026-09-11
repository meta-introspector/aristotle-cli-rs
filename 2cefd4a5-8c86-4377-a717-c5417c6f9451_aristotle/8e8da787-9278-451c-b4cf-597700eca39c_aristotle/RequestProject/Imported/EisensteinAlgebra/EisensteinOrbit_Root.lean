import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinThetaBridge_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinUnits_Root

/-!
# The unit group acts freely on nonzero Eisenstein integers

This file proves that the 6-element unit group of `ℤ[ω]` acts freely
on the nonzero Eisenstein integers. Consequently, every nonzero
`z : Eisenstein` has an **orbit of exactly 6 elements** under
multiplication by the units `{1, -1, ω, -ω, ω², -ω²}`.

This is **Piece 3** of the four-piece path to a complete proof of the
theta formula `r(n) = 6 · divSum n` laid out in `EisensteinTheta.lean`.

## The proof structure

The key insight: $\mathbb{Z}[\omega]$ is an integral domain
(no zero divisors). Proof: the norm map `N : Eisenstein → ℤ` is
multiplicative (`norm_mul` from `EisensteinIntegers.lean`), and
`N(z) = 0 ↔ z = 0` (because $4N(z) = (2a-b)^2 + 3b^2$ is a sum of
non-negative terms which vanish iff $a = b = 0$).

From integral domain we get **cancellation**: for nonzero `z`,
the map `u ↦ u * z` is injective. So the 6 images
$\{u \cdot z : u \in \text{unitSet}\}$ are 6 distinct elements.

## What this file establishes

* `norm_eq_zero_iff` : `norm z = 0 ↔ z = 0`. Direct calculation via
  $4N(z) = (2a-b)^2 + 3b^2$.
* `Eisenstein.IsDomain` : `Eisenstein` has no zero divisors.
* `mul_unit_injective` : for nonzero `z`, the map `u ↦ u * z` is
  injective.
* `orbit z` : the explicit finset `unitSet.image (· * z)` of the
  6 unit-multiples of `z`.
* `orbit_card_eq_six` : for nonzero `z`, the orbit has exactly 6
  elements.
* `orbit_card_zero` : the orbit of `0` is `{0}` (one element).

## Connection to the theta formula

This piece supplies the geometric reason for the factor of 6 in
$r(n) = 6 \sum_{d|n} \chi_{-3}(d)$. Each ideal of norm $n$ has
exactly 6 generators (its associates under the unit action), so:

  (number of norm-$n$ elements) = 6 × (number of ideals of norm $n$).

Combining with Piece 4 (Dedekind: # ideals of norm $n$ = $\sum_{d|n} \chi_{-3}(d)$)
will complete the theta formula.

**No `sorry`s.** All theorems below are fully proved.
-/

namespace EisensteinOrbit

open Eisenstein EisensteinThetaBridge EisensteinUnits

/-! ### `Eisenstein` is an integral domain -/

/-- **The norm vanishes only at zero.** `norm z = 0 ↔ z = 0`.

Proof: $4 N(z) = (2a - b)^2 + 3 b^2 \geq 0$, with equality iff
both squares are zero, iff $b = 0$ and $a = 0$. -/
theorem norm_eq_zero_iff (z : Eisenstein) : norm z = 0 ↔ z = 0 := by
  constructor
  · intro h
    -- Use 4·norm = (2a-b)² + 3b² = 0, forcing both terms to zero.
    have key : (2 * z.a - z.b) ^ 2 + 3 * z.b ^ 2 = 0 := by
      have hexp : 4 * (z.a ^ 2 - z.a * z.b + z.b ^ 2) =
                  (2 * z.a - z.b) ^ 2 + 3 * z.b ^ 2 := by ring
      have hn : norm z = z.a ^ 2 - z.a * z.b + z.b ^ 2 := rfl
      rw [hn] at h
      linarith
    -- Both squares are non-negative; their sum is 0; each is 0.
    have h_sq1 : (2 * z.a - z.b) ^ 2 = 0 := by
      have h1 : 0 ≤ (2 * z.a - z.b) ^ 2 := sq_nonneg _
      have h2 : 0 ≤ 3 * z.b ^ 2 := by positivity
      linarith
    have h_sq2 : 3 * z.b ^ 2 = 0 := by
      have h1 : 0 ≤ (2 * z.a - z.b) ^ 2 := sq_nonneg _
      linarith
    -- z.b = 0
    have hb : z.b = 0 := by
      have : z.b ^ 2 = 0 := by linarith
      have : z.b * z.b = 0 := by rw [← sq]; exact this
      exact (mul_self_eq_zero.mp this)
    -- 2 z.a - z.b = 0, so 2 z.a = 0 (since z.b = 0), so z.a = 0
    have h2a : 2 * z.a - z.b = 0 := by
      have : (2 * z.a - z.b) * (2 * z.a - z.b) = 0 := by rw [← sq]; exact h_sq1
      exact (mul_self_eq_zero.mp this)
    have ha : z.a = 0 := by
      rw [hb] at h2a
      linarith
    -- Conclude z = ⟨0, 0⟩ = 0
    ext
    · exact ha
    · exact hb
  · intro h
    rw [h, Eisenstein.norm_zero]

/-- `Eisenstein` has no zero divisors: if `z * w = 0`, then `z = 0` or `w = 0`. -/
theorem mul_eq_zero_iff (z w : Eisenstein) : z * w = 0 ↔ z = 0 ∨ w = 0 := by
  constructor
  · intro h
    -- norm(z * w) = norm z * norm w = norm 0 = 0
    have hn : norm z * norm w = 0 := by
      rw [← norm_mul, h, norm_zero]
    -- In ℤ, product is zero iff one factor is zero
    rcases mul_eq_zero.mp hn with h1 | h1
    · left; exact (norm_eq_zero_iff z).mp h1
    · right; exact (norm_eq_zero_iff w).mp h1
  · rintro (rfl | rfl)
    · rw [zero_mul]
    · rw [mul_zero]

/-- `Eisenstein` is an integral domain (no zero divisors). -/
instance : NoZeroDivisors Eisenstein where
  eq_zero_or_eq_zero_of_mul_eq_zero := fun h => (mul_eq_zero_iff _ _).mp h

/-- `Eisenstein` is a (commutative) integral domain. -/
instance : IsDomain Eisenstein where
  exists_pair_ne := ⟨0, 1, by decide⟩

/-! ### Free action of the unit group -/

/-- **Cancellation lemma**: for nonzero `z` and any `u₁ u₂ : Eisenstein`,
if `u₁ * z = u₂ * z`, then `u₁ = u₂`.

This is just `mul_left_cancel₀` from Mathlib applied to our domain
structure, stated explicitly for clarity. -/
theorem mul_right_cancel_of_ne_zero {z u₁ u₂ : Eisenstein} (hz : z ≠ 0)
    (h : u₁ * z = u₂ * z) : u₁ = u₂ := by
  exact mul_right_cancel₀ hz h

/-- For nonzero `z`, the map `u ↦ u * z` is injective on `Eisenstein`. -/
theorem mul_right_injective_of_ne_zero {z : Eisenstein} (hz : z ≠ 0) :
    Function.Injective (fun u : Eisenstein => u * z) := by
  intro u₁ u₂ h
  exact mul_right_cancel_of_ne_zero hz h

/-! ### The orbit -/

/-- The orbit of `z` under multiplication by units:
the 6-element image of `unitSet` under `u ↦ u * z`. -/
def orbit (z : Eisenstein) : Finset Eisenstein :=
  unitSet.image (fun u => u * z)

/-- The orbit of `z` is contained in the image of `unitSet`. -/
theorem orbit_subset_image (z : Eisenstein) :
    orbit z = unitSet.image (fun u => u * z) := rfl

/-- **Main theorem (orbit size):** for nonzero `z`, the orbit has
exactly 6 elements.

Proof: `unitSet.card = 6` by `unitSet_card`, and `u ↦ u * z` is
injective on `unitSet` because `Eisenstein` is an integral domain
and `z ≠ 0`. Injectivity preserves cardinality under `Finset.image`. -/
theorem orbit_card_eq_six {z : Eisenstein} (hz : z ≠ 0) :
    (orbit z).card = 6 := by
  unfold orbit
  rw [Finset.card_image_of_injective _ (mul_right_injective_of_ne_zero hz)]
  exact unitSet_card

/-- The orbit of `0` is `{0}` — a single point, not 6. -/
theorem orbit_card_zero : (orbit 0).card = 1 := by
  unfold orbit
  -- Every u * 0 = 0, so the image collapses to {0}.
  have : unitSet.image (fun u : Eisenstein => u * 0) = {0} := by
    apply Finset.ext
    intro x
    simp only [Finset.mem_image, Finset.mem_singleton]
    constructor
    · rintro ⟨u, _, rfl⟩
      rw [mul_zero]
    · intro hx
      rw [hx]
      -- Use 1 ∈ unitSet as a witness (since 1 * 0 = 0)
      refine ⟨1, ?_, ?_⟩
      · unfold unitSet; decide
      · rw [mul_zero]
  rw [this]
  rfl

/-! ### Spot checks at concrete values -/

/-- Spot check: orbit of `1` has 6 elements (it equals `unitSet`). -/
theorem orbit_one_card : (orbit 1).card = 6 :=
  orbit_card_eq_six (by decide : (1 : Eisenstein) ≠ 0)

/-- Spot check: orbit of `ω` has 6 elements. -/
theorem orbit_omega_card : (orbit ω).card = 6 := by
  apply orbit_card_eq_six
  -- ω = ⟨0, 1⟩ ≠ 0 = ⟨0, 0⟩ : compare the .b fields
  intro h
  have : (1 : ℤ) = 0 := by
    have hb : ω.b = (0 : Eisenstein).b := by rw [h]
    simp at hb
  exact one_ne_zero this

/-- Spot check: orbit of `θ = 1 - ω` has 6 elements. -/
theorem orbit_theta_card : (orbit θ).card = 6 := by
  apply orbit_card_eq_six
  -- θ = ⟨1, -1⟩ ≠ 0 = ⟨0, 0⟩ : compare the .a fields
  intro h
  have : (1 : ℤ) = 0 := by
    have ha : θ.a = (0 : Eisenstein).a := by rw [h]
    simp at ha
  exact one_ne_zero this

/-! ### Status summary

**Delivered (all proved, 0 sorries):**
* Integral domain structure on `Eisenstein` via `norm_eq_zero_iff`
  and `norm_mul`.
* Free action: for nonzero `z`, the map `u ↦ u * z` is injective.
* `orbit z` definition and its cardinality:
  - For `z ≠ 0`: `(orbit z).card = 6`
  - For `z = 0`: `(orbit z).card = 1`
* Spot checks at `z = 1`, `z = ω`, `z = θ`.

**Connection to the theta formula:**

This piece supplies the "factor of 6" in the formula
`r(n) = 6 · divSum n`. The picture:

  {z : Eisenstein | norm z = n}
       = ⨆_{ideals I of norm n} (the 6 generators of I)
       = (number of ideals of norm n) · 6 elements each.

Combining with Piece 4 — Dedekind's formula
`# ideals of norm n = divSum n` — will give the theta formula.

**Remaining piece (Piece 4):**
* `dedekind_count` : `# ideals of `Eisenstein`` `with norm n = divSum n`.
  This is the substantial number-theoretic content: the splitting of
  rational primes in `ℤ[ω]` (split/inert/ramified) and the multiplicativity
  of the ideal-counting function.
-/

end EisensteinOrbit
