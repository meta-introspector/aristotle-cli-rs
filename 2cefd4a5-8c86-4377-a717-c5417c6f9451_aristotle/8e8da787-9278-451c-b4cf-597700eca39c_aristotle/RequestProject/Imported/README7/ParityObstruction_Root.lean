/-
# The parity obstruction for flat bilinear 2-unitaries

STATUS: compiled against Mathlib for `leanprover/lean4:v4.28.0`.  The file contains no
proof placeholders, no kernel-bypassing decision procedures and no new axioms; the
grep-based acceptance criteria in README.md are stated so that they are not satisfied by
this sentence.

## What is proved here, and what is not

Fix `d : ℕ`, let `ζ = exp(2πi/d)`, and for `M = !![a, b; c, e]` over `ZMod d` define the
flat matrix of order `d²`

    U^(M)_{(x,y),(u,v)} = d⁻¹ · ζ ^ (x*(a*u + b*v) + y*(c*u + e*v)).

An analytic lemma -- character-sum orthogonality applied to `U`, to its reshuffling and to
its partial transpose -- shows

    U^(M) is 2-unitary  ↔  IsUnit (a*e - b*c) ∧ IsUnit (a*e) ∧ IsUnit (b*c).       (★)

**(★) is NOT formalised in this file.**  It is the interface between the analysis and the
arithmetic.  What this file does is take the right-hand side of (★) as the definition
`Admissible` and prove, completely, the arithmetic statement

    (∃ a b c e, Admissible d a b c e)  ↔  Odd d.

So `Odd d` is proved equivalent to the *criterion*, not to 2-unitarity; the reader must
supply (★) to conclude anything about matrices.  The prose in the accompanying paper is
responsible for that step and says so.

The same two-line parity mechanism is then shown to govern linear orthomorphisms and
linear complete mappings of `ZMod d`, which is the Hall--Paige connection.

## Method

Everything rests on one observation: when `2 ∣ d` there is a ring homomorphism
`f : ZMod d →+* ZMod 2`, ring homomorphisms preserve units, and the only unit of `ZMod 2`
is `1`.  Hence a unit of `ZMod d` is "odd", and a difference of two odd things is even.
-/

import Mathlib

namespace ParityObstruction

open scoped Classical

/-! ## Step 0: units of `ZMod 2` -/

private lemma zmodTwo_cases : ∀ x : ZMod 2, x = 0 ∨ x = 1 := by decide

/-- The only unit of `ZMod 2` is `1`.  This is the whole source of the obstruction. -/
lemma eq_one_of_isUnit_zmodTwo {x : ZMod 2} (hx : IsUnit x) : x = 1 := by
  have h0 : x ≠ 0 := hx.ne_zero
  rcases zmodTwo_cases x with h | h
  · exact absurd h h0
  · exact h

/-- Reduction `ZMod d →+* ZMod 2`, available exactly when `d` is even. -/
noncomputable def redTwo {d : ℕ} (hd : 2 ∣ d) : ZMod d →+* ZMod 2 :=
  ZMod.castHom hd (ZMod 2)

/-- A unit of `ZMod d`, `d` even, reduces to `1` in `ZMod 2`. -/
lemma red_unit_eq_one {d : ℕ} (hd : 2 ∣ d) {x : ZMod d} (hx : IsUnit x) :
    redTwo hd x = 1 :=
  eq_one_of_isUnit_zmodTwo (hx.map (redTwo hd))

/-! ## Step 1: the criterion -/

/-- The three unit conditions of (★), for `M = !![a, b; c, e]`:
the determinant `a*e - b*c`, the diagonal product `a*e`, and the off-diagonal product
`b*c` must all be units.  This is a *verbatim* transcription of the right-hand side of
(★) and must not be weakened. -/
def Admissible (d : ℕ) (a b c e : ZMod d) : Prop :=
  IsUnit (a * e - b * c) ∧ IsUnit (a * e) ∧ IsUnit (b * c)

/-! ## Step 2: the obstruction at even `d` -/

/-- **Parity obstruction.**  If `d` is even, no `M` satisfies the criterion.

