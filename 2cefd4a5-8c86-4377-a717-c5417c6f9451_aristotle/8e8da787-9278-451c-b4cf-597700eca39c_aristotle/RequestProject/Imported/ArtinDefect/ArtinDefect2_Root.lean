/-
  ArtinDefect2.lean
  -----------------
  The defect-1/2 certificates for ALL THREE binary polyhedral groups,
  stated in MULTIPLICITY form.

  ---------------------------------------------------------------------------
  WHY MULTIPLICITY FORM

  In file 1 the SL(2,5) certificate was stated as an identity of character
  VALUES in ℤ[√5].  That works but it obscures the content and drags in a
  quadratic field.  Every certificate here is instead an identity of
  MULTIPLICITY VECTORS in ℤ^r (r = number of irreducible characters), i.e.
  coordinates with respect to the basis Irr(G).  Three consequences:

    * the statements become pure ℤ-vector identities, decidable by `decide`
      with no algebraic number theory at all;
    * the orthogonality checks of file 1 (`ip_A_A = 3`, `ip_B_X = 0`, …)
      become immediate coordinate facts rather than separate computations;
    * the SAME formulation covers the tetrahedral case (values in ℤ[ω]) and
      the octahedral case (values in ℤ[√-2]) without changing rings.

  ---------------------------------------------------------------------------
  THE DATA  (exact LP optima; deterministic single-pass extraction)

  For each binary polyhedral group 2.G, G of triangle type (2,3,n):

      n = 3  SL(2,3) = 2.A₄   binary tetrahedral    |G| = 24
      n = 4  GL(2,3) = 2.S₄   binary octahedral     |G| = 48
      n = 5  SL(2,5) = 2.A₅   binary icosahedral    |G| = 120

  the faithful degree-2 character χ (the tetrahedral / octahedral /
  ICOSAHEDRAL Artin representation) has defect exactly 1/2, and the optimal
  certificate always has:

      POSITIVE part induced from  C_{2n}  (preimage of the n-fold axis)
      NEGATIVE part induced from  C₆      (preimage of the 3-fold axis)

  For n = 3 these two subgroups COINCIDE, and the certificate degenerates from
  the two-term shape `2(χ+R) − 2R` into a three-term "triangle" using three
  distinct linear characters of the single C₆.  That degeneration is the only
  difference between the three cases.

  ---------------------------------------------------------------------------
  STATUS / WHAT IS AND IS NOT CLAIMED

  Proved here: three finite ℤ-vector identities, plus their degree checks.

  NOT proved here, and deliberately left as hypotheses (same gap as file 1):
    (a) that the listed vectors really are induced from linear characters of
        the named cyclic subgroups — they are tabulated, not derived;
    (b) that 1/2 is OPTIMAL (the LP lower bound).  Only the UPPER bound is
        needed for the pole theorem, so nothing downstream depends on (b).

  The analytic consequence is `pole_bound_of_half_certificate` from file 1;
  it applies verbatim to each certificate below.
-/

import Mathlib.Tactic

namespace ArtinDefect2

/-- A multiplicity vector: coordinates w.r.t. `Irr(G)`. -/
abbrev Mult (r : ℕ) := Fin r → ℤ

/-- Standard basis vector: the irreducible character with index `i`. -/
def e {r : ℕ} (i : Fin r) : Mult r := fun j => if j = i then 1 else 0

/-- Degree of a virtual character from its multiplicity vector and the
    list of irreducible degrees. -/
def dim {r : ℕ} (deg : Fin r → ℤ) (v : Mult r) : ℤ := ∑ i, v i * deg i

/-! ## Section 1.  Binary tetrahedral, `SL(2,3) = 2.A₄`,  n = 3

`Irr` degrees: `[1, 1, 1, 2, 2, 2, 3]`.  Target: `χ = Irr 3`, a faithful
degree-2 character (the TETRAHEDRAL Artin representation; this case is a
theorem of Langlands).

