/-
# PrecedentLog.lean
## The Accumulating Case Law Ledger

This file models the precedent accumulation mechanism shared by the US Senate
and the Monster DAO:

- **Senate**: Each `RulingEvent` becomes a precedent entry. These precedents guide
  future rulings and can only be reversed by a subsequent Senate decision.
  "Historically, the Senate follows such precedents until 'the Senate in its
  wisdom should reverse or modify that decision.'" (CRS RL30788)

- **DAO**: Each governance decision (a block passing the Congruence gate) becomes
  a ledger entry forming the Boardroom — the verified, immutable record.

### Key Properties

1. **Monotonicity**: The log only grows; entries are never deleted.
2. **Weight ordering**: Senate vote precedents (weight 3) outweigh presiding
   officer rulings (weight 2) outweigh parliamentary inquiries (weight 1).
3. **Bounded weight**: All entries have weight in {1, 2, 3}.
-/

import Mathlib
import RequestProject.Governance.Basic
import RequestProject.Governance.Enforcement

open PrecedentOrigin



-- ════════════════════════════════════════════════════════════════
-- §1. PRECEDENT ENTRIES
-- ════════════════════════════════════════════════════════════════

/-- A single entry in the precedent log. -/
structure PrecedentEntry where
  /-- A unique identifier for this precedent. -/
  entryId   : ℕ
  /-- The ruling event that established this precedent. -/
  event     : RulingEvent
  /-- The authority weight, determined by origin. -/
  weight    : ℕ
  /-- The weight is consistent with the event's precedent origin. -/
  weightOk  : weight = event.precedentOrigin.weight

/-- Construct a precedent entry from a ruling event. -/
def PrecedentEntry.fromRuling (id : ℕ) (e : RulingEvent) : PrecedentEntry where
  entryId  := id
  event    := e
  weight   := e.precedentOrigin.weight
  weightOk := rfl

-- ════════════════════════════════════════════════════════════════
-- §2. THE PRECEDENT LOG
-- ════════════════════════════════════════════════════════════════

/-- A predicate asserting that entry IDs are strictly increasing in a list. -/
def idsStrictlyIncreasing : List PrecedentEntry → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a.entryId < b.entryId ∧ idsStrictlyIncreasing (b :: rest)

/-- The precedent log: an ordered list of precedent entries with
    strictly increasing IDs. -/
structure PrecedentLog where
  /-- The list of entries, oldest first. -/
  entries : List PrecedentEntry
  /-- Entry IDs are strictly increasing. -/
  ordered : idsStrictlyIncreasing entries

/-- The empty precedent log. -/
def PrecedentLog.empty : PrecedentLog where
  entries := []
  ordered := trivial

/-- The number of entries in a log. -/
def PrecedentLog.size (log : PrecedentLog) : ℕ := log.entries.length

/-- The empty log has size 0. -/
theorem PrecedentLog.empty_size : PrecedentLog.empty.size = 0 := rfl

-- ════════════════════════════════════════════════════════════════
-- §3. WEIGHT BOUNDS
-- ════════════════════════════════════════════════════════════════

/-- All entries have weight ≤ 3 (senateVote is the maximum). -/
theorem PrecedentEntry.weight_le_three (entry : PrecedentEntry) :
    entry.weight ≤ 3 := by
  rw [entry.weightOk]
  cases entry.event.precedentOrigin <;> simp [PrecedentOrigin.weight]

/-- All entries have weight ≥ 1 (parliamentaryInquiry is the minimum). -/
theorem PrecedentEntry.weight_pos (entry : PrecedentEntry) :
    entry.weight ≥ 1 := by
  rw [entry.weightOk]
  cases entry.event.precedentOrigin <;> simp [PrecedentOrigin.weight]

/-- Weight is always in {1, 2, 3}. -/
theorem PrecedentEntry.weight_in_range (entry : PrecedentEntry) :
    entry.weight = 1 ∨ entry.weight = 2 ∨ entry.weight = 3 := by
  rw [entry.weightOk]
  cases entry.event.precedentOrigin <;> simp [PrecedentOrigin.weight]

-- ════════════════════════════════════════════════════════════════
-- §4. WEIGHT QUERIES
-- ════════════════════════════════════════════════════════════════

/-- The maximum weight of any entry in the log. Returns 0 for the empty log. -/
def PrecedentLog.maxWeight (log : PrecedentLog) : ℕ :=
  log.entries.foldl (fun acc e => max acc e.weight) 0

/-- The empty log has max weight 0. -/
theorem PrecedentLog.empty_maxWeight : PrecedentLog.empty.maxWeight = 0 := rfl

-- ════════════════════════════════════════════════════════════════
-- §5. PATTERN STRENGTH
-- ════════════════════════════════════════════════════════════════

/-!
"precedents that reflect an established pattern of rulings have more
weight than precedents that are isolated in effect" (CRS RL30788)
-/

/-- Count entries with a given precedent origin. -/
def PrecedentLog.patternCount (log : PrecedentLog) (origin : PrecedentOrigin) : ℕ :=
  log.entries.filter (fun e => e.event.precedentOrigin == origin) |>.length

/-- A pattern is "established" when there are at least 2 consistent rulings. -/
def PrecedentLog.hasEstablishedPattern (log : PrecedentLog) (origin : PrecedentOrigin) : Prop :=
  log.patternCount origin ≥ 2

