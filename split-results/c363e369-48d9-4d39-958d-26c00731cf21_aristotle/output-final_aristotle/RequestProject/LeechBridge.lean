import Mathlib
import RequestProject.Monster
import RequestProject.Atlas

/-!
# Up to dimensions 24 and 26: the Leech lattice behind the Monster

The divisibility hypercube studied in `Shadows.lean` and `Atlas.lean` lives in
`{0,1}¹⁵` — it has **exactly 15 axes**, one per supersingular prime
(`hypercube_ambient_dim`).  So it literally *cannot* cast the shadow of a `d`-cube with
`d > 15`; the realized maximum is the `5`-cube of `MonsterShadows.cube5_shadow`, and a
`6`-cube shadow is already impossible (`MonsterShadows.no_cube6_shadow`).  The numbers
`24` and `26` therefore do **not** enter as hypercube dimensions of this matrix.  They
enter the Monster's story one level deeper, through the geometry the supersingular
primes are a *shadow of*: the **Leech lattice** `Λ₂₄` and the even unimodular
Lorentzian lattice `II₂₅,₁`.

This file certifies the arithmetic bridges to that 24/26-dimensional world.

## The 24 ⊂ 26 cannonball identity (Conway's construction of the Leech lattice)

In `II₂₅,₁` the **Weyl vector** `w = (0,1,2,…,24 ∣ 70)` is *light-like*: its norm is
`(0² + 1² + ⋯ + 24²) − 70² = 0`.  The Leech lattice is recovered as `w⊥/w`, which is
`26 − 2 = 24`-dimensional.  The whole construction hinges on the unique non-trivial
"cannonball" identity
`0² + 1² + ⋯ + 24² = 70²` (`leech_weyl_cannonball`),
which is *why* the Leech lattice sits in dimension `24` and the ambient Lorentzian
lattice in dimension `26`.

## The Conway group and the Leech kissing number

The automorphism group of `Λ₂₄` is `Co₀ = 2·Co₁`, of order
`|Co₀| = 2²²·3⁹·5⁴·7²·11·13·23` (`orderCo0_value`).  Its prime divisors are a *proper
subset* of the supersingular primes (`co0Primes_subset_supersingular`,
`supersingular_not_in_co0`): the Monster's lattice symmetry already lives inside the
supersingular world, but uses only `7` of the `15` primes.  The Leech **kissing
number** is `196560 = 2⁴·3³·5·7·13` (`leech_kissing_factorization`), again supported on
supersingular primes.

All statements are closed by `decide`/`native_decide` or elementary arithmetic (only
standard axioms).
-/

namespace LeechBridge

open Monster (supersingularPrimes)

/-! ## The hypercube is only 15-dimensional -/

/-- The divisibility hypercube has exactly 15 axes (one per supersingular prime); there
is no room for a 24- or 26-dimensional cube here.  The largest cube whose shadow the
matrix casts is the 5-cube (`MonsterShadows.cube5_shadow_exists`), and no 6-cube shadow
exists (`MonsterShadows.no_cube6_shadow`). -/
theorem hypercube_ambient_dim : MonsterAtlas.primesList.length = 15 := by native_decide

/-! ## The 24 ⊂ 26 cannonball identity -/

/-- **The Leech/Weyl cannonball identity.**  `0² + 1² + ⋯ + 24² = 70²`.  This is the
arithmetic heart of Conway's construction: it makes the Weyl vector
`(0,1,…,24 ∣ 70) ∈ II₂₅,₁` light-like, so that `Λ₂₄ = w⊥/w` is `26 − 2 = 24`
dimensional.  `24` is the only `n > 1` for which `∑_{k≤n} k²` is a perfect square. -/
theorem leech_weyl_cannonball : ∑ k ∈ Finset.range 25, k ^ 2 = 70 ^ 2 := by decide

/-- The Leech lattice dimension equals the Lorentzian dimension minus the two null
directions spanned by the Weyl vector: `24 = 26 - 2`. -/
theorem leech_dim_eq : (24 : ℕ) = 26 - 2 := by decide

/-! ## The Conway group `Co₀ = Aut(Λ₂₄)` -/

/-- The order of `Co₀ = 2·Co₁`, the automorphism group of the Leech lattice. -/
def orderCo0 : ℕ := 2 ^ 22 * 3 ^ 9 * 5 ^ 4 * 7 ^ 2 * 11 * 13 * 23

/-- The decimal value of `|Co₀|`. -/
theorem orderCo0_value : orderCo0 = 8315553613086720000 := by native_decide

/-- The prime divisors of `|Co₀|`. -/
def co0Primes : List ℕ := [2, 3, 5, 7, 11, 13, 23]

/-- The prime divisors of `|Co₀|` are exactly `{2,3,5,7,11,13,23}`. -/
theorem prime_dvd_orderCo0_iff (p : ℕ) (hp : p.Prime) :
    p ∣ orderCo0 ↔ p ∈ co0Primes := by
  constructor
  · intro hdiv
    have h_prime : p ∣ 8315553613086720000 := by
      simpa [orderCo0] using hdiv
    have h_prime_factors : p ∈ Nat.primeFactorsList 8315553613086720000 := by
      norm_num [hp, h_prime]
    norm_num [Nat.primeFactorsList] at h_prime_factors
    rcases h_prime_factors with
      (rfl | rfl | rfl | rfl | rfl | rfl | rfl) <;> trivial
  · intro hp_mem
    fin_cases hp_mem <;> native_decide

/-- **The Leech-lattice symmetry lives inside the supersingular world.**  Every prime
dividing `|Co₀| = |Aut Λ₂₄|` is one of the 15 supersingular primes. -/
theorem co0Primes_subset_supersingular :
    ∀ p ∈ co0Primes, p ∈ supersingularPrimes := by native_decide

/-- **…but it uses only 7 of the 15.**  The supersingular primes that do *not* divide
`|Co₀|` are exactly `{17,19,29,31,41,47,59,71}` — the eight "Monster-only" primes
beyond the Leech lattice's reach. -/
theorem supersingular_not_in_co0 :
    supersingularPrimes.filter (· ∉ co0Primes) = [17, 19, 29, 31, 41, 47, 59, 71] := by
  native_decide

/-! ## The Leech kissing number -/

/-- The kissing number of the Leech lattice (number of minimal vectors). -/
def leechKissing : ℕ := 196560

/-- **The Leech kissing number factors over supersingular primes**:
`196560 = 2⁴·3³·5·7·13`. -/
theorem leech_kissing_factorization : leechKissing = 2 ^ 4 * 3 ^ 3 * 5 * 7 * 13 := by
  native_decide

/-- Every prime dividing the Leech kissing number is supersingular. -/
theorem leech_kissing_primes_supersingular :
    ∀ p, p.Prime → p ∣ leechKissing → p ∈ supersingularPrimes := by
  intro p hp hdvd
  have : p ∈ Nat.primeFactorsList 196560 := by
    norm_num [hp, leechKissing] at hdvd ⊢
    exact hdvd
  norm_num [Nat.primeFactorsList] at this
  rcases this with (rfl | rfl | rfl | rfl | rfl) <;> decide

end LeechBridge