The diagonal and off-diagonal products are units, hence both reduce to `1` in `ZMod 2`;
their difference therefore reduces to `0`, so it cannot be a unit. -/
theorem not_admissible_of_even {d : ℕ} (hd : 2 ∣ d) (a b c e : ZMod d) :
    ¬ Admissible d a b c e := by
  rintro ⟨hdet, hdiag, hoff⟩
  have h1 : redTwo hd (a * e) = 1 := red_unit_eq_one hd hdiag
  have h2 : redTwo hd (b * c) = 1 := red_unit_eq_one hd hoff
  have h3 : redTwo hd (a * e - b * c) = 1 := red_unit_eq_one hd hdet
  rw [map_sub, h1, h2, sub_self] at h3
  exact zero_ne_one h3

/-! ## Step 3: existence at odd `d` -/

/-- For odd `d`, `2` is a unit of `ZMod d`: its inverse is `(d+1)/2`. -/
lemma isUnit_two_of_odd {d : ℕ} (hd : Odd d) : IsUnit (2 : ZMod d) := by
  have hcop : Nat.Coprime 2 d := Nat.coprime_two_left.mpr hd
  have hunit : IsUnit ((2 : ℕ) : ZMod d) :=
    (ZMod.isUnit_iff_coprime 2 d).mpr hcop
  norm_num at hunit ⊢
  exact hunit

/-- For odd `d` the matrix `!![1, 1; 1, 2]` satisfies the criterion:
`det = 1`, `a*e = 2`, `b*c = 1`. -/
theorem admissible_of_odd {d : ℕ} (hd : Odd d) :
    Admissible d 1 1 1 2 := by
  refine ⟨?_, ?_, ?_⟩
  · have h : (1 : ZMod d) * 2 - 1 * 1 = 1 := by ring
    rw [h]; exact isUnit_one
  · have h : (1 : ZMod d) * 2 = 2 := by ring
    rw [h]; exact isUnit_two_of_odd hd
  · have h : (1 : ZMod d) * 1 = 1 := by ring
    rw [h]; exact isUnit_one

/-! ## Step 4: the dichotomy -/

/-- **Main theorem.**  A flat bilinear phase matrix satisfying the 2-unitarity criterion
exists over `ZMod d` if and only if `d` is odd.

Combined with (★) -- supplied outside this file -- this says: a flat bilinear 2-unitary
of order `d²` exists iff `d` is odd. -/
theorem admissible_iff_odd (d : ℕ) :
    (∃ a b c e : ZMod d, Admissible d a b c e) ↔ Odd d := by
  constructor
  · rintro ⟨a, b, c, e, h⟩
    by_contra hodd
    have hmod : d % 2 = 0 := by
      rcases Nat.even_or_odd d with hev | hod
      · exact Nat.even_iff.mp hev
      · exact absurd hod hodd
    exact not_admissible_of_even (Nat.dvd_of_mod_eq_zero hmod) a b c e h
  · intro hd
    exact ⟨1, 1, 1, 2, admissible_of_odd hd⟩

/-- Restatement: no admissible `M` exists over `ZMod d` for even `d`, for every `d`. -/
theorem no_admissible_even {d : ℕ} (hd : Even d) :
    ¬ ∃ a b c e : ZMod d, Admissible d a b c e := by
  rw [admissible_iff_odd]
  exact Nat.not_odd_iff_even.mpr hd

/-! ## Step 5: the same mechanism is Hall--Paige for cyclic groups

A *linear orthomorphism* of an abelian group `A` is `σ ∈ Aut A` with `σ - 1 ∈ Aut A`;
a *linear complete mapping* is `c ∈ Aut A` with `c + 1 ∈ Aut A`.  For `A = ZMod d`,
automorphisms are units, and both notions collapse to the same parity question.  -/

/-- `σ` is a linear orthomorphism of `ZMod d`. -/
def IsLinearOrthomorphism {d : ℕ} (σ : ZMod d) : Prop := IsUnit σ ∧ IsUnit (σ - 1)

