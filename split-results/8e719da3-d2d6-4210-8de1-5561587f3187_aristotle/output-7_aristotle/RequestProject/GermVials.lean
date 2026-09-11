/-
# Germ Vials: One Clifford Algebra per Supersingular Prime

We model the Monster group's prime factorization as a tensor product of
**germ vials** — one Clifford algebra per supersingular prime, sized by its
exponent in |M|.

  |M| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71

Each prime `pᵢ` with exponent `eᵢ` contributes a *germ vial* `GermVial i = Cl(0,eᵢ)`,
the local algebraic data at that prime. The full slice algebra is the tensor
product of all 15 vials, which embeds into the ambient `Cl(0, N)` where
`N = ∑ eᵢ`.

## Correction to the informal specification

The original specification claimed `∑ eᵢ = 94` and that the vials embed into
`Cl(0,94)`. This is an arithmetic slip: the nine exponent-1 primes contribute
`9`, and `46 + 20 + 9 + 6 + 2 + 3 + 9 = 95`. Hence the correct ambient algebra
is **`Cl(0,95)`** and the total generator count is `95`. We formalize the
corrected value `95` throughout (see `germTotalGenerators`).

The specification also asked to prove `∏ 2^(eᵢ) = monsterOrder`. This too is
false: `∏ 2^(eᵢ) = 2^(∑ eᵢ) = 2⁹⁵`, which is the *dimension* of the slice
algebra, not `|M|`. The Monster order is the product of the *prime powers*
`∏ pᵢ^(eᵢ)` (already established as `monsterOrder_eq_prod` in `MonsterOrder`).
We therefore state `monsterAlgebraDim` as the dimension identity
`∏ 2^(eᵢ) = 2⁹⁵`, and recall the genuine order factorization separately.
-/
import Mathlib
import RequestProject.SupersingularPrimes
import RequestProject.MonsterOrder
import RequestProject.CliffordDefs

open scoped BigOperators

set_option maxRecDepth 4000

namespace GermVials

/-- The ambient dimension: total number of Clifford generators across all vials,
    `∑ eᵢ = 95`. -/
def ambientDim : ℕ := 95

/-! ## The germ vials -/

/-- The germ vial for prime `i`: the Clifford algebra `Cl(0, eᵢ)` whose dimension
    `2^(eᵢ)` matches the contribution of `pᵢ` to `|M|`. -/
noncomputable def GermVial (i : Fin 15) : Type := Cl (monsterExponent i)

noncomputable instance (i : Fin 15) : Ring (GermVial i) :=
  inferInstanceAs (Ring (Cl (monsterExponent i)))

noncomputable instance (i : Fin 15) : Algebra ℝ (GermVial i) :=
  inferInstanceAs (Algebra ℝ (Cl (monsterExponent i)))

/-- The total generator count across all vials is `95`. -/
theorem germTotalGenerators : ∑ i : Fin 15, monsterExponent i = 95 := by
  native_decide

/-- The dimension of vial `i` is `2^(eᵢ)`, matching `pᵢ`'s contribution to `|M|`.
    (Uses `Cl.finrank` from `CliffordDefs`.) -/
theorem germVialDim (i : Fin 15) :
    Module.finrank ℝ (GermVial i) = 2 ^ monsterExponent i :=
  Cl.finrank (monsterExponent i)

/-! ## Generator offsets

Vial `i` occupies the contiguous block of ambient generators
`[offset i, offset i + eᵢ)` in `Cl(0,95)`, where `offset i = ∑_{j < i} eⱼ`.
-/

/-- The exponent function extended to all of `ℕ` (zero outside `Fin 15`),
    convenient for summing over `Finset.range`. -/
def monsterExponentN (k : ℕ) : ℕ :=
  if h : k < 15 then monsterExponent ⟨k, h⟩ else 0

/-- The starting index of vial `i` inside `Cl(0,95)`: `∑_{j < i} eⱼ`. -/
def germGeneratorOffset (i : Fin 15) : ℕ :=
  ∑ k ∈ Finset.range i.val, monsterExponentN k

/-- The block of vial `i` fits inside the ambient `Cl(0,95)`. -/
theorem germ_block_fits (i : Fin 15) :
    germGeneratorOffset i + monsterExponent i ≤ ambientDim := by
  fin_cases i <;> native_decide

/-- Distinct vials occupy disjoint generator ranges
    `[offset i, offset i + eᵢ)` inside `Cl(0,95)`. -/
