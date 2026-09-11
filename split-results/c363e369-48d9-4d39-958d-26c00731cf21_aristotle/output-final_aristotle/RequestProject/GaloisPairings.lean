import Mathlib
import RequestProject.Monster

/-!
# Galois pairings among the Monster's irreducible degrees

Among the 194 irreducible degrees of the Monster `M` (the list `Monster.degrees`),
exactly **170 distinct values** occur, so **23 degree values repeat**.  This file
machine-verifies the combinatorial structure of those repeats and packages it as a
"Galois pairing" picture.

## Why degrees repeat: Galois conjugacy

Two irreducible characters `χ, χ'` of a finite group are *Galois conjugate* when
`χ' = σ ∘ χ` for some `σ ∈ Gal(ℚ(ζ_e)/ℚ)` (here `e = exp M`).  Galois conjugation
permutes the irreducible characters and **preserves the degree** `χ(1) = χ'(1)`,
because `χ(1)` is a rational integer fixed by every `σ`.  Complex conjugation is the
special case `σ : ζ ↦ ζ⁻¹`, pairing each non-real character with its dual.

Consequently every nontrivial Galois orbit forces a repeated degree.  In the Monster
these orbits have size `2` (a conjugate/dual pair) or `3` (a Galois triple), which is
exactly the multiplicity structure we verify below:

* `pairing_multiplicity_le_three` — every degree occurs at most 3 times;
* `nontrivial_pairings_card` — exactly 23 degrees occur with multiplicity `> 1`;
* `paired_degrees_card` / `tripled_degrees_card` — 22 of them are pairs and 1 is a triple;
* `repeatedDegrees_correct` — the explicit list of the 23 repeated values is correct.

The *representation-theoretic* statement that these repeats come from Galois orbits is
documented here; the data itself only exhibits the repeats, which is what is proved.
-/

namespace Monster

open List

/-- The 23 degree values that occur more than once among the 194 irreducible degrees,
listed in order of first appearance. -/
def repeatedDegrees : List ℕ :=
  [8980616927734375,
   3503434660075044981,
   172399434201593354756,
   286243267692724486144,
   640558364167263622626,
   691170144025469730622,
   1480279477146615234375,
   1768130802583126953125,
   4567199176912486400000,
   42940402913709544921875,
   70660346341309333984375,
   149614794149226010902528,
   161649111002260792968750,
   191259085113459945312500,
   260799524107083767968750,
   597787522207315571077947,
   626877403613887304040448,
   689763222744895005949242,
   689766726179555080994223,
   5514132424881463208443904,
   7567151576542452425781250,
   9592298143650890255171584,
   136574874874360806036041889]

/-- There are exactly 170 distinct irreducible degrees. -/
theorem distinct_degrees_card : degrees.dedup.length = 170 := by native_decide

/-- Hence exactly 24 of the 194 entries are duplicate copies of an earlier one. -/
theorem duplicate_entries : degrees.length - degrees.dedup.length = 24 := by native_decide

/-- Every degree value occurs at most three times: Galois orbits among the
Monster's irreducibles have size at most `3`. -/
theorem pairing_multiplicity_le_three :
    ∀ d ∈ degrees, degrees.count d ≤ 3 := by native_decide

/-- Exactly 23 distinct degree values occur with multiplicity greater than one. -/
theorem nontrivial_pairings_card :
    (degrees.dedup.filter (fun d => 1 < degrees.count d)).length = 23 := by native_decide

/-- Of the repeated degrees, exactly 22 are Galois/complex-conjugate pairs
(multiplicity exactly 2). -/
theorem paired_degrees_card :
    (degrees.dedup.filter (fun d => degrees.count d = 2)).length = 22 := by native_decide

/-- Exactly one degree value occurs three times — the unique Galois triple. -/
theorem tripled_degrees_card :
    (degrees.dedup.filter (fun d => degrees.count d = 3)).length = 1 := by native_decide

/-- The unique thrice-occurring degree is `5514132424881463208443904`. -/
theorem unique_triple_value :
    degrees.dedup.filter (fun d => degrees.count d = 3)
      = [5514132424881463208443904] := by native_decide

/-- The explicit list `repeatedDegrees` is exactly the set of degrees with
multiplicity `> 1` (ordered by first occurrence). -/
theorem repeatedDegrees_correct :
    degrees.dedup.filter (fun d => 1 < degrees.count d) = repeatedDegrees := by native_decide

/-- The multiplicities partition all 194 representations: summing the orbit sizes
over the distinct degrees recovers the total count. -/
theorem pairings_sum_to_total :
    (degrees.dedup.map (fun d => degrees.count d)).sum = 194 := by native_decide

/-- Every value listed in `repeatedDegrees` genuinely repeats (multiplicity `≥ 2`)
and is an actual degree. -/
theorem repeatedDegrees_repeat :
    ∀ d ∈ repeatedDegrees, 2 ≤ degrees.count d ∧ d ∈ degrees := by native_decide

end Monster
