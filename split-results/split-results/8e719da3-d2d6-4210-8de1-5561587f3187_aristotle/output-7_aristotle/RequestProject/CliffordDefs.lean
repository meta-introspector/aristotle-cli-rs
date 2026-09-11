/-
# Clifford Algebra Definitions and Filtration

We define Cl(0,n) — the Clifford algebra of the negative definite quadratic form
on ℝⁿ — for n = 1, ..., 15, and construct the natural filtration:

  Cl(0,1) → Cl(0,2) → ··· → Cl(0,15)

Each Cl(0,n) has dimension 2ⁿ as an ℝ-algebra, with basis elements corresponding
to subsets of {e₁, ..., eₙ} and multiplication rule eᵢ² = -1.
-/
import Mathlib

open scoped BigOperators

/-! ## The negative definite quadratic form -/

/-- The negative definite quadratic form Q(v) = -∑ᵢ vᵢ² on ℝⁿ.
    This defines the signature (0,n) Clifford algebra. -/
noncomputable def negDefQuadForm (n : ℕ) : QuadraticForm ℝ (Fin n → ℝ) :=
  -(QuadraticMap.weightedSumSquares ℝ (fun _ : Fin n => (1 : ℝ)))

/-- Cl(0,n): the Clifford algebra of the negative definite form on ℝⁿ.
    Generators satisfy eᵢ² = -1 and eᵢeⱼ = -eⱼeᵢ for i ≠ j. -/
noncomputable def Cl (n : ℕ) : Type :=
  CliffordAlgebra (negDefQuadForm n)

noncomputable instance (n : ℕ) : Ring (Cl n) :=
  inferInstanceAs (Ring (CliffordAlgebra (negDefQuadForm n)))

noncomputable instance (n : ℕ) : Algebra ℝ (Cl n) :=
  inferInstanceAs (Algebra ℝ (CliffordAlgebra (negDefQuadForm n)))

/-- The canonical embedding of ℝⁿ into Cl(0,n). -/
noncomputable def Cl.ι (n : ℕ) : (Fin n → ℝ) →ₗ[ℝ] Cl n :=
  CliffordAlgebra.ι (negDefQuadForm n)

/-! ## The filtration maps Cl(0,n) → Cl(0,m) for n ≤ m

For n ≤ m, the inclusion ℝⁿ ↪ ℝᵐ (by zero-extension) preserves the
quadratic form and induces an algebra homomorphism Cl(0,n) → Cl(0,m).
-/

/-- Zero-extension embedding: ℝⁿ ↪ ℝᵐ for n ≤ m. -/
noncomputable def zeroExtend {n m : ℕ} (_h : n ≤ m) : (Fin n → ℝ) →ₗ[ℝ] (Fin m → ℝ) where
  toFun v i :=
    if hi : i.val < n then v ⟨i.val, hi⟩ else 0
  map_add' u v := by
    ext i; simp only [Pi.add_apply]; split_ifs <;> ring
  map_smul' r v := by
    ext i; simp only [Pi.smul_apply, RingHom.id_apply, smul_eq_mul]; split_ifs <;> ring

/-
The zero-extension preserves the negative definite quadratic form.
-/
theorem zeroExtend_preserves_form {n m : ℕ} (h : n ≤ m) (v : Fin n → ℝ) :
    negDefQuadForm m (zeroExtend h v) = negDefQuadForm n v := by
      unfold negDefQuadForm;
      -- The sum of the squares of the zero-extended vector is equal to the sum of the squares of the original vector because the additional terms are zero.
      have h_sum : ∑ x : Fin m, (if h : x.val < n then v ⟨x.val, h⟩ else 0) * (if h : x.val < n then v ⟨x.val, h⟩ else 0) = ∑ x : Fin n, v x * v x := by
        rw [ ← Finset.sum_subset ( Finset.subset_univ ( Finset.image ( fun x : Fin n => ⟨ x, by linarith [ Fin.is_lt x ] ⟩ : Fin n → Fin m ) Finset.univ ) ) ] <;> norm_num [ Finset.sum_image, Fin.val_injective.eq_iff ];
        · rw [ Finset.sum_image <| by intros a ha b hb hab; simpa [ Fin.ext_iff ] using hab ] ; aesop;
        · exact fun x hx₁ hx₂ hx₃ => False.elim <| hx₁ ⟨ x, hx₃ ⟩ rfl;
      convert congr_arg Neg.neg h_sum using 1;
      · simp +decide [ QuadraticMap.weightedSumSquares, zeroExtend ];
      · simp +decide [ QuadraticMap.weightedSumSquares ]

