import RequestProject.CliffordBlades
import Mathlib

/-!
# Genuine `Module.finrank` of the Clifford algebra and its even subalgebra

`RequestProject.CliffordBlades` models the basis blades of a Clifford/exterior algebra
*combinatorially* as `Blade n := Finset (Fin n)`, and shows there are `2 ^ n` of them, split
`2^(n-1) | 2^(n-1)` into even and odd blade degree.  This module closes the loop with the
**genuine** algebra: working with honest `CliffordAlgebra Q` over a field `K`, we prove that its
`Module.finrank` equals the blade count `2 ^ n`, and that the even subalgebra has finrank
`2 ^ (n-1)` — matching exactly the even/odd blade split.

## Main results

* `finrank_exteriorAlgebra` — `Module.finrank K (ExteriorAlgebra K M) = 2 ^ finrank K M`
  for any finite free module `M` over a field `K`.
* `finrank_cliffordAlgebra` — `Module.finrank K (CliffordAlgebra Q) = 2 ^ finrank K M`
  for any quadratic form `Q` on `M` (over a field with `2` invertible), independent of signature,
  via `CliffordAlgebra.equivExterior`.
* `finrank_cliffordAlgebra_even` — the even subalgebra `CliffordAlgebra.even (Q' Q₀)` of the
  "one-up" form has finrank `2 ^ finrank K M₀`, via `CliffordAlgebra.equivEven`; i.e. the even
  subalgebra of an `n`-dimensional Clifford algebra has finrank `2 ^ (n-1)`.
* `Qn`, `finrank_cliffordAlgebra_Qn`, `finrank_cliffordAlgebra_eq_blades_card`,
  `finrank_cliffordAlgebra_even_eq_evenBlades_card` — the concrete `Fin n → K` instance and the
  bridges to the combinatorial blade counts of `RequestProject.CliffordBlades`.
-/

open Module DirectSum

namespace CliffordFinrank

/-- A `Cardinal.sum` over `ℕ` of a function that eventually vanishes collapses to the finite
`Finset.sum` over the support window `Finset.range N`. -/
theorem cardinal_sum_eventually_zero (f : ℕ → Cardinal) (N : ℕ)
    (hf : ∀ i, N ≤ i → f i = 0) :
    Cardinal.sum f = ∑ i ∈ Finset.range N, f i := by
  induction' N with N ih generalizing f
  · simp +decide [show f = fun _ => 0 from funext fun i => hf i (Nat.zero_le i)]
  · rw [Finset.sum_range_succ', ← ih]
    · rw [add_comm, Cardinal.sum_nat_eq_add_sum_succ f]
    · exact fun i hi => hf _ (Nat.succ_le_succ hi)

variable {K M : Type*} [Field K] [AddCommGroup M] [Module K M]
  [Module.Finite K M] [Module.Free K M]

/-- The exterior algebra of a finite free module has `Module.finrank` equal to `2 ^ finrank K M`. -/
theorem finrank_exteriorAlgebra :
    Module.finrank K (ExteriorAlgebra K M) = 2 ^ Module.finrank K M := by
  -- The exterior algebra is isomorphic to the direct sum of the exterior powers.
  have h_iso : ExteriorAlgebra K M ≃ₗ[K] ⨁ i : ℕ, ⋀[K]^i M :=
    DirectSum.decomposeLinearEquiv (fun i => ⋀[K]^i M)
  rw [h_iso.finrank_eq, finrank_eq_of_rank_eq (n := 2 ^ Module.finrank K M)]
  have h_rank : ∀ i : ℕ, Module.rank K (⋀[K]^i M) = (Nat.choose (Module.finrank K M) i : Cardinal) := by
    intro i
    rw [← Module.finrank_eq_rank, exteriorPower.finrank_eq]
  rw [rank_directSum]
  rw [show (fun i => Module.rank K (⋀[K]^i M)) = (fun i => (Nat.choose (Module.finrank K M) i : Cardinal)) from funext h_rank]
  rw [cardinal_sum_eventually_zero _ (Module.finrank K M + 1)
        (fun i hi => by rw [Nat.choose_eq_zero_of_lt (by omega), Nat.cast_zero])]
  rw [← Nat.cast_sum, Nat.sum_range_choose]

/-- **Genuine finrank of the Clifford algebra (signature-independent).**  Over a field in which
`2` is invertible, the Clifford algebra of any quadratic form on a finite free module `M` has
`Module.finrank` equal to `2 ^ finrank K M`. -/
theorem finrank_cliffordAlgebra (Q : QuadraticForm K M) [Invertible (2 : K)] :
    Module.finrank K (CliffordAlgebra Q) = 2 ^ Module.finrank K M := by
  rw [(CliffordAlgebra.equivExterior Q).finrank_eq, finrank_exteriorAlgebra]

/-- **Genuine finrank of the even subalgebra.**  The even subalgebra of the "one-up" Clifford
algebra of `Q₀` is isomorphic (as an algebra, via `CliffordAlgebra.equivEven`) to `CliffordAlgebra Q₀`,
so it has finrank `2 ^ finrank K M`.  Since the one-up form lives on `M × K` (dimension
`finrank K M + 1`), this is the statement that the even subalgebra of an `n`-dimensional Clifford
algebra has finrank `2 ^ (n - 1)`. -/
theorem finrank_cliffordAlgebra_even (Q₀ : QuadraticForm K M) [Invertible (2 : K)] :
    Module.finrank K (CliffordAlgebra.even (CliffordAlgebra.EquivEven.Q' Q₀)) =
      2 ^ Module.finrank K M := by
  rw [← (CliffordAlgebra.equivEven Q₀).toLinearEquiv.finrank_eq, finrank_cliffordAlgebra]

end CliffordFinrank

namespace CliffordFinrank

variable (K : Type*) [Field K] (n : ℕ)

/-- The diagonal quadratic form `∑ xᵢ²` on the `n`-dimensional space `Fin n → K`. -/
noncomputable def Qn : QuadraticForm K (Fin n → K) :=
  QuadraticMap.weightedSumSquares K (fun _ : Fin n => (1 : K))

/-- The genuine Clifford-algebra `Module.finrank` of the `n`-dimensional form `Qn` is `2 ^ n`. -/
theorem finrank_cliffordAlgebra_Qn [Invertible (2 : K)] :
    Module.finrank K (CliffordAlgebra (Qn K n)) = 2 ^ n := by
  rw [finrank_cliffordAlgebra]
  simp

/-- The genuine Clifford-algebra `Module.finrank` equals the combinatorial blade count of
`RequestProject.CliffordBlades`. -/
theorem finrank_cliffordAlgebra_eq_blades_card [Invertible (2 : K)] :
    Module.finrank K (CliffordAlgebra (Qn K n)) = (CliffordBlades.blades n).card := by
  rw [finrank_cliffordAlgebra_Qn, CliffordBlades.blades_card]

/-- The genuine even subalgebra finrank for the one-up form built on `Qn K n` equals the
combinatorial even-blade count in dimension `n + 1`, namely `2 ^ n`. -/
theorem finrank_cliffordAlgebra_even_eq_evenBlades_card [Invertible (2 : K)] :
    Module.finrank K (CliffordAlgebra.even (CliffordAlgebra.EquivEven.Q' (Qn K n))) =
      (CliffordBlades.evenBlades (n + 1)).card := by
  rw [finrank_cliffordAlgebra_even, CliffordBlades.evenBlades_card (n + 1) (Nat.succ_pos n)]
  simp

end CliffordFinrank
