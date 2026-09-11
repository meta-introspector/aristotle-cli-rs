import Mathlib
import RequestProject.Solfunmeme.Onchain.Holders

/-!
Correctness of the holder model and the concentration metrics.

These are the statements a reader of the report is implicitly relying on:
merging token accounts by wallet neither creates nor destroys tokens and really
does leave one entry per address; sorting only permutes; and every quantity
printed as a percentage genuinely lies in `[0,1]` and is monotone where the
report presents it as such.
-/

namespace Solana.Holders

/-! ### Aggregation -/

/-- `addTo` adds exactly the amount it is given. -/
theorem totalAmount_addTo (addr : String) (x : Nat) (hs : List Holder) :
    totalAmount (addTo addr x hs) = totalAmount hs + x := by
  induction hs with
  | nil => simp [addTo, totalAmount]
  | cons h t ih =>
      by_cases hc : h.address = addr <;> simp [addTo, hc, totalAmount] at * <;> omega

/-- `addTo` does not change which addresses are present, beyond possibly adding
`addr`. -/
theorem addresses_addTo (addr : String) (x : Nat) (hs : List Holder) :
    (addTo addr x hs).map Holder.address =
      if addr ∈ hs.map Holder.address then hs.map Holder.address
      else hs.map Holder.address ++ [addr] := by
  induction hs with
  | nil => simp [addTo]
  | cons h t ih =>
      by_cases hc : h.address = addr
      · simp [addTo, hc]
      · simp only [addTo, hc, if_false, List.map_cons, ih]
        by_cases hm : addr ∈ t.map Holder.address <;> simp [hm, Ne.symm hc]

/-- `addTo` preserves distinctness of addresses. -/
theorem nodup_addTo (addr : String) (x : Nat) (hs : List Holder)
    (h : (hs.map Holder.address).Nodup) :
    ((addTo addr x hs).map Holder.address).Nodup := by
  rw [addresses_addTo]
  by_cases hm : addr ∈ hs.map Holder.address
  · simpa [hm] using h
  · rw [if_neg hm, List.nodup_append]
    exact ⟨h, by simp, by simpa using hm⟩

/-- Merging token accounts by wallet conserves the total balance. -/
theorem totalAmount_aggregate (hs : List Holder) :
    totalAmount (aggregate hs) = totalAmount hs := by
  have key : ∀ (l : List Holder) (acc : List Holder),
      totalAmount (l.foldl (fun acc h => addTo h.address h.amount acc) acc)
        = totalAmount acc + totalAmount l := by
    intro l
    induction l with
    | nil => intro acc; simp [totalAmount]
    | cons h t ih =>
        intro acc
        rw [List.foldl_cons, ih, totalAmount_addTo]
        simp only [totalAmount, List.map_cons, List.sum_cons]
        omega
  simpa [aggregate, totalAmount] using key hs []

/-- After aggregation each address occurs exactly once. -/
theorem aggregate_nodup (hs : List Holder) :
    ((aggregate hs).map Holder.address).Nodup := by
  have key : ∀ (l acc : List Holder), ((acc.map Holder.address).Nodup) →
      (((l.foldl (fun acc h => addTo h.address h.amount acc) acc)).map Holder.address).Nodup := by
    intro l
    induction l with
    | nil => intro acc h; simpa using h
    | cons h t ih => intro acc hacc; exact ih _ (nodup_addTo _ _ _ hacc)
  exact key hs [] (by simp)

/-! ### Sorting -/

/-- Sorting only permutes the holder list. -/
theorem sortedDesc_perm (hs : List Holder) : (sortedDesc hs).Perm hs :=
  List.mergeSort_perm hs _

/-- Hence it conserves the total balance. -/
theorem totalAmount_sortedDesc (hs : List Holder) :
    totalAmount (sortedDesc hs) = totalAmount hs :=
  ((sortedDesc_perm hs).map Holder.amount).sum_eq

