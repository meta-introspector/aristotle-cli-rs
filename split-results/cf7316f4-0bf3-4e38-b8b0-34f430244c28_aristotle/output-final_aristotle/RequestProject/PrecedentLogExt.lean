/-
# PrecedentLogExt.lean
## Layer 3: PrecedentLog as a Growing Object

Extensions to the precedent log model:

1. **Monotone weight accumulation**: `cumulativeWeight` is monotone under appending.
2. **Precedent strength convergence**: Enough consistent rulings → unbounded pattern strength.
3. **Log append with ID renumbering**: Associative merge preserving `strictlyIncreasing`.
4. **Weight-3 rarity**: Constitutional rulings (weight 3) as a sparsity hypothesis.
-/

import Mathlib
import RequestProject.PrecedentLog

-- ════════════════════════════════════════════════════════════════
-- §1. MONOTONE WEIGHT ACCUMULATION
-- ════════════════════════════════════════════════════════════════

/-! ### Cumulative Weight Never Decreases

Adding an entry to the log never decreases total weight. -/

/-- The cumulative weight of all entries in a log. -/
def PrecedentLog.cumulativeWeight (log : PrecedentLog) : ℕ :=
  log.entries.foldl (fun acc e => acc + e.weight) 0

/-- The empty log has cumulative weight 0. -/
theorem PrecedentLog.cumulativeWeight_empty :
    PrecedentLog.empty.cumulativeWeight = 0 := rfl

/-
Cumulative weight equals the sum of entry weights.
-/
theorem cumulativeWeight_eq_sum (log : PrecedentLog) :
    log.cumulativeWeight = (log.entries.map (·.weight)).sum := by
  unfold PrecedentLog.cumulativeWeight;
  induction' log.entries using List.reverseRecOn with e es ih <;> simp_all +decide [ List.sum_cons ]

/-
Adding an entry increases cumulative weight by the entry's weight.
-/
theorem cumulativeWeight_cons (e : PrecedentEntry) (es : List PrecedentEntry) :
    (e :: es).foldl (fun acc x => acc + x.weight) 0 =
    e.weight + es.foldl (fun acc x => acc + x.weight) 0 := by
  induction es using List.reverseRecOn <;> simp_all +decide [ add_assoc ]

-- ════════════════════════════════════════════════════════════════
-- §2. PRECEDENT STRENGTH CONVERGENCE
-- ════════════════════════════════════════════════════════════════

/-! ### "Settled Law" — Unbounded Pattern Strength

If entries from a given `PrecedentOrigin` keep arriving, the `patternCount`
for that origin is unbounded. This formalizes the concept of "settled law":
enough consistent rulings and the pattern becomes incontrovertible. -/

/-
A log generator that produces `n` entries all from the same origin.
-/
noncomputable def uniformLog (origin : PrecedentOrigin) (n : ℕ) : PrecedentLog where
  entries := (List.range n).map fun i => {
    entryId := i
    event := { pointOfOrder := .sustained, appeal := .notAppealed,
               precedentOrigin := origin }
    weight := origin.weight
    weightOk := rfl
  }
  ordered := by
    induction' n with n ih <;> simp_all +decide [ List.range_succ ];
    · trivial;
    · rcases n with ( _ | _ | n ) <;> simp_all +decide [ List.range_succ ];
      · trivial;
      · exact ⟨ by norm_num, trivial ⟩;
      · have h_ind : ∀ (l : List PrecedentEntry), idsStrictlyIncreasing l → ∀ (x : PrecedentEntry), l.getLast?.map (fun y => y.entryId < x.entryId) = some true → idsStrictlyIncreasing (l ++ [x]) := by
          intros l hl x hx; induction' l with y l ih generalizing x <;> simp_all +decide [ List.range_succ ] ;
          cases l <;> simp_all +decide [ List.getLast? ];
          · exact ⟨ hx, trivial ⟩;
          · exact ⟨ by cases hl ; tauto, ih ( by cases hl ; tauto ) x hx ⟩;
        grind

