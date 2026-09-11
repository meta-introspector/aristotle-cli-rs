/-
  ArtinDefect2O.lean
  ------------------
  The defect-1/2 certificate for the BINARY OCTAHEDRAL group `2O`, in multiplicity form,
  matching the conventions of `ArtinDefect2.lean`.

  ---------------------------------------------------------------------------
  WHY THIS FILE EXISTS: a correction

  `ArtinDefect2.lean` Section 2 originally stated its certificate for "`GL(2,3)`, binary
  octahedral".  That identification is WRONG.  Every finite subgroup of the unit
  quaternions has exactly one involution (the central `-1`).  Counting involutions:

        SL(2,3)   order  24    1 involution     -> IS binary tetrahedral, 2T
        GL(2,3)   order  48   13 involutions    -> is NOT binary polyhedral
        SL(2,5)   order 120    1 involution     -> IS binary icosahedral, 2I

  `GL(2,3)` is `2.S₄⁻`, one of the two double covers of `S₄`.  The binary octahedral group
  `2O` is the other one.  They have the SAME character degrees `[1,1,2,2,2,3,3,4]` and are
  not isomorphic, which is how the confusion arose.

  The certificate proved in `ArtinDefect2.lean` Section 2 remains TRUE — it is a correct
  statement about `GL(2,3) = 2.S₄⁻`.  Only its label was wrong.  This file supplies the
  missing member of the binary polyhedral family.

  ---------------------------------------------------------------------------
  CONSEQUENCE FOR THE SECTION-5 CONJECTURE

  `ArtinDefect2.lean` Section 5 conjectures that for the binary polyhedral group of
  triangle type `(2,3,n)`, an optimal defect-1/2 certificate has

        POSITIVE part induced from a cyclic  C_{2n}   (preimage of the n-fold axis)
        NEGATIVE part induced from a cyclic  C₆       (preimage of the 3-fold axis)

  and claimed verification for `n = 3,4,5`.  The `n = 4` case was verified with `GL(2,3)`,
  which is not in the family.  Recomputed with `2O` the pattern HOLDS, with positive part
  from `C₈ = C_{2·4}` and negative part from `C₆`:

        Ind_{C₈} λ    degree 6    multiplicities [0,0,1,0,0,0,0,1]  = χ₂ + χ₇
        Ind_{C₆} μ    degree 8    multiplicities [0,0,0,0,0,0,0,2]  = 2χ₇
        certificate   2·Ind_{C₈}λ − Ind_{C₆}μ = 2χ₂,  degrees 2·6 − 8 = 4 = 2·2

  The conjecture is therefore verified on the COMPLETE binary polyhedral family

        2T = SL(2,3)   (n=3)      2O   (n=4)      2I = SL(2,5)   (n=5)

  these being the only non-cyclic, non-dihedral finite quaternion subgroups.  For `n = 3`
  the two cyclic subgroups coincide (`C_{2n} = C₆`) and the certificate degenerates into
  the three-term "triangle" form of `ArtinDefect2.lean` Section 1.

  NOTE also that the note in `ArtinDefect.lean` Section 3 concerning `SL(2,7)` is not a
  refutation of this conjecture: `SL(2,7)` is not binary polyhedral, so its differently
  shaped certificate bears only on a generalisation BEYOND the family, not on the
  statement above.  (The other item refuted in that paragraph — the `N(chi)` invariant —
  stands as refuted.)

  ---------------------------------------------------------------------------
  STATUS

  Proved here: two finite ℤ-vector identities (`cert_2O`, `deg_2O`), the degree identity
  also re-derived structurally as `deg_2O'` from `ArtinDefect2.dim_certificate`, and one
  coordinate fact (`N₄_orthogonal`).

  NOT proved, exactly as in `ArtinDefect2.lean`:
    (a) that the listed vectors really are induced from linear characters of the named
        cyclic subgroups — they are tabulated, not derived;
    (b) that 1/2 is optimal (the LP lower bound).  Only the upper bound is used.

  Nothing here — and nothing anywhere in this development — proves Artin's conjecture for
  any representation.  The certificates yield CONDITIONAL pole bounds only.

  The analytic consequence is `pole_bound_of_certificate` from `ArtinDefect2.lean`.
-/

import RequestProject.Imported.ArtinDefect2.ArtinDefect2_Root

namespace ArtinDefect2O

/-- A multiplicity vector: coordinates w.r.t. `Irr(G)`.  Shared with
    `ArtinDefect2.lean` rather than redefined. -/
abbrev Mult (r : ℕ) := ArtinDefect2.Mult r

/-- Standard basis vector: the irreducible character with index `i`
    (`ArtinDefect2.e`). -/
abbrev e {r : ℕ} (i : Fin r) : Mult r := ArtinDefect2.e i

/-- Degree of a virtual character from its multiplicity vector and the degree list
    (`ArtinDefect2.dim`). -/
