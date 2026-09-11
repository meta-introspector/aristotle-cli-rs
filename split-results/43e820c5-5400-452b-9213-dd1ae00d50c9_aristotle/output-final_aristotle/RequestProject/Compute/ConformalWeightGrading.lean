import RequestProject.Compute.SpectralPlane
import RequestProject.Math.Monster.GradedGenerator

/-!
# Conformal weight grading

The moonshine module is graded by **conformal weight**. With the `j`-invariant
normalization `J(q) = q⁻¹ + 196884 q + …`, the homogeneous piece sitting at
`qⁿ` carries conformal weight `n - 1`. The **weight fibre** of a weight `w`
collects all degrees with that conformal weight; since the weight function is a
bijection (a shift), each fibre is a singleton — the primary sector at that
weight.
-/

namespace RequestProject.Compute

open RequestProject.Math.Monster

/-- The conformal weight of the homogeneous piece at `qⁿ` of the `j`-invariant
graded module. -/
def conformalWeight (n : ℕ) : ℤ := (n : ℤ) - 1

/-- The **weight fibre** at conformal weight `w`: the degrees `n < N` whose
homogeneous piece has conformal weight `w`. -/
def weightFiber (N : ℕ) (w : ℤ) : Finset ℕ :=
  (Finset.range N).filter (fun n => conformalWeight n = w)

/-- The graded dimension of the primary sector at `qⁿ` is the `n`-th
`j`-coefficient. -/
def primaryDim (n : ℕ) : ℕ := jCoeff n

/-- The vacuum sector sits at conformal weight `-1` (the `q⁻¹` term). -/
theorem vacuum_weight : conformalWeight 0 = -1 := by decide

/-- The first primary sector sits at conformal weight `0`. -/
theorem first_primary_weight : conformalWeight 1 = 0 := by decide

/-- The conformal weight is injective: distinct degrees carry distinct weights. -/
theorem conformalWeight_injective {m n : ℕ} (h : conformalWeight m = conformalWeight n) :
    m = n := by
  unfold conformalWeight at h
  omega

/-- **Each weight fibre is a singleton.** Within range `N`, the fibre over the
weight `conformalWeight k` of an in-range degree `k` is exactly `{k}` — one
primary sector per conformal weight. -/
theorem weightFiber_singleton (N k : ℕ) (hk : k < N) :
    weightFiber N (conformalWeight k) = {k} := by
  unfold weightFiber
  ext n
  simp only [Finset.mem_filter, Finset.mem_range, Finset.mem_singleton]
  constructor
  · rintro ⟨_, hw⟩
    exact conformalWeight_injective hw
  · rintro rfl
    exact ⟨hk, rfl⟩

/-- The primary sector at conformal weight `0` has graded dimension
`196884 = 1 + 196883`, recovering the first moonshine head character. -/
theorem first_primary_dim : primaryDim 1 = monsterIrrep 0 + monsterIrrep 1 := by
  unfold primaryDim
  exact moonshine_head₁

end RequestProject.Compute