All three monomial characters below are induced from the SAME cyclic `C₆`,
using three different linear characters.  Each has degree 4 and is a sum of
two of the three faithful degree-2 characters. -/

def degSL23 : Fin 7 → ℤ := ![1, 1, 1, 2, 2, 2, 3]

/-- `Ind_{C₆} λ₀ = χ₃ + χ₅`. -/
def P₀ : Mult 7 := ![0, 0, 0, 1, 0, 1, 0]
/-- `Ind_{C₆} λ₁ = χ₃ + χ₄`. -/
def P₁ : Mult 7 := ![0, 0, 0, 1, 1, 0, 0]
/-- `Ind_{C₆} λ₄ = χ₄ + χ₅`  (the negative-mass term). -/
def N₃ : Mult 7 := ![0, 0, 0, 0, 1, 1, 0]

/-- **Binary tetrahedral certificate** (triangle form):
    `Ind λ₀ + Ind λ₁ − Ind λ₄ = 2χ₃`.  Negative mass `1`, so `def(χ₃) ≤ 1/2`. -/
theorem cert_SL23 : ∀ i : Fin 7, P₀ i + P₁ i - N₃ i = 2 * e (3 : Fin 7) i := by
  decide

/-- Degrees: `4 + 4 − 4 = 4 = 2 · 2`. -/
theorem deg_SL23 :
    dim degSL23 P₀ + dim degSL23 P₁ - dim degSL23 N₃ = 2 * 2 := by
  decide

/-! ## Section 2.  Binary octahedral, `GL(2,3) = 2.S₄`,  n = 4

`Irr` degrees: `[1, 1, 2, 2, 2, 3, 3, 4]`.  Target: `χ = Irr 2`, faithful of
degree 2 (the OCTAHEDRAL Artin representation; a theorem of Tunnell).

Positive part from a cyclic `C₈`; negative part from a cyclic `C₆`. -/

def degGL23 : Fin 8 → ℤ := ![1, 1, 2, 2, 2, 3, 3, 4]

/-- `Ind_{C₈} λ = χ₂ + χ₇`, degree `2 + 4 = 6`. -/
def P₄ : Mult 8 := ![0, 0, 1, 0, 0, 0, 0, 1]
/-- `Ind_{C₆} μ = 2χ₇`, degree `8`  (the negative-mass term). -/
def N₄ : Mult 8 := ![0, 0, 0, 0, 0, 0, 0, 2]

/-- **Binary octahedral certificate**: `2·Ind_{C₈}λ − Ind_{C₆}μ = 2χ₂`. -/
theorem cert_GL23 : ∀ i : Fin 8, 2 * P₄ i - N₄ i = 2 * e (2 : Fin 8) i := by
  decide

/-- Degrees: `2·6 − 8 = 4 = 2 · 2`. -/
theorem deg_GL23 : 2 * dim degGL23 P₄ - dim degGL23 N₄ = 2 * 2 := by
  decide

/-! ## Section 3.  Binary icosahedral, `SL(2,5) = 2.A₅`,  n = 5

`Irr` degrees: `[1, 2, 2, 3, 3, 4, 4, 5, 6]`.  Target: `χ = Irr 1`, faithful of
degree 2 — the ICOSAHEDRAL Artin representation.  THIS CASE IS OPEN.

Positive part from a cyclic `C₁₀`; negative part from a cyclic `C₆`.
This is the same certificate as file 1, restated in multiplicity coordinates:
`Ind_{C₁₀}λ = χ₁ + χ₅ + χ₈` and `Ind_{C₆}μ = 2χ₅ + 2χ₈`, where the indices are
the 0-based `Fin 9` coordinates used below (the original 1-based labels
`χ₂ + χ₄ + χ₆` / `2χ₄ + 2χ₆` refer to the same three constituents, of degrees
`2`, `4`, `6`). -/

