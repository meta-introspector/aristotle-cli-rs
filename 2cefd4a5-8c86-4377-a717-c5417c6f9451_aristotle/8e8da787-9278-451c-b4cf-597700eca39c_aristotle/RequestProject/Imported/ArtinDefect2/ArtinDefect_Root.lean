/-
  ArtinDefect.lean
  ----------------
  The "Artin defect" certificate for the icosahedral case.

  CONTEXT.
  For a finite group G and an irreducible character χ, Brauer's induction theorem
  writes χ as a ℤ-combination of characters induced from linear characters of
  subgroups.  Each such induced character has an Artin L-function equal to an
  abelian Hecke L-function, hence entire.  So L(s,χ) is a *ratio* of Hecke
  L-functions, and a pole of L(s,χ) can only sit at a zero of a denominator.

  Define the DEFECT of χ as the minimum total negative mass over all such
  decompositions:

      def(χ) = min { Σ b_j : χ = Σ a_i Ind λ_i − Σ b_j Ind μ_j,  a, b ≥ 0 }.

  This is a rational linear program over the finitely many pairs (H, λ) with
  H ≤ G and λ a linear character of H.  Computation (LP, exact optimum):

      G = SL(2,5) = 2.A₅  (binary icosahedral):
        deg 1 : 0     deg 3, 3' : 1/4     deg 5 : 0     deg 6 : 0
        deg 2, 2' : 1/2   deg 4 (faithful) : 1/2   deg 4' : 2/5

  The two degree-2 faithful characters are the ICOSAHEDRAL ARTIN
  REPRESENTATIONS.  Their defect is 1/2, so 2χ has negative mass exactly 1:
  a single Hecke L-function in the denominator.  This file certifies that
  decomposition and derives the pole bound from it.

  STATUS: file 1.  Section 1 is a closed finite computation.
  Section 2 is the abstract order-of-vanishing consequence.
  Section 3 states the open conjecture def(χ) ≤ 1/2 in a form that is a finite
  LP feasibility question for each fixed G.
  Companion files: `ArtinDefect2.lean` (multiplicity form, `2T`, `GL(2,3)`,
  `2I`) and `ArtinDefect2O.lean` (the binary octahedral group `2O`).

  WHAT IS NOT CLAIMED.  Nothing here proves Artin's conjecture for any
  representation.  The certificates yield CONDITIONAL pole bounds: a pole of
  the Artin L-function forces a high-order zero of an explicit abelian Hecke
  L-function.  Numerical survey work, where it appears, is evidence in a
  bounded region under stated assumptions, and any residue bound coming from
  the theta-residual pole test must carry the qualifier `|γ| ≳ 2`, since that
  test is identically blind at `s₀ = 1/2`.  Two survey fields (discriminant
  radicals 20867 and 44713) fail the analytic test with every ingredient
  independently certified; they are recorded as OPEN, not explained away.

  NOTE ON `ArtinDefect3.lean`.  The two CORRECTION remarks below refer to a
  file `ArtinDefect3.lean`, which is NOT part of this project copy; the
  cross-references are kept because the corrections they record stand on their
  own, but the reader should not expect to find that file here.

  All character values below were computed independently (Burnside class-sum
  eigenvector method) and cross-checked against the known character table of
  SL(2,5).
-/

import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.Tactic

namespace ArtinDefect

/-! ## Section 1.  The icosahedral certificate (finite, decidable)

`SL(2,5)` has 9 conjugacy classes.  We index them by `Fin 9` in the order

    i :  0    1    2    3    4    5     6     7    8
  ord :  1    5    5    4    2   10    10     6    3
 size :  1   12   12   30    1   12    12    20   20

Character values of the faithful 2-dimensional characters involve the golden
ratio, so they are not integral.  We therefore work throughout with values
DOUBLED, which lands everything in `ℤ[√5]`.

  `X` := 2·χ₂            where χ₂ is a faithful degree-2 (icosahedral) character
  `A` := 2·Ind_{C₁₀}^{G} λ   λ a faithful linear character of a cyclic C₁₀
  `B` :=   Ind_{C₆}^{G}  μ   μ the ORDER-TWO linear character of a cyclic C₆
                              (kernel of order 3 — NOT faithful; see below)

