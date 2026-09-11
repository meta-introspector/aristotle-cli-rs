/-
# Urania §6 — donation pledges (which are *not* a ledger)

`donate(topic, resource_type, amount, sig)` is a signed, logged, public
promise of future bandwidth/compute/storage.  §6 is explicit that this
must **not** be modelled on `Kant.Credits`: that module proves
conservation and no-overdraft, which are the invariants of a closed
ledger where value moves between accounts.  A pledge moves nothing;
nothing is conserved, and "no overdraft" is vacuous for a promise that
has not been drawn on.

So the properties proved here are the ones a pledge log actually has, and
they are proved directly over the log:

* `leaderboard_honest` — the total shown for a topic is exactly the sum
  of the logged pledges for it;
* `no_double_count` — re-posting a pledge already in the log (same
  content hash / signature id) changes no total;
* `total_new` — a genuinely new pledge adds exactly its own amount;
* `total_monotone` — pledges only accumulate: a pledge log is not
  conserved, and this is what "not a ledger" looks like as a theorem;
* `fulfilment_le_pledge` — if delivery is tracked, recorded fulfilment
  never exceeds what was pledged.

Vocabulary, per §6: **pledges** (donated capacity) are kept lexically
distinct from **credits** (earned by serving, `Kant.Credits`) — different
objects, different laws.
-/
import Mathlib
import RequestProject.Kant.Urania.Chain

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Urania

/-- What is being offered. -/
inductive Resource where
  /-- Bytes served. -/
  | bandwidth
  /-- Cycles. -/
  | compute
  /-- Bytes held. -/
  | storage
deriving DecidableEq, Repr

/-- A logged pledge.  `id` is the dedupe key: the content hash of the
signed payload (equivalently its signature), so two entries carrying the
same `id` are the same pledge, posted twice. -/
structure Pledge where
  /-- What the capacity is offered to. -/
  topic : List Char
  /-- Which kind of capacity. -/
  resource : Resource
  /-- How much. -/
  amount : Nat
  /-- Who promised it (a pseudonym, §5). -/
  author : Key
  /-- Content hash of the signed payload. -/
  id : List Char
deriving DecidableEq, Repr

/-- The log, newest first. -/
abbrev PledgeLog := List Pledge

/-- The ids present in a log. -/
def ids (l : PledgeLog) : List (List Char) := l.map Pledge.id

/-- Two entries with the same id are the same pledge: what it means for
`id` to be a content hash. -/
def IdConsistent (l : PledgeLog) : Prop :=
  ∀ p ∈ l, ∀ q ∈ l, p.id = q.id → p = q

/-- Keep the first occurrence of each id. -/
def dedupe : PledgeLog → PledgeLog
  | [] => []
  | p :: rest => p :: (dedupe rest).filter (fun q => !(q.id == p.id))

/-- The leaderboard total for a topic. -/
def totalFor (l : PledgeLog) (topic : List Char) : Nat :=
  (((dedupe l).filter (fun p => p.topic = topic)).map Pledge.amount).sum

theorem mem_dedupe {l : PledgeLog} {p : Pledge} (h : p ∈ dedupe l) : p ∈ l := by
  induction l with
  | nil => simp [dedupe] at h
  | cons a t ih =>
    rw [dedupe, List.mem_cons] at h
    rcases h with rfl | h
    · exact List.mem_cons_self ..
    · exact List.mem_cons_of_mem _ (ih (List.mem_of_mem_filter h))

theorem mem_ids_dedupe {l : PledgeLog} {x : List Char} :
    x ∈ ids (dedupe l) ↔ x ∈ ids l := by
  induction l with
  | nil => simp [dedupe, ids]
  | cons a t ih =>
    simp only [dedupe, ids, List.map_cons, List.mem_cons]
    constructor
    · rintro (rfl | h)
      · exact Or.inl rfl
      · obtain ⟨q, hq, rfl⟩ := List.mem_map.mp h
        exact Or.inr (ih.mp (List.mem_map_of_mem (List.mem_of_mem_filter hq)))
    · rintro (rfl | h)
      · exact Or.inl rfl
      · by_cases hx : x = a.id
        · exact Or.inl hx
        · obtain ⟨q, hq, rfl⟩ := List.mem_map.mp (ih.mpr h)
          refine Or.inr (List.mem_map.mpr ⟨q, ?_, rfl⟩)
          exact List.mem_filter.mpr ⟨hq, by simpa using hx⟩