def degSL25 : Fin 9 → ℤ := ![1, 2, 2, 3, 3, 4, 4, 5, 6]

/-- `Ind_{C₁₀} λ = χ₁ + χ₅ + χ₈`, degree `2 + 4 + 6 = 12`. -/
def P₅ : Mult 9 := ![0, 1, 0, 0, 0, 1, 0, 0, 1]
/-- `Ind_{C₆} μ = 2χ₅ + 2χ₈`, degree `8 + 12 = 20`  (the negative-mass term). -/
def N₅ : Mult 9 := ![0, 0, 0, 0, 0, 2, 0, 0, 2]

/-- **Binary icosahedral certificate**: `2·Ind_{C₁₀}λ − Ind_{C₆}μ = 2χ`.
    Equivalently `L(s,χ)² · L(s,μ,K₂₀) = L(s,λ,K₁₂)²`. -/
theorem cert_SL25 : ∀ i : Fin 9, 2 * P₅ i - N₅ i = 2 * e (1 : Fin 9) i := by
  decide

/-- Degrees: `2·12 − 20 = 4 = 2 · 2`. -/
theorem deg_SL25 : 2 * dim degSL25 P₅ - dim degSL25 N₅ = 2 * 2 := by
  decide

/-- The negative term is orthogonal to the target: `⟨Ind_{C₆}μ, χ⟩ = 0`.
    In multiplicity coordinates this is just `N₅ 1 = 0` — it is a coordinate
    fact, not a separate inner-product computation.  NOTE: this does NOT show
    the negative mass is necessary (that is the LP lower bound, not proved
    here); it shows only that `N₅` strips the non-`χ` constituents of `P₅`. -/
theorem N₅_orthogonal : N₅ 1 = 0 := by decide

/-! ## Section 4.  The two shapes, abstractly

Both certificate shapes are instances of trivial ring identities.  Isolating
them makes clear that all the mathematical content is in the CLAIM that the
listed vectors are induced from linear characters — not in the algebra. -/

/-- Two-term shape (`n = 4, 5`): if a monomial character splits as `χ + R` and
    another equals `2R`, then `2(χ + R) − 2R = 2χ`. -/
theorem two_term_shape {r : ℕ} (chi R : Mult r) :
    (fun i => 2 * (chi i + R i) - 2 * R i) = (fun i => 2 * chi i) := by
  funext i; ring

/-- Triangle shape (`n = 3`, the degenerate case where the positive and
    negative subgroups coincide): `(χ+b) + (χ+c) − (b+c) = 2χ`. -/
theorem triangle_shape {r : ℕ} (chi b c : Mult r) :
    (fun i => (chi i + b i) + (chi i + c i) - (b i + c i)) = (fun i => 2 * chi i) := by
  funext i; ring

/-! ## Section 4b.  Degrees and the analytic bound, in general form

The three degree checks above were verified numerically by `decide`.  They are
in fact automatic: `dim` is linear, so a multiplicity identity forces the
corresponding degree identity.  Likewise the analytic consequence (a pole of
`L(s,χ)` forces a high-order zero of the negative abelian factor) depends only
on the *shape* of the certificate, not on the group. -/

/-- The degree of an irreducible character, read off its multiplicity vector. -/
theorem dim_e {r : ℕ} (deg : Fin r → ℤ) (i : Fin r) : dim deg (e i) = deg i := by
  simp [dim, e]

/-- Two-term shape: a multiplicity identity `c·P − N = 2·χ_k` forces the degree
    identity `c·deg P − deg N = 2·deg χ_k`. -/
theorem dim_certificate {r : ℕ} (deg : Fin r → ℤ) (c : ℤ) (P N : Mult r) (k : Fin r)
    (h : ∀ i, c * P i - N i = 2 * e k i) :
    c * dim deg P - dim deg N = 2 * deg k := by
  have hs : ∑ i, (c * P i - N i) * deg i = ∑ i, (2 * e k i) * deg i := by
    simp only [h]
  rw [← dim_e deg k]
  simp only [sub_mul, Finset.sum_sub_distrib, dim, Finset.mul_sum, mul_assoc] at hs ⊢
  linarith [hs]

