import RequestProject.Gvcs.Net.Log

/-!
# Compaction: dropping acknowledged operations

`GAMEPLAN.md` §6.3 says that logs grow, and that a peer may drop the operations
below a watermark that it and its partners have both acknowledged, keeping a
**snapshot** — the state those dropped operations computed — in their place.
It also says that a snapshot is *a cache, never an authority*.  This file makes
both statements theorems about the replicated log of `RequestProject/Net/Log.lean`.

* `below`/`above` split a log at a watermark operation id.
* `sortLog_split` — the canonical replay order of a consistent log is the
  canonical order of the old operations followed by the canonical order of the
  new ones: compaction never reorders anything.
* `replay_split` — therefore replay factors through the watermark.
* `Snapshot`, `Snapshot.Valid`, `compact` — the snapshot a peer keeps and the
  log it keeps beside it.
* `replay_compact` — **the compaction rule is sound**: replaying the surviving
  operations on top of the snapshot gives exactly the state the full log gives.
* `replay_compact_merge` — a compacted replica keeps working: later operations,
  which carry stamps above the watermark, merge into the compacted log and
  still give the state of the full uncompacted log.
* `Snapshot.advance_valid`, `compact_compact` — compacting again at a later
  watermark agrees with compacting the full log there, so snapshots compose.
* `Acked`, `replay_compact_of_acked` — the watermark rule actually used: a peer
  may drop what all of its partners already hold.
* `compact_card_lt` — compaction really does shrink the log.
-/

namespace LifeTrac
namespace Net

variable {P : Type} [DecidableEq P] {S : Type}

/-! ## Splitting a log at a watermark -/

/-- The operations of a log strictly below a watermark: the ones a snapshot
summarises. -/
def below (L : Log P) (w : OpId) : Log P := L.filter (fun o => o.id < w)

/-- The operations of a log at or above a watermark: the ones that survive
compaction. -/
def above (L : Log P) (w : OpId) : Log P := L.filter (fun o => w ≤ o.id)

@[simp] theorem mem_below {L : Log P} {w : OpId} {o : Op P} :
    o ∈ below L w ↔ o ∈ L ∧ o.id < w := Finset.mem_filter

@[simp] theorem mem_above {L : Log P} {w : OpId} {o : Op P} :
    o ∈ above L w ↔ o ∈ L ∧ w ≤ o.id := Finset.mem_filter

theorem below_subset (L : Log P) (w : OpId) : below L w ⊆ L := Finset.filter_subset _ _

theorem above_subset (L : Log P) (w : OpId) : above L w ⊆ L := Finset.filter_subset _ _

