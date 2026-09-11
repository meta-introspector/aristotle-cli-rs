import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterIrreps

/-!
# CICADA-71: the `j`-invariant Gödel encoding

This module formalizes the verifiable content of the "CICADA-71 Level 1" program, which
Gödel-encodes the `q`-expansion coefficients of Klein's modular `j`-invariant
(OEIS A000521) using the first `71` primes.

The `j`-function has the expansion
`j(τ) = q⁻¹ + 744 + 196884 q + 21493760 q² + 864299970 q³ + ⋯`,
and the central observation of monstrous moonshine is that its coefficients decompose into
the dimensions of the irreducible representations of the Monster `𝕄` — most famously
`196884 = 1 + 196883`, where `1` and `196883` are the two smallest irreducible degrees.

## What is proved

* `primes71_length`, `primes71_all_prime`, `primes71_sorted`, `primes71_eq_first71`: the
  list `primes71` is exactly the first `71` prime numbers (`2, 3, …, 353`).
* `monsterPrimes_subset_primes71`: the `15` Monster primes all occur among the first `71`
  primes (so the Gödel encoding's prime alphabet contains the Monster's prime support).
* `jA000521` records the first coefficients (the A000521 sequence `744, 196884, …`).
* `moonshine_196884`: `196884 = 1 + 196883`, the first McKay relation, linking the `j`
  coefficient to the two smallest Monster irreducible degrees (cross-checked against
  `MonsterIrreps.smallest_nontrivial_degree`).
* `godelEncode` is the (faithful, uncapped) Gödel encoding `∏ pᵢ ^ (aᵢ)`, with
  `godelEncode_nil`/`godelEncode_pos` basic sanity lemmas.

Scope note: the Rust program caps each exponent at `10` with saturating multiplication to
fit a machine `u128`; that capping is a machine-arithmetic artifact, so here we formalize
the faithful mathematical encoding instead. Monstrous moonshine itself (Borcherds' theorem)
is the motivation; what is *proved* are the arithmetic identities and the correctness of
the prime alphabet. No `sorry` is used.
-/

namespace MonsterGodel

open MonsterWalk MonsterIrreps

/-- The first `71` primes, the Gödel-encoding alphabet of CICADA-71. -/
def primes71 : List Nat :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71,
   73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151,
   157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233,
   239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317,
   331, 337, 347, 349, 353]

/-- There are `71` primes in the alphabet. -/
theorem primes71_length : primes71.length = 71 := by native_decide

/-- Every entry of `primes71` is prime. -/
theorem primes71_all_prime : ∀ p ∈ primes71, Nat.Prime p := by
  intro p hp
  fin_cases hp <;> norm_num

/-- `primes71` is strictly increasing. -/
theorem primes71_sorted : primes71.Pairwise (· < ·) := by native_decide

/-- `primes71` is **exactly** the list of the first `71` primes: it equals the increasing
enumeration of all primes below `354` (and `353` is the `71`-st prime, the next being
`359`). -/
theorem primes71_eq_first71 :
    (List.range 354).filter (fun n => decide (Nat.Prime n)) = primes71 := by
  native_decide

/-- All `15` Monster primes occur among the first `71` primes. -/
theorem monsterPrimes_subset_primes71 :
    ∀ p ∈ MonsterIrreps.primeBases, p ∈ primes71 := by native_decide

/-- The first coefficients of `j(τ)` (OEIS A000521), starting at the constant term `744`:
`744, 196884, 21493760, 864299970, 20245856256, …`. -/
def jA000521 : List Nat :=
  [744, 196884, 21493760, 864299970, 20245856256, 333202640600, 4252023300096,
   44656994071935, 401490886656000, 3176440229784420, 22567393309593600]

/-- **The first McKay relation:** `196884 = 1 + 196883`, the coefficient of `q` in `j`
written as the sum of the two smallest Monster irreducible degrees. -/
theorem moonshine_196884 : jA000521.getD 1 0 = 1 + 196883 := by native_decide

/-- The `196883` appearing above is exactly the smallest nontrivial Monster irreducible
degree (`idx = 1` in `MonsterIrreps`). -/
theorem moonshine_196884_irrep :
    ∀ r ∈ MonsterIrreps.irrepRows, r.idx = 1 →
      jA000521.getD 1 0 = 1 + degOf r.exps := by
  intro r hr h
  rw [MonsterIrreps.smallest_nontrivial_degree r hr h]
  native_decide

/-- The (faithful, uncapped) Gödel encoding of a coefficient list `as`: `∏ pᵢ ^ (aᵢ)` over
the prime alphabet `primes71`. -/
def godelEncode (as : List Nat) : Nat :=
  ((primes71.zip as).map (fun pe => pe.1 ^ pe.2)).prod

/-- The empty encoding is `1`. -/
theorem godelEncode_nil : godelEncode [] = 1 := by native_decide

/-- The Gödel encoding is always positive (no prime is `0`). -/
theorem godelEncode_pos (as : List Nat) : 0 < godelEncode as := by
  unfold godelEncode
  apply List.prod_pos
  intro x hx
  simp only [List.mem_map] at hx
  obtain ⟨pe, hpe, rfl⟩ := hx
  have : pe.1 ∈ primes71 := (List.of_mem_zip hpe).1
  exact pow_pos (primes71_all_prime _ this).pos _

end MonsterGodel