/-- Triangle shape: `P + Q − N = 2·χ_k` forces the corresponding degree
    identity. -/
theorem dim_triangle {r : ℕ} (deg : Fin r → ℤ) (P Q N : Mult r) (k : Fin r)
    (h : ∀ i, P i + Q i - N i = 2 * e k i) :
    dim deg P + dim deg Q - dim deg N = 2 * deg k := by
  have hs : ∑ i, (P i + Q i - N i) * deg i = ∑ i, (2 * e k i) * deg i := by
    simp only [h]
  rw [← dim_e deg k]
  simp only [sub_mul, add_mul, Finset.sum_sub_distrib, Finset.sum_add_distrib, dim,
    Finset.mul_sum, mul_assoc] at hs ⊢
  linarith [hs]

/-- The three degree checks re-derived from the multiplicity certificates,
    with no further computation. -/
theorem deg_SL23' :
    dim degSL23 P₀ + dim degSL23 P₁ - dim degSL23 N₃ = 2 * degSL23 3 :=
  dim_triangle degSL23 P₀ P₁ N₃ 3 cert_SL23

theorem deg_GL23' : 2 * dim degGL23 P₄ - dim degGL23 N₄ = 2 * degGL23 2 :=
  dim_certificate degGL23 2 P₄ N₄ 2 cert_GL23

theorem deg_SL25' : 2 * dim degSL25 P₅ - dim degSL25 N₅ = 2 * degSL25 1 :=
  dim_certificate degSL25 2 P₅ N₅ 1 cert_SL25

/-- Analytic consequence, in the form used downstream.  If the orders of
    vanishing at a point `s₀` satisfy the certificate relation
    `2·ord χ = c·ord(positive part) − ord(negative part)` with `c ≥ 0` and the
    positive (monomial, hence entire) part having non-negative order, then a
    pole of `L(s,χ)` of order `p` forces the negative abelian factor to vanish
    to order at least `2p`. -/
theorem pole_bound_of_certificate (c ordChi ordPos ordNeg p : ℤ)
    (hc : 0 ≤ c) (hpos : 0 ≤ ordPos) (hcert : 2 * ordChi = c * ordPos - ordNeg)
    (hpole : ordChi = -p) : 2 * p ≤ ordNeg := by
  nlinarith

/-! ## Section 5.  Conjecture to test next

  CONJECTURE (uniform binary-polyhedral certificate).  Let `2.G` be the binary
  polyhedral group attached to the triangle type `(2,3,n)`, `n = 3,4,5`, and
  let `χ` be a faithful degree-2 character.  Then `def(χ) = 1/2`, and an
  optimal certificate exists whose positive part is induced from a cyclic
  `C_{2n}` (the preimage of the n-fold axis) and whose negative part is
  induced from a cyclic `C₆` (the preimage of the 3-fold axis).

  Verified computationally for n = 3, 4, 5 (this file).

  TEST TO RUN: the same statement for `SL(2,7)`, where the LP also returns
  max defect 1/2 but the defect-1/2 characters have degree 6, not 2.  If the
  negative part there is again a cyclic C₆, the pattern is about the 3-fold
  axis rather than about degree 2.  If it is not, the pattern is special to
  the binary polyhedral family.

  CAUTION worth stating plainly: `SL(2,3)` (Langlands) and `GL(2,3)` (Tunnell)
  are PROVED cases of Artin's conjecture, yet they carry the same defect 1/2
  as the open icosahedral case.  So the defect measures failure of the
  positive-induction argument, NOT difficulty of the problem.  What separates
  n = 3,4 from n = 5 is solvability of the quotient (A₄ and S₄ are solvable,
  A₅ is not), which the defect does not see.
-/

end ArtinDefect2