theorem disjoint_below_above (L : Log P) (w : OpId) : Disjoint (below L w) (above L w) := by
  refine Finset.disjoint_left.2 ?_
  intro o ho ho'
  exact absurd (mem_above.1 ho').2 (not_le.2 (mem_below.1 ho).2)

theorem below_add_above (L : Log P) (w : OpId) :
    (below L w).val + (above L w).val = L.val := by
  classical
  have h2 : Multiset.filter (fun o : Op P => w ≤ o.id) L.val
      = Multiset.filter (fun o : Op P => ¬ (o.id < w)) L.val :=
    Multiset.filter_congr (fun o _ => by simp)
  simp only [below, above, Finset.filter_val]
  rw [h2]
  exact Multiset.filter_add_not _ _

theorem below_union_above (L : Log P) (w : OpId) :
    merge (below L w) (above L w) = L := by
  ext o
  simp only [mem_merge, mem_below, mem_above]
  constructor
  · rintro (⟨h, -⟩ | ⟨h, -⟩) <;> exact h
  · intro h
    rcases lt_or_ge o.id w with hw | hw
    · exact Or.inl ⟨h, hw⟩
    · exact Or.inr ⟨h, hw⟩

@[simp] theorem below_empty (w : OpId) : below (∅ : Log P) w = ∅ := rfl

@[simp] theorem above_empty (w : OpId) : above (∅ : Log P) w = ∅ := rfl

/-- Splitting a log twice, the second time later, leaves the same tail. -/
theorem above_above {L : Log P} {w w' : OpId} (h : w ≤ w') :
    above (above L w) w' = above L w' := by
  ext o
  simp only [mem_above]
  exact ⟨fun ho => ⟨ho.1.1, ho.2⟩, fun ho => ⟨⟨ho.1, h.trans ho.2⟩, ho.2⟩⟩

/-- The operations a later snapshot must absorb: those between the two
watermarks. -/
theorem below_above {L : Log P} {w w' : OpId} :
    below (above L w) w' = above (below L w') w := by
  ext o
  simp only [mem_above, mem_below]
  tauto

/-! ## Sorted lists are determined by their contents -/

omit [DecidableEq P] in
theorem before_of_id_le {a b : Op P} (h : a.id ≤ b.id) : before a b := h

omit [DecidableEq P] in
/-- A sorted list is determined by its multiset of elements, as long as no two
of those elements share an operation id — which is exactly `Consistent`. -/
theorem eq_of_perm_of_sorted {l₁ l₂ : List (Op P)} (hp : l₁.Perm l₂)
    (h₁ : l₁.Pairwise (before (P := P))) (h₂ : l₂.Pairwise (before (P := P)))
    (hinj : ∀ a ∈ l₁, ∀ b ∈ l₁, a.id = b.id → a = b) : l₁ = l₂ := by
  induction l₁ generalizing l₂ with
  | nil => exact hp.nil_eq
  | cons a t ih =>
      cases l₂ with
      | nil => exact absurd hp.eq_nil (by simp)
      | cons b t' =>
          have hb : b ∈ a :: t := hp.mem_iff.2 (by simp)
          have ha : a ∈ b :: t' := hp.mem_iff.1 (by simp)
          have hab : a.id ≤ b.id := by
            rcases List.mem_cons.1 hb with rfl | hb'
            · exact le_rfl
            · exact (List.pairwise_cons.1 h₁).1 _ hb'
          have hba : b.id ≤ a.id := by
            rcases List.mem_cons.1 ha with rfl | ha'
            · exact le_rfl
            · exact (List.pairwise_cons.1 h₂).1 _ ha'
          have hEq : a = b := hinj a (by simp) b hb (le_antisymm hab hba)
          subst hEq
          have hpt : t.Perm t' := hp.cons_inv
          have := ih hpt (List.pairwise_cons.1 h₁).2 (List.pairwise_cons.1 h₂).2
            (fun x hx y hy hxy => hinj x (by simp [hx]) y (by simp [hy]) hxy)
          rw [this]

/-! ## Compaction never reorders -/

/-- **Replay order factors at the watermark.**  The canonical order of a
consistent log is the canonical order of its old operations followed by the
canonical order of its new ones. -/
theorem sortLog_split {L : Log P} (h : Consistent L) (w : OpId) :
    sortLog L = sortLog (below L w) ++ sortLog (above L w) := by
  refine eq_of_perm_of_sorted ?_ (sortLog_sorted L) ?_ ?_
  · -- the two sides have the same elements
    refine Multiset.coe_eq_coe.1 ?_
    show (sortLog L : Multiset (Op P)) =
      ((sortLog (below L w) ++ sortLog (above L w) : List (Op P)) : Multiset (Op P))
    have e₁ : (sortLog L : Multiset (Op P)) = L.val := by
      rw [← Finset.coe_toList L]; exact Quotient.sound (sortLog_perm L)
    have e₂ : (sortLog (below L w) : Multiset (Op P)) = (below L w).val := by
      rw [← Finset.coe_toList (below L w)]; exact Quotient.sound (sortLog_perm _)
    have e₃ : (sortLog (above L w) : Multiset (Op P)) = (above L w).val := by
      rw [← Finset.coe_toList (above L w)]; exact Quotient.sound (sortLog_perm _)
    rw [e₁, ← Multiset.coe_add, e₂, e₃, below_add_above]
  · -- the concatenation is sorted
    refine List.pairwise_append.2 ⟨sortLog_sorted _, sortLog_sorted _, ?_⟩
    intro a ha b hb
    have hA := (mem_below.1 (mem_sortLog.1 ha)).2
    have hB := (mem_above.1 (mem_sortLog.1 hb)).2
    exact before_of_id_le (le_of_lt (lt_of_lt_of_le hA hB))
  · intro a ha b hb hab
    exact h a (mem_sortLog.1 ha) b (mem_sortLog.1 hb) hab

/-- **Replay factors at the watermark**: the state of a consistent log is what
you get by replaying the old operations and then the new ones. -/
theorem replay_split (step : S → P → S) (init : S) {L : Log P} (h : Consistent L) (w : OpId) :
    replay step init L = replay step (replay step init (below L w)) (above L w) := by
  simp [replay, sortLog_split h w, List.foldl_append]

/-! ## Snapshots -/

/-- What a peer keeps in place of the operations it has dropped: the watermark
it compacted at, and the state the dropped operations computed. -/
structure Snapshot (S : Type) where
  /-- Operations strictly below this id have been dropped. -/
  watermark : OpId
  /-- The state those dropped operations replayed to. -/
  state : S
deriving Repr

/-- A snapshot is *valid* for a log when its state really is what the log's
operations below the watermark replay to. -/
def Snapshot.Valid (snap : Snapshot S) (step : S → P → S) (init : S) (L : Log P) : Prop :=
  snap.state = replay step init (below L snap.watermark)

/-- The log a peer keeps beside a snapshot: the operations that survive. -/
def compact (L : Log P) (w : OpId) : Log P := above L w

@[simp] theorem mem_compact {L : Log P} {w : OpId} {o : Op P} :
    o ∈ compact L w ↔ o ∈ L ∧ w ≤ o.id := mem_above

/-- **Compaction is sound.**  Dropping the operations below the watermark and
replaying the survivors on top of the snapshot gives exactly the state the whole
log gives: a peer that compacts computes what it would have computed. -/
theorem replay_compact (step : S → P → S) (init : S) {L : Log P} (h : Consistent L)
    {snap : Snapshot S} (hv : snap.Valid step init L) :
    replay step snap.state (compact L snap.watermark) = replay step init L := by
  rw [hv, compact, ← replay_split step init h]

/-- A snapshot taken by actually replaying the prefix is valid, so every log
admits a compaction at every watermark. -/
theorem valid_snapshot (step : S → P → S) (init : S) (L : Log P) (w : OpId) :
    (Snapshot.mk w (replay step init (below L w)) : Snapshot S).Valid step init L := rfl

/-- **A compacted replica keeps playing.**  New operations carry stamps above
the watermark (`lt_nextStamp` in `Net/Log.lean` is why), so they merge into the
compacted log; replaying them on the snapshot gives the state of the full,
uncompacted log. -/
theorem replay_compact_merge (step : S → P → S) (init : S) {L M : Log P}
    (h : Consistent (merge L M)) {snap : Snapshot S}
    (hv : snap.Valid step init L) (hM : ∀ o ∈ M, snap.watermark ≤ o.id) :
    replay step snap.state (merge (compact L snap.watermark) M) =
      replay step init (merge L M) := by
  have hbelow : below (merge L M) snap.watermark = below L snap.watermark := by
    ext o
    simp only [mem_below, mem_merge]
    constructor
    · rintro ⟨hL | hM', hlt⟩
      · exact ⟨hL, hlt⟩
      · exact absurd (hM o hM') (not_le.2 hlt)
    · rintro ⟨hL, hlt⟩; exact ⟨Or.inl hL, hlt⟩
  have habove : above (merge L M) snap.watermark = merge (compact L snap.watermark) M := by
    ext o
    simp only [mem_above, mem_merge, mem_compact]
    constructor
    · rintro ⟨hL | hM', hle⟩
      · exact Or.inl ⟨hL, hle⟩
      · exact Or.inr hM'
    · rintro (⟨hL, hle⟩ | hM')
      · exact ⟨Or.inl hL, hle⟩
      · exact ⟨Or.inr hM', hM o hM'⟩
  rw [replay_split step init h snap.watermark, hbelow, habove, hv]

/-- **Snapshots compose.**  Advancing a snapshot by replaying the operations
between the old and the new watermark — all a compacted peer still has — gives
a snapshot that is valid for the full log at the later watermark.  Nothing that
was dropped is needed again. -/
theorem Snapshot.advance_valid (step : S → P → S) (init : S) {L : Log P}
    {snap : Snapshot S} (hv : snap.Valid step init L) {w' : OpId} (hw : snap.watermark ≤ w')
    (hc : Consistent (below L w')) :
    (Snapshot.mk w' (replay step snap.state (below (compact L snap.watermark) w')) :
        Snapshot S).Valid step init L := by
  show replay step snap.state (below (above L snap.watermark) w') =
    replay step init (below L w')
  have hb : below (above L snap.watermark) w' = above (below L w') snap.watermark :=
    below_above
  have hb' : below (below L w') snap.watermark = below L snap.watermark := by
    ext o
    simp only [mem_below]
    exact ⟨fun ho => ⟨ho.1.1, ho.2⟩, fun ho => ⟨⟨ho.1, lt_of_lt_of_le ho.2 hw⟩, ho.2⟩⟩
  rw [hb, hv, ← hb', ← replay_split step init hc snap.watermark]

/-- Compacting an already compacted log at a later watermark is compacting the
original log there: a snapshot is a cache, and re-caching loses nothing. -/
theorem compact_compact {L : Log P} {w w' : OpId} (h : w ≤ w') :
    compact (compact L w) w' = compact L w' := above_above h

/-! ## The watermark rule -/

/-- An operation id is *acknowledged* by a set of peer logs when every one of
those peers already holds every operation of `L` below it.  This is the
condition under which `GAMEPLAN.md` §6.3 lets a peer drop those operations:
nobody will ever have to be sent them again. -/
def Acked (L : Log P) (peers : List (Log P)) (w : OpId) : Prop :=
  ∀ M ∈ peers, ∀ o ∈ L, o.id < w → o ∈ M

theorem acked_zero (L : Log P) (peers : List (Log P)) :
    Acked L peers ⟨0, 0, 0⟩ := by
  intro M _ o _ hlt
  exact absurd hlt (not_lt.2 (by
    show (⟨0,0,0⟩ : OpId) ≤ o.id
    rw [OpId.le_def]
    exact bot_le (α := ℕ ×ₗ (ℕ ×ₗ ℕ))))

/-- Everything a peer drops at an acknowledged watermark, its partners still
hold: compaction never loses an operation from the system as a whole. -/
theorem below_subset_of_acked {L M : Log P} {peers : List (Log P)} {w : OpId}
    (h : Acked L peers w) (hM : M ∈ peers) : below L w ⊆ M := by
  intro o ho
  exact h M hM o (mem_below.1 ho).1 (mem_below.1 ho).2

/-- The compaction rule as it is actually applied: at an acknowledged
watermark, a peer replaces its old operations by a snapshot and still computes
the state of its whole log. -/
theorem replay_compact_of_acked (step : S → P → S) (init : S) {L : Log P}
    {peers : List (Log P)} (h : Consistent L) {snap : Snapshot S}
    (_hack : Acked L peers snap.watermark) (hv : snap.Valid step init L) :
    replay step snap.state (compact L snap.watermark) = replay step init L :=
  replay_compact step init h hv

/-! ## Compaction shrinks the log -/

theorem compact_subset (L : Log P) (w : OpId) : compact L w ⊆ L := above_subset L w

theorem compact_card_le (L : Log P) (w : OpId) : (compact L w).card ≤ L.card :=
  Finset.card_le_card (compact_subset L w)

/-- If anything at all is below the watermark, the compacted log is strictly
smaller. -/
theorem compact_card_lt {L : Log P} {w : OpId} {o : Op P} (ho : o ∈ L) (hlt : o.id < w) :
    (compact L w).card < L.card := by
  refine Finset.card_lt_card ⟨compact_subset L w, ?_⟩
  intro hsub
  exact absurd (mem_compact.1 (hsub ho)).2 (not_le.2 hlt)

/-- Two peers that compacted at the same watermark from the same log agree —
compaction is deterministic, so it cannot make replicas diverge. -/
theorem compact_eventual_consistency (step : S → P → S) (init : S) {L M : Log P}
    (hL : Consistent L) (hM : Consistent M) {snap snap' : Snapshot S}
    (hv : snap.Valid step init L) (hv' : snap'.Valid step init M)
    (hlog : ∀ o : Op P, o ∈ L ↔ o ∈ M) :
    replay step snap.state (compact L snap.watermark) =
      replay step snap'.state (compact M snap'.watermark) := by
  rw [replay_compact step init hL hv, replay_compact step init hM hv',
    eventual_consistency step init hlog]

end Net
end LifeTrac