CORRECTION (see `ArtinDefect3.lean`, where `A` and `B` are computed from the
group `SL(2,ℤ/5)` itself rather than tabulated).  The character `λ` is indeed a
faithful linear character of a cyclic `C₁₀`, and the tabulated `A` is `2·Ind λ`.
The character `μ`, however, is NOT faithful: the tabulated `B` is the character
induced from the ORDER-TWO linear character of `C₆` (the one with kernel the
cyclic subgroup of order 3).  A faithful `μ` would give the values `1, -1` on
the classes of order `6, 3` instead of the tabulated `-2, 2`, and would not
satisfy the certificate.  Everything else in this file is unaffected: `B` is a
monomial character either way, which is all the pole bound uses.

Note `A` and `B` are (twice) monomial characters: their Artin L-functions are
abelian Hecke L-functions over the degree-12 and degree-20 fixed fields.
-/

/-- Values are elements of `ℤ[√5]`; `⟨a, b⟩` denotes `a + b√5`. -/
abbrev V := Zsqrtd (5 : ℤ)

/-- `2 · χ₂`, twice a faithful degree-2 (icosahedral) character of `SL(2,5)`. -/
def X : Fin 9 → V
  | 0 => ⟨ 4,  0⟩
  | 1 => ⟨-1, -1⟩
  | 2 => ⟨-1,  1⟩
  | 3 => ⟨ 0,  0⟩
  | 4 => ⟨-4,  0⟩
  | 5 => ⟨ 1,  1⟩
  | 6 => ⟨ 1, -1⟩
  | 7 => ⟨ 2,  0⟩
  | 8 => ⟨-2,  0⟩

/-- `2 · Ind_{C₁₀}^{G} λ`, twice a monomial character of degree 12. -/
def A : Fin 9 → V
  | 0 => ⟨ 24,  0⟩
  | 1 => ⟨ -1, -1⟩
  | 2 => ⟨ -1,  1⟩
  | 3 => ⟨  0,  0⟩
  | 4 => ⟨-24,  0⟩
  | 5 => ⟨  1,  1⟩
  | 6 => ⟨  1, -1⟩
  | 7 => ⟨  0,  0⟩
  | 8 => ⟨  0,  0⟩

/-- `Ind_{C₆}^{G} μ`, a monomial character of degree 20.  Here `μ` is the
order-two linear character of `C₆` (kernel of order 3), not a faithful one; see
the CORRECTION in the header and `ArtinDefect3.indChar_muB_eq`. -/
def B : Fin 9 → V
  | 0 => ⟨ 20, 0⟩
  | 1 => ⟨  0, 0⟩
  | 2 => ⟨  0, 0⟩
  | 3 => ⟨  0, 0⟩
  | 4 => ⟨-20, 0⟩
  | 5 => ⟨  0, 0⟩
  | 6 => ⟨  0, 0⟩
  | 7 => ⟨ -2, 0⟩
  | 8 => ⟨  2, 0⟩

/-- **The icosahedral certificate.**  As class functions on `SL(2,5)`,
    `2·χ₂ = 2·Ind_{C₁₀}λ − Ind_{C₆}μ`.
    Equivalently `L(s,χ₂)² · L(s,μ,K₂₀) = L(s,λ,K₁₂)²`. -/
theorem icosahedral_certificate : ∀ i : Fin 9, X i = A i - B i := by
  decide

/-- Degree check: `2·2 = 2·12 − 20`. -/
theorem degree_check : (X 0).re = 2 * 12 - 20 := by decide

/-! ### Consistency checks on the tabulated data

All the class functions above are real valued, and the classes are closed under
inversion, so the Frobenius inner product of two of them is
`(1/120) · Σ_i |C_i| · f i · g i`.  Checking these inner products is an
independent confirmation that `X`, `A`, `B` really are (multiples of) characters
of `SL(2,5)` with the claimed decomposition.  We record the unnormalised sums,
i.e. `120 · ⟨f, g⟩`.

