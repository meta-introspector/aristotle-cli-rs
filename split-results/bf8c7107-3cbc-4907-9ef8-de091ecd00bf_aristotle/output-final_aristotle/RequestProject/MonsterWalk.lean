import Mathlib

/-!
# The Monster Walk: a formalization of the verifiable claims

This file formalizes the *concrete, machine-checkable* mathematical content of the note
"The Monster Group Walk and Bott Periodicity".

The original document interleaves genuine arithmetic statements about the prime
factorization of the Monster group order with physical/topological *analogies*
(topological phases, Bott periodicity, the Altland–Zirnbauer "10-fold way",
"harmonic frequencies", etc.). The physical interpretations are not mathematical
statements and cannot be formalized as theorems. What *can* be stated and proved are
the underlying arithmetic and combinatorial facts, which is what we do here:

* the value of the Monster order and its number of decimal digits;
* the "Monster Walk": removing the listed prime-power factors from `|𝕄|` preserves the
  stated leading decimal digits at each position;
* the number of groups (10) and the total digit coverage (37 of 54 digits);
* the number of factors removed in each group, and the "period-8" observation that the
  groups removing exactly 8 factors are precisely groups `{0, 5, 6, 9}` (1-indexed
  `G₁, G₆, G₇, G₁₀`);
* the "harmonic" sums `H(G₁), H(G₂), H(G₃)`;
* the "10-fold way correspondence", formalized honestly as the existence of a bijection
  between the 10 walk groups and a 10-element set of symmetry-class labels (this holds
  precisely because both sets have 10 elements; the physical content is not a theorem).

All computational claims are checked by the kernel-backed `decide`/`native_decide`.
-/

namespace MonsterWalk

/-- The 15 prime factors of the Monster order, as `(prime, exponent)` pairs (0-indexed). -/
def monsterPrimes : List (Nat × Nat) :=
  [(2, 46), (3, 20), (5, 9), (7, 6), (11, 2), (13, 3), (17, 1), (19, 1),
   (23, 1), (29, 1), (31, 1), (41, 1), (47, 1), (59, 1), (71, 1)]

/-- The order of the Monster group `𝕄`. -/
def monsterOrder : Nat :=
  2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3 * 17 * 19 * 23 * 29 * 31 * 41 *
    47 * 59 * 71

/-- The Monster order equals the product over its prime factorization data. -/
theorem monsterOrder_eq_prod :
    monsterOrder = (monsterPrimes.map (fun pe => pe.1 ^ pe.2)).prod := by
  native_decide

/-- The Monster order in decimal. -/
theorem monsterOrder_value :
    monsterOrder = 808017424794512875886459904961710757005754368000000000 := by
  native_decide

/-- The Monster order has 54 decimal digits. -/
theorem monsterOrder_numDigits : (toString monsterOrder).length = 54 := by
  native_decide

/-- A Monster Walk group: the starting decimal `position`, the preserved leading-digit
`sequence`, and the list of indices (into `monsterPrimes`) of the prime powers removed. -/
structure Group where
  position : Nat
  sequence : String
  removed : List Nat
deriving Repr, DecidableEq

/-- The 10 Monster Walk groups, exactly as tabulated in the note. -/
def monsterWalkGroups : List Group :=
  [⟨0,  "8080", [3, 4, 6, 7, 9, 10, 11, 13]⟩,
   ⟨4,  "1742", [1, 2, 5, 10]⟩,
   ⟨8,  "479",  [1, 5, 10, 14]⟩,
   ⟨11, "451",  [2, 3, 7, 11]⟩,
   ⟨14, "2875", [2, 4, 9, 11]⟩,
   ⟨18, "8864", [1, 2, 3, 4, 6, 7, 11, 14]⟩,
   ⟨22, "5990", [0, 1, 5, 10, 11, 12, 13, 14]⟩,
   ⟨26, "496",  [0, 3, 7, 10, 12, 14]⟩,
   ⟨29, "1710", [2, 11, 13]⟩,
   ⟨33, "7570", [0, 3, 6, 8, 9, 11, 12, 13]⟩]

/-- There are exactly 10 Monster Walk groups (Theorem: "The Monster Walk"). -/
theorem num_groups : monsterWalkGroups.length = 10 := by native_decide

