import Mathlib

/-!
# A Structural Blueprint for Galois Fields, formalized

This file extracts the *concrete, verifiable* mathematical content of the informal
"Architectural Blueprint Derived from the History of Galois Fields" and proves it in Lean 4.

The narrative blueprint describes several historical viewpoints on finite (Galois) fields and
the linear groups acting on them.  Stripped of the historical framing, the genuinely
mathematical assertions are the following, organized by the sections of the blueprint.

* §1 Field ontology and indexing.
    - *Galois's multiplicative approach*: the multiplicative group of a Galois field is a
      cyclic group (there is a primitive root `j`).
    - *Serret/Cauchy's modular approach*: the Galois field `GF(p^n)` has `p^n` elements and is
      an `n`-dimensional vector space over its prime field.
    - The additive group is *elementary abelian*: `p · x = 0` for every element `x`.

* §2 The analytic representation layer (polynomial mappings).
    - Affine substitutions `k ↦ a·k + b` with `a ≠ 0` are bijections.
    - The Frobenius substitution `k ↦ k^p` is a bijection of a finite field
      (the building block of the Betti–Mathieu "quantics" `∑ aᵢ k^{p^i}`).

* §3–§4 The general and special linear groups.
    - The `2×2` unimodular / non-singularity conditions `ad - bc = 1` (for `SL₂`) and
      `ad - bc ≠ 0` (for `GL₂`).
    - Order of the general linear group: `|GLₙ(𝔽_q)| = ∏_{i<n} (qⁿ - qⁱ)`.
    - Order of the special linear group: `|SLₙ(𝔽_q)| · (q-1) = |GLₙ(𝔽_q)|`,
      i.e. `|SLₙ| = |GLₙ| / (q-1)`.

All statements are proved without `sorry`.
-/

open scoped Classical
open Matrix

namespace GFArch

set_option maxHeartbeats 1000000

/-! ## §1 Field ontology: the two historical approaches to `GF(p^n)`. -/

/-- **Galois's multiplicative approach.** The multiplicative group of units of a Galois field is
cyclic: there is a single primitive root `j` whose powers exhaust the nonzero elements. -/
theorem galois_units_isCyclic (p n : ℕ) [Fact p.Prime] :
    IsCyclic (GaloisField p n)ˣ := by
  infer_instance

/-- **Serret/Cauchy's modular approach (cardinality).** The Galois field `GF(p^n)` has exactly
`p^n` elements. -/
theorem serret_card (p n : ℕ) [Fact p.Prime] (hn : n ≠ 0) :
    Nat.card (GaloisField p n) = p ^ n :=
  GaloisField.card p n hn

/-- **Serret/Cauchy's modular approach (dimension).** `GF(p^n)` is an `n`-dimensional vector
space over its prime field `ℤ/p`. -/
theorem serret_finrank (p n : ℕ) [Fact p.Prime] (hn : n ≠ 0) :
    Module.finrank (ZMod p) (GaloisField p n) = n :=
  GaloisField.finrank p hn

/-- **The additive group is elementary abelian.** Every element is killed by the prime `p`:
`p · x = 0`. This is the additive `(ℤ/p)`-vector-space structure underlying the `GLₙ`
representation. -/
theorem additive_elementary_abelian (p n : ℕ) [Fact p.Prime] (x : GaloisField p n) :
    (p : GaloisField p n) * x = 0 := by
  rw [CharP.cast_eq_zero (GaloisField p n) p, zero_mul]

/-! ## §2 The analytic representation layer: polynomial substitutions. -/

variable {F : Type*}

/-- **Affine substitutions are permutations.** The "Linear/Affine Form" `k ↦ a·k + b`
(with `a ≠ 0`) is a bijection of the field. -/
theorem affine_bijective [Field F] (a b : F) (ha : a ≠ 0) :
    Function.Bijective (fun k : F => a * k + b) := by
  constructor
  · intro x y hxy
    simp only at hxy
    have := mul_left_cancel₀ ha (add_right_cancel hxy)
    exact this
  · intro y
    refine ⟨a⁻¹ * (y - b), ?_⟩
    show a * (a⁻¹ * (y - b)) + b = y
    rw [mul_inv_cancel_left₀ ha, sub_add_cancel]

/-- **The Frobenius substitution is a permutation.** Over a finite field the map `k ↦ k^p`
(the generator of the cyclic Galois group and the atom of the Betti–Mathieu quantics) is a
bijection. -/
theorem frobenius_bijective (p n : ℕ) [Fact p.Prime] :
    Function.Bijective (frobenius (GaloisField p n) p) :=
  bijective_frobenius (GaloisField p n) p

/-! ## §3–§4 Linear groups: membership conditions and orders. -/

/-- **Unimodular condition for `SL₂`.** A `2×2` matrix `[[a,b],[c,d]]` lies in the special
linear group exactly when `a·d - b·c = 1`. -/
theorem mem_SL2_iff [CommRing F] (M : Matrix (Fin 2) (Fin 2) F) :
    M.det = 1 ↔ M 0 0 * M 1 1 - M 0 1 * M 1 0 = 1 := by
  rw [Matrix.det_fin_two]

