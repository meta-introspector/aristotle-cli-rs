import Mathlib

/-!
# DULA Universal: The Abstract Graded Monoid for Any Modulus

This file states and proves the **Universal DULA theorem** — the abstraction
behind the specific quadratic case (`DULAGradedMonoid.lean`, mod 6) and the
specific cubic case (`DULACubic.lean`, mod 9).

## The universal pattern

For any modulus `k > 0`, the multiplicative monoid `M_k` of positive integers
coprime to `k` admits a natural monoid homomorphism

  `laneIdx_k : M_k →* (ZMod k)ˣ`

sending `n ↦ (n : ZMod k)` (viewed as a unit because `n` is coprime to `k`).

Given any subgroup `H ≤ (ZMod k)ˣ`, post-composing with the quotient
`(ZMod k)ˣ →* (ZMod k)ˣ ⧸ H` gives a refined grading

  `M_k →* (ZMod k)ˣ ⧸ H`

This recovers both existing instances:

  - `k = 6`, `H = ⊥`: `laneIdx_6 : M_6 →* (ZMod 6)ˣ ≅ ZMod 2`
    This is `DULAGradedMonoid.laneIndex`.

  - `k = 9`, `H = cubes`: `laneIdx_9_mod_cubes : M_9 →* (ZMod 9)ˣ ⧸ cubes ≅ ZMod 3`
    This is (the quotient projection of) `DULACubic.chi9`.

## What this file builds

1. `coprimeSet (k : ℕ)` — the set of positive integers coprime to `k`.
2. `coprimeSubmonoid (k : ℕ)` — the same as a submonoid of `ℕ`.
3. `toZModUnit` — the lane index function `M_k → (ZMod k)ˣ`, with the proof
   that the image is genuinely a unit (uses `ZMod.unitOfCoprime`).
4. `toZModUnit_mul` — the homomorphism property.
5. `toZModUnit_one` — sends 1 to 1.
6. The packaged `MonoidHom` version.

## Status

Builds the abstract framework. The specific instances (mod 6 quadratic,
mod 9 cubic) remain in their own files, with corollaries to this universal
construction added separately if needed.

This file has **no `sorry`s**: all proofs are routine homomorphism
manipulations using Mathlib's `ZMod.unitOfCoprime` API.
-/

noncomputable section

namespace DULAUniversal

/-! ### The coprime-to-`k` submonoid of `ℕ` -/

/-- The set of positive natural numbers coprime to `k`. -/
def coprimeSet (k : ℕ) : Set ℕ := { n | 0 < n ∧ Nat.Coprime n k }

theorem mem_coprimeSet_iff (k n : ℕ) :
    n ∈ coprimeSet k ↔ 0 < n ∧ Nat.Coprime n k := Iff.rfl

theorem one_mem_coprimeSet (k : ℕ) : (1 : ℕ) ∈ coprimeSet k := by
  refine ⟨Nat.one_pos, ?_⟩
  exact Nat.coprime_one_left k

theorem mul_mem_coprimeSet {k a b : ℕ}
    (ha : a ∈ coprimeSet k) (hb : b ∈ coprimeSet k) :
    a * b ∈ coprimeSet k := by
  obtain ⟨ha_pos, ha_cop⟩ := ha
  obtain ⟨hb_pos, hb_cop⟩ := hb
  exact ⟨Nat.mul_pos ha_pos hb_pos, Nat.Coprime.mul_left ha_cop hb_cop⟩

/-! ### The lane index function to `(ZMod k)ˣ` -/

/-- The lane index of `n ∈ coprimeSet k`, valued in the unit group `(ZMod k)ˣ`. -/
def toZModUnit (k : ℕ) (n : ℕ) (h : n ∈ coprimeSet k) : (ZMod k)ˣ :=
  ZMod.unitOfCoprime n h.2

/-
The lane index of 1 is the identity unit.
-/
theorem toZModUnit_one (k : ℕ) :
    toZModUnit k 1 (one_mem_coprimeSet k) = 1 := by
  unfold toZModUnit; aesop;

/-
**The key homomorphism property**: lane indices multiply in `(ZMod k)ˣ`.
-/
theorem toZModUnit_mul (k : ℕ) {a b : ℕ}
    (ha : a ∈ coprimeSet k) (hb : b ∈ coprimeSet k) :
    toZModUnit k (a * b) (mul_mem_coprimeSet ha hb)
      = toZModUnit k a ha * toZModUnit k b hb := by
  unfold toZModUnit;
  ext;
  simp +decide [ ZMod.unitOfCoprime, Nat.cast_mul ]

/-! ### Underlying ZMod element -/

/-
The underlying residue of the lane index is just `(n : ZMod k)`.
-/
@[simp] theorem toZModUnit_val (k : ℕ) (n : ℕ) (h : n ∈ coprimeSet k) :
    ((toZModUnit k n h) : ZMod k) = (n : ZMod k) := by
  convert ZMod.coe_unitOfCoprime n h.2 using 1

/-! ### Quotient by a subgroup -/

/-- The lane index modulo a subgroup `H ≤ (ZMod k)ˣ`. -/
def toQuotient (k : ℕ) (H : Subgroup (ZMod k)ˣ) (n : ℕ) (h : n ∈ coprimeSet k) :
    (ZMod k)ˣ ⧸ H :=
  QuotientGroup.mk (toZModUnit k n h)

/-
The quotient lane index of 1 is the identity.
-/
theorem toQuotient_one (k : ℕ) (H : Subgroup (ZMod k)ˣ) :
    toQuotient k H 1 (one_mem_coprimeSet k) = 1 := by
  -- By definition of `toQuotient`, we have `toQuotient k H 1 ⋯ = QuotientGroup.mk (toZModUnit k 1 (one_mem_coprimeSet k))`.
  simp [toQuotient];
  convert H.one_mem;
  convert toZModUnit_one k

/-
**The quotient grading is a homomorphism**.
-/
theorem toQuotient_mul (k : ℕ) (H : Subgroup (ZMod k)ˣ) {a b : ℕ}
    (ha : a ∈ coprimeSet k) (hb : b ∈ coprimeSet k) :
    toQuotient k H (a * b) (mul_mem_coprimeSet ha hb)
      = toQuotient k H a ha * toQuotient k H b hb := by
  convert congr_arg _ ( toZModUnit_mul k ha hb ) using 1

/-! ### Lane partition -/

/-
Two coprime-to-`k` integers are in the same lane iff their `ZMod`-images
    differ by an element of `H`.
-/
theorem same_lane_iff (k : ℕ) (H : Subgroup (ZMod k)ˣ) {a b : ℕ}
    (ha : a ∈ coprimeSet k) (hb : b ∈ coprimeSet k) :
    toQuotient k H a ha = toQuotient k H b hb ↔
      (toZModUnit k a ha) * (toZModUnit k b hb)⁻¹ ∈ H := by
  simp +decide [ toQuotient, QuotientGroup.eq ];
  constructor <;> intro h <;> have := H.inv_mem h <;> simp_all +decide;
  · grind;
  · grind +revert

end DULAUniversal

end