theorem germOffsets_disjoint {i j : Fin 15} (h : i ≠ j) :
    Disjoint
      (Finset.Ico (germGeneratorOffset i) (germGeneratorOffset i + monsterExponent i))
      (Finset.Ico (germGeneratorOffset j) (germGeneratorOffset j + monsterExponent j)) := by
  fin_cases i <;> fin_cases j <;> revert h <;> native_decide

/-! ## The offset embedding of a vial into the ambient algebra -/

/-- Place a vector `v : ℝⁿ` into `ℝ⁹⁵` starting at coordinate `off`. -/
noncomputable def offsetEmbed (off n : ℕ) :
    (Fin n → ℝ) →ₗ[ℝ] (Fin ambientDim → ℝ) where
  toFun v := fun j =>
    if hj : off ≤ j.val ∧ j.val < off + n then v ⟨j.val - off, by omega⟩ else 0
  map_add' u v := by
    ext j; simp only [Pi.add_apply]; split_ifs <;> ring
  map_smul' r v := by
    ext j; simp only [Pi.smul_apply, RingHom.id_apply, smul_eq_mul]; split_ifs <;> ring

/-
The offset placement preserves the negative definite quadratic form.
-/
theorem offsetEmbed_preserves_form (off n : ℕ) (h : off + n ≤ ambientDim)
    (v : Fin n → ℝ) :
    negDefQuadForm ambientDim (offsetEmbed off n v) = negDefQuadForm n v := by
  -- The sum of the squares of the offset-embedded vector is equal to the sum of the squares of the original vector because the nonzero entries are exactly the image of the injective map `i ↦ ⟨off + i, _⟩`.
  have h_sum_eq : ∑ j : Fin ambientDim, (offsetEmbed off n v) j * (offsetEmbed off n v) j = ∑ i : Fin n, v i * v i := by
    rw [ ← Finset.sum_subset ( Finset.subset_univ ( Finset.image ( fun i : Fin n => ⟨ off + i, by linarith [ Fin.is_lt i ] ⟩ : Fin n → Fin ambientDim ) Finset.univ ) ) ];
    · rw [ Finset.sum_image ] <;> norm_num [ offsetEmbed ];
      exact fun i j h => by simpa [ Fin.ext_iff ] using h;
    · simp +decide [ offsetEmbed ];
      exact fun x hx₁ hx₂ hx₃ hp hq => False.elim <| hx₁ ⟨ x - off, by omega ⟩ <| Fin.ext <| by simp +decide [ Nat.add_sub_of_le hx₂ ] ;
  unfold negDefQuadForm; aesop;

/-- The offset placement as an isometry of quadratic forms. -/
noncomputable def offsetEmbedIsometry (off n : ℕ) (h : off + n ≤ ambientDim) :
    negDefQuadForm n →qᵢ negDefQuadForm ambientDim where
  toLinearMap := offsetEmbed off n
  map_app' v := offsetEmbed_preserves_form off n h v

/-- The germ embedding: each vial `GermVial i = Cl(0, eᵢ)` embeds as an
    ℝ-algebra into the ambient `Cl(0,95)`, occupying the generator block
    `[offset i, offset i + eᵢ)`. -/
noncomputable def germEmbedding (i : Fin 15) : GermVial i →ₐ[ℝ] Cl ambientDim :=
  CliffordAlgebra.map (offsetEmbedIsometry (germGeneratorOffset i) (monsterExponent i)
    (germ_block_fits i))

/-! ## Generators and orthogonality -/

/-- The ambient coordinate index of the `k`-th generator of vial `i`. -/
def germGenIdx (i : Fin 15) (k : Fin (monsterExponent i)) : Fin ambientDim :=
  ⟨germGeneratorOffset i + k.val, by
    have := germ_block_fits i
    have := k.isLt
    omega⟩

/-- The `k`-th ambient generator vector of vial `i`: the standard basis vector
    at coordinate `germGenIdx i k`. -/
noncomputable def germGen (i : Fin 15) (k : Fin (monsterExponent i)) :
    Fin ambientDim → ℝ :=
  Pi.single (germGenIdx i k) 1

/-
Distinct vials occupy disjoint generator blocks, so their generators sit at
    distinct ambient coordinates.
-/
theorem germGenIdx_ne {i j : Fin 15} (hij : i ≠ j)
    (k : Fin (monsterExponent i)) (l : Fin (monsterExponent j)) :
    germGenIdx i k ≠ germGenIdx j l := by
  native_decide +revert

/-
The polar form of `negDefQuadForm` vanishes on distinct standard basis
    vectors.