(These value-level checks are NOT superseded by the multiplicity form in
`ArtinDefect2.lean`: there the decomposition is assumed as coordinates, whereas
here it is verified against the raw character values.) -/

/-- The sizes of the nine conjugacy classes of `SL(2,5)`, in the same order. -/
def size : Fin 9 → V
  | 0 => ⟨ 1, 0⟩
  | 1 => ⟨12, 0⟩
  | 2 => ⟨12, 0⟩
  | 3 => ⟨30, 0⟩
  | 4 => ⟨ 1, 0⟩
  | 5 => ⟨12, 0⟩
  | 6 => ⟨12, 0⟩
  | 7 => ⟨20, 0⟩
  | 8 => ⟨20, 0⟩

/-- The class sizes add up to `|SL(2,5)| = 120`. -/
theorem size_total : ∑ i : Fin 9, size i = (120 : V) := by decide

/-- Unnormalised Frobenius inner product `120 · ⟨f, g⟩`. -/
def ip (f g : Fin 9 → V) : V := ∑ i : Fin 9, size i * f i * g i

/-- `⟨χ₂, χ₂⟩ = 1`: the doubled character `X = 2χ₂` has norm `4`, so `χ₂` is
    irreducible. -/
theorem ip_X_X : ip X X = 4 * 120 := by decide

/-- `⟨Ind_{C₁₀}λ, Ind_{C₁₀}λ⟩ = 3`, i.e. the degree-12 monomial character is a
    sum of three distinct irreducibles (namely `χ₂ + χ₄ + χ₆`). -/
theorem ip_A_A : ip A A = 4 * 3 * 120 := by decide

/-- `⟨Ind_{C₆}μ, Ind_{C₆}μ⟩ = 8`  (consistent with `Ind_{C₆}μ = 2χ₄ + 2χ₆`,
    since `2² + 2² = 8`). -/
theorem ip_B_B : ip B B = 8 * 120 := by decide

/-- `⟨Ind_{C₁₀}λ, χ₂⟩ = 1`: the icosahedral character occurs exactly once in the
    degree-12 monomial character. -/
theorem ip_A_X : ip A X = 4 * 120 := by decide

/-- `⟨Ind_{C₆}μ, χ₂⟩ = 0`: the icosahedral character does not occur in the
    degree-20 monomial character.  So `B` serves only to strip the non-`χ₂`
    constituents `χ₄, χ₆` from `A`.

    CAUTION.  This does NOT show that the negative mass is necessary.  That is
    the LP *lower* bound (optimality of 1/2), which is not proved anywhere in
    this development.  Only the upper bound — existence of the certificate — is
    needed for the pole theorems below, so nothing downstream depends on it. -/
theorem ip_B_X : ip B X = 0 := by decide


/-! ## Section 2.  The pole bound

We abstract the analytic input.  For a fixed `s₀ ∈ ℂ` let `ord π` denote the
order of vanishing at `s₀` of `L(s, π)`, extended additively to virtual
characters.  The only facts used are:

  (i)  `ord` is additive:  `ord (φ + ψ) = ord φ + ord ψ`;
  (ii) for a MONOMIAL character σ, `L(s,σ)` is an abelian Hecke L-function
       hence entire, so `0 ≤ ord σ`.

Applying `ord` to the certificate gives `2·ord χ₂ = 2·ord λ − ord μ`.
-/

/-- If the icosahedral Artin L-function has a pole of order `p > 0` at `s₀`,
    then the abelian Hecke L-function `L(s, μ, K₂₀)` vanishes there to order
    at least `2p`.  In particular a simple zero of `L(s,μ,K₂₀)` cannot produce
    a pole: the zero must be (at least) DOUBLE. -/
theorem pole_forces_double_zero
    (ordχ ordLam ordμ p : ℤ)
    (hLam : 0 ≤ ordLam)
    (hcert : 2 * ordχ = 2 * ordLam - ordμ)
    (hpole : ordχ = -p) :
    2 * p ≤ ordμ := by
  omega

