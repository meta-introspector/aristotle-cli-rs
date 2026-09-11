import RequestProject.Tracker.Emit

/-!
# The event bus and its resumable replay ring (`bus.ts`, `server.ts: stream`)

Every event is serialized once, given a monotone sequence number, fanned out to
the subscribers and kept in a bounded replay ring.  An SSE client reconnects
with `Last-Event-ID: <bootId>:<seq>` and is replayed the retained frames newer
than that cursor; a cursor from a previous boot is not trusted and the whole
retained ring is replayed instead.

The properties proved here are the ones a resumable stream depends on:
sequence numbers strictly increase and are never reused, the ring is bounded
and ordered, replay after a cursor returns exactly the retained frames newer
than it (in order, none missed, none repeated), and withdrawal
(`removeFromReplay`) deletes exactly the named posts while preserving order.
-/

namespace Tracker

/-- A serialized frame on the wire. -/
structure Frame where
  seq : Nat
  event : Event
  deriving DecidableEq, Repr, Inhabited

/-- The bus: a boot identity, the next sequence number and the bounded ring. -/
structure Bus where
  bootId : String
  next : Nat := 0
  /-- Retained frames, oldest first. -/
  ring : List Frame := []
  cap : Nat := 512
  deriving DecidableEq, Repr, Inhabited

namespace Bus

/-- `publish`: stamp the event, append it to the ring and evict the oldest. -/
def publish (b : Bus) (e : Event) : Bus :=
  { b with next := b.next + 1, ring := pushBounded b.cap b.ring ⟨b.next, e⟩ }

/-- `publish` behind the publication guard: an event the guard rejects never
enters a live or replay frame. -/
def publishGuarded (guard : Event → Bool) (b : Bus) (e : Event) : Bus :=
  if guard e then publish b e else b

/-- A resumption cursor: the boot identity the client saw and the last sequence
number it received. -/
structure Cursor where
  bootId : String
  seq : Nat
  deriving DecidableEq, Repr, Inhabited

/-- `replay`: frames newer than the cursor.  A cursor from another boot cannot
be interpreted, so the whole retained ring is replayed. -/
def replay (b : Bus) : Option Cursor → List Frame
  | none => b.ring
  | some c => if c.bootId = b.bootId then b.ring.filter (fun f => decide (c.seq < f.seq))
              else b.ring

/-- `removeFromReplay`: withdraw every frame addressing one of these posts. -/
def removeFromReplay (b : Bus) (ids : List String) : Bus :=
  { b with ring := b.ring.filter (fun f => decide (∀ id ∈ f.event.postId, id ∉ ids)) }

/-- The bus invariant. -/
structure Wf (b : Bus) : Prop where
  /-- Sequence numbers strictly increase along the ring. -/
  ordered : b.ring.Pairwise (fun f g => f.seq < g.seq)
  /-- Every retained sequence number has already been issued. -/
  issued : ∀ f ∈ b.ring, f.seq < b.next
  bounded : b.ring.length ≤ b.cap

@[simp] theorem publish_next (b : Bus) (e : Event) : (publish b e).next = b.next + 1 := rfl

@[simp] theorem publish_bootId (b : Bus) (e : Event) : (publish b e).bootId = b.bootId := rfl

theorem mem_publish_ring {b : Bus} {e : Event} {f : Frame} (h : f ∈ (publish b e).ring) :
    f ∈ b.ring ∨ f = ⟨b.next, e⟩ := mem_pushBounded h

/-- The newest frame is always retained. -/
theorem mem_publish_self {b : Bus} (hcap : 1 ≤ b.cap) (e : Event) :
    (⟨b.next, e⟩ : Frame) ∈ (publish b e).ring :=
  mem_pushBounded_self hcap _ _

