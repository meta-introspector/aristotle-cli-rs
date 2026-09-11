import RequestProject.Tracker.Types

/-!
# The timing model: latency, staleness, the rolling window and its percentiles

This file models the numeric side of `service.ts`:

* `age now t` — how old a post is at the moment we look at it;
* `isStale cap now t` — the `MAX_TWEET_AGE_MS` guard (`now - createdAt > cap`);
* `recordDetect` — the bounded rolling window of the last `n` detections
  (`detectMs.push(v); if (detectMs.length > 50) detectMs.shift()`);
* `pct` — the percentile readout the dashboard header shows
  (`s[Math.min(s.length - 1, Math.floor(s.length * p / 100))]` over the sorted
  window).

The facts proved here are the ones that make the reported latency figures
meaningful: the window is bounded and contains only recorded detections, every
percentile is an actually-observed sample, percentiles are monotone in `p` (so
`p50 ≤ p90 ≤ p99` always), and every percentile is bounded by any bound that
holds for the whole window.
-/

namespace Tracker

/-- Age of a post at wall-clock time `now` (truncating, i.e. never negative). -/
def age (now : Nat) (t : Tweet) : Nat := now - t.createdAt

/-- The `MAX_TWEET_AGE_MS` guard: a post older than the cap is a stale replay. -/
def isStale (cap now : Nat) (t : Tweet) : Prop := cap < age now t

instance (cap now : Nat) (t : Tweet) : Decidable (isStale cap now t) := by
  unfold isStale; infer_instance

theorem not_stale_iff (cap now : Nat) (t : Tweet) :
    ¬ isStale cap now t ↔ age now t ≤ cap := by
  simp [isStale]

/-- A post seen at `now` reports exactly its age as `detectMs`. -/
theorem detectMs_eq_age {now : Nat} {t : Tweet} (h : t.timedAt now) :
    t.detectMs = age now t := h.2

/-! ## The rolling detection window -/

/-- Append to a bounded, insertion-ordered buffer, evicting the oldest entries
until at most `cap` remain.  This is the shape of both the detection window
(`detectMs.push(v); if (detectMs.length > 50) detectMs.shift()`) and the
`recentTweets` ring. -/
def pushBounded {α : Type _} (cap : Nat) (l : List α) (x : α) : List α :=
  (l ++ [x]).drop (l.length + 1 - cap)

@[simp] theorem length_pushBounded {α : Type _} (cap : Nat) (l : List α) (x : α) :
    (pushBounded cap l x).length = min (l.length + 1) cap := by
  simp only [pushBounded, List.length_drop, List.length_append, List.length_singleton]
  omega

/-- A bounded buffer never exceeds its cap. -/
theorem length_pushBounded_le {α : Type _} (cap : Nat) (l : List α) (x : α) :
    (pushBounded cap l x).length ≤ cap := by
  simp

/-- The newest entry is retained (the cap is at least one). -/
theorem mem_pushBounded_self {α : Type _} {cap : Nat} (hcap : 1 ≤ cap) (l : List α) (x : α) :
    x ∈ pushBounded cap l x := by
  have hlen : l.length + 1 - cap ≤ l.length := by omega
  have hx : (l ++ [x]).drop l.length = [x] := by simp
  have hsub := List.drop_subset_drop_left (l := l ++ [x]) hlen
  exact hsub (by simp [hx])

/-- Nothing is invented: every entry of the new buffer was already in the old
one or is the entry just appended. -/
theorem mem_pushBounded {α : Type _} {cap : Nat} {l : List α} {x y : α}
    (hy : y ∈ pushBounded cap l x) : y ∈ l ∨ y = x := by
  have hy' : y ∈ l ++ [x] := (List.drop_subset _ _) hy
  rcases List.mem_append.mp hy' with h | h
  · exact Or.inl h
  · exact Or.inr (by simpa using h)

/-- `recordDetect`: append a sample, then drop the oldest while the window
exceeds `cap`. -/
def recordDetect (cap : Nat) (window : List Nat) (v : Nat) : List Nat :=
  pushBounded cap window v

@[simp] theorem length_recordDetect (cap : Nat) (window : List Nat) (v : Nat) :
    (recordDetect cap window v).length = min (window.length + 1) cap :=
  length_pushBounded _ _ _

/-- The window never exceeds its cap. -/
theorem length_recordDetect_le (cap : Nat) (window : List Nat) (v : Nat) :
    (recordDetect cap window v).length ≤ cap :=
  length_pushBounded_le _ _ _

/-- The newest sample is retained (the cap is at least one). -/
theorem mem_recordDetect_self {cap : Nat} (hcap : 1 ≤ cap) (window : List Nat) (v : Nat) :
    v ∈ recordDetect cap window v :=
  mem_pushBounded_self hcap _ _

/-- Nothing is invented: every sample in the new window was already in the old
one or is the sample just recorded. -/
theorem mem_recordDetect {cap : Nat} {window : List Nat} {v x : Nat}
    (hx : x ∈ recordDetect cap window v) : x ∈ window ∨ x = v :=
  mem_pushBounded hx