/-- Contrapositive form: if `L(s,μ,K₂₀)` has a zero of order `< 2` at `s₀`,
    then `L(s,χ₂)` is holomorphic there. -/
theorem holomorphic_of_low_order
    (ordχ ordLam ordμ : ℤ)
    (hLam : 0 ≤ ordLam)
    (hcert : 2 * ordχ = 2 * ordLam - ordμ)
    (hlow : ordμ ≤ 1) :
    0 ≤ ordχ := by
  omega

/-! ## Section 3.  The conjecture

  CONJECTURE (defect bound).  For every finite group `G` and every irreducible
  character `χ` of `G`, `def(χ) ≤ 1/2`.

  Equivalently: for every `χ` there are monomial characters `σ_i`, `τ_j` and
  nonnegative integers `a_i`, `b_j` with `Σ b_j = 1` such that

        2χ + Σ b_j τ_j = Σ a_i σ_i.

  Analytic consequence, if true: a pole of order `p` of ANY Artin L-function at
  `s₀ ≠ 1` forces a zero of order `≥ 2p` of an explicit abelian Hecke
  L-function at `s₀`.  This is a sharp, optimal form of the Foote–Murty
  inequality (Math. Proc. Camb. Phil. Soc. 105 (1989) 5–11) and is the
  mechanism behind Foote–Wales, "Zeros of order 2 of Dedekind zeta functions
  and Artin's conjecture" (J. Algebra 131 (1990) 226–257).

  EVIDENCE (exact LP optima, computed):
    S₃, A₄, S₄, and every ℤ/q ⋊ ℤ/(q−1)   : all defects 0   (M-groups)
    A₅                                     : max 2/5
    A₆                                     : max 3/7   (also 1/19 appears)
    PSL(2,7)                               : max 1/3
    SL(2,3) = 2T  binary tetrahedral       : max 1/2
    GL(2,3) = 2.S_4^-, a double cover of S_4,
              NOT the binary octahedral group             : max 1/2
    2O            binary octahedral        : max 1/2   (see `ArtinDefect2O.lean`)
    SL(2,5) = 2I  binary icosahedral       : max 1/2
    SL(2,7)                                : max 1/2

  Observed refinement: the value 1/2 occurs ONLY for faithful characters of
  Schur double covers; the simple groups themselves stay strictly below 1/2.

  For each FIXED `G` this is a finite rational LP feasibility problem, so it is
  decidable; the content of the conjecture is uniformity in `G`.

  SCOPE OF THE `C₆` PATTERN (a limitation, NOT a refutation).  For each of the
  three binary polyhedral groups `2T = SL(2,3)`, `2O`, `2I = SL(2,5)` the
  optimal certificate has its negative mass on a cyclic `C₆`; this is verified
  throughout the family (`ArtinDefect2.lean` Sections 1 and 3, and
  `ArtinDefect2O.lean` for `2O` — note that the group `GL(2,3)` treated in
  `ArtinDefect2.lean` Section 2 is `2.S₄⁻` and is NOT a member of the family).
  What does NOT generalise is the pattern beyond the family.  For `SL(2,7)`,
  which is not binary polyhedral, at a degree-6 character,
  an optimal integral certificate at `2χ` is
        2χ = 2·Ind_{C₈}λ + 2·Ind_{C₁₄}μ₁ + 2·Ind_{C₁₄}μ₂ − Ind_{Z}ν
             (degrees: 2·42 + 2·24 + 2·24 − 168 = 12 = 2·6),
  negative mass exactly 1, supported on the CENTER `Z = C₂`.  A `C₆` exists in
  `SL(2,7)` and is not used.  So the `C₆` pattern is special to the `(2,3,n)`
  binary polyhedral family: `SL(2,7)` refutes only a broader generalisation,
  and is not a counterexample to the family statement of `ArtinDefect2.lean`
  Section 5.

  ALSO REFUTED (a second idea, recorded with its correction).  Define `N(χ)` as
  the least `N` admitting an INTEGRAL certificate for `Nχ` at negative mass
  `N·def(χ)`.  This was proposed as an invariant finer than `def`, on the basis
  of a fractional `SL(2,7)` certificate suggesting `N = 6` there.  That was an
  artifact of reading a single LP vertex: `SL(2,7)` in fact has `N = 2`, as the
  integral certificate displayed above shows.  Computed across
  SL(2,3), GL(2,3), A₅, SL(2,5), S₅, SL(2,7), A₆ — 16 non-monomial characters
  in all — `N(χ)` equals the DENOMINATOR of `def(χ)` in lowest terms, without
  exception (e.g. A₆ degree 5: `def = 1/19`, `N = 19`, attained; and at `N = 1`
  there is a genuine integrality gap, so `N` is not vacuous).  Hence `N`
  carries no information beyond `def`, and does NOT separate the tetrahedral,
  octahedral and icosahedral cases, which all have `def = 1/2`, `N = 2`.

  What this does record is a nontrivial integrality property of the monomial
  cone: the LP optimum is attained at a lattice point as soon as `N·def(χ) ∈ ℤ`.
  That property is itself worth proving or refuting.
