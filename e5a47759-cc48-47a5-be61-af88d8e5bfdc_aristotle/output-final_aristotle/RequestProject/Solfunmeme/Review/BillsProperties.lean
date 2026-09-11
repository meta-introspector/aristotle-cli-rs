/-
  BillsProperties.lean — the rollup-schedule properties that `lean4/Bills.lean`
  advertises in its header but never states.

  The upstream header claims:
    * "Schedule is append-only (no rewriting history)"
    * "Daily rollup number is strictly increasing"
    * "Transaction inclusion requires both chambers"
  The only schedule-related theorems in the file are `append_length`
  (a restatement of `List.length_append`) and
  `day_increases (d1 d2 : Nat) (h : d1 < d2) : d1 < d2 := h`, which is `id`
  and says nothing about `Schedule` or `scheduleValid` at all.  `scheduleValid`
  is in fact never mentioned by any upstream theorem.

  Below the intended statements are proved: appending a rollup with a later day
  preserves `scheduleValid`, a valid schedule has pairwise strictly increasing
  day numbers, and the day filter used to build a bill really does select the
  slots of that day and never puts one transaction in two bills.
-/

import Mathlib.Tactic
import RequestProject.Solfunmeme.Upstream.Bills

namespace Review.Bills

/-- Strict increase of the rollup day number, as a relation on rollups. -/
abbrev DayLt (a b : DailyRollup) : Prop := a.day < b.day

instance : Trans DayLt DayLt DayLt := ⟨fun h₁ h₂ => lt_trans h₁ h₂⟩

theorem scheduleValid_iff_isChain (l : Schedule) :
    scheduleValid l ↔ l.IsChain DayLt := by
  induction l with
  | nil => simp [scheduleValid]
  | cons a t ih =>
      cases t with
      | nil => simp [scheduleValid]
      | cons b rest =>
          rw [List.isChain_cons_cons]
          exact and_congr_right fun _ => ih

/-- **Append-only.**  Adding a rollup whose day is later than the last recorded
    day keeps the schedule valid. -/
theorem scheduleValid_appendRollup (s : Schedule) (r : DailyRollup)
    (hs : scheduleValid s) (hlast : ∀ x ∈ s.getLast?, x.day < r.day) :
    scheduleValid (appendRollup s r) := by
  rw [scheduleValid_iff_isChain] at hs ⊢
  unfold appendRollup
  rw [List.isChain_append]
  refine ⟨hs, List.isChain_singleton _, ?_⟩
  intro x hx y hy
  simp only [List.head?_cons, Option.mem_def, Option.some.injEq] at hy
  subst hy
  exact hlast x hx

/-- **No rewriting history.**  In a valid schedule every earlier entry has a
    strictly smaller day number than every later one; in particular no day
    number occurs twice. -/
theorem scheduleValid_pairwise (l : Schedule) (h : scheduleValid l) :
    l.Pairwise DayLt := by
  rw [scheduleValid_iff_isChain] at h
  exact List.isChain_iff_pairwise.1 h

theorem scheduleValid_days_nodup (l : Schedule) (h : scheduleValid l) :
    (l.map DailyRollup.day).Nodup := by
  rw [List.Nodup, List.pairwise_map]
  exact (scheduleValid_pairwise l h).imp fun hab => Nat.ne_of_lt hab

/-- The number of rollups grows by exactly one per appended bill
    (upstream's `append_length`, stated for `appendRollup`). -/
theorem appendRollup_length (s : Schedule) (r : DailyRollup) :
    (appendRollup s r).length = s.length + 1 := by
  simp [appendRollup]

/-! ### The daily transaction filter -/

/-- Every transaction selected for day `[s, e)` really has its slot in that
    range (upstream only bounds the length of the filtered list). -/
theorem mem_filterDay (txs : List TxProposal) (s e : Nat) (tx : TxProposal)
    (h : tx ∈ filterDay txs s e) : s ≤ tx.slot ∧ tx.slot < e := by
  simp only [filterDay, List.mem_filter, slotInDay, Bool.and_eq_true,
    decide_eq_true_eq, ge_iff_le] at h
  exact h.2

/-- Consecutive daily bills are disjoint: a transaction cannot be included in
    two different days' rollups. -/
theorem filterDay_disjoint (txs : List TxProposal) (a b c : Nat)
    (tx : TxProposal) (h₁ : tx ∈ filterDay txs a b) (h₂ : tx ∈ filterDay txs b c) :
    False := by
  have := mem_filterDay txs a b tx h₁
  have := mem_filterDay txs b c tx h₂
  omega

/-- Every filtered transaction came from the input list. -/
theorem filterDay_subset (txs : List TxProposal) (s e : Nat) (tx : TxProposal)
    (h : tx ∈ filterDay txs s e) : tx ∈ txs :=
  List.mem_of_mem_filter h

end Review.Bills
