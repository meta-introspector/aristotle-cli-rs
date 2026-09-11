import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterMoonshine
import RequestProject.MonsterIrreps

/-!
# Divisors of the Monster, and bracketing the irreducibles and walk parts

This module adds the **divisors of the Monster** and uses them to "bracket" the other
objects already formalized: the `194` irreducible-representation degrees
(`MonsterIrreps`) and the partial parts produced by the Monster Walk
(`MonsterMoonshine.partialParts`).

## What is proved

* `monster_card_divisors`: the Monster order has exactly `424488960` divisors. This is the
  *actual* cardinality of `monsterOrder.divisors` (not merely the formula `∏ (eᵢ + 1)`),
  obtained from `Nat.card_divisors`.
* `degrees_are_divisors`: every one of the `194` irreducible degrees is a divisor of
  `|𝕄|`; i.e. the irreducibles are literally bracketed by the divisor set. Equivalently,
  the *closest divisor* to each irreducible degree is the degree itself.
* `degrees_subset_divisors` / `num_distinct_degrees`: the `194` degrees take `170` distinct
  values, all lying inside `monsterOrder.divisors`.
* `partialParts_are_divisors`: each partial part `|𝕄| / (removed factors)` of the Monster
  Walk is also a divisor of `|𝕄|`.
* `everything_bracketed`: a single statement bundling that both the irreducible degrees and
  the walk partial parts live among the `424488960` divisors, each bracketed between `1`
  and `|𝕄|`.

Scope note: the divisor lattice has `424488960` elements, far too many to enumerate
directly; the count is therefore obtained from the prime factorization via
`Nat.card_divisors`. Membership facts (`∣` / `∈ divisors`) are checked directly by the
kernel-backed `native_decide`. No `sorry` is used.
-/

namespace MonsterDivisors

open MonsterWalk MonsterIrreps

/-- The Monster order is positive. -/
theorem monsterOrder_pos : 0 < monsterOrder := by
  unfold monsterOrder; positivity

theorem monsterOrder_ne_zero : monsterOrder ≠ 0 := monsterOrder_pos.ne'

/-- **The Monster order has exactly `424488960` divisors.** This is the genuine cardinality
of `monsterOrder.divisors`, computed from the prime factorization via `Nat.card_divisors`
(`= ∏ (eᵢ + 1) = 47·21·10·7·3·4·2⁹`). -/
theorem monster_card_divisors : monsterOrder.divisors.card = 424488960 := by
  rw [Nat.card_divisors monsterOrder_ne_zero]
  native_decide

/-- **Every irreducible degree is a divisor of `|𝕄|`.** The divisor set therefore brackets
all `194` irreducibles exactly. -/
theorem degrees_are_divisors :
    ∀ r ∈ irrepRows, degOf r.exps ∈ monsterOrder.divisors := by
  intro r hr
  rw [Nat.mem_divisors]
  exact ⟨degrees_divide_order r hr, monsterOrder_ne_zero⟩

/-- The (distinct) irreducible degrees form a subset of the divisors of `|𝕄|`. -/
theorem degrees_subset_divisors :
    irrepDegrees.toFinset ⊆ monsterOrder.divisors := by
  intro d hd
  simp only [List.mem_toFinset, irrepDegrees, List.mem_map] at hd
  obtain ⟨r, hr, rfl⟩ := hd
  exact degrees_are_divisors r hr

/-- The `194` irreducible degrees take exactly `170` distinct values (some irreducibles
share a dimension). -/
theorem num_distinct_degrees : irrepDegrees.toFinset.card = 170 := by native_decide

/-- Each partial part `|𝕄| / (removed factors)` of the Monster Walk divides `|𝕄|`, hence is
a divisor. -/
theorem partialParts_are_divisors :
    ∀ x ∈ MonsterMoonshine.partialParts, x ∈ monsterOrder.divisors := by
  intro x hx
  rw [Nat.mem_divisors]
  refine ⟨?_, monsterOrder_ne_zero⟩
  simp only [MonsterMoonshine.partialParts, List.mem_map] at hx
  obtain ⟨g, hg, rfl⟩ := hx
  have h := MonsterWalk.removals_divide g hg
  exact Nat.div_dvd_of_dvd (Nat.dvd_of_mod_eq_zero h)

/-- **Everything is bracketed by the divisors.** Both the irreducible degrees and the
Monster-Walk partial parts lie in `monsterOrder.divisors` (a set of size `424488960`), and
each is bracketed `1 ≤ · ≤ |𝕄|`. -/
theorem everything_bracketed :
    monsterOrder.divisors.card = 424488960 ∧
    (∀ r ∈ irrepRows, degOf r.exps ∈ monsterOrder.divisors ∧
      1 ≤ degOf r.exps ∧ degOf r.exps ≤ monsterOrder) ∧
    (∀ x ∈ MonsterMoonshine.partialParts, x ∈ monsterOrder.divisors ∧
      1 ≤ x ∧ x ≤ monsterOrder) := by
  refine ⟨monster_card_divisors, ?_, ?_⟩
  · intro r hr
    have hmem := degrees_are_divisors r hr
    rw [Nat.mem_divisors] at hmem
    exact ⟨degrees_are_divisors r hr,
      Nat.one_le_iff_ne_zero.mpr (by
        rintro h
        rw [h] at hmem; exact monsterOrder_ne_zero (Nat.eq_zero_of_zero_dvd hmem.1)),
      Nat.le_of_dvd monsterOrder_pos hmem.1⟩
  · intro x hx
    have hmem := partialParts_are_divisors x hx
    rw [Nat.mem_divisors] at hmem
    exact ⟨partialParts_are_divisors x hx,
      Nat.one_le_iff_ne_zero.mpr (by
        rintro h
        rw [h] at hmem; exact monsterOrder_ne_zero (Nat.eq_zero_of_zero_dvd hmem.1)),
      Nat.le_of_dvd monsterOrder_pos hmem.1⟩

end MonsterDivisors
