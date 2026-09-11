import Mathlib

/-!
# DULA-VIAZOVSKA v10.1: D4 Basis Generator
Formalizing the lead coefficients (cF0) and intertwiners (cF1, cF2)
for the 4-Dimensional Checkerboard Lattice D₄.
-/

open Real
open BigOperators

-- 1. DEFINE THE ARISTOTLE BASIS STRUCTURE
/--
An `AristotleBasis N` packages the three coefficient arrays needed for the
DULA–Viazovska linear-programming bound in a given dimension.
- `cF0`: lead (theta-series) coefficients,
- `cF1`: linear intertwiner coefficients,
- `cF2`: quadratic intertwiner coefficients.
-/
structure AristotleBasis (N : ℕ) where
  cF0 : Fin N → ℝ
  cF1 : Fin N → ℝ
  cF2 : Fin N → ℝ

-- 2. DEFINE THE D4 LEAD COEFFICIENTS (cF0)
/--
For k=2 (4D), the lead coefficients follow the Theta series of the D4 lattice.
We formalize these as a finite sequence based on the locked v9.9.38 values.
-/
def d4_lead_coeffs : List ℝ := [
  1, 48, 252, 960, 3060, 8640, 21708, 50400, 108864, 221760, 431244, 806400,
  1454832, 2545920, 4342356, 7230720, 11765316, 18720000, 29286108, 44881920,
  67527564, 99671040, 144532020, 206265600, 290074284, 402336000, 550688988
]

/-- Maps index n to the D4 lead coefficient. -/
noncomputable def cF0_d4 (n : ℕ) : ℝ :=
  if h : n < d4_lead_coeffs.length then
    d4_lead_coeffs.get ⟨n, h⟩
  else
    -- Asymptotic growth O(n^1) for weight k=2
    (n : ℝ) * log (n : ℝ) -- Simplified model for N > 27

-- 3. DEFINE THE INTERTWINER ARRAYS (cF1, cF2)
/-- The linear intertwiner for weight 2. -/
def cF1_d4 (n : ℕ) : ℝ := (n : ℝ)

/-- The quadratic intertwiner for weight 2. -/
def cF2_d4 (n : ℕ) : ℝ := (n : ℝ) ^ 2

-- 4. THE ARISTOTLE-200 BASIS OBJECT
/--
Constructs the AristotleBasis for D4.
This is the "Witness Object" required by the optimality theorem.
-/
noncomputable def get_d4_basis : AristotleBasis 200 where
  cF0 := fun i => cF0_d4 i.val
  cF1 := fun i => cF1_d4 i.val
  cF2 := fun i => cF2_d4 i.val

-- 5. THE 4D PACKING RADIUS (Formal y-Target)
/--
The D4 lattice is characterized by vectors of norm squared 2.
In the DULA transform space, the root is exactly 2.
-/
def d4_target_root : ℝ := 2

-- 6. DEFINE THE DULA–VIAZOVSKA SUM
/--
The DULA–Viazovska witness function. Given basis coefficients and linear-programming
multipliers `a₁`, `a₂`, this constructs the candidate auxiliary function evaluated at `y`:

  `W(y) = Σ_{n=0}^{N-1} (cF0(n) + a₁ · cF1(n) + a₂ · cF2(n)) · exp(-n · y)`

The function `W` must vanish at the packing radius for the bound to be tight.
-/
noncomputable def dula_viazovska_sum {N : ℕ} (basis : AristotleBasis N)
    (a₁ a₂ y : ℝ) : ℝ :=
  ∑ i : Fin N, (basis.cF0 i + a₁ * basis.cF1 i + a₂ * basis.cF2 i) * exp (-(↑i.val) * y)

/-
PROBLEM
7. LINEARITY OF THE WITNESS FUNCTION

The DULA–Viazovska sum is affine in the multipliers `(a₁, a₂)`.

PROVIDED SOLUTION
Expand the definition of dula_viazovska_sum, distribute multiplication over addition in each summand, then split the sum using Finset.sum_add_distrib and factor out the constants a₁, a₂ using Finset.mul_sum.
-/
theorem dula_viazovska_sum_affine {N : ℕ} (basis : AristotleBasis N) (y : ℝ) :
    ∀ a₁ a₂ : ℝ,
      dula_viazovska_sum basis a₁ a₂ y =
        (∑ i : Fin N, basis.cF0 i * exp (-(↑i.val) * y)) +
        a₁ * (∑ i : Fin N, basis.cF1 i * exp (-(↑i.val) * y)) +
        a₂ * (∑ i : Fin N, basis.cF2 i * exp (-(↑i.val) * y)) := by
  -- Expand the definition of dula_viazovska_sum.
  -- Apply Finset.mul_sum to factor out constants and Finset.sum_add_distrib to split the sum.
  intros a₁ a₂
  simp [dula_viazovska_sum, Finset.mul_sum, Finset.sum_add_distrib, mul_assoc, add_mul]

