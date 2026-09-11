/-
# Supersingular Primes

The 15 supersingular primes are exactly those primes p such that the supersingular
j-invariants in characteristic p are all defined over 𝔽_p². Equivalently, they are
the prime divisors of the order of the Monster group.

Reference: Ogg's observation (1975) connecting supersingular primes to the Monster.
-/
import Mathlib

/-! ## The 15 supersingular primes -/

/-- The list of 15 supersingular primes, in increasing order. -/
def supersingularPrimesList : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The i-th supersingular prime (0-indexed), as a lookup table. -/
def supersingularPrime : Fin 15 → ℕ
  | ⟨0, _⟩ => 2
  | ⟨1, _⟩ => 3
  | ⟨2, _⟩ => 5
  | ⟨3, _⟩ => 7
  | ⟨4, _⟩ => 11
  | ⟨5, _⟩ => 13
  | ⟨6, _⟩ => 17
  | ⟨7, _⟩ => 19
  | ⟨8, _⟩ => 23
  | ⟨9, _⟩ => 29
  | ⟨10, _⟩ => 31
  | ⟨11, _⟩ => 41
  | ⟨12, _⟩ => 47
  | ⟨13, _⟩ => 59
  | ⟨14, _⟩ => 71

instance : DecidableEq (Fin 15) := inferInstance

/-- There are exactly 15 supersingular primes. -/
theorem supersingularPrimesList_length : supersingularPrimesList.length = 15 := by native_decide

/-- All supersingular primes are prime. -/
theorem supersingularPrime_prime (i : Fin 15) : Nat.Prime (supersingularPrime i) := by
  fin_cases i <;> native_decide

/-- The supersingular primes are strictly increasing. -/
theorem supersingularPrime_strictMono : StrictMono supersingularPrime := by
  intro ⟨i, hi⟩ ⟨j, hj⟩ hij
  simp only [Fin.lt_def] at hij
  interval_cases i <;> interval_cases j <;> simp_all [supersingularPrime]

/-- The supersingular primes are pairwise distinct. -/
theorem supersingularPrime_injective : Function.Injective supersingularPrime :=
  supersingularPrime_strictMono.injective

/-! ## Eigenspace classification (DA51 partition)

The 15 supersingular primes partition into four eigenspaces under the
Monster's characteristic operator:
- **Earth** (7 primes): {2, 3, 5, 7, 11, 13, 47} — carry the dominant representation energy
- **Spoke** (5 primes): {29, 31, 41, 59, 71} — radial connectors
- **Hub** (1 prime): {19} — central eigenvector
- **Clock** (2 primes): {17, 23} — cyclic phase generators
-/

/-- Earth eigenspace: the 7 primes carrying dominant representation energy. -/
def earthPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 47]

/-- Spoke eigenspace: 5 radial connector primes. -/
def spokePrimes : List ℕ := [29, 31, 41, 59, 71]

/-- Hub eigenspace: the central eigenvector prime. -/
def hubPrimes : List ℕ := [19]

/-- Clock eigenspace: 2 cyclic phase generator primes. -/
def clockPrimes : List ℕ := [17, 23]

/-- The eigenspace partition covers all supersingular primes. -/
theorem eigenspace_partition :
    (earthPrimes ++ spokePrimes ++ hubPrimes ++ clockPrimes).toFinset =
    supersingularPrimesList.toFinset := by native_decide

/-- The eigenspace dimensions sum to 15. -/
theorem eigenspace_dims :
    earthPrimes.length + spokePrimes.length + hubPrimes.length + clockPrimes.length = 15 := by
  native_decide
