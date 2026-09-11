/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal3.RhoBar1951

/-!
# Klein's icosahedral signs, and the absence of an `SL₂`-section

Klein's two generators of the icosahedral subgroup of `PGL₂(K)` (for `K` a field containing a
primitive fifth root of unity `z`) are the classes of

  `a = ⎡z² 0 ⎤`      `b = ⎡-(z - z⁴)   z² - z³ ⎤`
  `    ⎣0  z³⎦`          `⎣ z² - z³    z - z⁴  ⎦`

(`ArtinA5Even/KleinPGL.lean`).  In `GL₂(K)` these satisfy

  `a⁵ = 1 · I`,  `b² = (-5) · I`,  `(ab)³ = 5(z - z⁴)(z² - z³) · I = (-5√5) · I`,

with `√5 = 2(z + z⁴) + 1 ∈ K` (`ArtinA5Even.Klein.sqrtFive_sq`).  So the three scalars
`ε₅, ε₂, ε₃ ∈ K^×` of the task are, for these particular matrices,

  `ε₅ = 1`,   `ε₂ = -5`,   `ε₃ = -5√5`.

**`b` is not in `SL₂`:** `det a = 1` but `det b = 5`.  Rescaling by `√5` fixes this: with

  `X := a`,   `Y := (√5)⁻¹ • b`

both matrices have determinant `1`, i.e. `X, Y ∈ SL₂(K)`, and the three scalars normalise to

  `X⁵ = I`,   `Y² = -I`,   `(XY)³ = -I`,

which are exactly the signs of the **binary icosahedral group** `2.A₅ ⊂ SL₂`: the lift of the
involution squares to `-I`, not to `I`.

## The obstruction, honestly

That single sign is already the whole obstruction to an `SL₂`-section.  If `φ` is a group
homomorphism into `SL₂(K)` whose projectivisation sends an element `β` with `β² = 1` to Klein's
involution `b`, then `φ β` is a scalar multiple `c⁻¹ • b`; the determinant condition forces
`c² = 5`, hence `(φ β)² = (-5/c²) • I = -I ≠ I` (whenever `-1 ≠ 1` in `K`), contradicting
`φ(β)² = φ(β²) = 1`.  This is `ArtinA5Even.KleinSigns.no_involution_lift`, and it yields

* `ArtinA5Even.KleinSigns.no_sl2_section_kleinEmb` — the icosahedral embedding
  `A₅ ↪ PGL₂(ℚ(ζ₅))` of this library has **no** section through `SL₂(ℚ(ζ₅))`;
* `ArtinA5Even.not_linearLiftOfRhoBar1951` — **`¬ LinearLiftOfRhoBar1951`**: the map
  `ρ̄ : Gal(f₁₉₅₁) → PGL₂(ℚ(ζ₅))` of `ArtinA5Even/RhoBar1951.lean` admits no lift to a
  homomorphism `Gal(f₁₉₅₁) →* SL₂(ℚ(ζ₅))`.

Conceptually: such a section, since `Gal(f₁₉₅₁) ≃ A₅`, would split the double cover
`2.A₅ → A₅`, and that cover is nonsplit (`ArtinA5Even.SL2F5_extension_nonsplit`).  The proof
given here does not go through an abstract identification of the cover; it uses the explicit
sign `Y² = -I`, which is cheaper and needs no extra hypothesis.

## What this does *not* say

This is **not** a statement that there is no Artin representation attached to `f₁₉₅₁`.  Artin's
setting asks for a lift to `GL₂(ℂ)`, where the centre is all of `ℂ^×` and Tate's theorem
`H²(G_ℚ, ℂ^×) = 0` supplies projective-to-linear lifts.  That theorem is not in Mathlib and is
**not** encoded here, as a theorem or as an assumption.  Nothing in this file rules out a
homomorphism `Gal → GL₂(K)` lifting `ρ̄` — indeed `ρ̄` does lift to `GL₂` after allowing
determinant characters; what is ruled out is a lift landing in `SL₂`.