-/
theorem negDefQuadForm_polar_single {m : ℕ} {a b : Fin m} (hab : a ≠ b) :
    QuadraticMap.polar (negDefQuadForm m) (Pi.single a (1 : ℝ)) (Pi.single b 1) = 0 := by
  simp +decide [ QuadraticMap.polar, negDefQuadForm ];
  simp +decide [ Finset.sum_add_distrib, mul_add, Pi.single_apply ];
  aesop

/-- **Orthogonality of germ vials.** Generators belonging to distinct vials
    anticommute inside the ambient Clifford algebra `Cl(0,95)`. -/
theorem germOrthogonal {i j : Fin 15} (hij : i ≠ j)
    (k : Fin (monsterExponent i)) (l : Fin (monsterExponent j)) :
    Cl.ι ambientDim (germGen i k) * Cl.ι ambientDim (germGen j l) =
      -(Cl.ι ambientDim (germGen j l) * Cl.ι ambientDim (germGen i k)) := by
  have hpolar :
      QuadraticMap.polar (negDefQuadForm ambientDim)
        (germGen i k) (germGen j l) = 0 :=
    negDefQuadForm_polar_single (germGenIdx_ne hij k l)
  have hswap := CliffordAlgebra.ι_mul_ι_add_swap
    (Q := negDefQuadForm ambientDim) (germGen i k) (germGen j l)
  rw [hpolar, map_zero] at hswap
  -- ι a * ι b + ι b * ι a = 0  ⟹  ι a * ι b = -(ι b * ι a)
  exact eq_neg_of_add_eq_zero_left hswap

/-! ## The exponent-one vials (the Boolean flag layer)

The nine primes with index `≥ 6` (17, 19, 23, 29, 31, 41, 47, 59, 71) each have
exponent `1`, so `GermVial i = Cl(0,1)`.  Their nine mutually anticommuting unit
generators span a `Cl(0,9)` subalgebra of `Cl(0,95)`, occupying the top block of
coordinates `[86, 95)`.
-/

/-- Each prime of index `≥ 6` has exponent `1`, i.e. `GermVial i = Cl(0,1)`. -/
theorem exponentOne_vial (i : Fin 15) (hi : 6 ≤ i.val) :
    monsterExponent i = 1 :=
  monsterExponent_large_primes i hi

/-- The nine exponent-one generators occupy the contiguous block `[86, 95)`. -/
theorem exponentOne_block (i : Fin 15) (hi : 6 ≤ i.val) :
    86 ≤ germGeneratorOffset i := by
  fin_cases i <;> revert hi <;> native_decide

/-- The flag layer spanned by the nine exponent-one vials is a `Cl(0,9)`, whose
    dimension is `2⁹ = 512`. -/
theorem exponentOneVials_dim : Module.finrank ℝ (Cl 9) = 512 := by
  rw [Cl.finrank]; norm_num

/-! ## Clock vs. Hub: orthogonal vials of the same type

Prime 17 (index 6, the *Clock* eigenspace) and prime 19 (index 7, the *Hub*
eigenspace) are both minimal vials `Cl(0,1)`, but they sit at distinct ambient
coordinates and their generators anticommute. -/

/-- The Clock vial (prime 17) and the Hub vial (prime 19) have the same type
    `Cl(0,1)`. -/
theorem clockHub_same_type :
    monsterExponent ⟨6, by omega⟩ = 1 ∧ monsterExponent ⟨7, by omega⟩ = 1 := by
  native_decide

/-- The Clock vial (prime 17, index 6) and the Hub vial (prime 19, index 7)
    occupy adjacent length-1 blocks: `offset 6 + 1 = offset 7`. -/
theorem clockHub_blocks_adjacent :
    germGeneratorOffset ⟨6, by omega⟩ + monsterExponent ⟨6, by omega⟩ =
      germGeneratorOffset ⟨7, by omega⟩ := by
  native_decide

/-- The Clock generator (prime 17) and the Hub generator (prime 19) are
    orthogonal vials: they anticommute inside `Cl(0,95)`. -/
theorem clockHubOrthogonal
    (k : Fin (monsterExponent ⟨6, by omega⟩))
    (l : Fin (monsterExponent ⟨7, by omega⟩)) :
    Cl.ι ambientDim (germGen ⟨6, by omega⟩ k) *
        Cl.ι ambientDim (germGen ⟨7, by omega⟩ l) =
      -(Cl.ι ambientDim (germGen ⟨7, by omega⟩ l) *
        Cl.ι ambientDim (germGen ⟨6, by omega⟩ k)) :=
  germOrthogonal (by decide) k l

