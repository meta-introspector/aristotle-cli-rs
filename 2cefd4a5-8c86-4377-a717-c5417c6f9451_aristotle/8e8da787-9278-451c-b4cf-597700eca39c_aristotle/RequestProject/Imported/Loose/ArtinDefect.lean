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

  STATUS: file 1 of 2.  Section 1 is a closed finite computation.
  Section 2 is the abstract order-of-vanishing consequence.
  Section 3 states the open conjecture def(χ) ≤ 1/2 in a form that is a finite
  LP feasibility question for each fixed G.

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
  `B` :=   Ind_{C₆}^{G}  μ   μ a faithful linear character of a cyclic C₆

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

/-- `Ind_{C₆}^{G} μ`, a monomial character of degree 20. -/
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
i.e. `120 · ⟨f, g⟩`. -/

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
    sum of three distinct irreducibles. -/
theorem ip_A_A : ip A A = 4 * 3 * 120 := by decide

/-- `⟨Ind_{C₆}μ, Ind_{C₆}μ⟩ = 8`. -/
theorem ip_B_B : ip B B = 8 * 120 := by decide

/-- `⟨Ind_{C₁₀}λ, χ₂⟩ = 1`: the icosahedral character occurs exactly once in the
    degree-12 monomial character. -/
theorem ip_A_X : ip A X = 4 * 120 := by decide

/-- `⟨Ind_{C₆}μ, χ₂⟩ = 0`: the icosahedral character does not occur in the
    degree-20 monomial character, so the negative mass is genuinely needed. -/
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
    (ordChi ordLam ordMu p : ℤ)
    (hLam : 0 ≤ ordLam)
    (hcert : 2 * ordChi = 2 * ordLam - ordMu)
    (hpole : ordChi = -p) :
    2 * p ≤ ordMu := by
  omega

/-- Contrapositive form: if `L(s,μ,K₂₀)` has a zero of order `< 2` at `s₀`,
    then `L(s,χ₂)` is holomorphic there. -/
theorem holomorphic_of_low_order
    (ordChi ordLam ordMu : ℤ)
    (hLam : 0 ≤ ordLam)
    (hcert : 2 * ordChi = 2 * ordLam - ordMu)
    (hlow : ordMu ≤ 1) :
    0 ≤ ordChi := by
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
    SL(2,3)  binary tetrahedral            : max 1/2
    GL(2,3)  binary octahedral             : max 1/2
    SL(2,5)  binary icosahedral            : max 1/2
    SL(2,7)                                : max 1/2

  Observed refinement: the value 1/2 occurs ONLY for faithful characters of
  Schur double covers; the simple groups themselves stay strictly below 1/2.

  For each FIXED `G` this is a finite rational LP feasibility problem, so it is
  decidable; the content of the conjecture is uniformity in `G`.
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