No Maass form, no `L`-function, no automorphy, no `native_decide`, no `axiom`.
-/

namespace ArtinA5Even

namespace KleinSigns

open Matrix Klein

variable {K : Type*} [Field K] (z : K)

/-! ## `√5` inside `K`, and the product identity `(z - z⁴)(z² - z³) = -√5` -/

/-- `√5 = 2(z + z⁴) + 1`, an element of any field containing a primitive fifth root of unity
(`ArtinA5Even.Klein.sqrtFive_sq`: its square is `5`). -/
def sqrtFive : K := 2 * (z + z ^ 4) + 1

theorem sqrtFive_sq' (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) : (sqrtFive z) ^ 2 = 5 :=
  Klein.sqrtFive_sq z hz5 hz1

theorem sqrtFive_ne_zero (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) : sqrtFive z ≠ 0 := by
  intro h
  have h5 : (5 : K) = 0 := by rw [← sqrtFive_sq' z hz5 hz1, h]; ring
  exact Klein.five_ne_zero z hz5 hz1 h5

/-- The off-diagonal/diagonal product occurring in `(ab)³` is `-√5`. -/
theorem prod_eq_neg_sqrtFive (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    (z - z ^ 4) * (z ^ 2 - z ^ 3) = -(sqrtFive z) := by
  have hc := Klein.cyclotomic_rel z hz5 hz1
  rw [sqrtFive]
  linear_combination (z ^ 2 - z) * hz5 + hc

/-! ## Task 1a — the three scalars for Klein's own matrices (not in `SL₂`)

`det a = 1`, but `det b = 5`, so `b ∉ SL₂(K)` unless `5 = 1` in `K`.  The three scalars are
recorded here in `K^×`. -/

/-- **`ε₅ = 1`**: `a⁵ = 1 • I`. -/
theorem genAMat_pow_five_smul (hz5 : z ^ 5 = 1) : (genAMat z) ^ 5 = (1 : K) • 1 := by
  rw [one_smul]; exact genAMat_pow_five z hz5

/-- **`ε₂ = -5`**: `b² = (-5) • I`. -/
theorem genBMat_sq_smul (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    (genBMat z) ^ 2 = (-5 : K) • 1 := genBMat_sq z hz5 hz1

/-- **`ε₃ = -5√5`**: `(ab)³ = 5(z - z⁴)(z² - z³) • I = (-5√5) • I`. -/
theorem genABMat_pow_three_smul (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    (genAMat z * genBMat z) ^ 3 = (-(5 * sqrtFive z)) • 1 := by
  rw [genABMat_pow_three z hz5]
  congr 1
  rw [mul_assoc, prod_eq_neg_sqrtFive z hz5 hz1]
  ring

/-- `det a = 1`: Klein's order-five generator already lies in `SL₂(K)`. -/
theorem det_genAMat' (hz5 : z ^ 5 = 1) : (genAMat z).det = 1 := det_genAMat z hz5

/-- `det b = 5`: Klein's involution does **not** lie in `SL₂(K)` when `5 ≠ 1`. -/
theorem det_genBMat' (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) : (genBMat z).det = 5 :=
  det_genBMat z hz5 hz1

/-! ## Task 1b — the rescaled generators, in `SL₂(K)` -/

/-- `X = a`, an element of `SL₂(K)`. -/
def liftX (hz5 : z ^ 5 = 1) : SpecialLinearGroup (Fin 2) K :=
  ⟨genAMat z, det_genAMat z hz5⟩

theorem det_smul_genBMat (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    ((sqrtFive z)⁻¹ • genBMat z).det = 1 := by
  have hs := sqrtFive_ne_zero z hz5 hz1
  rw [Matrix.det_smul, det_genBMat z hz5 hz1]
  simp only [Fintype.card_fin]
  field_simp
  exact (sqrtFive_sq' z hz5 hz1).symm

/-- `Y = (√5)⁻¹ • b`, the rescaled involution, an element of `SL₂(K)`. -/
def liftY (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) : SpecialLinearGroup (Fin 2) K :=
  ⟨(sqrtFive z)⁻¹ • genBMat z, det_smul_genBMat z hz5 hz1⟩

@[simp] theorem val_liftX (hz5 : z ^ 5 = 1) :
    ((liftX z hz5 : SpecialLinearGroup (Fin 2) K) : Matrix (Fin 2) (Fin 2) K) = genAMat z := rfl

@[simp] theorem val_liftY (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    ((liftY z hz5 hz1 : SpecialLinearGroup (Fin 2) K) : Matrix (Fin 2) (Fin 2) K)
      = (sqrtFive z)⁻¹ • genBMat z := rfl

/-- **`X⁵ = I`**: the normalised `ε₅ = 1`. -/
theorem liftX_pow_five (hz5 : z ^ 5 = 1) : (liftX z hz5) ^ 5 = 1 := by
  apply Subtype.ext
  show (genAMat z) ^ 5 = (1 : Matrix (Fin 2) (Fin 2) K)
  exact genAMat_pow_five z hz5

/-- **`Y² = -I`**: the normalised `ε₂ = -1`.  This is the binary icosahedral sign: the lift of
the involution does *not* square to the identity. -/
theorem liftY_sq (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) : (liftY z hz5 hz1) ^ 2 = -1 := by
  have hs := sqrtFive_ne_zero z hz5 hz1
  have hsq := sqrtFive_sq' z hz5 hz1
  have hc : ((sqrtFive z)⁻¹ ^ 2 * (-5 : K)) = -1 := by
    field_simp
    linear_combination hsq
  apply Subtype.ext
  show ((sqrtFive z)⁻¹ • genBMat z) ^ 2 = ((-1 : SpecialLinearGroup (Fin 2) K) :
    Matrix (Fin 2) (Fin 2) K)
  rw [smul_pow, genBMat_sq z hz5 hz1, smul_smul, hc]
  show (-1 : K) • (1 : Matrix (Fin 2) (Fin 2) K) = -(1 : Matrix (Fin 2) (Fin 2) K)
  rw [neg_smul, one_smul]

/-- **`(XY)³ = -I`**: the normalised `ε₃ = -1`. -/
theorem liftXY_pow_three (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    (liftX z hz5 * liftY z hz5 hz1) ^ 3 = -1 := by
  have hs := sqrtFive_ne_zero z hz5 hz1
  have hsq := sqrtFive_sq' z hz5 hz1
  have hc : ((sqrtFive z)⁻¹ ^ 3 * (-(5 * sqrtFive z)) : K) = -1 := by
    field_simp
    linear_combination hsq
  apply Subtype.ext
  show (genAMat z * ((sqrtFive z)⁻¹ • genBMat z)) ^ 3 =
    ((-1 : SpecialLinearGroup (Fin 2) K) : Matrix (Fin 2) (Fin 2) K)
  rw [Matrix.mul_smul, smul_pow, genABMat_pow_three_smul z hz5 hz1, smul_smul, hc]
  show (-1 : K) • (1 : Matrix (Fin 2) (Fin 2) K) = -(1 : Matrix (Fin 2) (Fin 2) K)
  rw [neg_smul, one_smul]

/-- **The three signs, together.**  `X, Y ∈ SL₂(K)` are lifts of Klein's projective generators
with `X⁵ = I`, `Y² = -I`, `(XY)³ = -I`. -/
theorem klein_sl2_signs (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    (liftX z hz5) ^ 5 = 1 ∧ (liftY z hz5 hz1) ^ 2 = -1 ∧
      (liftX z hz5 * liftY z hz5 hz1) ^ 3 = -1 :=
  ⟨liftX_pow_five z hz5, liftY_sq z hz5 hz1, liftXY_pow_three z hz5 hz1⟩

/-! ## The projective classes of `X` and `Y` are Klein's `a` and `b` -/

/-- Two elements of `GL₂(K)` differing by a scalar have the same class in `PGL₂(K)`. -/
theorem toPGL2_eq_of_smul {g h : GeneralLinearGroup (Fin 2) K} {c : K}
    (H : (g : Matrix (Fin 2) (Fin 2) K) = c • (h : Matrix (Fin 2) (Fin 2) K)) :
    toPGL2 g = toPGL2 h := by
  have hh : (h : Matrix (Fin 2) (Fin 2) K) * ((h⁻¹ : GeneralLinearGroup (Fin 2) K) :
      Matrix (Fin 2) (Fin 2) K) = 1 := by
    rw [← Units.val_mul, mul_inv_cancel, Units.val_one]
  have hone : toPGL2 (g * h⁻¹) = 1 := by
    refine toPGL2_eq_one_of_scalar (c := c) ?_
    rw [Units.val_mul, H, smul_mul_assoc, hh]
  rw [map_mul, map_inv, mul_inv_eq_one] at hone
  exact hone

/-- Conversely: equal classes in `PGL₂(K)` means the matrices differ by a nonzero scalar. -/
theorem exists_smul_of_toPGL2_eq {g h : GeneralLinearGroup (Fin 2) K}
    (H : toPGL2 g = toPGL2 h) :
    ∃ c : K, c ≠ 0 ∧ (h : Matrix (Fin 2) (Fin 2) K) = c • (g : Matrix (Fin 2) (Fin 2) K) := by
  rw [toPGL2, QuotientGroup.mk'_apply, QuotientGroup.mk'_apply, QuotientGroup.eq] at H
  obtain ⟨c, hc⟩ := Matrix.GeneralLinearGroup.mem_center_iff_val_mem_range_scalar.mp H
  have hgh : (h : Matrix (Fin 2) (Fin 2) K)
      = (g : Matrix (Fin 2) (Fin 2) K) *
        ((g⁻¹ * h : GeneralLinearGroup (Fin 2) K) : Matrix (Fin 2) (Fin 2) K) := by
    rw [← Units.val_mul]
    congr 1
    group
  refine ⟨c, ?_, ?_⟩
  · rintro rfl
    have hzero : (h : Matrix (Fin 2) (Fin 2) K) = 0 := by
      rw [hgh, ← hc, scalar_eq_smul_one, zero_smul, mul_zero]
    have : IsUnit (0 : Matrix (Fin 2) (Fin 2) K) := by
      rw [← hzero]; exact ⟨h, rfl⟩
    exact zero_ne_one (isUnit_zero_iff.mp this)
  · rw [hgh, ← hc, scalar_eq_smul_one, mul_smul_comm, mul_one]

theorem sl2ToPGL2_liftX (hz5 : z ^ 5 = 1) :
    sl2ToPGL2 K (liftX z hz5) = kleinA z hz5 := by
  refine congrArg toPGL2 ?_
  ext i j
  rfl

theorem sl2ToPGL2_liftY (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    sl2ToPGL2 K (liftY z hz5 hz1) = kleinB z hz5 hz1 :=
  toPGL2_eq_of_smul (c := (sqrtFive z)⁻¹) rfl

/-! ## Task 2 — no `SL₂`-section

The core statement: an involution of the abstract group cannot be sent by a homomorphism into
`SL₂(K)` to a lift of Klein's `b`, because every such lift squares to `-I`. -/

/-- **The `SL₂` obstruction.**  If `β² = 1` and `φ : G →* SL₂(K)` projectivises to Klein's
involution `b` at `β`, then `False` (provided `-1 ≠ 1` in `K`).

Indeed `φ β = c⁻¹ • b` for some `c ≠ 0`; taking determinants, `c² = 5`; hence
`(φ β)² = (-5/c²) • I = -I`, while `β² = 1` forces `(φ β)² = I`. -/
theorem no_involution_lift {G : Type*} [Group G] {β : G} (hβ : β ^ 2 = 1)
    (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) (h2 : (-1 : K) ≠ 1)
    (φ : G →* SpecialLinearGroup (Fin 2) K)
    (hφ : sl2ToPGL2 K (φ β) = kleinB z hz5 hz1) : False := by
  set s : SpecialLinearGroup (Fin 2) K := φ β with hs
  -- `s² = 1`
  have hs2 : s ^ 2 = 1 := by rw [hs, ← map_pow, hβ, map_one]
  -- the projective classes agree, so the matrices differ by a scalar
  have hclass : toPGL2 (SpecialLinearGroup.toGL s) = toPGL2 (genB z hz5 hz1) := hφ
  obtain ⟨c, hc0, hc⟩ := exists_smul_of_toPGL2_eq hclass
  have hcoe : ((SpecialLinearGroup.toGL s : GeneralLinearGroup (Fin 2) K) :
      Matrix (Fin 2) (Fin 2) K) = (s : Matrix (Fin 2) (Fin 2) K) := rfl
  rw [hcoe] at hc
  -- `hc : genBMat z = c • s`
  have hcb : genBMat z = c • (s : Matrix (Fin 2) (Fin 2) K) := hc
  -- determinants: `5 = c²`
  have hdet : (5 : K) = c ^ 2 := by
    have := congrArg Matrix.det hcb
    rw [det_genBMat z hz5 hz1, Matrix.det_smul, s.prop] at this
    simpa using this
  -- `s² = -I`
  have hsq : (s : Matrix (Fin 2) (Fin 2) K) ^ 2 = (-1 : K) • 1 := by
    have hcs : (c ^ 2) • ((s : Matrix (Fin 2) (Fin 2) K) ^ 2) = (-5 : K) • 1 := by
      rw [← smul_pow, ← hcb]; exact genBMat_sq z hz5 hz1
    have hc2 : (c ^ 2 : K) ≠ 0 := pow_ne_zero 2 hc0
    have : ((c ^ 2)⁻¹ * (-5 : K)) = -1 := by
      field_simp
      linear_combination -hdet
    calc (s : Matrix (Fin 2) (Fin 2) K) ^ 2
        = (c ^ 2)⁻¹ • ((c ^ 2) • ((s : Matrix (Fin 2) (Fin 2) K) ^ 2)) := by
          rw [smul_smul, inv_mul_cancel₀ hc2, one_smul]
      _ = ((c ^ 2)⁻¹ * (-5 : K)) • 1 := by rw [hcs, smul_smul]
      _ = (-1 : K) • 1 := by rw [this]
  -- but `s² = 1`
  have h1 : (s : Matrix (Fin 2) (Fin 2) K) ^ 2 = 1 := congrArg Subtype.val hs2
  rw [h1] at hsq
  have hentry := congrFun (congrFun hsq 0) 0
  simp at hentry
  exact h2 hentry.symm

end KleinSigns

/-! ## The two concrete corollaries over `ℚ(ζ₅)` -/

open Matrix Klein KleinSigns

theorem neg_one_ne_one_cyclotomic : (-1 : CyclotomicField 5 ℚ) ≠ 1 := by
  intro h
  have : (2 : CyclotomicField 5 ℚ) = 0 := by linear_combination -h
  exact two_ne_zero this

/-- Klein's icosahedral embedding `A₅ ↪ PGL₂(ℚ(ζ₅))` of this library, i.e. the inverse of
`kleinEquivA5` followed by the inclusion of `⟨a, b⟩`. -/
noncomputable def kleinEmb : alternatingGroup (Fin 5) →* PGL2 (CyclotomicField 5 ℚ) :=
  kleinSubgroup.subtype.comp kleinEquivA5.symm.toMonoidHom

theorem kleinEmb_apply (x : alternatingGroup (Fin 5)) :
    kleinEmb x = (kleinEquivA5.symm x : PGL2 (CyclotomicField 5 ℚ)) := rfl

/-- **No `SL₂`-section of the icosahedral embedding.**  There is no homomorphism
`A₅ →* SL₂(ℚ(ζ₅))` whose projectivisation is `kleinEmb`: such a section would split the double
cover `2.A₅ → A₅`.  (This says nothing about lifts to `GL₂`.) -/
theorem no_sl2_section_kleinEmb :
    ¬ ∃ φ : alternatingGroup (Fin 5) →* SpecialLinearGroup (Fin 2) (CyclotomicField 5 ℚ),
        (sl2ToPGL2 (CyclotomicField 5 ℚ)).comp φ = kleinEmb := by
  rintro ⟨φ, hφ⟩
  set β : alternatingGroup (Fin 5) := kleinEquivA5 ⟨kleinWordB, kleinWordB_mem⟩ with hβdef
  have hβ : β ^ 2 = 1 := by
    have hb : (⟨kleinWordB, kleinWordB_mem⟩ : kleinSubgroup) ^ 2 = 1 := by
      ext
      push_cast
      exact Klein.kleinB_sq zeta5 zeta5_pow_five zeta5_ne_one
    rw [hβdef, ← map_pow, hb, map_one]
  have hemb : kleinEmb β = kleinWordB := by
    rw [kleinEmb_apply, hβdef, MulEquiv.symm_apply_apply]
  have hval : sl2ToPGL2 (CyclotomicField 5 ℚ) (φ β)
      = Klein.kleinB zeta5 zeta5_pow_five zeta5_ne_one := by
    have := congrArg (fun (ψ : alternatingGroup (Fin 5) →*
      PGL2 (CyclotomicField 5 ℚ)) => ψ β) hφ
    simpa [hemb, kleinWordB] using this
  exact KleinSigns.no_involution_lift zeta5 hβ zeta5_pow_five zeta5_ne_one
    neg_one_ne_one_cyclotomic φ hval

/-- **`¬ LinearLiftOfRhoBar1951`.**  The projective representation
`ρ̄ : Gal(f₁₉₅₁) → PGL₂(ℚ(ζ₅))` has no lift to a homomorphism `Gal(f₁₉₅₁) →* SL₂(ℚ(ζ₅))`.

The reason is the sign `Y² = -I`: an element of order `2` of `Gal(f₁₉₅₁)` maps to Klein's
involution `b` (`rhoBar1951_dictionary_two`), and no lift of `b` to `SL₂` is an involution.

This is **not** a statement about Artin representations: those are homomorphisms into `GL₂(ℂ)`,
where the centre is `ℂ^×` and Tate's theorem (not in Mathlib, not used here) provides
projective-to-linear lifts. -/
theorem not_linearLiftOfRhoBar1951 : ¬ LinearLiftOfRhoBar1951 := by
  rintro ⟨r, hr⟩
  obtain ⟨g, hg, hord⟩ := rhoBar1951_dictionary_two
  have hβ : g ^ 2 = 1 := by rw [← hord]; exact pow_orderOf_eq_one g
  have hval : sl2ToPGL2 (CyclotomicField 5 ℚ) (r g)
      = Klein.kleinB zeta5 zeta5_pow_five zeta5_ne_one := by
    have := congrArg (fun (ψ : poly1951Q.Gal →* PGL2 (CyclotomicField 5 ℚ)) => ψ g) hr
    simpa [hg, kleinWordB] using this
  exact KleinSigns.no_involution_lift zeta5 hβ zeta5_pow_five zeta5_ne_one
    neg_one_ne_one_cyclotomic r hval

end ArtinA5Even