/-- The zero-extension as an isometry of quadratic forms. -/
noncomputable def zeroExtendIsometry {n m : ℕ} (h : n ≤ m) :
    negDefQuadForm n →qᵢ negDefQuadForm m where
  toLinearMap := zeroExtend h
  map_app' v := by
    show negDefQuadForm m (zeroExtend h v) = negDefQuadForm n v
    exact zeroExtend_preserves_form h v

/-- The filtration map: Cl(0,n) →ₐ[ℝ] Cl(0,m) for n ≤ m. -/
noncomputable def Cl.inclusion {n m : ℕ} (h : n ≤ m) : Cl n →ₐ[ℝ] Cl m :=
  CliffordAlgebra.map (zeroExtendIsometry h)

/-! ## Basic properties -/

/-- Cl(0,n) has dimension 2ⁿ as an ℝ-vector space. -/
theorem Cl.finrank (n : ℕ) : Module.finrank ℝ (Cl n) = 2 ^ n := by sorry

/-- The inclusion map is injective (Cl(0,n) embeds into Cl(0,m)). -/
theorem Cl.inclusion_injective {n m : ℕ} (h : n ≤ m) :
    Function.Injective (Cl.inclusion h) := by sorry

/-
Transitivity: the composition of inclusions is an inclusion.
-/
theorem Cl.inclusion_trans {n m k : ℕ} (hnm : n ≤ m) (hmk : m ≤ k) :
    (Cl.inclusion hmk).comp (Cl.inclusion hnm) =
    Cl.inclusion (le_trans hnm hmk) := by
      ext;
      -- By definition of inclusion, we know that the composition of two inclusions is equal to the inclusion from n to k.
      have h_comp : (CliffordAlgebra.map (zeroExtendIsometry hmk)).comp (CliffordAlgebra.map (zeroExtendIsometry hnm)) = CliffordAlgebra.map (zeroExtendIsometry (by linarith)) := by
        ext;
        simp [zeroExtendIsometry];
        congr! 1;
        ext; simp [zeroExtend];
        grind;
      exact congr_arg ( fun f => f ‹_› ) h_comp

/-! ## The 15-step filtration aligned with supersingular primes

We construct the chain:
  Cl(0,1) → Cl(0,2) → ··· → Cl(0,15)

Each step adds one generator eᵢ corresponding to the i-th supersingular prime.
-/

/-- The Clifford algebra at filtration level i (i = 1,...,15). -/
noncomputable def ClFilt (i : Fin 15) : Type := Cl (i.val + 1)

noncomputable instance ClFilt.instRing (i : Fin 15) : Ring (ClFilt i) :=
  inferInstanceAs (Ring (Cl (i.val + 1)))

noncomputable instance ClFilt.instAlgebra (i : Fin 15) : Algebra ℝ (ClFilt i) :=
  inferInstanceAs (Algebra ℝ (Cl (i.val + 1)))

/-- The inclusion ClFilt i → ClFilt j for i ≤ j. -/
noncomputable def ClFilt.inclusion {i j : Fin 15} (h : i ≤ j) :
    ClFilt i →ₐ[ℝ] ClFilt j :=
  Cl.inclusion (by omega)