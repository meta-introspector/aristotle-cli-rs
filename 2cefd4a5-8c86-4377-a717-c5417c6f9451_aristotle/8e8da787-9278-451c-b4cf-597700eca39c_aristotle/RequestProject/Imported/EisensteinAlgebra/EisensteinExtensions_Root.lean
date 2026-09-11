import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinThetaBridge_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinUnits_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinOrbit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplitHard_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinEuclidean_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinAlgebra_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinIdealCount_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinDivSum_Root

/-!
# Eisenstein extensions: F₄ quotient, ArithmeticFunction framework, Dedekind ζ

This file packages three contained extensions of the DULA Eisenstein program,
each of which gives a clean numerical-content identification with classical
mathematics. None of these extensions claim anything beyond what is rigorously
provable.

## Part 1: ℤ[ω]/(2) ≅ 𝔽₄

The ideal `(2)` in `Eisenstein` is maximal (proved as `inert_prime` in
`EisensteinPrimeSplit.lean` for `p ≡ 2 (mod 3)`, applied at `p = 2`). The
quotient `Eisenstein ⧸ (2)` is therefore a field. By enumeration of cosets,
this field has exactly 4 elements, hence is `𝔽₄`. We deliver:

  `quotient_two_card : Fintype.card (Eisenstein ⧸ Ideal.span {(2 : Eisenstein)}) = 4`

## Part 2: `divSum` as a Dirichlet convolution

In Mathlib's `ArithmeticFunction R` framework, Dirichlet convolution `f * g`
satisfies `(f * g)(n) = Σ_{d|n} f(d) · g(n/d)`. The "constant 1" arithmetic
function `ArithmeticFunction.zeta` has `zeta(n) = 1` for `n ≥ 1`, `zeta(0) = 0`.

Our `divSum n = Σ_{d|n} χ_{-3}(d)` is exactly the Dirichlet convolution
`(χ̃ * zeta)(n)`, where `χ̃` is `χ_{-3}` packaged as an `ArithmeticFunction ℤ`.

We deliver:
  `chi3Arith : ArithmeticFunction ℤ`            -- χ_{-3} as an ArithmeticFunction
  `divSum_eq_dirichlet_convolution`             -- divSum n = (chi3Arith * ζ)(n)

## Part 3: The Dedekind ζ coefficient identity

Our master theorem `iCount_eq_divSum` plus Part 2 above gives:

  `iCountArith = chi3Arith * ArithmeticFunction.zeta`  (as ArithmeticFunctions)

which is the Dirichlet-coefficient form of the classical Dedekind zeta
factorization

  ζ_{ℚ(√-3)}(s) = ζ(s) · L(s, χ_{-3})       (for Re(s) > 1).

This file establishes the *coefficient identity only*. It does NOT establish
analytic continuation, functional equations, or anything about zeros of these
functions. Those are separate and substantial pieces of work.
-/

noncomputable section

open scoped Classical

namespace Eisenstein

/-! ## Part 1: ℤ[ω]/(2) ≅ 𝔽₄ -/

/-- The ideal `(2)` in `Eisenstein`, viewed as `Ideal.span {(2 : Eisenstein)}`. -/
def idealTwo : Ideal Eisenstein := Ideal.span {(2 : Eisenstein)}

/-- The ideal `(2)` is nonzero. -/
theorem idealTwo_ne_bot : idealTwo ≠ ⊥ := by
  unfold idealTwo
  rw [ne_eq, Ideal.span_singleton_eq_bot]
  intro h
  have := congr_arg Eisenstein.a h
  change ((1 : Eisenstein) + 1).a = (0 : Eisenstein).a at this
  simp at this

/-- The quotient `Eisenstein ⧸ (2)` is finite. -/
instance : Finite (Eisenstein ⧸ idealTwo) := by
  rw [← Ideal.absNorm_ne_zero_iff]
  unfold idealTwo
  rw [Eisenstein.absNorm_span_singleton]
  show (Eisenstein.norm ((1 : Eisenstein) + 1)).natAbs ≠ 0
  simp [Eisenstein.norm]

/-- The quotient `Eisenstein ⧸ (2)` has a `Fintype` instance. -/
instance : Fintype (Eisenstein ⧸ idealTwo) := Fintype.ofFinite _

/-- The absolute norm of `idealTwo` is 4. -/
theorem absNorm_idealTwo : Ideal.absNorm idealTwo = 4 := by
  unfold idealTwo
  rw [Eisenstein.absNorm_span_singleton]
  show (Eisenstein.norm ((1 : Eisenstein) + 1)).natAbs = 4
  simp [Eisenstein.norm]

/-- The quotient `Eisenstein ⧸ (2)` has exactly 4 elements. -/
theorem quotient_two_card :
    Fintype.card (Eisenstein ⧸ idealTwo) = 4 := by
  rw [← Nat.card_eq_fintype_card]
  have h1 : Ideal.absNorm idealTwo = Nat.card (Eisenstein ⧸ idealTwo) := by
    show Submodule.cardQuot idealTwo = Nat.card (Eisenstein ⧸ idealTwo)
    exact Submodule.cardQuot_apply idealTwo
  linarith [absNorm_idealTwo]

/-- The four canonical representatives of cosets in `Eisenstein ⧸ (2)`:
namely `⟨a, b⟩` with `a, b ∈ {0, 1}`. -/
def fourReps : Finset Eisenstein :=
  {⟨0, 0⟩, ⟨1, 0⟩, ⟨0, 1⟩, ⟨1, 1⟩}