/-- The product of the prime powers at the given indices into `monsterPrimes`. -/
def removedProduct (idxs : List Nat) : Nat :=
  (idxs.map (fun i => let pe := monsterPrimes.getD i (1, 0); pe.1 ^ pe.2)).prod

/-- Every group's removed-factor product genuinely divides the Monster order, i.e. the
removed factors are honest factors of `|𝕄|`. -/
theorem removals_divide :
    ∀ g ∈ monsterWalkGroups, monsterOrder % removedProduct g.removed = 0 := by
  native_decide

/-- **The Monster Walk.** For each group, the leading decimal digits of `|𝕄|` divided by
the removed factors agree with the digits of `|𝕄|` starting at that group's position. -/
theorem digit_preservation :
    monsterWalkGroups.all (fun g =>
      (toString (monsterOrder / removedProduct g.removed)).take g.sequence.length
        == ((toString monsterOrder).drop g.position).take g.sequence.length) = true := by
  native_decide

/-- Each group's recorded `sequence` is indeed the slice of `|𝕄|`'s decimal expansion
starting at the group's `position`. -/
theorem sequences_are_slices :
    monsterWalkGroups.all (fun g =>
      g.sequence == ((toString monsterOrder).drop g.position).take g.sequence.length)
      = true := by
  native_decide

/-- The Monster Walk covers 37 of the 54 decimal digits before terminating. -/
theorem coverage_37 :
    (monsterWalkGroups.map (fun g => g.sequence.length)).sum = 37 := by native_decide

/-- The number of factors removed in each group, in order. -/
theorem factor_counts :
    monsterWalkGroups.map (fun g => g.removed.length) = [8, 4, 4, 4, 4, 8, 8, 6, 3, 8] := by
  native_decide

/-- The numbers of factors removed all lie in `{3, 4, 6, 8}`. -/
theorem factor_counts_mem :
    ∀ g ∈ monsterWalkGroups, g.removed.length ∈ ({3, 4, 6, 8} : List Nat) := by
  native_decide

/-- **Period-8 observation.** The groups that remove exactly 8 (= 2³) factors are
precisely the groups at 0-indexed positions `{0, 5, 6, 9}`, i.e. `G₁, G₆, G₇, G₁₀`. -/
theorem bott_eight_factor_groups :
    (List.range monsterWalkGroups.length).filter
        (fun i => (monsterWalkGroups.getD i ⟨0, "", []⟩).removed.length == 8)
      = [0, 5, 6, 9] := by
  native_decide

/-- The "harmonic" of a group: `432` times the sum of `p * e` over the *kept* prime
powers (those whose indices are **not** in the removed list). -/
def harmonic (removed : List Nat) : Nat :=
  let kept := (List.range monsterPrimes.length).filter (fun i => ¬ removed.contains i)
  432 * (kept.map (fun i => let pe := monsterPrimes.getD i (1, 0); pe.1 * pe.2)).sum

/-- The harmonic sums of the first three groups, as stated in the note. -/
theorem harmonics_first_three :
    (monsterWalkGroups.take 3).map (fun g => harmonic g.removed)
      = [162864, 199584, 188352] := by
  native_decide

/-! ## The "10-fold way" correspondence

The note claims a bijection between the 10 walk groups and the 10 Altland–Zirnbauer
symmetry classes. Mathematically this is simply the statement that both are 10-element
sets, hence in bijection. We record the 10 symmetry-class labels and exhibit the
bijection. (The *physical* content of the correspondence is an analogy, not a theorem.) -/

/-- The ten Altland–Zirnbauer symmetry-class labels. -/
inductive SymmetryClass
  | A | AIII | AI | BDI | D | DIII | AII | CII | C | CI
deriving DecidableEq, Fintype, Repr

/-- There are exactly 10 symmetry classes. -/
theorem card_symmetryClass : Fintype.card SymmetryClass = 10 := by decide

/-- **10-fold way correspondence (combinatorial form).** There is a bijection between
the index set of the 10 Monster Walk groups and the 10 symmetry classes. -/
theorem tenfold_bijection :
    Nonempty (Fin monsterWalkGroups.length ≃ SymmetryClass) := by
  rw [num_groups]
  exact ⟨(Fintype.equivFinOfCardEq card_symmetryClass).symm⟩

end MonsterWalk
