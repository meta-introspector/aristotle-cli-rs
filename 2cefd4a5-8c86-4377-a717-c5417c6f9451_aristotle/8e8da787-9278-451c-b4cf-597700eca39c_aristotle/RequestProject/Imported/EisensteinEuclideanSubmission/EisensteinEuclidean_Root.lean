import Mathlib
import RequestProject.Imported.EisensteinEuclideanSubmission.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinEuclideanSubmission.EisensteinOrbit_Root

/-!
# The Eisenstein integers form a Euclidean domain

This file establishes `EuclideanDomain Eisenstein` with the size function `norm`.

## Strategy

Given `z, w : Eisenstein` with `w ≠ 0`, we construct `q, r : Eisenstein` such that
`z = q * w + r` and `norm r < norm w`.

The construction uses the standard rounding argument in `ℚ(ω)`:
1. Compute `num := z * conj w` (in `Eisenstein`).
2. We have `num = z * (N(w) / w)` so morally `num / N(w) = z / w` in the field.
3. Round each integer coordinate of `num` to the nearest multiple of `N(w)`; call
   the resulting integers `p` and `q`. Then `quot z w := ⟨p, q⟩`.
4. The remainder is `r := z - quot * w`.

The bound `norm r < norm w` follows from the identity
`r * conj w = num - quot * ⟨N(w), 0⟩`, taking norms and using that each rounded
coordinate is within `N(w) / 2` of `num`'s.

## Two helper lemmas

* `roundInt_bound`: for `m > 0` and any `n`, the symmetric quotient
  `(2n + m) / (2m)` satisfies `2 |n - q m| ≤ m`.
* `key_quadForm_bound`: if `2|α| ≤ N` and `2|β| ≤ N`, then
  `4 (α² - αβ + β²) ≤ 3 N²` — the "covering bound" of the Eisenstein lattice
  expressed integrally.
-/

noncomputable section

open scoped Classical

namespace Eisenstein

/-! ## Auxiliary lemmas -/

/-
Symmetric rounding of `n / m`. For `m > 0`, the value `q := (2n + m) / (2m)`
satisfies `2 * |n - q * m| ≤ m`.
-/
theorem roundInt_bound (n m : ℤ) (hm : 0 < m) :
    let q := (2 * n + m) / (2 * m)
    2 * |n - q * m| ≤ m := by
  cases abs_cases ( n - ( 2 * n + m ) / ( 2 * m ) * m ) <;> nlinarith [ Int.mul_ediv_add_emod ( 2 * n + m ) ( 2 * m ), Int.emod_nonneg ( 2 * n + m ) ( by linarith : ( 2 * m ) ≠ 0 ), Int.emod_lt_of_pos ( 2 * n + m ) ( by linarith : 0 < ( 2 * m ) ) ]

/-
The Eisenstein quadratic form's covering bound, in integer form:
if `2|α| ≤ N` and `2|β| ≤ N`, then `4(α² - αβ + β²) ≤ 3 N²`.
-/
theorem key_quadForm_bound (α β N : ℤ) (hα : 2 * |α| ≤ N) (hβ : 2 * |β| ≤ N) :
    4 * (α ^ 2 - α * β + β ^ 2) ≤ 3 * N ^ 2 := by
  cases abs_cases α <;> cases abs_cases β <;> push_cast [ * ] at * <;> nlinarith

/-! ## Quotient and remainder -/

/-
A nonzero Eisenstein integer has positive norm.
-/
theorem norm_pos_of_ne_zero (w : Eisenstein) (hw : w ≠ 0) : 0 < norm w := by
  contrapose! hw;
  exact Eisenstein.norm_eq_zero_iff w |>.1 ( le_antisymm hw ( Eisenstein.norm_nonneg w ) )

/-- The Eisenstein-integer quotient of `z` by `w`: round each coordinate of
`z * conj w` to the nearest multiple of `norm w`. -/
def eDiv (z w : Eisenstein) : Eisenstein :=
  let num := z * conj w
  let N := norm w
  if _ : 0 < N then
    ⟨(2 * num.a + N) / (2 * N), (2 * num.b + N) / (2 * N)⟩
  else
    0

/-- The Eisenstein-integer remainder. -/
def eMod (z w : Eisenstein) : Eisenstein := z - eDiv z w * w

