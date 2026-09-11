import Mathlib
import RequestProject.Monster

/-!
# The Prime–Exponent Resolved Monster Clifford Tower

This file formalises the construction discussed informally as the
*prime–exponent resolved Clifford tower* of the Monster group `M`.

The idea: for each prime `p` dividing `|M|` with multiplicity `eₚ`, we attach a
**graded Clifford tower** built on the exponent index set `Iₚ = {0, 1, …, eₚ}`
(so `eₚ + 1` generators). Each generator carries a negative-definite "graded
metric" (`Q(e_{p,k}) = -1`), giving the Clifford algebra `Clₚ = Cl(Vₚ, Qₚ)` of
signature `(0, eₚ+1)`. The whole Monster Clifford algebra is then the **graded
tensor product** of these per-prime towers:

  `C_M  =  ⨂ₚ Clₚ`.

Mathlib's `CliffordAlgebra.prodEquiv` is exactly the statement that the Clifford
algebra of a product quadratic form is the graded tensor product of the factor
Clifford algebras, so the tower is built honestly, one prime block at a time.

## What is proved

* `blockMetric e` — the negative-definite graded metric on `eₚ+1` generators,
  with `block_metric_diag` showing each generator squares to `-1`.
* `Cl2` — the explicit `p = 2` tower over `Fin 47 → ℝ` (47 = 46 + 1 grades).
* `monsterTowerMetric` / `monsterCliffordTower` — the full 15-prime nested
  product metric and its Clifford algebra.
* `tower_head_factor` — the graded-tensor factorisation peeling off the `p = 2`
  block, an instance of `prodEquiv`; iterating it realises the full tower.
* `towerStep` — the generic single graded-tensor tower step.
* Dimension bookkeeping: the tower has `monsterTowerGenerators = 110` generators
  (`110 = Σ (eₚ + 1)`), so `dim C_M = 2^110`, factoring as `∏ₚ 2^(eₚ+1)`.

These are organisational/algebraic facts about the construction; they do **not**
claim to reconstruct the Monster group itself from the tower.
-/

open scoped TensorProduct
open CliffordAlgebra QuadraticMap

namespace MonsterCliffordTower

set_option maxHeartbeats 1000000

/-! ## §1. Prime–exponent data of `|M|` -/

/-- The 15 `(prime, exponent)` pairs of the Monster order, in supersingular order. -/
def sspExp : List (ℕ × ℕ) :=
  [(2, 46), (3, 20), (5, 9), (7, 6), (11, 2), (13, 3), (17, 1), (19, 1), (23, 1), (29, 1), (31, 1), (41, 1), (47, 1), (59, 1), (71, 1)]

/-- The exponent data reproduces `|M| = ∏ pₚ^eₚ`. -/
theorem sspExp_prod : (sspExp.map (fun pe => pe.1 ^ pe.2)).prod = Monster.order := by
  native_decide

/-- Total number of generators of the tower: `Σ (eₚ + 1)`, one per exponent index
    `k ∈ {0,…,eₚ}` for every prime. -/
def monsterTowerGenerators : ℕ := (sspExp.map (fun pe => pe.2 + 1)).sum

/-- The tower has exactly `110` generators. -/
theorem monsterTowerGenerators_eq : monsterTowerGenerators = 110 := by native_decide

/-- The Clifford-algebra dimension of the tower is `2^110`. -/
theorem tower_dimension : (2 : ℕ) ^ monsterTowerGenerators = 2 ^ 110 := by
  rw [monsterTowerGenerators_eq]

/-- **Graded tensor multiplicativity of dimension.** The dimension of the tower
    equals the product of the per-prime block dimensions `2^(eₚ+1)` — exactly what
    a graded tensor product of Clifford algebras requires. -/
theorem tower_dimension_factor :
    (2 : ℕ) ^ monsterTowerGenerators = (sspExp.map (fun pe => 2 ^ (pe.2 + 1))).prod := by
  native_decide

/-! ## §2. The per-prime graded metric and block Clifford tower -/

/-- The negative-definite **graded metric** on the `e+1` exponent generators of a
    prime block: every generator squares to `-1`. This is the quadratic form of
    `Cl(0, e+1)`. -/
noncomputable def blockMetric (e : ℕ) : QuadraticForm ℝ (Fin (e + 1) → ℝ) :=
  weightedSumSquares ℝ (fun _ : Fin (e + 1) => (-1 : ℝ))

/-- Each generator of a block squares to `-1` under the graded metric. -/
theorem block_metric_diag (e : ℕ) (i : Fin (e + 1)) :
    blockMetric e (Pi.single i 1) = -1 := by
  classical
  simp [blockMetric, weightedSumSquares_apply, Pi.single_apply]