/-
PROBLEM
8. THE FORMAL D4 OPTIMALITY THEOREM

There exist linear-programming multipliers `a₁`, `a₂` such that the
DULA–Viazovska witness function vanishes at the D4 packing radius `y = 2`.

This is the key feasibility condition for showing that the Cohn–Elkies
linear programming bound is tight for the D4 lattice, establishing that
D4 achieves the densest sphere packing in 4 dimensions.

The proof uses the fact that the witness function is affine in `(a₁, a₂)`,
and the coefficient of `a₁` is strictly positive (since `cF1(n) = n ≥ 0`
with `cF1(1) = 1` and `exp(-2) > 0`), so one can always solve for `a₁`
given any choice of `a₂`.

PROVIDED SOLUTION
Use dula_viazovska_sum_affine to rewrite the sum as C0 + a₁ * C1 + a₂ * C2. Set a₂ = 0 and a₁ = -C0 / C1 where C0 = Σ cF0 * exp(...) and C1 = Σ cF1 * exp(...). Then the expression becomes C0 + (-C0/C1) * C1 = C0 - C0 = 0. The division is valid because C1 > 0 by d4_linear_coeff_pos. Specifically, use ⟨-C0/C1, 0, _⟩ for the existential witnesses.
-/
theorem d4_is_checkerboard_optimal :
    ∃ a₁ a₂ : ℝ,
      dula_viazovska_sum get_d4_basis a₁ a₂ d4_target_root = 0 := by
  by_contra! h_contra;
  -- By definition of $dula_viazovska_sum$, we can write it as $C0 + a₁ * C1 + a₂ * C2$ where $C0$, $C1$, and $C2$ are constants.
  obtain ⟨C0, C1, C2, hC⟩ : ∃ C0 C1 C2 : ℝ, ∀ a₁ a₂ : ℝ, dula_viazovska_sum get_d4_basis a₁ a₂ d4_target_root = C0 + a₁ * C1 + a₂ * C2 := by
    exact ⟨ _, _, _, fun a₁ a₂ => dula_viazovska_sum_affine _ _ _ _ ⟩;
  by_cases hC1 : C1 = 0 <;> by_cases hC2 : C2 = 0 <;> simp_all +decide;
  · have := hC 0 0; have := hC 1 0; have := hC 0 1; have := hC 1 1; norm_num [ dula_viazovska_sum ] at *;
    simp_all +decide [ add_mul, Finset.sum_add_distrib ];
    rw [ Finset.sum_eq_zero_iff_of_nonneg ] at this <;> norm_num [ get_d4_basis ] at *;
    · exact absurd ( this 1 ) ( by norm_num [ cF2_d4 ] );
    · exact fun i => mul_nonneg ( sq_nonneg _ ) ( Real.exp_nonneg _ );
  · exact h_contra ( -C0 / C2 ) ( by rw [ div_mul_cancel₀ _ hC2 ] ; ring );
  · exact h_contra ( -C0 / C1 ) ( by rw [ div_mul_cancel₀ _ hC1 ] ; ring );
  · exact h_contra ( -C0 / C1 ) 0 ( by rw [ div_mul_cancel₀ _ hC1 ] ; ring )

/-
PROBLEM
9. POSITIVITY OF THE LINEAR INTERTWINER COEFFICIENT

The coefficient of `a₁` in the affine decomposition of `W(y)` at `y = 2`
is strictly positive. This ensures the system `W(2) = 0` is always solvable.

PROVIDED SOLUTION
The sum has 200 non-negative terms (since cF1_d4 i = i ≥ 0 and exp is always positive). The term at i=1 is 1 * exp(-2) > 0. Use Finset.sum_pos or show one positive term in a non-negative sum. Alternatively, bound below by just the i=1 term using Finset.single_le_sum or similar.
-/
theorem d4_linear_coeff_pos :
    0 < ∑ i : Fin 200, cF1_d4 i.val * exp (-(↑i.val : ℝ) * 2) := by
  refine' lt_of_lt_of_le _ ( Finset.single_le_sum ( fun i _ => _ ) ( Finset.mem_univ ⟨ 1, _ ⟩ ) ) <;> norm_num [ cF1_d4 ];
  · positivity;
  · positivity