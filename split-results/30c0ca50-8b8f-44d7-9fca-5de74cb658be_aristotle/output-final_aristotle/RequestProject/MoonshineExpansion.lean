import Mathlib
import RequestProject.MonsterMoonshine

open scoped BigOperators

/-!
# Moonshine `q`-expansion — the infinite skeleton behind the finite Monster

This module formalizes the central observation of the design notes: in Monstrous
Moonshine the **Monster order** is *finite data* (a single integer with a finite
prime factorization — "the address book"), whereas the **`q`-expansion** of the
modular `j`-invariant is an *infinite* sequence of graded dimensions ("the city
that keeps growing").  Every finite truncation of the `q`-series admits a larger
truncation with one more coefficient — a structural analogue of the
incompleteness story already running through this project's `vault_always_incomplete`.

We make this precise with three layers of content.

* **The finite skeleton.**  `monsterOrder` is the order of the Monster group `𝕄`,
  given by its prime factorization on the 15 supersingular primes `monsterPrimes`.
  It is a single (huge but finite) natural number; `monster_order_eq` pins its
  value and `monster_order_finite_skeleton` records that the address book has
  exactly 15 prime axes.

* **The McKay–Thompson dictionary.**  The first graded dimensions of the Moonshine
  module `V♮` (equivalently, the `q`-coefficients of `j(τ) - 744`) are non-negative
  integer combinations of the first irreducible-representation dimensions `chi` of
  the Monster.  These are genuine arithmetic identities
  (`mckayThompson_1/2/3`), the equations that launched Moonshine.

* **The infinite skeleton / incompleteness.**  The graded layers are indexed by all
  of `ℕ` (layer `k` ↔ the `q^{k-1}` coefficient).  No finite truncation records
  every layer: `truncation_always_extends`, `moonshine_vault_always_incomplete`,
  and the headline contrast `address_book_finite_city_infinite`.

Honesty note: `dimLayer` records the *true* Moonshine graded dimensions only for
the displayed initial segment (layers `0..4`, i.e. the `q^{-1} .. q^{3}`
coefficients of `j - 744`); entries past layer `4` are set to `0` as placeholders
and **no theorem asserts their values are the genuine Moonshine dimensions**.  The
infinite-skeleton theorems below are about the *index set* of layers, so they are
independent of those unknown coefficients — exactly the point the notes make: the
incompleteness is structural, not about the magnitude of any particular
coefficient.

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

namespace Moonshine

/-! ## The finite skeleton: the Monster order -/

/-- The 15 supersingular primes dividing the order of the Monster group `𝕄` — the
prime axes of the finite "address book". -/
def monsterPrimes : List Nat :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The order of the Monster group `𝕄`, written as its prime factorization on the
supersingular primes:
`2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71`. -/
def monsterOrder : Nat :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-
The explicit value of the Monster order.
-/
theorem monster_order_eq :
    monsterOrder = 808017424794512875886459904961710757005754368000000000 := by
  rfl

/-
The finite skeleton: the address book has exactly 15 prime axes, and the
Monster order is a positive (finite) integer.
-/
theorem monster_order_finite_skeleton :
    monsterPrimes.length = 15 ∧ 0 < monsterOrder := by
  native_decide

/-! ## The McKay–Thompson dictionary -/

/-- The dimensions of the first few irreducible representations of the Monster
group: `χ₁ = 1` (trivial), `χ₂ = 196883` (the smallest faithful irrep),
`χ₃ = 21296876`, `χ₄ = 842609326`. -/
def chi : Nat → Nat
  | 1 => 1
  | 2 => 196883
  | 3 => 21296876
  | 4 => 842609326
  | _ => 0

/-- The graded dimension `dim Vₖ₋₁` of the Moonshine module `V♮`, equivalently the
`q^{k-1}` coefficient of `j(τ) - 744`:

* layer `0` ↔ `q^{-1}` coefficient `= 1`,
* layer `1` ↔ `q^{0}` coefficient `= 0` (the constant `744` is subtracted off),
* layer `2` ↔ `q^{1}` coefficient `= 196884`,
* layer `3` ↔ `q^{2}` coefficient `= 21493760`,
* layer `4` ↔ `q^{3}` coefficient `= 864299970`.

Entries past layer `4` are placeholders (`0`); see the module docstring. -/
def dimLayer : Nat → Nat
  | 0 => 1
  | 1 => 0
  | 2 => 196884
  | 3 => 21493760
  | 4 => 864299970
  | _ => 0

/-
The `q^{-1}` coefficient is the dimension of the head layer `V₋₁ = 1`.
-/
theorem dimLayer_head : dimLayer 0 = chi 1 := by
  rfl

/-
**McKay's equation** `196884 = 1 + 196883`: the `q¹` coefficient of `j` is the
trivial representation plus the smallest faithful Monster irrep.
-/
theorem mckayThompson_1 : dimLayer 2 = chi 1 + chi 2 := by
  decide

/-
The `q²` coefficient `21493760 = 1 + 196883 + 21296876`.
-/
theorem mckayThompson_2 : dimLayer 3 = chi 1 + chi 2 + chi 3 := by
  rfl

/-
The `q³` coefficient `864299970 = 2·1 + 2·196883 + 21296876 + 842609326`.
-/
theorem mckayThompson_3 : dimLayer 4 = 2 * chi 1 + 2 * chi 2 + chi 3 + chi 4 := by
  decide

/-
The smallest faithful Monster irrep dimension `χ₂` agrees with the cardinality
`monsterIrrepDim = 196883` proved in `MonsterMoonshine`.
-/
theorem chi2_eq_monsterIrrepDim : chi 2 = monsterIrrepDim := by
  rw [monsterIrrepDim_eq]; rfl

/-! ## The infinite skeleton: no finite truncation is complete -/

/-- A **truncation** of the Moonshine `q`-expansion to its first `N` graded layers
is the index set `{0, 1, …, N-1}`. -/
def truncation (N : Nat) : Finset Nat := Finset.range N

/-
Every truncation admits a strictly larger truncation with exactly one more
coefficient: the `q`-series never terminates.
-/
theorem truncation_always_extends (N : Nat) :
    truncation N ⊂ truncation (N + 1) ∧ N ∈ truncation (N + 1) ∧ N ∉ truncation N := by
  grind +locals

/-
**The Moonshine incompleteness.**  No finite vault (truncation) can record
every graded layer of `V♮`: there is always a layer beyond it.
-/
theorem moonshine_vault_always_incomplete (vault : Finset Nat) :
    ∃ k : Nat, k ∉ vault := by
  exact Finset.exists_notMem vault

/-
**The address book is finite, the city is infinite.**  The Monster's prime
support (the "address book") is a finite set of 15 primes, while the set of graded
Moonshine layers (the "city") is infinite.
-/
theorem address_book_finite_city_infinite :
    (monsterPrimes.toFinset.card = 15) ∧ (Set.univ : Set Nat).Infinite := by
  exact ⟨ by decide, Set.infinite_univ ⟩

end Moonshine