theorem eDiv_zero (z : Eisenstein) : eDiv z 0 = 0 := by
  unfold Eisenstein.eDiv; aesop;

theorem eDiv_mul_add_eMod (z w : Eisenstein) :
    w * eDiv z w + eMod z w = z := by
  unfold Eisenstein.eMod;
  rw [ mul_comm ] ; aesop;

/-
The key algebraic identity: `(eMod z w) * conj w = z * conj w - eDiv z w * ⟨norm w, 0⟩`.
-/
theorem eMod_mul_conj (z w : Eisenstein) :
    eMod z w * conj w = z * conj w - eDiv z w * ⟨norm w, 0⟩ := by
  rw [ show z.eMod w = z - z.eDiv w * w from rfl, sub_mul ];
  rw [ mul_assoc, Eisenstein.conj_mul_self ]

/-
Norm bound: when `w ≠ 0`, `norm (eMod z w) < norm w`.
-/
theorem norm_eMod_lt (z w : Eisenstein) (hw : w ≠ 0) :
    norm (eMod z w) < norm w := by
  -- Set N = norm w > 0, � num� = z * � conj� w, p = (2*num.a+N)/(2*N), q = (2*num.b+N)/(2*N).
  set N := norm w with hN
  have hN_pos : 0 < N := by
    exact norm_pos_of_ne_zero w hw
  set num := z * conj w with hnum
  set p := (2 * num.a + N) / (2 * N) with hp
  set q := (2 * num.b + N) / (2 * N) with hq;
  -- Set α = num.a - p*N, β = num.b - q*N.
  set α := num.a - p * N with hα
  set β := num.b - q * N with hβ;
  -- By roundInt_bound: 2|α| ≤ N and 2|β| ≤ N.
  have hα_bound : 2 * |α| ≤ N := by
    have := roundInt_bound num.a N hN_pos; aesop;
  have hβ_bound : 2 * |β| ≤ N := by
    convert roundInt_bound num.b N hN_pos using 1;
  -- By eMod_mul_conj: eMod z w * conj w = ⟨α, β⟩.
  have h_eMod_mul_conj : eMod z w * conj w = ⟨α, β⟩ := by
    convert eMod_mul_conj z w using 1;
    unfold Eisenstein.eDiv; aesop;
  -- Taking norms: norm(eMod z w) * N = norm ⟨α, β⟩ = α²-αβ+β² (use norm_mul and norm_conj).
  have h_norm_eMod : norm (eMod z w) * N = α ^ 2 - α * β + β ^ 2 := by
    convert congr_arg norm h_eMod_mul_conj using 1;
    rw [ norm_mul, norm_conj ];
  nlinarith [ key_quadForm_bound α β N hα_bound hβ_bound ]

theorem norm_mul_ge (a b : Eisenstein) (hb : b ≠ 0) : norm a ≤ norm (a * b) := by
  rw [ Eisenstein.norm_mul ];
  exact le_mul_of_one_le_right ( Eisenstein.norm_nonneg a ) ( by linarith [ Eisenstein.norm_pos_of_ne_zero b hb ] )

/-! ## The EuclideanDomain instance -/

instance : Nontrivial Eisenstein := ⟨⟨0, 1, by decide⟩⟩

instance : EuclideanDomain Eisenstein where
  exists_pair_ne := ⟨0, 1, by decide⟩
  quotient := eDiv
  remainder := eMod
  quotient_zero := eDiv_zero
  quotient_mul_add_remainder_eq z w := eDiv_mul_add_eMod z w
  r z w := (norm z).toNat < (norm w).toNat
  r_wellFounded := InvImage.wf (fun z => (norm z).toNat) Nat.lt_wfRel.wf
  remainder_lt z {w} hw := by
    have h := norm_eMod_lt z w hw
    have hnnr : 0 ≤ norm (eMod z w) := norm_nonneg _
    have hnnw : 0 ≤ norm w := norm_nonneg _
    omega
  mul_left_not_lt a {b} hb := by
    intro h
    have hle : norm a ≤ norm (a * b) := norm_mul_ge a b hb
    have hnn : 0 ≤ norm a := norm_nonneg _
    have hnn2 : 0 ≤ norm (a * b) := norm_nonneg _
    omega

end Eisenstein