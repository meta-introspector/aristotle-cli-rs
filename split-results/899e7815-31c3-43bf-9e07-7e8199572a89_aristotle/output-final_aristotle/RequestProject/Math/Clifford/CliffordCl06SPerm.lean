/-
# CliffordCl06SPerm — GramEngine Instantiation at n = 6

This file instantiates the generic `GramEngine` framework at level `n = 6`,
for the **six weighted supersingular primes** `{2, 3, 5, 7, 11, 13}` that carry
genuine valuation depth in the Monster group order.

The six generators of `Cl(0,6)` are realized as signed permutation matrices of
size 8 (`SPerm 8`), so the faithful representation lands in `M₈(ℝ)`
(indeed `Cl(0,6) ≅ M₈(ℝ)`). They are exactly the top-left `8×8` blocks of the
`Cl(0,8)` generators, i.e. the building blocks from which all higher levels are
produced by Kronecker doubling.

From the verified `GramEngine 6 8` we obtain, with **zero** additional proof work,
the faithful algebra homomorphism `Cl(0,6) →ₐ[ℝ] M₈(ℝ)`, its injectivity, and the
dimension `finrank ℝ (Cl(0,6)) = 2^6 = 64`.

## Mathematical note

This is the "weighted" half of the architecture described in the task: the six
primes with nontrivial exponents get the *full* Clifford treatment `Cl(0,6)`
(dimension `2^6`). The nine "tail" primes are handled separately as a 9-bit
binary index in `CliffordMonsterStratification.lean`.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordGenericProof

set_option maxHeartbeats 1600000

open CliffordAlgebra Matrix

noncomputable section

/-! ## §1. The six Cl(0,6) generators as `SPerm 8` -/

/-- The six generators of `Cl(0,6)` as signed permutations of `Fin 8`.

    These are the top-left `8×8` blocks `γ₀,…,γ₅` of the `Cl(0,8)` generators
    `gamSP16`; the full `Cl(0,8)` generators are `diag(γᵢ, -γᵢ)`.

    Indexing mirrors the six weighted primes `2,3,5,7,11,13`. -/
def cl06SPgen : Fin 6 → SPerm 8
  | 0 => { perm := ![1, 0, 3, 2, 5, 4, 7, 6],
           sign := ![false, true, false, true, true, false, true, false] }
  | 1 => { perm := ![2, 3, 0, 1, 6, 7, 4, 5],
           sign := ![false, true, true, false, true, false, false, true] }
  | 2 => { perm := ![3, 2, 1, 0, 7, 6, 5, 4],
           sign := ![false, false, true, true, true, true, false, false] }
  | 3 => { perm := ![4, 5, 6, 7, 0, 1, 2, 3],
           sign := ![true, true, true, true, false, false, false, false] }
  | 4 => { perm := ![5, 4, 7, 6, 1, 0, 3, 2],
           sign := ![true, false, false, true, true, false, false, true] }
  | 5 => { perm := ![6, 7, 4, 5, 2, 3, 0, 1],
           sign := ![true, true, false, false, true, true, false, false] }

/-- The signed-permutation representation `SPermRep 6 8` for `Cl(0,6)`. -/
def cl06SPermRep : SPermRep 6 8 where
  generators := cl06SPgen
  gen_bijective := by native_decide

/-! ## §2. The verified Gram engine -/

/-- The `GramEngine 6 8`: generators square to `-I`, distinct generators
    anticommute, and the 64 monomials are Gram-orthogonal (`trace = 8·δ`).
    All three invariants are discharged by `native_decide`. -/
def cl06GramEngine : GramEngine 6 8 where
  rep := cl06SPermRep
  gram_check := by native_decide
  sq_neg_id := by native_decide
  anticommute := by native_decide

/-! ## §3. Consequences from the generic framework -/

/-- The faithful representation `Cl(0,6) →ₐ[ℝ] M₈(ℝ)`. -/
def cl06Forward : Cl0 6 →ₐ[ℝ] Matrix (Fin 8) (Fin 8) ℝ :=
  cl06GramEngine.forward

/-- The representation is injective (faithful). -/
theorem cl06Forward_injective : Function.Injective cl06Forward :=
  cl06GramEngine.forward_injective (by norm_num)

/-- `finrank ℝ (Cl(0,6)) = 2^6 = 64`: the six weighted primes carry a Clifford
    algebra of dimension exactly `64`. -/
theorem cl06_finrank : Module.finrank ℝ (Cl0 6) = 2 ^ 6 :=
  cl06GramEngine.finrank_eq

/-- Restated numerically: `finrank ℝ (Cl(0,6)) = 64`. -/
theorem cl06_finrank_64 : Module.finrank ℝ (Cl0 6) = 64 := by
  rw [cl06_finrank]; norm_num

end
