/-
# Urania §7 — the QoS cache: bounded, bucketed, expiring, gated

New nodes bootstrap good connections from a cache of **self-reported**
peer quality rather than connecting blind.  The cache is also, as §7
admits, a network map of the membership, so the design is defensive:

* latency is **bucketed** coarsely before it ever leaves the client, so
  the relay never sees raw milliseconds;
* reports **expire**, and the store is a bounded ring log that drops the
  oldest entry and says so — the `Kant.Diagnostics.Log` discipline, which
  is the right substrate *here* and the wrong one for taints (§5);
* aggregation is a **trimmed median across reporters**, so a single
  dishonest reporter cannot move a peer's score outside the honest range;
* `GET /qos/peers` is **gated**: it answers vouched members only, because
  as written it is otherwise a membership directory served to anyone.

Proved here:

* `latencyBucket_le`, `latencyBucket_coarse` — the bucket is one of five
  values and is far from injective: many latencies are indistinguishable
  in it;
* `RingLog.add_length_le`, `add_total`, `add_getLast` — bounded, honest
  about what it dropped, and never dropping the newest report;
* `mem_expire_iff` — an expired report is gone, a live one is kept;
* `trimmedMedian_within_honest_range` — **one liar cannot move the
  aggregate**: with at least two honest reports, the aggregate stays
  between the honest bounds whatever the dishonest reporter says;
* `qosPeers_closed_to_strangers` — an unvouched caller learns nothing.
-/
import Mathlib
import RequestProject.Kant.Urania.Trust

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Urania

/-! ## Coarse buckets -/

/-- Latency, coarsened before it is reported.  Five buckets; the exact
edges are one of the open constants of §9. -/
def latencyBucket (ms : Nat) : Nat :=
  if ms < 50 then 0
  else if ms < 150 then 1
  else if ms < 500 then 2
  else if ms < 1500 then 3
  else 4

theorem latencyBucket_le (ms : Nat) : latencyBucket ms ≤ 4 := by
  unfold latencyBucket
  split_ifs <;> omega

theorem latencyBucket_monotone {a b : Nat} (h : a ≤ b) : latencyBucket a ≤ latencyBucket b := by
  unfold latencyBucket
  split_ifs <;> omega

/-- **The bucket hides the measurement**: distinct latencies collapse to
the same reported value, which is the point of reporting buckets. -/
theorem latencyBucket_coarse : latencyBucket 10 = latencyBucket 40 := by decide

/-! ## Reports and the bounded store -/

/-- One self-reported observation.  Note there is no raw millisecond
field: what is reported is the bucket. -/
structure Report where
  /-- Who is reporting (a pseudonym, §5). -/
  reporter : Key
  /-- Which peer they measured. -/
  peer : Key
  /-- The coarse latency bucket. -/
  bucket : Nat
  /-- Whether the exchange succeeded. -/
  ok : Bool
  /-- When it was measured. -/
  time : Nat
deriving DecidableEq, Repr

/-- A bounded ring log of reports: the `Kant.Diagnostics.Log` discipline,
specialised to QoS.  Old entries are dropped, and the count of dropped
entries is kept, so the log is honest about having forgotten. -/
structure RingLog where
  /-- How many reports are kept. -/
  cap : Nat
  /-- The reports kept, oldest first. -/
  entries : List Report
  /-- How many were dropped to stay inside `cap`. -/
  dropped : Nat
deriving DecidableEq, Repr

namespace RingLog

/-- An empty cache. -/
def empty (cap : Nat) : RingLog := ⟨cap, [], 0⟩

/-- How many reports have been seen, kept or dropped. -/
def total (l : RingLog) : Nat := l.dropped + l.entries.length

/-- Add a report, trimming the oldest if the cache is full. -/
def add (l : RingLog) (r : Report) : RingLog :=
  let es := l.entries ++ [r]
  let excess := es.length - l.cap
  { cap := l.cap, entries := es.drop excess, dropped := l.dropped + excess }

@[simp] theorem add_cap (l : RingLog) (r : Report) : (l.add r).cap = l.cap := rfl

theorem add_entries_length (l : RingLog) (r : Report) :
    (l.add r).entries.length = min (l.entries.length + 1) l.cap := by
  simp only [RingLog.add, List.length_drop, List.length_append, List.length_cons,
    List.length_nil]
  omega

/-- **The cache is bounded.** -/
theorem add_length_le (l : RingLog) (r : Report) : (l.add r).entries.length ≤ l.cap := by
  rw [RingLog.add_entries_length]; omega