/-- **Non-singularity condition for `GL₂`.** Over a field, a `2×2` matrix is invertible
exactly when `a·d - b·c ≠ 0`. -/
theorem mem_GL2_iff [Field F] (M : Matrix (Fin 2) (Fin 2) F) :
    IsUnit M ↔ M 0 0 * M 1 1 - M 0 1 * M 1 0 ≠ 0 := by
  rw [Matrix.isUnit_iff_isUnit_det, Matrix.det_fin_two, isUnit_iff_ne_zero]

variable [Field F] [Fintype F]

/-- **Order of the general linear group.** `|GLₙ(𝔽_q)| = ∏_{i<n} (qⁿ - qⁱ)`. -/
theorem card_GL (n : ℕ) :
    Nat.card (GL (Fin n) F) =
      ∏ i : Fin n, (Fintype.card F ^ n - Fintype.card F ^ (i : ℕ)) :=
  Matrix.card_GL_field n

/-
The determinant is a surjective group homomorphism `GLₙ(𝔽) → 𝔽ˣ` when `n ≥ 1`.
-/
omit [Fintype F] in
theorem det_surjective (n : ℕ) (hn : 0 < n) :
    Function.Surjective
      (Matrix.GeneralLinearGroup.det : GL (Fin n) F →* Fˣ) := by
  intro u
  use Matrix.GeneralLinearGroup.mkOfDetNeZero (Matrix.diagonal (fun i => if i = ⟨0, hn⟩ then u else 1)) (by
  simp +decide [ Matrix.det_diagonal ])
  generalize_proofs at *;
  simp +decide [ GeneralLinearGroup.det, GeneralLinearGroup.mkOfDetNeZero ]

/-
The kernel of the determinant homomorphism is in bijection with the special linear group.
-/
noncomputable def specialLinearEquivKerDet (n : ℕ) :
    Matrix.SpecialLinearGroup (Fin n) F ≃
      (Matrix.GeneralLinearGroup.det (n := Fin n) (R := F)).ker where
  toFun M := ⟨M.toGL, by rw [MonoidHom.mem_ker]; exact M.coeToGL_det⟩
  invFun g := ⟨(g.1 : Matrix (Fin n) (Fin n) F), by
    have hg : Matrix.GeneralLinearGroup.det g.1 = 1 := g.2
    have h := GeneralLinearGroup.val_det_apply g.1
    rw [hg] at h
    simpa using h.symm⟩
  left_inv M := by
    apply Subtype.ext
    exact Matrix.SpecialLinearGroup.coe_GL_coe_matrix M
  right_inv g := by
    apply Subtype.ext
    apply Units.ext
    rfl

/-- **Order of the special linear group (multiplicative form).**
`|SLₙ(𝔽_q)| · (q - 1) = |GLₙ(𝔽_q)|`. -/
theorem card_SL_mul (n : ℕ) (hn : 0 < n) :
    Nat.card (Matrix.SpecialLinearGroup (Fin n) F) * (Fintype.card F - 1) =
      Nat.card (GL (Fin n) F) := by
  classical
  set φ := (Matrix.GeneralLinearGroup.det : GL (Fin n) F →* Fˣ) with hφ
  have hquot := Subgroup.card_eq_card_quotient_mul_card_subgroup φ.ker
  have hsurj := det_surjective (F := F) n hn
  have hrange : φ.range = ⊤ := MonoidHom.range_eq_top.mpr hsurj
  have e1 : (GL (Fin n) F ⧸ φ.ker) ≃ φ.range := (QuotientGroup.quotientKerEquivRange φ).toEquiv
  have hcardquot : Nat.card (GL (Fin n) F ⧸ φ.ker) = Nat.card Fˣ := by
    rw [Nat.card_congr e1, hrange]
    exact Nat.card_congr (Subgroup.topEquiv).toEquiv
  have hcardker : Nat.card φ.ker = Nat.card (Matrix.SpecialLinearGroup (Fin n) F) :=
    Nat.card_congr (specialLinearEquivKerDet n).symm
  rw [hquot, hcardquot, hcardker, Nat.card_eq_fintype_card (α := Fˣ), Fintype.card_units]
  ring

/-- **Order of the special linear group (quotient form).** `|SLₙ(𝔽_q)| = |GLₙ(𝔽_q)| / (q - 1)`. -/
theorem card_SL (n : ℕ) (hn : 0 < n) :
    Nat.card (Matrix.SpecialLinearGroup (Fin n) F) =
      Nat.card (GL (Fin n) F) / (Fintype.card F - 1) := by
  have hpos : 0 < Fintype.card F - 1 := by
    have := Fintype.one_lt_card (α := F); omega
  rw [← card_SL_mul (F := F) n hn, Nat.mul_div_cancel _ hpos]

end GFArch