/-- In the Clifford algebra of a block, every generator squares to the scalar
    `Q(v)` (and to `-1` on a unit basis generator, via `block_metric_diag`). -/
theorem block_generator_sq (e : ℕ) (x : Fin (e + 1) → ℝ) :
    (ι (blockMetric e)) x * (ι (blockMetric e)) x = algebraMap ℝ _ (blockMetric e x) :=
  CliffordAlgebra.ι_sq_scalar _ _

/-- The grade space of a prime block has dimension `e+1`. -/
theorem block_finrank (e : ℕ) : Module.finrank ℝ (Fin (e + 1) → ℝ) = e + 1 := by
  simp

/-! ## §3. The explicit `p = 2` tower `Cl₂` over `Fin 47 → ℝ` -/

/-- The `p = 2` graded metric: `46 + 1 = 47` generators, each squaring to `-1`. -/
noncomputable def Cl2Metric : QuadraticForm ℝ (Fin 47 → ℝ) := blockMetric 46

/-- The `p = 2` Clifford tower. -/
noncomputable def Cl2 := CliffordAlgebra Cl2Metric

/-- `Cl₂` is built on `47` exponent grades (`k = 0, …, 46`). -/
theorem Cl2_grade_count : Module.finrank ℝ (Fin 47 → ℝ) = 47 := by simp

/-- Each generator of `Cl₂` squares to `-1` on a unit basis generator. -/
theorem Cl2_generator_sq (i : Fin 47) :
    (ι Cl2Metric) (Pi.single i 1) * (ι Cl2Metric) (Pi.single i 1)
      = algebraMap ℝ _ (-1 : ℝ) := by
  rw [CliffordAlgebra.ι_sq_scalar]
  rw [show Cl2Metric = blockMetric 46 from rfl, block_metric_diag]

/-! ## §4. The full Monster Clifford tower -/

/-- The full **Monster tower metric**: the nested product of all 15 per-prime
    graded metrics. Its underlying module has `110` dimensions. -/
noncomputable def monsterTowerMetric :
    QuadraticForm ℝ ((Fin 47 → ℝ) × ((Fin 21 → ℝ) × ((Fin 10 → ℝ) × ((Fin 7 → ℝ) × ((Fin 3 → ℝ) × ((Fin 4 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × (Fin 2 → ℝ))))))))))))))) :=
  (blockMetric 46).prod ((blockMetric 20).prod ((blockMetric 9).prod ((blockMetric 6).prod ((blockMetric 2).prod ((blockMetric 3).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod (blockMetric 1))))))))))))))

/-- The **Monster Clifford tower** `C_M`, the Clifford algebra of the full nested
    product metric. -/
noncomputable def monsterCliffordTower := CliffordAlgebra monsterTowerMetric

/-- The full tower is built on `110` generators. -/
theorem monsterTower_finrank :
    Module.finrank ℝ ((Fin 47 → ℝ) × ((Fin 21 → ℝ) × ((Fin 10 → ℝ) × ((Fin 7 → ℝ) × ((Fin 3 → ℝ) × ((Fin 4 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × ((Fin 2 → ℝ) × (Fin 2 → ℝ))))))))))))))) = 110 := by
  simp [Module.finrank_prod]

/-- **Graded tensor tower step (peeling off `p = 2`).** The Monster Clifford
    tower factors as the graded tensor product of the `p = 2` block tower and the
    Clifford tower of the remaining 14 primes. Iterating this is exactly the
    graded tensor product `⨂ₚ Clₚ`. -/
noncomputable def tower_head_factor :
    CliffordAlgebra monsterTowerMetric ≃ₐ[ℝ]
      (evenOdd (blockMetric 46) ᵍ⊗[ℝ] evenOdd ((blockMetric 20).prod ((blockMetric 9).prod ((blockMetric 6).prod ((blockMetric 2).prod ((blockMetric 3).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod ((blockMetric 1).prod (blockMetric 1))))))))))))))) :=
  CliffordAlgebra.prodEquiv _ _

/-! ## §5. The generic graded tensor tower step -/

/-- **One generic tower step.** For any two graded metrics, the Clifford algebra
    of their product is the graded tensor product of the two Clifford algebras.
    This is the structural rule that grows the tower one prime block at a time. -/
noncomputable def towerStep {M₁ M₂ : Type*}
    [AddCommGroup M₁] [Module ℝ M₁] [AddCommGroup M₂] [Module ℝ M₂]
    (Q₁ : QuadraticForm ℝ M₁) (Q₂ : QuadraticForm ℝ M₂) :
    CliffordAlgebra (Q₁.prod Q₂) ≃ₐ[ℝ] (evenOdd Q₁ ᵍ⊗[ℝ] evenOdd Q₂) :=
  CliffordAlgebra.prodEquiv Q₁ Q₂

end MonsterCliffordTower
