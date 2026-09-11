/-
# CliffordTemplate — Reusable Patterns for Clifford Algebra Isomorphisms

This file extracts the common proof architecture used in the construction
of Cl(0,n) ≃ₐ[ℝ] Target for n = 3, 4, 5, into reusable templates and
documentation. It does NOT introduce new axioms or sorry'd definitions —
it provides:

1. A parameterized monomial generator pattern
2. A generic span lemma skeleton
3. A generic dimension bound skeleton
4. A generic forward map pattern
5. A generic inverse pattern
6. A generic right-inverse lemma structure
7. A generic rank–nullity injectivity lemma
8. The final AlgEquiv.ofBijective assembly

## Usage

When building Cl(0,n) for n ≥ 6, follow these steps:

### Step 1: Create CliffordCl0{n}Finite.lean
  - Import CliffordBase
  - Define `cl0{n}_gen (i : Fin n) := ι (negDefForm n) (stdBasis n i)`
  - Enumerate all 2ⁿ monomials as `cl0{n}_monoSet : Set (Cl0 n)`
  - Prove `cl0{n}_monoSpan_eq_top` (the monomials span the whole algebra)
  - Derive `finrank_Cl0{n}_le_{2^n}`

### Step 2: Create CliffordCl0{n}.lean
  - Import CliffordBase and CliffordCl0{n}Finite
  - Define generator images `cl0{n}_img : Fin n → Target`
  - Prove `cl0{n}_img_sq` and `cl0{n}_img_anticommute`
  - Build the forward map via `CliffordAlgebra.lift`
  - Define an explicit inverse `cl0{n}_inv : Target → Cl0 n`
  - Prove the right-inverse: `cl0{n}_forward (cl0{n}_inv M) = M`
  - Derive surjectivity, then injectivity via rank–nullity
  - Assemble `AlgEquiv.ofBijective`

### Step 3: Wire into CliffordCanonical.lean
  - Import the new CliffordCl0{n}
  - Replace the sorry with the proved equivalence

## Dependency Invariants

The following invariants MUST be maintained:
- CliffordBase imports ONLY Mathlib
- Each CliffordCl0{n}[Finite] imports ONLY CliffordBase (+ its own Finite file)
- CliffordCanonical imports CliffordBase + all CliffordCl0{n} files
- No file imports CliffordCanonical except top-level executables
- No cycles are permitted

## File Naming Convention

| File | Purpose |
|------|---------|
| `CliffordCl0{n}Finite.lean` | Monomial set, span lemma, dimension bound |
| `CliffordCl0{n}.lean` | Forward map, inverse, right-inverse, equivalence |
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase

/-!
## §1. Parameterized Monomial Generator

For Cl(0,n), the generators are `ι(eᵢ)` for `i : Fin n`.
The full monomial basis consists of all products `eᵢ₁ * eᵢ₂ * ⋯ * eᵢₖ`
for strictly increasing sequences `i₁ < i₂ < ⋯ < iₖ`, giving 2ⁿ elements.

### Pattern (used in Cl03, Cl04, Cl05):

```
noncomputable def cl0n_gen (i : Fin n) : Cl0 n :=
  ι (negDefForm n) (stdBasis n i)
```

### Generator Relations (from CliffordBase):

- `cl0_generator_sq n i`: `ι(eᵢ)² = -1`
- Anticommutativity: `ι(eᵢ) * ι(eⱼ) + ι(eⱼ) * ι(eᵢ) = 0` for `i ≠ j`
  (proved via `ι_mul_ι_add_swap` and the fact that the bilinear form
   is zero on distinct basis vectors)
-/

/-!
## §2. Generic Span Lemma Skeleton

The span lemma proves that the 2ⁿ ordered monomials span Cl(0,n).

### Strategy (used successfully for n = 3, 4, 5):

1. Define the monomial set as a `Set (Cl0 n)` containing all 2ⁿ products.
2. Use `CliffordAlgebra.iSup_ι_range_eq_top` or the universal property
   to show that every element of Cl(0,n) is in the span.
3. The key insight: since every generator `ι(eᵢ)` is in the set,
   and the set is closed under the algebra operations (modulo rewriting
   via the Clifford relations), the span equals ⊤.