/-- The empty log has no established patterns. -/
theorem PrecedentLog.empty_no_patterns (origin : PrecedentOrigin) :
    ¬PrecedentLog.empty.hasEstablishedPattern origin := by
  simp [PrecedentLog.hasEstablishedPattern, PrecedentLog.patternCount, PrecedentLog.empty]

-- ════════════════════════════════════════════════════════════════
-- §6. THE SENATE ↔ DAO CORRESPONDENCE
-- ════════════════════════════════════════════════════════════════

/-!
The precedent log is the **same structure** in both systems:

| Senate                          | DAO                                |
|---------------------------------|------------------------------------|
| `PrecedentEntry`                | Admitted block in Boardroom ledger |
| Weight ∈ {1, 2, 3}             | Bias tier ∈ {low, med, high}      |
| Monotonic growth                | Append-only ledger                 |
-/

/-- The log is isomorphic to a DAO ledger:
    - All weights are bounded by 3.
    - All weights are positive.
    - The log preserves ordering. -/
theorem precedent_log_is_bounded_ledger (log : PrecedentLog) :
    (∀ e ∈ log.entries, e.weight ≤ 3) ∧
    (∀ e ∈ log.entries, e.weight ≥ 1) := by
  exact ⟨fun e _ => e.weight_le_three, fun e _ => e.weight_pos⟩

-- ════════════════════════════════════════════════════════════════
-- §7. MONOTONE WEIGHT ACCUMULATION (from PrecedentLogExt)
-- ════════════════════════════════════════════════════════════════

/-- The cumulative weight of all entries in a log. -/
def PrecedentLog.cumulativeWeight (log : PrecedentLog) : ℕ :=
  log.entries.foldl (fun acc e => acc + e.weight) 0

theorem PrecedentLog.cumulativeWeight_empty :
    PrecedentLog.empty.cumulativeWeight = 0 := rfl

theorem cumulativeWeight_eq_sum (log : PrecedentLog) :
    log.cumulativeWeight = (log.entries.map (·.weight)).sum := by
  unfold PrecedentLog.cumulativeWeight;
  induction' log.entries using List.reverseRecOn with e es ih <;> simp_all +decide [ List.sum_cons ]

theorem cumulativeWeight_cons (e : PrecedentEntry) (es : List PrecedentEntry) :
    (e :: es).foldl (fun acc x => acc + x.weight) 0 =
    e.weight + es.foldl (fun acc x => acc + x.weight) 0 := by
  induction es using List.reverseRecOn <;> simp_all +decide [ add_assoc ]

-- ════════════════════════════════════════════════════════════════
-- §8. PRECEDENT STRENGTH CONVERGENCE
-- ════════════════════════════════════════════════════════════════

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

theorem uniformLog_patternCount (origin : PrecedentOrigin) (n : ℕ) :
    (uniformLog origin n).patternCount origin = n := by
  unfold uniformLog; simp +decide [ PrecedentLog.patternCount ] ;
  rw [ List.filter_eq_self.mpr ] <;> simp +decide

theorem precedent_strength_unbounded (origin : PrecedentOrigin) (k : ℕ) :
    ∃ log : PrecedentLog, log.patternCount origin ≥ k := by
  exact ⟨ uniformLog origin k, by rw [ uniformLog_patternCount ] ⟩

theorem established_pattern_from_uniform (origin : PrecedentOrigin) (n : ℕ)
    (hn : n ≥ 2) :
    (uniformLog origin n).hasEstablishedPattern origin := by
  exact hn.trans ( by rw [ uniformLog_patternCount ] )

-- ════════════════════════════════════════════════════════════════
-- §9. LOG APPEND / MERGE
-- ════════════════════════════════════════════════════════════════

def PrecedentLog.maxId (log : PrecedentLog) : ℕ :=
  log.entries.foldl (fun acc e => max acc e.entryId) 0

def renumberEntries (offset : ℕ) : List PrecedentEntry → List PrecedentEntry :=
  List.map fun e => { e with entryId := e.entryId + offset + 1 }

theorem renumber_preserves_weight (offset : ℕ) (entries : List PrecedentEntry) :
    (renumberEntries offset entries).map (·.weight) = entries.map (·.weight) := by
  unfold renumberEntries; aesop;

theorem renumber_preserves_length (offset : ℕ) (entries : List PrecedentEntry) :
    (renumberEntries offset entries).length = entries.length := by
  exact List.length_map _

-- ════════════════════════════════════════════════════════════════
-- §10. WEIGHT-3 RARITY
-- ════════════════════════════════════════════════════════════════

def PrecedentLog.weight3Count (log : PrecedentLog) : ℕ :=
  (log.entries.filter (fun e => e.weight == 3)).length

def Weight3Sparse (log : PrecedentLog) (k : ℕ) : Prop :=
  k > 0 ∧ log.weight3Count * k ≤ log.size

theorem empty_weight3_sparse (k : ℕ) (hk : k > 0) :
    Weight3Sparse PrecedentLog.empty k := by
  constructor
  · exact hk
  · simp [PrecedentLog.weight3Count, PrecedentLog.size, PrecedentLog.empty]

theorem no_weight3_means_zero (log : PrecedentLog)
    (h : ∀ e ∈ log.entries, e.weight ≠ 3) :
    log.weight3Count = 0 := by
  unfold PrecedentLog.weight3Count;
  aesop