theorem fourReps_card : fourReps.card = 4 := by
  unfold fourReps; decide

/-
The quotient `Eisenstein ⧸ (2)` is a field. This uses that `(2)` is maximal,
which in turn is a consequence of `inert_prime` from `EisensteinPrimeSplit.lean`
(since `2 ≡ 2 (mod 3)`).
-/
theorem idealTwo_isMaximal : idealTwo.IsMaximal := by
  -- 2 is inert in Eisenstein (norm 2 has no Eisenstein elements, per Piece 4a),
  -- so (2) is a prime ideal in a PID, hence maximal.
  have h_four : ∀ (z : Eisenstein), Eisenstein.norm z = 2 → False := by
    exact fun z hz => EisensteinPrimeSplit.no_norm_eq_of_two_mod_three_nat 2 ( by decide ) z hz;
  -- Since there's no element in Eisenstein with norm 2, 2 is irreducible in Eisenstein.
  have h_irreducible : Irreducible (2 : Eisenstein) := by
    constructor;
    · rw [ isUnit_iff_exists_inv ];
      simp +zetaDelta at *;
      intro x hx; have := congr_arg ( fun z => z.a ) hx; norm_num at this;
      erw [ show a 2 = 2 by rfl, show b 2 = 0 by rfl ] at this ; omega;
    · intro a b hab
      have h_norm : Eisenstein.norm a * Eisenstein.norm b = 4 := by
        rw [ ← Eisenstein.norm_mul, ← hab ] ; norm_num [ Eisenstein.norm ]
        exact Int.sub_add_cancel (Eisenstein.a 2 ^ 2) (Eisenstein.a 2 * Eisenstein.b 2)
      generalize_proofs at *;
      rcases lt_trichotomy ( Eisenstein.norm a ) 0 with ha | ha | ha <;> rcases lt_trichotomy ( Eisenstein.norm b ) 0 with hb | hb | hb <;> (try nlinarith);
      · exact False.elim <| ha.not_ge <| Eisenstein.norm_nonneg a;
      · rcases lt_trichotomy ( Eisenstein.norm a ) 2 with ha' | ha' | ha' <;> rcases lt_trichotomy ( Eisenstein.norm b ) 2 with hb' | hb' | hb' <;> (try nlinarith);
        · exact Or.inl <| Eisenstein.isUnit_of_norm_one a <| by linarith;
        · exact False.elim <| h_four a ha';
        · exact Or.inr ( Eisenstein.isUnit_of_norm_one _ <| by linarith [ show b.norm = 1 by linarith ] );
  have h_prime : Ideal.IsPrime (Ideal.span {(2 : Eisenstein)}) := by
    convert Ideal.span_singleton_prime h_irreducible.ne_zero |>.2 h_irreducible.prime using 1;
  convert h_prime.isMaximal;
  simp [idealTwo]

instance : Field (Eisenstein ⧸ idealTwo) :=
  haveI := idealTwo_isMaximal
  Ideal.Quotient.field idealTwo

/-! ## Part 2: `divSum` as Dirichlet convolution -/

open Nat ArithmeticFunction in
/-- The Dirichlet character `χ_{-3}` packaged as an `ArithmeticFunction ℤ`.
Note that `EisensteinTheta.chi3 0 = 0` already, so no guard is needed. -/
def chi3Arith : ArithmeticFunction ℤ where
  toFun n := EisensteinTheta.chi3 n
  map_zero' := EisensteinTheta.chi3_zero

/-
The key identity: our `divSum n` is the Dirichlet convolution of
`chi3Arith` and `ArithmeticFunction.zeta`.
-/
theorem divSum_eq_dirichlet_convolution (n : ℕ) (_hn : 0 < n) :
    EisensteinTheta.divSum n = (chi3Arith * ArithmeticFunction.zeta) n := by
  rw [ ArithmeticFunction.coe_mul_zeta_apply ];
  rfl

/-! ## Part 3: The Dedekind ζ coefficient identity -/

open Nat ArithmeticFunction in
/-- The Eisenstein ideal-count function packaged as an `ArithmeticFunction ℤ`.
The `if n = 0` guard is required because `iCount 0 = 1` (the bottom ideal has
`absNorm = 0`), but `ArithmeticFunction` requires `f 0 = 0` by convention. -/
def iCountArith : ArithmeticFunction ℤ where
  toFun n := if n = 0 then 0 else (Eisenstein.iCount n : ℤ)
  map_zero' := by simp

open Nat ArithmeticFunction in
/-- **The Dedekind zeta coefficient identity** (for `ℚ(√-3)`). At the level of
Dirichlet coefficients, the ideal-counting function of the Eisenstein integers
factors as the Dirichlet convolution of `χ_{-3}` and the constant-1 function.

This is the coefficient form of `ζ_{ℚ(√-3)}(s) = ζ(s) · L(s, χ_{-3})`. -/
theorem dedekind_zeta_factorization :
    iCountArith = chi3Arith * ArithmeticFunction.zeta := by
  ext n;
  by_cases hn : n = 0;
  · aesop;
  · convert Eisenstein.iCount_eq_divSum n ( Nat.pos_of_ne_zero hn ) using 1;
    · exact if_neg hn;
    · exact Eisenstein.divSum_eq_dirichlet_convolution n ( Nat.pos_of_ne_zero hn ) ▸ rfl

end Eisenstein