### Template:

```
def cl0n_monoSet : Set (Cl0 n) :=
  {1, gen 0, gen 1, ..., gen 0 * gen 1, ..., gen 0 * gen 1 * ... * gen (n-1)}

theorem cl0n_monoSpan_eq_top : Submodule.span ℝ cl0n_monoSet = ⊤ := by
  -- Show generators are in the span
  -- Use CliffordAlgebra induction to show closure
  sorry
```
-/

/-!
## §3. Generic Dimension Bound Skeleton

Once the span lemma is proved, derive the finite-dimensionality bound.

### Template:

```
theorem finrank_Cl0n_le_2n : Module.finrank ℝ (Cl0 n) ≤ 2^n := by
  have h_span : Submodule.span ℝ cl0n_monoSet = ⊤ := cl0n_monoSpan_eq_top
  have h_finite : Set.Finite cl0n_monoSet := Set.toFinite _
  have h_card : Set.ncard cl0n_monoSet ≤ 2^n := by ...
  have h_le := finrank_span_le_card cl0n_monoSet
  rw [h_span, finrank_top] at h_le
  linarith
```
-/

/-!
## §4. Generic Forward Map Pattern

The forward map is built via `CliffordAlgebra.lift`, which requires:
- A linear map `f : ℝⁿ →ₗ[ℝ] Target`
- A proof that `f(v) * f(v) = algebraMap ℝ Target (Q(v))` for all `v`

### Template:

```
-- Define generator images
noncomputable def cl0n_img : Fin n → Target := ...

-- Prove generator images satisfy Clifford relations
theorem cl0n_img_sq (a : Fin n) : cl0n_img a * cl0n_img a = -1 := by ...
theorem cl0n_img_anticommute {a b : Fin n} (hab : a ≠ b) :
    cl0n_img a * cl0n_img b + cl0n_img b * cl0n_img a = 0 := by ...

-- Build the linear map
noncomputable def cl0n_forward_lin : (Fin n → ℝ) →ₗ[ℝ] Target where
  toFun v := ∑ i, v i • cl0n_img i
  map_add' := by ...
  map_smul' := by ...

-- Prove the Clifford relation
theorem cl0n_clifford_sq (v : Fin n → ℝ) :
    cl0n_forward_lin v * cl0n_forward_lin v =
    algebraMap ℝ Target (negDefForm n v) := by ...

-- Lift to algebra homomorphism
noncomputable def cl0n_forward : Cl0 n →ₐ[ℝ] Target :=
  CliffordAlgebra.lift (negDefForm n) ⟨cl0n_forward_lin, cl0n_clifford_sq⟩
```
-/

/-!
## §5. Generic Inverse Pattern

The inverse map extracts coefficients from the target algebra and maps
them back to the corresponding Clifford basis monomials.

### Key Design Principle:

The inverse is defined as a **linear** map (not an algebra map).
It maps each of the 2ⁿ basis elements of the target back to the
corresponding Clifford monomial, scaled by the appropriate coefficient
extracted from the target element.

### Template:

```
noncomputable def cl0n_inv (M : Target) : Cl0 n :=
  coeff₁(M) • 1
  + coeff₂(M) • gen 0
  + coeff₃(M) • gen 1
  + ...
  + coeff_{2ⁿ}(M) • (gen 0 * gen 1 * ... * gen (n-1))
```

The coefficients are typically linear combinations of matrix entries
(for matrix targets) or component projections (for product targets),
divided by the appropriate normalization factor (often `1/2ⁿ⁻¹` or similar).
-/

/-!
## §6. Generic Right-Inverse Lemma

### Template:

```
theorem cl0n_forward_inv (M : Target) :
    cl0n_forward (cl0n_inv M) = M := by
  -- Unfold inverse, apply forward to each term
  -- Use linearity of forward and known images of generators
  -- Reduce to matrix/component equality
  ...
```

### Tips:
- For matrix targets, use `Matrix.ext` to reduce to entry-wise equality.
- For product targets, use `Prod.ext` to reduce to component equality.
- `ring_nf` and `norm_num` are essential for the arithmetic.
- For complex entries, use `Complex.ext_iff` to split real/imaginary parts.
-/