/-- A uniform bound on the window survives recording a sample that respects it. -/
theorem recordDetect_forall_le {cap c : Nat} {window : List Nat} {v : Nat}
    (hw : ∀ x ∈ window, x ≤ c) (hv : v ≤ c) :
    ∀ x ∈ recordDetect cap window v, x ≤ c := by
  intro x hx
  rcases mem_recordDetect hx with h | h
  · exact hw x h
  · exact h ▸ hv

/-! ## Percentiles over the window -/

/-- The window sorted ascending. -/
def sortAsc (l : List Nat) : List Nat := l.mergeSort (fun a b => decide (a ≤ b))

@[simp] theorem length_sortAsc (l : List Nat) : (sortAsc l).length = l.length :=
  List.length_mergeSort l

theorem sortAsc_perm (l : List Nat) : (sortAsc l).Perm l :=
  List.mergeSort_perm l _

theorem sortAsc_sorted (l : List Nat) : (sortAsc l).Pairwise (· ≤ ·) := by
  have := List.pairwise_mergeSort (le := fun a b => decide (a ≤ b))
    (by intro a b c hab hbc; simp_all; omega) (by intro a b; simp; omega) l
  simpa [sortAsc] using this

theorem mem_sortAsc {l : List Nat} {x : Nat} (h : x ∈ sortAsc l) : x ∈ l :=
  (sortAsc_perm l).mem_iff.mp h

/-- The index the percentile readout picks. -/
def pctIndex (n p : Nat) : Nat := min (n - 1) (n * p / 100)

/-- The percentile readout: `0` on an empty window, otherwise the sample at
`min(n-1, ⌊n·p/100⌋)` of the ascending window. -/
def pct (l : List Nat) (p : Nat) : Nat :=
  if l = [] then 0 else (sortAsc l).getD (pctIndex l.length p) 0

@[simp] theorem pct_nil (p : Nat) : pct [] p = 0 := by simp [pct]

theorem pctIndex_lt {n : Nat} (hn : 0 < n) (p : Nat) : pctIndex n p < n := by
  have : n - 1 < n := by omega
  exact lt_of_le_of_lt (min_le_left _ _) this

/-- Every percentile the dashboard reports is an actually observed sample. -/
theorem pct_mem {l : List Nat} (hl : l ≠ []) (p : Nat) : pct l p ∈ l := by
  have hn : 0 < l.length := List.length_pos_iff.mpr hl
  have hidx : pctIndex l.length p < (sortAsc l).length := by
    simpa using pctIndex_lt hn p
  have : (sortAsc l).getD (pctIndex l.length p) 0 ∈ sortAsc l := by
    rw [List.getD_eq_getElem _ _ hidx]
    exact List.getElem_mem hidx
  simpa [pct, hl] using mem_sortAsc this

/-- Any bound that holds for the whole window bounds every percentile of it. -/
theorem pct_le {l : List Nat} {c : Nat} (h : ∀ x ∈ l, x ≤ c) (p : Nat) : pct l p ≤ c := by
  by_cases hl : l = []
  · simp [hl]
  · exact h _ (pct_mem hl p)

/-- Sorted lists read monotonically. -/
theorem sorted_getD_mono {l : List Nat} (hl : l.Pairwise (· ≤ ·)) {i j : Nat}
    (hij : i ≤ j) (hj : j < l.length) : l.getD i 0 ≤ l.getD j 0 := by
  have hi : i < l.length := lt_of_le_of_lt hij hj
  rw [List.getD_eq_getElem _ _ hi, List.getD_eq_getElem _ _ hj]
  rcases eq_or_lt_of_le hij with rfl | hlt
  · simp
  · exact List.pairwise_iff_getElem.mp hl i j hi hj hlt

theorem pctIndex_mono (n : Nat) {p q : Nat} (hpq : p ≤ q) : pctIndex n p ≤ pctIndex n q := by
  have : n * p / 100 ≤ n * q / 100 := Nat.div_le_div_right (Nat.mul_le_mul_left n hpq)
  exact min_le_min (le_refl _) this

/-- Percentiles are monotone in `p`; in particular `p50 ≤ p90 ≤ p99`. -/
theorem pct_mono (l : List Nat) {p q : Nat} (hpq : p ≤ q) : pct l p ≤ pct l q := by
  by_cases hl : l = []
  · simp [hl]
  · have hn : 0 < l.length := List.length_pos_iff.mpr hl
    have hj : pctIndex l.length q < (sortAsc l).length := by
      simpa using pctIndex_lt hn q
    simpa [pct, hl] using
      sorted_getD_mono (sortAsc_sorted l) (pctIndex_mono l.length hpq) hj

/-- The headline readout of the dashboard header. -/
theorem p50_le_p90_le_p99 (l : List Nat) : pct l 50 ≤ pct l 90 ∧ pct l 90 ≤ pct l 99 :=
  ⟨pct_mono l (by norm_num), pct_mono l (by norm_num)⟩

end Tracker
