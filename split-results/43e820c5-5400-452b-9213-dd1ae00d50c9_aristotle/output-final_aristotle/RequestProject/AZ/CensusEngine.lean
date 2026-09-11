import RequestProject.AZ.Examples

/-!
# The dimension-advancing census engine

The **census engine** walks the spatial dimension `n : ℕ` upward and records, at
a fixed real symmetry class `s`, the resulting group of strong topological
invariants. Because of Bott periodicity the census is 8-periodic in the
dimension, and over one period it visits exactly two `ℤ`-classes — the hallmark
of the real `KO` spectrum.
-/

namespace RequestProject.AZ

/-- The census engine: at fixed Bott-clock class `s`, advancing the spatial
dimension to `n` yields the strong invariant group `azReal s n`. -/
def census (s : BottClock) (n : ℕ) : KGroup := azReal s n

/-- **8-periodicity of the census.** Advancing the dimension by a full Bott
period returns to the same invariant group. -/
theorem census_periodic (s : BottClock) (n : ℕ) :
    census s (n + 8) = census s n := by
  unfold census azReal
  congr 1
  have h8 : ((8 : ℕ) : BottClock) = 0 := by decide
  push_cast
  linear_combination -h8

/-- Over one full period (dimensions `0,1,…,7`) at class `AI`, the census visits
exactly two `ℤ`-classes — at dimensions `0` and `4`. -/
theorem census_two_Z_per_period :
    (Finset.range 8).filter (fun n => census classAI n = KGroup.Z) = {0, 4} := by
  decide

/-- The census engine advances by exactly one dimension at each step, and a
single step relates to advancing the symmetry class (spectral reduction). -/
theorem census_step (s : BottClock) (n : ℕ) :
    census (padDegen s) (n + 1) = census s n := by
  unfold census
  exact azReal_reduction s n

end RequestProject.AZ