/-!
## §7. Generic Rank–Nullity Injectivity

Once surjectivity is established (from the right-inverse), injectivity
follows from the dimension bound.

### Template:

```
theorem cl0n_forward_surjective : Function.Surjective cl0n_forward :=
  fun M => ⟨cl0n_inv M, cl0n_forward_inv M⟩

theorem cl0n_forward_injective : Function.Injective cl0n_forward := by
  have h_le := finrank_Cl0n_le_2n       -- from the Finite file
  have h_rn := LinearMap.finrank_range_add_finrank_ker cl0n_forward.toLinearMap
  rw [LinearMap.range_eq_top.mpr cl0n_forward_surjective, finrank_top, finrank_Target] at h_rn
  have h_ker : Module.finrank ℝ (LinearMap.ker cl0n_forward.toLinearMap) = 0 := by omega
  rwa [Submodule.finrank_eq_zero, LinearMap.ker_eq_bot] at h_ker
```

### Key Ingredients:
- `finrank_Cl0n_le_2n` from the Finite file
- `finrank_Target = 2^n` (must be proved for the specific target)
- `LinearMap.finrank_range_add_finrank_ker` (rank–nullity theorem from Mathlib)
-/

/-!
## §8. Final Assembly: AlgEquiv.ofBijective

### Template:

```
noncomputable def cl0_n_equiv : Cl0 n ≃ₐ[ℝ] Target :=
  AlgEquiv.ofBijective cl0n_forward ⟨cl0n_forward_injective, cl0n_forward_surjective⟩
```

This is the final one-liner that assembles the equivalence from bijectivity.
-/

/-!
## §9. Target Algebra Dimension Facts

For reference, the target dimensions used in the existing stack:

| n | Target | dim_ℝ(Target) | Formula |
|---|--------|---------------|---------|
| 0 | ℝ | 1 | 2⁰ |
| 1 | ℂ | 2 | 2¹ |
| 2 | ℍ | 4 | 2² |
| 3 | ℍ × ℍ | 8 | 2³ |
| 4 | M₂(ℍ) | 16 | 2⁴ |
| 5 | M₄(ℂ) | 32 | 2⁵ |
| 6 | M₈(ℝ) | 64 | 2⁶ |
| 7 | M₈(ℝ) × M₈(ℝ) | 128 | 2⁷ |

### Useful Mathlib lemmas for computing target dimensions:
- `Module.finrank_matrix`: finrank of Matrix (Fin m) (Fin m) R
- `Complex.finrank_real_complex`: finrank ℝ ℂ = 2
- `Quaternion.finrank_eq_four`: finrank ℝ ℍ = 4
- `Module.finrank_prod`: finrank of A × B = finrank A + finrank B
-/

/-!
## §10. Cl(0,6) and Cl(0,7) Planning Notes

### Cl(0,6) ≃ₐ[ℝ] M₈(ℝ)
- 64 monomials from 6 generators
- Target: Matrix (Fin 8) (Fin 8) ℝ (dim = 64)
- Generator images: 6 real 8×8 matrices squaring to -I₈, pairwise anticommuting
- Can use standard gamma matrix representations from physics literature
- The inverse extracts 64 real coefficients from the 8×8 matrix

### Cl(0,7) ≃ₐ[ℝ] M₈(ℝ) × M₈(ℝ)
- 128 monomials from 7 generators
- Target: Matrix (Fin 8) (Fin 8) ℝ × Matrix (Fin 8) (Fin 8) ℝ (dim = 128)
- Generator images: 7 pairs of 8×8 matrices
- The 7th generator maps to (I₈, -I₈) times the volume element pattern
- Extends the Cl(0,6) representation with a chirality-like splitting

### Scaling Concerns:
- 64 monomials → the span lemma and inverse map are significantly longer
- Consider using `decide` or `native_decide` for finite verification steps
- The right-inverse proof will need careful `simp` lemma management
- Heartbeat limits may need to be increased (set_option maxHeartbeats 12800000)
-/