abbrev dim {r : ℕ} (deg : Fin r → ℤ) (v : Mult r) : ℤ := ArtinDefect2.dim deg v

/-! ## The binary octahedral group `2O`, n = 4

`|2O| = 48 = 2⁴·3`, eight conjugacy classes, `Irr` degrees `[1,1,2,2,2,3,3,4]`.
Presentation `⟨a, b | a⁴ = b³ = (ab)²⟩`.

Target: `χ = Irr 2`, one of the two FAITHFUL degree-2 characters (`χ(z) = -2` at the
central involution).  Its values include `±√2 = 2cos(π/4)` on the elements of order 8, so
its character field is `ℚ(ζ₈)⁺ = ℚ(√2)`.  This is an octahedral-type Artin representation,
settled by Tunnell (1981) via solvable base change — recorded here because the defect is
`1/2`, the same as the OPEN icosahedral case, which is the point of the whole development.

The third degree-2 character (`Irr 4`, factoring through `S₄`) has defect `0`; so do the
two 3's and the 4.  Only the FAITHFUL degree-2 characters — the spin representations —
leave the monomial cone. -/

def deg2O : Fin 8 → ℤ := ![1, 1, 2, 2, 2, 3, 3, 4]

/-- `Ind_{C₈} λ = χ₂ + χ₇`, degree `2 + 4 = 6`. -/
def P₄ : Mult 8 := ![0, 0, 1, 0, 0, 0, 0, 1]

/-- `Ind_{C₆} μ = 2χ₇`, degree `8`  (the negative-mass term). -/
def N₄ : Mult 8 := ![0, 0, 0, 0, 0, 0, 0, 2]

/-- **Binary octahedral certificate**: `2·Ind_{C₈}λ − Ind_{C₆}μ = 2χ`.
    Negative mass `1` against `2χ`, so `def(χ) ≤ 1/2`. -/
theorem cert_2O : ∀ i : Fin 8, 2 * P₄ i - N₄ i = 2 * e (2 : Fin 8) i := by
  decide

/-- Degrees: `2·6 − 8 = 4 = 2·2`. -/
theorem deg_2O : 2 * dim deg2O P₄ - dim deg2O N₄ = 2 * 2 := by
  decide

/-- The same degree identity obtained structurally, with no numerical computation, from
    `ArtinDefect2.dim_certificate` applied to `cert_2O`: linearity of `dim` turns the
    multiplicity identity into the degree identity `2·deg P₄ − deg N₄ = 2·deg₂`. -/
theorem deg_2O' : 2 * dim deg2O P₄ - dim deg2O N₄ = 2 * deg2O 2 :=
  ArtinDefect2.dim_certificate deg2O 2 P₄ N₄ 2 cert_2O

/-- The negative term is orthogonal to the target: `N₄` has no `χ₂` component, so it
    serves only to strip the `χ₇` constituent of `P₄`.  As in `ArtinDefect2.lean`, this
    does NOT show the negative mass is necessary — that is the LP lower bound, which is
    not proved anywhere in this development. -/
theorem N₄_orthogonal : N₄ 2 = 0 := by decide

/-! ## The family, assembled

For reference, the three certificates of the complete binary polyhedral family, all in the
conventions of this file and `ArtinDefect2.lean`:

    n = 3   2T = SL(2,3)    Ind λ₀ + Ind λ₁ − Ind λ₄ = 2χ₃      (three chars of ONE C₆)
    n = 4   2O              2·Ind_{C₈}λ − Ind_{C₆}μ  = 2χ₂
    n = 5   2I = SL(2,5)    2·Ind_{C₁₀}λ − Ind_{C₆}μ = 2χ₁

Two-term shape `2(χ + R) − 2R = 2χ` for `n = 4, 5`; for `n = 3` the positive and negative
subgroups coincide (`C_{2·3} = C₆`) and it degenerates to the triangle
`(χ + b) + (χ + c) − (b + c) = 2χ`.  Both shapes are isolated as `two_term_shape` and
`triangle_shape` in `ArtinDefect2.lean` Section 4.

CAUTION, restated because it is the substance of the whole development: `n = 3` (Langlands
1980) and `n = 4` (Tunnell 1981) are PROVED cases of Artin's conjecture and carry exactly
the same defect `1/2` as the OPEN case `n = 5`.  The defect measures failure of the
positive-induction argument, not difficulty of the problem.  What separates them is
solvability of the polyhedral quotient — `A₄` and `S₄` are solvable, `A₅` is not — and the
defect is blind to it.

Arithmetically the same boundary appears in the prime content: `|2T| = 2³·3` and
`|2O| = 2⁴·3` are 6-smooth, while `|2I| = 2³·3·5` is not.  By Burnside's `pᵃqᵇ` theorem no
group of order `2ᵃ3ᵇ` can be non-abelian simple, so non-solvability cannot occur inside the
6-smooth world — but non-monomiality can, and does, first at `2T` of order 24. -/

end ArtinDefect2O