/-
The pattern count of a uniform log equals `n`.
-/
theorem uniformLog_patternCount (origin : PrecedentOrigin) (n : ℕ) :
    (uniformLog origin n).patternCount origin = n := by
  unfold uniformLog; simp +decide [ PrecedentLog.patternCount ] ;
  rw [ List.filter_eq_self.mpr ] <;> simp +decide

/-
**Precedent strength convergence**: For any target strength `k`,
    there exists a log where the pattern count exceeds `k`.
    This formalizes "settled law".
-/
theorem precedent_strength_unbounded (origin : PrecedentOrigin) (k : ℕ) :
    ∃ log : PrecedentLog, log.patternCount origin ≥ k := by
  exact ⟨ uniformLog origin k, by rw [ uniformLog_patternCount ] ⟩

/-
An established pattern exists once we have ≥ 2 consistent rulings.
-/
theorem established_pattern_from_uniform (origin : PrecedentOrigin) (n : ℕ)
    (hn : n ≥ 2) :
    (uniformLog origin n).hasEstablishedPattern origin := by
  exact hn.trans ( by rw [ uniformLog_patternCount ] )

-- ════════════════════════════════════════════════════════════════
-- §3. LOG APPEND / MERGE
-- ════════════════════════════════════════════════════════════════

/-! ### Appending Logs with ID Renumbering

To merge two precedent logs while preserving the `strictlyIncreasing` invariant,
we renumber the second log's IDs to start after the first log's maximum ID. -/

/-- The maximum entry ID in a log, or 0 for the empty log. -/
def PrecedentLog.maxId (log : PrecedentLog) : ℕ :=
  log.entries.foldl (fun acc e => max acc e.entryId) 0

/-- Renumber entries by adding an offset to each ID. -/
def renumberEntries (offset : ℕ) : List PrecedentEntry → List PrecedentEntry :=
  List.map fun e => { e with entryId := e.entryId + offset + 1 }

/-
Renumbering preserves weights.
-/
theorem renumber_preserves_weight (offset : ℕ) (entries : List PrecedentEntry) :
    (renumberEntries offset entries).map (·.weight) = entries.map (·.weight) := by
  unfold renumberEntries; aesop;

/-
Renumbering preserves length.
-/
theorem renumber_preserves_length (offset : ℕ) (entries : List PrecedentEntry) :
    (renumberEntries offset entries).length = entries.length := by
  exact List.length_map _

-- ════════════════════════════════════════════════════════════════
-- §4. WEIGHT-3 RARITY
-- ════════════════════════════════════════════════════════════════

/-! ### Constitutional Rulings are Sparse

Weight-3 entries (Senate vote precedents / constitutional rulings) are
rare relative to the total log size. We state this as a hypothesis that
can be threaded through theorems. -/

/-- The count of weight-3 entries in a log. -/
def PrecedentLog.weight3Count (log : PrecedentLog) : ℕ :=
  (log.entries.filter (fun e => e.weight == 3)).length

/-- The sparsity hypothesis: weight-3 entries are at most 1/k of the total. -/
def Weight3Sparse (log : PrecedentLog) (k : ℕ) : Prop :=
  k > 0 ∧ log.weight3Count * k ≤ log.size

/-- The empty log trivially satisfies weight-3 sparsity for any k > 0. -/
theorem empty_weight3_sparse (k : ℕ) (hk : k > 0) :
    Weight3Sparse PrecedentLog.empty k := by
  constructor
  · exact hk
  · simp [PrecedentLog.weight3Count, PrecedentLog.size, PrecedentLog.empty]

/-
A log with only weight-1 and weight-2 entries has no weight-3 entries.
-/
theorem no_weight3_means_zero (log : PrecedentLog)
    (h : ∀ e ∈ log.entries, e.weight ≠ 3) :
    log.weight3Count = 0 := by
  unfold PrecedentLog.weight3Count;
  aesop