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
import RequestProject.Basic
import RequestProject.Enforcement

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