/-- `publish` maintains the invariant: sequence numbers keep increasing, are
never reused, and the ring stays bounded. -/
theorem publish_wf {b : Bus} (h : Wf b) (e : Event) : Wf (publish b e) := by
  have hsub : (pushBounded b.cap b.ring ⟨b.next, e⟩).Sublist (b.ring ++ [⟨b.next, e⟩]) :=
    List.drop_sublist _ _
  have hpair : (b.ring ++ [(⟨b.next, e⟩ : Frame)]).Pairwise (fun f g => f.seq < g.seq) := by
    rw [List.pairwise_append]
    exact ⟨h.ordered, List.pairwise_singleton _ _, by
      intro a ha c hc
      have : c = (⟨b.next, e⟩ : Frame) := by simpa using hc
      subst this
      exact h.issued a ha⟩
  refine ⟨List.Pairwise.sublist hsub hpair, ?_, ?_⟩
  · intro f hf
    rcases mem_publish_ring hf with hf' | hf'
    · exact lt_trans (h.issued f hf') (Nat.lt_succ_self _)
    · subst hf'; exact Nat.lt_succ_self _
  · exact length_pushBounded_le _ _ _

/-- Replay after a cursor returns only frames the client has not seen. -/
theorem replay_newer {b : Bus} {c : Cursor} (hc : c.bootId = b.bootId) {f : Frame}
    (hf : f ∈ replay b (some c)) : c.seq < f.seq := by
  simp only [replay, if_pos hc, List.mem_filter] at hf
  simpa using hf.2

/-- Replay after a cursor misses nothing that is still retained. -/
theorem mem_replay_of_newer {b : Bus} {c : Cursor} (hc : c.bootId = b.bootId) {f : Frame}
    (hf : f ∈ b.ring) (hlt : c.seq < f.seq) : f ∈ replay b (some c) := by
  simp [replay, hc, List.mem_filter, hf, hlt]

/-- A cursor from a previous boot is not trusted: the whole retained ring is
replayed rather than silently skipping frames. -/
theorem replay_of_other_boot {b : Bus} {c : Cursor} (hc : c.bootId ≠ b.bootId) :
    replay b (some c) = b.ring := by simp [replay, hc]

/-- Replayed frames arrive in order and no sequence number repeats. -/
theorem replay_ordered {b : Bus} (h : Wf b) (c : Option Cursor) :
    (replay b c).Pairwise (fun f g => f.seq < g.seq) := by
  cases c with
  | none => exact h.ordered
  | some c =>
    by_cases hc : c.bootId = b.bootId
    · rw [replay, if_pos hc]
      exact List.Pairwise.sublist List.filter_sublist h.ordered
    · simpa [replay, hc] using h.ordered

/-- Everything the client is replayed really was published. -/
theorem replay_subset {b : Bus} {c : Option Cursor} {f : Frame} (hf : f ∈ replay b c) :
    f ∈ b.ring := by
  cases c with
  | none => exact hf
  | some c =>
    by_cases hc : c.bootId = b.bootId
    · simp only [replay, if_pos hc, List.mem_filter] at hf
      exact hf.1
    · simpa [replay, hc] using hf

/-- Withdrawal removes exactly the named posts and keeps everything else, in
order. -/
theorem mem_removeFromReplay {b : Bus} {ids : List String} {f : Frame} :
    f ∈ (removeFromReplay b ids).ring ↔ f ∈ b.ring ∧ ∀ id ∈ f.event.postId, id ∉ ids := by
  simp [removeFromReplay, List.mem_filter]

theorem removeFromReplay_wf {b : Bus} (h : Wf b) (ids : List String) :
    Wf (removeFromReplay b ids) := by
  refine ⟨List.Pairwise.sublist (List.filter_sublist) h.ordered, ?_, ?_⟩
  · intro f hf
    exact h.issued f (mem_removeFromReplay.mp hf).1
  · exact le_trans (List.length_filter_le _ _) h.bounded

/-- The guard is a real gate: a rejected event leaves the bus, and therefore
every live and replay frame, untouched. -/
theorem publishGuarded_of_reject {guard : Event → Bool} {b : Bus} {e : Event}
    (h : guard e = false) : publishGuarded guard b e = b := by
  simp [publishGuarded, h]

theorem publishGuarded_wf {guard : Event → Bool} {b : Bus} (h : Wf b) (e : Event) :
    Wf (publishGuarded guard b e) := by
  unfold publishGuarded
  split
  · exact publish_wf h e
  · exact h

end Bus

end Tracker