/-- ...and its length. -/
theorem length_sortedDesc (hs : List Holder) : (sortedDesc hs).length = hs.length :=
  (sortedDesc_perm hs).length_eq

/-! ### Top-`k` sums -/

/-- Longer prefixes of a holder list have at least as large a total. -/
theorem totalAmount_take_mono {k k' : Nat} (h : k ≤ k') (l : List Holder) :
    totalAmount (l.take k) ≤ totalAmount (l.take k') := by
  have hk : l.take k = (l.take k').take k := by rw [List.take_take, Nat.min_eq_left h]
  rw [hk, totalAmount, totalAmount]
  exact ((List.take_sublist _ _).map _).sum_le_sum (by simp)

/-- A prefix of a holder list never totals more than the whole. -/
theorem totalAmount_take_le (k : Nat) (l : List Holder) :
    totalAmount (l.take k) ≤ totalAmount l := by
  rw [totalAmount, totalAmount]
  exact ((List.take_sublist _ _).map _).sum_le_sum (by simp)

/-- Taking more holders can only increase the combined balance. -/
theorem topKAmount_mono {k k' : Nat} (h : k ≤ k') (hs : List Holder) :
    topKAmount k hs ≤ topKAmount k' hs :=
  totalAmount_take_mono h (sortedDesc hs)

/-- The top `k` holders never hold more than everybody together. -/
theorem topKAmount_le_totalAmount (k : Nat) (hs : List Holder) :
    topKAmount k hs ≤ totalAmount hs := by
  rw [topKAmount, ← totalAmount_sortedDesc hs]
  exact totalAmount_take_le k _

/-! ### Shares -/

/-- Shares are never negative. -/
theorem share_nonneg (part total : Nat) : 0 ≤ share part total := by
  rw [share]
  split
  · rfl
  · positivity

/-- A share of at most the whole is at most `1`. -/
theorem share_le_one {part total : Nat} (h : part ≤ total) : share part total ≤ 1 := by
  rw [share]
  split
  · norm_num
  · rename_i ht
    have ht' : (0 : Rat) < (total : Rat) := by
      have : total ≠ 0 := ht
      positivity
    rw [div_le_one ht']
    exact_mod_cast h

/-- Shares are monotone in the numerator. -/
theorem share_mono {a b total : Nat} (h : a ≤ b) : share a total ≤ share b total := by
  rw [share, share]
  split
  · rfl
  · rename_i ht
    have ht' : (0 : Rat) < (total : Rat) := by
      have : total ≠ 0 := ht
      positivity
    have : (a : Rat) ≤ (b : Rat) := by exact_mod_cast h
    exact (div_le_div_iff_of_pos_right ht').mpr this

/-- The reported top-`k` share is a genuine fraction. -/
theorem topKShare_nonneg (k : Nat) (hs : List Holder) (total : Nat) :
    0 ≤ topKShare k hs total := share_nonneg _ _

/-- ...at most one, as long as the ingested holders really are part of `total`. -/
theorem topKShare_le_one (k : Nat) (hs : List Holder) {total : Nat}
    (h : totalAmount hs ≤ total) : topKShare k hs total ≤ 1 :=
  share_le_one (le_trans (topKAmount_le_totalAmount k hs) h)

/-- ...and monotone in `k`, which is what makes the cumulative column of the
report meaningful. -/
theorem topKShare_mono {k k' : Nat} (h : k ≤ k') (hs : List Holder) (total : Nat) :
    topKShare k hs total ≤ topKShare k' hs total :=
  share_mono (topKAmount_mono h hs)

/-! ### Herfindahl–Hirschman -/

/-- The sum of squares is dominated by the square of the sum. -/
theorem sq_sum_le (hs : List Holder) :
    (hs.map (fun h => h.amount * h.amount)).sum ≤ totalAmount hs * totalAmount hs := by
  induction hs with
  | nil => simp [totalAmount]
  | cons h t ih =>
      simp only [List.map_cons, List.sum_cons, totalAmount] at *
      nlinarith [ih, Nat.zero_le h.amount, Nat.zero_le (t.map Holder.amount).sum]

/-- Closed form of the index for a nonzero supply. -/
theorem herfindahl_eq (hs : List Holder) {total : Nat} (ht : total ≠ 0) :
    herfindahl hs total
      = (((hs.map (fun h => h.amount * h.amount)).sum : Nat) : Rat) / ((total : Rat) * total) := by
  induction hs with
  | nil => simp [herfindahl]
  | cons h t ih =>
      simp only [herfindahl, List.map_cons, List.sum_cons] at *
      rw [ih, share, if_neg ht]
      push_cast
      ring

/-- The index is never negative. -/
theorem herfindahl_nonneg (hs : List Holder) (total : Nat) : 0 ≤ herfindahl hs total := by
  rw [herfindahl]
  refine List.sum_nonneg ?_
  intro x hx
  simp only [List.mem_map] at hx
  obtain ⟨h, _, rfl⟩ := hx
  exact mul_self_nonneg _

/-- The index is at most `1`; it approaches `1` exactly when a single holder owns
the entire supply. -/
theorem herfindahl_le_one (hs : List Holder) {total : Nat} (h : totalAmount hs ≤ total) :
    herfindahl hs total ≤ 1 := by
  rcases Nat.eq_zero_or_pos total with rfl | ht
  · simp [herfindahl, share]
  · have ht' : total ≠ 0 := by omega
    rw [herfindahl_eq hs ht', div_le_one (by positivity)]
    have h1 : (((hs.map (fun h => h.amount * h.amount)).sum : Nat) : Rat)
        ≤ ((totalAmount hs * totalAmount hs : Nat) : Rat) := by
      exact_mod_cast sq_sum_le hs
    have h2 : ((totalAmount hs * totalAmount hs : Nat) : Rat) ≤ (total : Rat) * total := by
      push_cast
      have hc : ((totalAmount hs : Rat)) ≤ (total : Rat) := by exact_mod_cast h
      nlinarith [Nat.cast_nonneg (α := Rat) (totalAmount hs)]
    linarith

/-! ### Nakamoto coefficient -/

/-- If a Nakamoto coefficient is reported, the top that many holders really do
control more than half of the supply, and no smaller set does. -/
theorem nakamoto_spec {hs : List Holder} {total k : Nat} (h : nakamoto hs total = some k) :
    k ≤ hs.length ∧ 1 < 2 * topKShare k hs total ∧
      ∀ j < k, ¬ (1 < 2 * topKShare j hs total) := by
  rw [nakamoto, List.find?_eq_some_iff_getElem] at h
  obtain ⟨hp, i, hi, hik, hj⟩ := h
  simp only [List.length_range] at hi
  simp only [List.getElem_range] at hik
  subst hik
  refine ⟨by omega, by simpa using hp, ?_⟩
  intro j hjk
  have hjj := hj j hjk
  simp only [List.getElem_range, Bool.not_eq_true', decide_eq_false_iff_not] at hjj
  exact hjj

/-- If no Nakamoto coefficient is reported, then even all of the ingested holders
together do not control half of the supply. -/
theorem nakamoto_none {hs : List Holder} {total : Nat} (h : nakamoto hs total = none) :
    ¬ (1 < 2 * topKShare hs.length hs total) := by
  rw [nakamoto, List.find?_eq_none] at h
  simpa using h hs.length (by simp)

/-- If the ingested holders together do not reach half of `total`, no Nakamoto
coefficient exists. -/
theorem nakamoto_eq_none_of_le_half {hs : List Holder} {total : Nat}
    (h : 2 * share (totalAmount hs) total ≤ 1) : nakamoto hs total = none := by
  rw [nakamoto, List.find?_eq_none]
  intro k _
  simp only [Bool.not_eq_true, decide_eq_false_iff_not, not_lt]
  have hk : topKShare k hs total ≤ share (totalAmount hs) total :=
    share_mono (topKAmount_le_totalAmount k hs)
  linarith

end Solana.Holders