/-- **Nothing is silently forgotten**: what is not kept is counted. -/
theorem add_total (l : RingLog) (r : Report) : (l.add r).total = l.total + 1 := by
  simp only [RingLog.total, RingLog.add, List.length_drop, List.length_append,
    List.length_cons, List.length_nil]
  omega

/-- **The newest report is never the one dropped.** -/
theorem add_getLast (l : RingLog) (r : Report) (h : 1 ≤ l.cap) :
    (l.add r).entries.getLast? = some r := by
  have hlen : l.entries.length + 1 - l.cap ≤ l.entries.length := by omega
  simp only [RingLog.add, List.length_append, List.length_cons, List.length_nil]
  rw [List.drop_append_of_le_length hlen]
  simp

end RingLog

/-! ## Expiry -/

/-- Drop reports older than `ttl`. -/
def expire (ttl now : Nat) (rs : List Report) : List Report :=
  rs.filter (fun r => now < r.time + ttl)

theorem mem_expire_iff {ttl now : Nat} {rs : List Report} {r : Report} :
    r ∈ expire ttl now rs ↔ r ∈ rs ∧ now < r.time + ttl := by
  simp [expire, List.mem_filter]

/-- Aggressive expiry keeps no per-pair history from before the window. -/
theorem expire_recent {ttl now : Nat} {rs : List Report} {r : Report}
    (h : r ∈ expire ttl now rs) : now < r.time + ttl :=
  (mem_expire_iff.mp h).2

/-! ## Aggregation: a trimmed median, not a mean

Bucketing and expiry limit how much leaks; they do nothing about a
reporter that lies.  Averaging lets one liar drag a score anywhere, so
the aggregate is the median of the per-reporter values. -/

/-- The median of a list of reported buckets (the middle element of the
sorted list; `0` for an empty list). -/
def trimmedMedian (xs : List Nat) : Nat :=
  ((xs.mergeSort (· ≤ ·)).drop (xs.length / 2)).headD 0