theorem dedupe_ids_nodup (l : PledgeLog) : (ids (dedupe l)).Nodup := by
  induction l with
  | nil => simp [dedupe, ids]
  | cons a t ih =>
    simp only [dedupe, ids, List.map_cons, List.nodup_cons]
    refine ⟨?_, (List.Sublist.map Pledge.id List.filter_sublist).nodup ih⟩
    intro hmem
    obtain ⟨q, hq, hqid⟩ := List.mem_map.mp hmem
    have h2 := (List.mem_filter.mp hq).2
    simp only [Bool.not_eq_true', beq_eq_false_iff_ne, ne_eq] at h2
    exact h2 hqid

/-- Nothing in a deduped log carries an id the log did not already have,
so a filter by "not this id" is a no-op when the id is absent. -/
theorem filter_ne_id_self {l : PledgeLog} {p : Pledge} (h : p.id ∉ ids l) :
    (dedupe l).filter (fun q => !(q.id == p.id)) = dedupe l := by
  refine List.filter_eq_self.mpr ?_
  intro q hq
  simp only [Bool.not_eq_true', beq_eq_false_iff_ne, ne_eq]
  intro hid
  exact h (by rw [← hid]; exact List.mem_map_of_mem (mem_dedupe hq))

/-- Consequently, prepending a genuinely new pledge just prepends it. -/
theorem dedupe_cons_of_new {l : PledgeLog} {p : Pledge} (h : p.id ∉ ids l) :
    dedupe (p :: l) = p :: dedupe l := by
  rw [dedupe, filter_ne_id_self h]

/-- A log with distinct ids is its own dedupe. -/
theorem dedupe_of_nodup {l : PledgeLog} (h : (ids l).Nodup) : dedupe l = l := by
  induction l with
  | nil => rfl
  | cons a t ih =>
    rw [ids, List.map_cons, List.nodup_cons] at h
    rw [dedupe, ih h.2]
    congr 1
    refine List.filter_eq_self.mpr ?_
    intro q hq
    simp only [Bool.not_eq_true', beq_eq_false_iff_ne, ne_eq]
    intro hid
    exact h.1 (by rw [← hid]; exact List.mem_map_of_mem hq)

/-- **Honest aggregation**: with no duplicates in the log, the total
shown is exactly the sum of what was logged. -/
theorem leaderboard_honest {l : PledgeLog} (h : (ids l).Nodup) (topic : List Char) :
    totalFor l topic = (((l.filter (fun p => p.topic = topic)).map Pledge.amount)).sum := by
  rw [totalFor, dedupe_of_nodup h]

/-- Removing the one entry carrying `p`'s id from a deduped log, and
putting `p` back at the front, is the same multiset. -/
theorem cons_filter_perm {d : PledgeLog} (hnodup : (ids d).Nodup) {p : Pledge} (hp : p ∈ d) :
    (p :: d.filter (fun q => !(q.id == p.id))).Perm d := by
  induction d with
  | nil => simp at hp
  | cons a t ih =>
    rw [ids, List.map_cons, List.nodup_cons] at hnodup
    rcases List.mem_cons.mp hp with rfl | hpt
    · have ht : t.filter (fun q => !(q.id == p.id)) = t := by
        refine List.filter_eq_self.mpr ?_
        intro q hq
        simp only [Bool.not_eq_true', beq_eq_false_iff_ne, ne_eq]
        intro hid
        exact hnodup.1 (by rw [← hid]; exact List.mem_map_of_mem hq)
      rw [List.filter_cons_of_neg (by simp), ht]
    · have hne : a.id ≠ p.id := by
        intro hid
        exact hnodup.1 (by rw [hid]; exact List.mem_map_of_mem hpt)
      rw [List.filter_cons_of_pos (by simpa using hne)]
      exact (List.Perm.swap a p _).trans ((ih hnodup.2 hpt).cons a)

/-- **No pledge counts twice**: re-posting an entry already in the log
changes nothing. -/
theorem no_double_count {l : PledgeLog} {p : Pledge} (hcons : IdConsistent (p :: l))
    (hmem : p.id ∈ ids l) (topic : List Char) :
    totalFor (p :: l) topic = totalFor l topic := by
  have hpd : p ∈ dedupe l := by
    obtain ⟨q, hq, hqid⟩ := List.mem_map.mp (mem_ids_dedupe.mpr hmem)
    have hql : q ∈ l := mem_dedupe hq
    have hqp : q = p := hcons q (List.mem_cons_of_mem _ hql) p (List.mem_cons_self ..) hqid
    rwa [← hqp]
  have hperm : (dedupe (p :: l)).Perm (dedupe l) := by
    rw [dedupe]
    exact cons_filter_perm (dedupe_ids_nodup l) hpd
  unfold totalFor
  exact ((hperm.filter (fun q => decide (q.topic = topic))).map Pledge.amount).sum_eq

/-- A genuinely new pledge adds exactly its own amount to its topic. -/
theorem total_new {l : PledgeLog} {p : Pledge} (hnew : p.id ∉ ids l) :
    totalFor (p :: l) p.topic = p.amount + totalFor l p.topic := by
  rw [totalFor, dedupe_cons_of_new hnew, List.filter_cons_of_pos (by simp), List.map_cons,
    List.sum_cons, totalFor]

/-- **Pledges only accumulate.**  Nothing is conserved and nothing is
transferred: this is the sense in which the pledge log is not a ledger.

The consistency hypothesis is not decorative: without it a "pledge" could
reuse an existing content hash with a smaller amount and the total would
fall. -/
theorem total_monotone {l : PledgeLog} {p : Pledge} (hcons : IdConsistent (p :: l))
    (topic : List Char) : totalFor l topic ≤ totalFor (p :: l) topic := by
  by_cases hmem : p.id ∈ ids l
  · rw [no_double_count hcons hmem topic]
  · by_cases htop : p.topic = topic
    · subst htop
      rw [total_new hmem]
      omega
    · have h1 : totalFor (p :: l) topic = totalFor l topic := by
        rw [totalFor, dedupe_cons_of_new hmem, List.filter_cons_of_neg (by simpa using htop),
          totalFor]
      rw [h1]

/-! ## Fulfilment

If delivery is tracked at all, it is tracked against the pledge it
discharges, and never allowed to exceed it. -/

/-- A delivery recorded against a pledge. -/
structure Delivery where
  /-- Which pledge is being discharged. -/
  pledgeId : List Char
  /-- How much was actually delivered. -/
  amount : Nat
deriving DecidableEq, Repr

/-- How much has been recorded as delivered against a pledge. -/
def deliveredFor (ds : List Delivery) (pid : List Char) : Nat :=
  ((ds.filter (fun d => d.pledgeId = pid)).map Delivery.amount).sum

/-- How much was pledged under an id. -/
def pledgedFor (l : PledgeLog) (pid : List Char) : Nat :=
  (((dedupe l).filter (fun p => p.id = pid)).map Pledge.amount).sum

/-- The invariant: nothing is recorded as delivered beyond what was
promised. -/
def FulfilmentOk (l : PledgeLog) (ds : List Delivery) : Prop :=
  ∀ pid, deliveredFor ds pid ≤ pledgedFor l pid

/-- Recording a delivery, refusing anything that would overshoot the
pledge. -/
def recordDelivery (l : PledgeLog) (ds : List Delivery) (d : Delivery) : List Delivery :=
  if deliveredFor ds d.pledgeId + d.amount ≤ pledgedFor l d.pledgeId then d :: ds else ds

/-- **Fulfilment never exceeds the pledge.** -/
theorem fulfilment_le_pledge {l : PledgeLog} {ds : List Delivery} (h : FulfilmentOk l ds)
    (d : Delivery) : FulfilmentOk l (recordDelivery l ds d) := by
  unfold recordDelivery
  split
  · rename_i hfits
    intro pid
    by_cases hpid : d.pledgeId = pid
    · subst hpid
      have : deliveredFor (d :: ds) d.pledgeId = d.amount + deliveredFor ds d.pledgeId := by
        simp [deliveredFor]
      rw [this]
      omega
    · have : deliveredFor (d :: ds) pid = deliveredFor ds pid := by
        simp [deliveredFor, hpid]
      rw [this]
      exact h pid
  · exact h

theorem fulfilmentOk_nil (l : PledgeLog) : FulfilmentOk l [] := by
  intro pid
  simp [deliveredFor]

end Kant.Urania