/-! ## The Monster slice algebra -/

/-- The full Monster slice algebra: the product of all 15 germ vials. -/
noncomputable def MonsterAlgebra : Type := Π i : Fin 15, GermVial i

noncomputable instance : Ring MonsterAlgebra :=
  inferInstanceAs (Ring (Π i : Fin 15, GermVial i))

noncomputable instance : Algebra ℝ MonsterAlgebra :=
  inferInstanceAs (Algebra ℝ (Π i : Fin 15, GermVial i))

/-- **Dimension of the Monster slice algebra.** The product of the slice
    dimensions `2^(eᵢ)` equals `2⁹⁵`, the dimension of the ambient `Cl(0,95)`.
    (Note: this is the *algebra dimension*, not the Monster order; see the file
    header.) -/
theorem monsterAlgebraDim : ∏ i : Fin 15, 2 ^ (monsterExponent i) = 2 ^ 95 := by
  native_decide

/-- The genuine Monster order is the product of the *prime powers*
    `∏ pᵢ^(eᵢ)` — recalled here for contrast with the dimension above. -/
theorem monsterAlgebra_orderFactorization :
    monsterOrder = ∏ i : Fin 15, (supersingularPrime i) ^ (monsterExponent i) :=
  monsterOrder_eq_prod

/-! ## Irrep sparsity: each irrep activates a sparse set of vials

Each Monster irreducible representation `ρⱼ` "activates" only the germ vials whose
prime divides `dim ρⱼ`. We record the first four (verified) irreducible degrees
`1, 196883, 21296876, 842609326`; these control the leading coefficients of the
modular j-function (`196884 = 1 + 196883`, `21493760 = 1 + 196883 + 21296876`).

(The full Monster has 194 irreps; here we formalize the verified initial segment
— the type signatures and arithmetic are the deliverable.)
-/

/-- The first four irreducible character degrees of the Monster group. -/
def monsterIrrepDim : Fin 4 → ℕ
  | ⟨0, _⟩ => 1
  | ⟨1, _⟩ => 196883
  | ⟨2, _⟩ => 21296876
  | ⟨3, _⟩ => 842609326

/-- The set of vials activated by irrep `j`: the supersingular primes dividing
    `dim ρⱼ`. -/
def IrrepVialSupport (j : Fin 4) : Finset (Fin 15) :=
  Finset.univ.filter (fun i => supersingularPrime i ∣ monsterIrrepDim j)

/-- The trivial irrep (dim 1) activates no vials. -/
theorem trivial_irrep_empty_support : IrrepVialSupport 0 = ∅ := by native_decide

/-- The minimal faithful irrep `ρ₁` (dim 196883 = 47·59·71) activates exactly the
    three "ontology" vials of primes 47, 59, 71 (indices 12, 13, 14). -/
theorem rho1_support :
    IrrepVialSupport 1 = {⟨12, by omega⟩, ⟨13, by omega⟩, ⟨14, by omega⟩} := by
  native_decide

/-- Sparsity: every recorded irrep activates strictly fewer than all 15 vials. -/
theorem irrep_support_sparse (j : Fin 4) : (IrrepVialSupport j).card < 15 := by
  fin_cases j <;> native_decide

/-! ## Thompson series as parallel weight tracks

The j-function and the 170 other McKay–Thompson series are parallel "views" of the
same graded Monster module: each is obtained by weighting the irreps by a
conjugacy-class character value. We record the type signatures — the shape of the
construction. -/

/-- A conjugacy-class weight assigns an integer weight to each irrep
    (a character-value row). -/
def ConjClassWeight : Type := Fin 4 → ℤ

/-- The j-function weight: each irrep weighted by its own dimension (the
    identity-class character). -/
def jWeight : ConjClassWeight := fun j => (monsterIrrepDim j : ℤ)

/-- A graded Thompson coefficient: the weighted sum of irreps at grade `n`
    (placeholder grading concentrated at grade 0 — the type-signature meme). -/
def ThompsonCoeff (w : ConjClassWeight) (n : ℕ) : ℤ :=
  ∑ j : Fin 4, w j * (if n = 0 then 1 else 0)

/-- At grade 0 the j-weighted Thompson coefficient is the total recorded
    dimension. -/
theorem jWeight_coeff_zero :
    ThompsonCoeff jWeight 0 = 1 + 196883 + 21296876 + 842609326 := by
  native_decide

end GermVials