-/

/-- Schematic form of a defect-`1/2` certificate, stated for `Fin n`-indexed
    class functions valued in an arbitrary commutative ring.

    CONVENTION: `twoChi` holds `2χ` (doubled, so that golden-ratio values become
    integral in `ℤ[√5]`), `sigma` holds doubled monomial characters, and `tau`
    holds the single monomial character carrying the negative mass.  Total
    negative mass `1` against `2χ` is precisely `def(χ) = 1/2`. -/
structure HalfCertificate (R : Type*) [CommRing R] (n m : ℕ) where
  twoChi : Fin n → R
  sigma  : Fin m → Fin n → R
  coeff  : Fin m → ℕ
  tau    : Fin n → R
  /-- `2χ + τ = Σ aᵢ σᵢ`. -/
  cert   : ∀ i, twoChi i + tau i = ∑ j : Fin m, (coeff j : R) * sigma j i

/-- The `SL(2,5)` data assembled as a `HalfCertificate`.  Here `m = 1`,
    `σ₀ = A = 2·Ind_{C₁₀}λ` and `τ = B = Ind_{C₆}μ`.

    NOTE for Aristotle: the sum over `Fin 1` should collapse via
    `Fin.sum_univ_one`; if `decide` stalls on the `Finset.sum`, try
    `intro i; fin_cases i <;> simp [X, A, B, Fin.sum_univ_one] <;> rfl`. -/
def icosahedralHalfCertificate : HalfCertificate V 9 1 where
  twoChi := X
  sigma  := fun _ => A
  coeff  := fun _ => 1
  tau    := B
  cert   := by
    intro i
    fin_cases i <;> simp [X, A, B]


/-- The abstract pole bound attached to a defect-`1/2` certificate.

    Suppose orders of vanishing at a fixed point `s₀` are additive, that the
    monomial characters `σ_j` contribute nonnegative orders `ordSigma j`
    (their L-functions being entire abelian Hecke L-functions), and that
    applying `ord` to the certificate `2χ + τ = Σ aⱼ σⱼ` gives
    `2·ordChi + ordTau = Σ aⱼ · ordSigma j`.  Then a pole of order `p` of
    `L(s, χ)` forces `L(s, τ)` to vanish to order at least `2p`. -/
theorem pole_bound_of_half_certificate {m : ℕ}
    (ordChi ordTau p : ℤ) (ordSigma : Fin m → ℤ) (coeff : Fin m → ℕ)
    (hSigma : ∀ j, 0 ≤ ordSigma j)
    (hcert : 2 * ordChi + ordTau = ∑ j : Fin m, (coeff j : ℤ) * ordSigma j)
    (hpole : ordChi = -p) :
    2 * p ≤ ordTau := by
  have hsum : 0 ≤ ∑ j : Fin m, (coeff j : ℤ) * ordSigma j :=
    Finset.sum_nonneg fun j _ => mul_nonneg (Int.natCast_nonneg _) (hSigma j)
  omega

end ArtinDefect