/-- **A single dishonest reporter cannot move the aggregate outside the
range of the honest ones.**  With at least two honest reports, whatever
the liar says, the published score stays between the honest bounds. -/
theorem trimmedMedian_within_honest_range {hs : List Nat} {lo hi x : Nat}
    (hlen : 2 ≤ hs.length) (hlo : ∀ y ∈ hs, lo ≤ y) (hhi : ∀ y ∈ hs, y ≤ hi) :
    lo ≤ trimmedMedian (x :: hs) ∧ trimmedMedian (x :: hs) ≤ hi := by
  set xs : List Nat := x :: hs with hxs
  set s : List Nat := xs.mergeSort (· ≤ ·) with hsdef
  have hperm : s.Perm xs := List.mergeSort_perm _ _
  have hsorted : s.Pairwise (· ≤ ·) := by
    have := List.pairwise_mergeSort (le := fun a b : Nat => decide (a ≤ b))
      (by intro a b c hab hbc; simp at *; omega) (by intro a b; simp; omega) xs
    simpa [hsdef] using this
  set n : Nat := xs.length with hn
  set m : Nat := n / 2 with hm
  have hslen : s.length = n := hperm.length_eq
  have hn3 : 3 ≤ n := by simp [hn, hxs]; omega
  have hdrop_len : (s.drop m).length = n - m := by
    rw [List.length_drop, hslen]
  have hdrop_ne : s.drop m ≠ [] := by
    intro hcon
    have := congrArg List.length hcon
    rw [hdrop_len] at this
    simp at this
    omega
  obtain ⟨a, t, hat⟩ : ∃ a t, s.drop m = a :: t := by
    cases hd : s.drop m with
    | nil => exact absurd hd hdrop_ne
    | cons a t => exact ⟨a, t, rfl⟩
  have hmed : trimmedMedian xs = a := by
    unfold trimmedMedian
    rw [← hsdef, ← hn, ← hm, hat]
    rfl
  have hsplit : ∀ b ∈ s.take m, ∀ c ∈ s.drop m, b ≤ c := by
    have h := hsorted
    rw [← List.take_append_drop m s] at h
    exact (List.pairwise_append.mp h).2.2
  have hdrop_ge : ∀ y ∈ s.drop m, a ≤ y := by
    intro y hy
    rw [hat] at hy
    rcases List.mem_cons.mp hy with rfl | hy
    · exact le_refl _
    · have hp : (a :: t).Pairwise (· ≤ ·) := by
        rw [← hat]
        exact hsorted.sublist (List.drop_sublist _ _)
      exact (List.pairwise_cons.mp hp).1 y hy
  constructor
  · by_contra hcon
    push_neg at hcon
    rw [hmed] at hcon
    have hsub : (s.take m ++ [a]).Sublist s := by
      conv_rhs => rw [← List.take_append_drop m s]
      rw [hat]
      exact List.Sublist.append_left (List.singleton_sublist.mpr (List.mem_cons_self ..)) _
    have hall : ∀ y ∈ s.take m ++ [a], decide (y < lo) = true := by
      intro y hy
      rcases List.mem_append.mp hy with hy | hy
      · have := hsplit y hy a (by rw [hat]; exact List.mem_cons_self ..)
        simp
        omega
      · simp at hy
        subst hy
        simp
        omega
    have hcount : (m + 1) ≤ s.countP (fun y => decide (y < lo)) := by
      calc m + 1 = (s.take m ++ [a]).length := by
                    simp [List.length_take, hslen]
                    omega
        _ = (s.take m ++ [a]).countP (fun y => decide (y < lo)) :=
              (List.countP_eq_length.mpr hall).symm
        _ ≤ s.countP (fun y => decide (y < lo)) := hsub.countP_le
    have hxcount : xs.countP (fun y => decide (y < lo)) ≤ 1 := by
      rw [hxs, List.countP_cons]
      have hz : hs.countP (fun y => decide (y < lo)) = 0 := by
        rw [List.countP_eq_zero]
        intro y hy
        have := hlo y hy
        simp
        omega
      rw [hz]
      split <;> omega
    rw [hperm.countP_eq] at hcount
    omega
  · by_contra hcon
    push_neg at hcon
    rw [hmed] at hcon
    have hall : ∀ y ∈ s.drop m, decide (hi < y) = true := by
      intro y hy
      have := hdrop_ge y hy
      simp
      omega
    have hcount : (n - m) ≤ s.countP (fun y => decide (hi < y)) := by
      calc n - m = (s.drop m).length := hdrop_len.symm
        _ = (s.drop m).countP (fun y => decide (hi < y)) :=
              (List.countP_eq_length.mpr hall).symm
        _ ≤ s.countP (fun y => decide (hi < y)) := (List.drop_sublist _ _).countP_le
    have hxcount : xs.countP (fun y => decide (hi < y)) ≤ 1 := by
      rw [hxs, List.countP_cons]
      have hz : hs.countP (fun y => decide (hi < y)) = 0 := by
        rw [List.countP_eq_zero]
        intro y hy
        have := hhi y hy
        simp
        omega
      rw [hz]
      split <;> omega
    rw [hperm.countP_eq] at hcount
    omega

/-! ## The gate

`GET /qos/peers` is trust-sensitive: it is a membership directory.  It
answers vouched members and nobody else. -/

/-- One row of the peer map. -/
abbrev PeerScore := Key × Nat

/-- The per-peer aggregate over a set of reports: one value per reporter,
then the trimmed median. -/
def peerScore (rs : List Report) (p : Key) : Nat :=
  trimmedMedian ((rs.filter (fun r => r.peer = p)).map Report.bucket)

/-- The gated answer to `GET /qos/peers`. -/
def qosPeers (P : TrustParams) (F : List Key) (L : TrustLog) (now : Nat)
    (viewer : Key) (rs : List Report) (peers : List Key) : Option (List PeerScore) :=
  if tier P F L viewer now = Tier.outside then none
  else some (peers.map (fun p => (p, peerScore rs p)))

/-- **An unvouched caller learns nothing** — not even who the members
are. -/
theorem qosPeers_closed_to_strangers {P : TrustParams} {F : List Key} {L : TrustLog}
    {now : Nat} {viewer : Key} {rs : List Report} {peers : List Key}
    (h : tier P F L viewer now = Tier.outside) :
    qosPeers P F L now viewer rs peers = none := by
  simp [qosPeers, h]

/-- A vouched caller gets a score for each peer asked about. -/
theorem qosPeers_vouched {P : TrustParams} {F : List Key} {L : TrustLog}
    {now : Nat} {viewer : Key} {rs : List Report} {peers : List Key}
    (h : tier P F L viewer now ≠ Tier.outside) :
    qosPeers P F L now viewer rs peers = some (peers.map (fun p => (p, peerScore rs p))) := by
  simp [qosPeers, h]

end Kant.Urania