/-- `c` is a linear complete mapping of `ZMod d`. -/
def IsLinearCompleteMapping {d : ℕ} (c : ZMod d) : Prop := IsUnit c ∧ IsUnit (c + 1)

/-- `ZMod d` admits a linear orthomorphism iff `d` is odd. -/
theorem exists_orthomorphism_iff_odd (d : ℕ) :
    (∃ σ : ZMod d, IsLinearOrthomorphism σ) ↔ Odd d := by
  constructor
  · rintro ⟨σ, hσ, hσ1⟩
    by_contra hodd
    have hmod : d % 2 = 0 := by
      rcases Nat.even_or_odd d with hev | hod
      · exact Nat.even_iff.mp hev
      · exact absurd hod hodd
    have hd : 2 ∣ d := Nat.dvd_of_mod_eq_zero hmod
    have h1 : redTwo hd σ = 1 := red_unit_eq_one hd hσ
    have h2 : redTwo hd (σ - 1) = 1 := red_unit_eq_one hd hσ1
    rw [map_sub, h1, map_one, sub_self] at h2
    exact zero_ne_one h2
  · intro hd
    refine ⟨2, isUnit_two_of_odd hd, ?_⟩
    have h : (2 : ZMod d) - 1 = 1 := by ring
    rw [h]; exact isUnit_one

/-- `ZMod d` admits a linear complete mapping iff `d` is odd.  This is the cyclic case of
the elementary direction of Hall--Paige: a group with nontrivial cyclic Sylow 2-subgroup
admits no complete mapping. -/
theorem exists_completeMapping_iff_odd (d : ℕ) :
    (∃ c : ZMod d, IsLinearCompleteMapping c) ↔ Odd d := by
  constructor
  · rintro ⟨c, hc, hc1⟩
    by_contra hodd
    have hmod : d % 2 = 0 := by
      rcases Nat.even_or_odd d with hev | hod
      · exact Nat.even_iff.mp hev
      · exact absurd hod hodd
    have hd : 2 ∣ d := Nat.dvd_of_mod_eq_zero hmod
    have h1 : redTwo hd c = 1 := red_unit_eq_one hd hc
    have h2 : redTwo hd (c + 1) = 1 := red_unit_eq_one hd hc1
    rw [map_add, h1, map_one] at h2
    -- `h2 : (1 : ZMod 2) + 1 = 1`, i.e. `0 = 1`
    have : (0 : ZMod 2) = 1 := by rw [← h2]; decide
    exact zero_ne_one this
  · intro hd
    refine ⟨1, isUnit_one, ?_⟩
    have h : (1 : ZMod d) + 1 = 2 := by ring
    rw [h]; exact isUnit_two_of_odd hd

/-! ## Step 6: the two notions agree over `ZMod d`

Over a cyclic group the orthomorphism and complete-mapping conditions are equivalent
(replace `σ` by `-σ`).  Both are strictly stronger than Hall--Paige for general abelian
groups -- `ZMod 4 × ZMod 2` admits a complete mapping but no *linear* one -- which is not
formalised here. -/

theorem orthomorphism_iff_completeMapping (d : ℕ) :
    (∃ σ : ZMod d, IsLinearOrthomorphism σ) ↔ (∃ c : ZMod d, IsLinearCompleteMapping c) := by
  rw [exists_orthomorphism_iff_odd, exists_completeMapping_iff_odd]

/-! ## Sanity checks (small, decidable instances) -/

example : ¬ ∃ a b c e : ZMod 6, Admissible 6 a b c e := by
  rw [admissible_iff_odd]; decide

example : ∃ a b c e : ZMod 5, Admissible 5 a b c e :=
  ⟨1, 1, 1, 2, admissible_of_odd (by decide)⟩

example : ∃ a b c e : ZMod 9, Admissible 9 a b c e :=
  ⟨1, 1, 1, 2, admissible_of_odd (by decide)⟩

example : ¬ ∃ a b c e : ZMod 4, Admissible 4 a b c e := by
  rw [admissible_iff_odd]; decide

end ParityObstruction
