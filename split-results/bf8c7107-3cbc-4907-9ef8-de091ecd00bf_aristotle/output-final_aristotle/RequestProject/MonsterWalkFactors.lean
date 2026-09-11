import Mathlib
import RequestProject.MonsterWalk

/-!
# Are the Monster-Walk numbers factors of the Monster?

The Monster Walk (see `RequestProject.MonsterWalk`) produces ten leading-digit
sequences
```
8080, 1742, 479, 451, 2875, 8864, 5990, 496, 1710, 7570
```
read off the decimal expansion of `|𝕄|`.  This module answers a concrete question
about these ten numbers:

> Read as ordinary integers, **which of them are factors (divisors) of `|𝕄|`?**
> How many?  And following what pattern?

The answers are all decided directly by the kernel (`decide` / `native_decide`):

* **How many.**  Exactly **four** of the ten sequences divide `|𝕄|`
  (`num_factors_eq_four`):
  these are `451, 2875, 496, 1710` (`factors_of_monster`), occurring at the walk
  groups `G₄, G₅, G₈, G₉` (0-indexed `3, 4, 7, 8`; `factor_group_indices`).

* **The pattern.**  A sequence `n` divides `|𝕄|` **iff every prime factor of `n` is a
  Monster prime** (`factor_iff_monsterSmooth`).  The four divisors factor entirely over
  the Monster primes,
  `451 = 11·41`, `2875 = 5³·23`, `496 = 2⁴·31`, `1710 = 2·3²·5·19`
  (`factorizations`); each of the six non-divisors carries a prime **outside** the
  fifteen Monster primes — `8080 = 2⁴·5·101`, `1742 = 2·13·67`, `479` prime,
  `8864 = 2⁵·277`, `5990 = 2·5·599`, `7570 = 2·5·757`
  (`non_factors_have_outside_prime`).

* **A walk pattern.**  None of the four "Bott" walk groups — the groups removing exactly
  `8 = 2³` factors (`G₁, G₆, G₇, G₁₀`) — has a sequence that divides `|𝕄|`
  (`bott_groups_not_factors`).

Here a number is *Monster-smooth* when all of its prime factors lie among the fifteen
Monster primes `{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}`.
-/

namespace MonsterWalkFactors

open MonsterWalk

/-- The fifteen Monster primes, as a `Finset`. -/
def monsterPrimeFs : Finset Nat :=
  {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

/-- A natural number is *Monster-smooth* when every prime dividing it is a Monster
prime. -/
def MonsterSmooth (n : Nat) : Prop := n.primeFactors ⊆ monsterPrimeFs

instance (n : Nat) : Decidable (MonsterSmooth n) := by
  unfold MonsterSmooth; infer_instance

/-- The ten Monster-Walk leading-digit sequences, read as integers. -/
def walkSeqs : List Nat :=
  [8080, 1742, 479, 451, 2875, 8864, 5990, 496, 1710, 7570]

/-- The `walkSeqs` are exactly the recorded group sequences of the Monster Walk, parsed
as natural numbers. -/
theorem walkSeqs_eq_group_sequences :
    monsterWalkGroups.map (fun g => g.sequence.toNat!) = walkSeqs := by
  native_decide

/-! ## How many of the sequences are factors of `|𝕄|`? -/

/-- **The factors among the walk sequences.**  Exactly `451, 2875, 496, 1710` divide
`|𝕄|`. -/
theorem factors_of_monster :
    walkSeqs.filter (fun n => decide (n ∣ monsterOrder)) = [451, 2875, 496, 1710] := by
  native_decide

/-- **How many.**  Exactly four of the ten walk sequences are factors of `|𝕄|`. -/
theorem num_factors_eq_four :
    (walkSeqs.filter (fun n => decide (n ∣ monsterOrder))).length = 4 := by
  native_decide

/-- The four dividing sequences occur at the walk groups with 0-indexed positions
`3, 4, 7, 8` (i.e. `G₄, G₅, G₈, G₉`). -/
theorem factor_group_indices :
    (List.range monsterWalkGroups.length).filter (fun i =>
        decide ((monsterWalkGroups.getD i ⟨0, "", []⟩).sequence.toNat! ∣ monsterOrder))
      = [3, 4, 7, 8] := by
  native_decide

/-! ## The pattern: dividing `|𝕄|` ⇔ Monster-smooth -/

/-- **The pattern.**  Among the ten walk sequences, a sequence divides `|𝕄|` *exactly
when* it is Monster-smooth — i.e. all of its prime factors are Monster primes. -/
theorem factor_iff_monsterSmooth :
    ∀ n ∈ walkSeqs, (n ∣ monsterOrder ↔ MonsterSmooth n) := by
  native_decide

/-- The explicit prime factorizations of the four dividing sequences: each factors
entirely over the Monster primes. -/
theorem factorizations :
    (451 = 11 * 41) ∧
    (2875 = 5 ^ 3 * 23) ∧
    (496 = 2 ^ 4 * 31) ∧
    (1710 = 2 * 3 ^ 2 * 5 * 19) := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> norm_num

/-- The four dividing sequences are Monster-smooth (all prime factors are Monster
primes). -/
theorem factors_are_monsterSmooth :
    MonsterSmooth 451 ∧ MonsterSmooth 2875 ∧ MonsterSmooth 496 ∧ MonsterSmooth 1710 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide

/-- **Each non-divisor carries a prime outside the Monster's support.**  For each of the
six sequences that do *not* divide `|𝕄|`, we exhibit a prime `p` dividing the sequence
that is **not** one of the fifteen Monster primes (hence does not divide `|𝕄|`). -/
theorem non_factors_have_outside_prime :
    [(8080, 101), (1742, 67), (479, 479), (8864, 277), (5990, 599), (7570, 757)].all
      (fun pr => Nat.Prime pr.2 && pr.1 % pr.2 == 0 && !(pr.2 ∣ monsterOrder)) = true := by
  native_decide

/-! ## A walk pattern: the Bott groups are never factors -/

/-- **The Bott groups are never factors.**  Every walk group that removes exactly
`8 = 2³` prime-power factors (the groups `G₁, G₆, G₇, G₁₀`) has a leading sequence that
is *not* a divisor of `|𝕄|`. -/
theorem bott_groups_not_factors :
    ∀ g ∈ monsterWalkGroups,
      g.removed.length = 8 → ¬ (g.sequence.toNat! ∣ monsterOrder) := by
  native_decide

/-! ## Summary -/

/-- **Summary.**  Of the ten Monster-Walk sequences, exactly four are factors of `|𝕄|`,
namely `451, 2875, 496, 1710`; a sequence is a factor precisely when it is
Monster-smooth; and no Bott (8-factor-removal) group yields a factor. -/
theorem monster_walk_factors_summary :
    (walkSeqs.filter (fun n => decide (n ∣ monsterOrder))).length = 4 ∧
    walkSeqs.filter (fun n => decide (n ∣ monsterOrder)) = [451, 2875, 496, 1710] ∧
    (∀ n ∈ walkSeqs, (n ∣ monsterOrder ↔ MonsterSmooth n)) ∧
    (∀ g ∈ monsterWalkGroups,
      g.removed.length = 8 → ¬ (g.sequence.toNat! ∣ monsterOrder)) :=
  ⟨num_factors_eq_four, factors_of_monster, factor_iff_monsterSmooth,
    bott_groups_not_factors⟩

end MonsterWalkFactors
