import Mathlib

/-!
# The move log: one replicated state machine for every platform

The game described in `GAMEPLAN.md` runs on a phone, in a browser (WebAssembly),
inside Roblox and on a server, and it must run *offline* and reconcile later.
The only way that can work without a referee is for every client to be a replica
of the same deterministic state machine, fed by a growing **set** of operations.

This file is that model, payload-agnostic:

* `OpId` — the identity of an operation: a Lamport stamp, the author, and the
  author's own counter.  Linearly ordered lexicographically, so the log has a
  canonical replay order that every platform computes identically.
* `Log P = Finset (Op P)` — what a replica has seen.  Delivery is a *set union*
  (`merge`), so it is commutative, associative and idempotent: messages may be
  duplicated, reordered or re-sent, and the merged log does not care.
* `sortLog` — the canonical replay order, and `replay` — the state a replica
  computes from a log.
* `eventual_consistency` — two replicas that have seen the same operations
  compute the same state; this is the correctness statement of the whole
  networking design.
* `replay_impl_eq` — an implementation on another platform that agrees with the
  reference step function pointwise computes the same state, which is the
  correctness statement for the Roblox/Lua and WASM ports.
* `replay_perm_eq` — when the operations commute, replicas agree even without
  sorting.
* `Consistent` and `consistent_merge_of_authors_disjoint` — distinct authors
  never mint the same operation id, so gossip between peers never produces an
  ambiguous log.
-/

namespace LifeTrac
namespace Net

/-! ## Operation identity -/

/-- The identity of an operation: the Lamport stamp it was issued at, the
author (peer) that issued it, and that author's own sequence number.  Ordered
lexicographically in that order: causally later operations sort later, ties are
broken by author and then by the author's counter. -/
structure OpId where
  /-- Lamport stamp: one plus the largest stamp the author had seen. -/
  lamport : ℕ
  /-- The peer that issued the operation. -/
  author : ℕ
  /-- The author's own counter, so one author's operations are totally ordered. -/
  seq : ℕ
deriving DecidableEq, Repr

namespace OpId

/-- The lexicographic key of an operation id. -/
def key (i : OpId) : ℕ ×ₗ (ℕ ×ₗ ℕ) := toLex (i.lamport, toLex (i.author, i.seq))

theorem key_injective : Function.Injective key := by
  rintro ⟨a, b, c⟩ ⟨a', b', c'⟩ h
  simp only [key, toLex_inj, Prod.mk.injEq] at h
  simp [h.1, h.2.1, h.2.2]

instance : LinearOrder OpId := LinearOrder.lift' key key_injective

theorem le_def (i j : OpId) : i ≤ j ↔ key i ≤ key j := Iff.rfl

end OpId

/-! ## Operations and logs -/

/-- An operation: an identity and a payload.  The payload is whatever the game
layer needs — a control input, a game move, or an edit to a creative-mode
design (see `RequestProject/Net/Design.lean`). -/
structure Op (P : Type) where
  /-- The operation's identity. -/
  id : OpId
  /-- What the operation does. -/
  payload : P
deriving DecidableEq, Repr

variable {P : Type} [DecidableEq P]

/-- What a replica has seen: a finite *set* of operations. -/
abbrev Log (P : Type) [DecidableEq P] := Finset (Op P)

/-- Delivering one replica's log to another. -/
def merge (L M : Log P) : Log P := L ∪ M

@[simp] theorem mem_merge {L M : Log P} {o : Op P} : o ∈ merge L M ↔ o ∈ L ∨ o ∈ M :=
  Finset.mem_union

theorem merge_comm (L M : Log P) : merge L M = merge M L := Finset.union_comm _ _

theorem merge_assoc (L M N : Log P) : merge (merge L M) N = merge L (merge M N) :=
  Finset.union_assoc _ _ _

@[simp] theorem merge_self (L : Log P) : merge L L = L := Finset.union_self _

@[simp] theorem merge_empty (L : Log P) : merge L ∅ = L := Finset.union_empty _

@[simp] theorem empty_merge (L : Log P) : merge ∅ L = L := Finset.empty_union _

theorem subset_merge_left (L M : Log P) : L ⊆ merge L M := Finset.subset_union_left

theorem subset_merge_right (L M : Log P) : M ⊆ merge L M := Finset.subset_union_right

theorem merge_mono {L L' M M' : Log P} (hL : L ⊆ L') (hM : M ⊆ M') :
    merge L M ⊆ merge L' M' := Finset.union_subset_union hL hM

/-- Re-delivering something already known changes nothing: the log is
idempotent under merge, so the transport may duplicate messages freely. -/
theorem merge_eq_self_of_subset {L M : Log P} (h : M ⊆ L) : merge L M = L :=
  Finset.union_eq_left.2 h

/-! ## Canonical replay order -/

/-- The replay order on operations: by operation id. -/
def before (a b : Op P) : Prop := a.id ≤ b.id

instance : DecidableRel (before (P := P)) := fun a b => inferInstanceAs (Decidable (a.id ≤ b.id))

instance : IsTrans (Op P) (before (P := P)) := ⟨fun _ _ _ h₁ h₂ => le_trans h₁ h₂⟩

instance : Std.Total (before (P := P)) := ⟨fun a b => le_total a.id b.id⟩

/-- The canonical replay order of a log: its operations sorted by id.  Every
platform computes this same list from the same set of operations. -/
noncomputable def sortLog (L : Log P) : List (Op P) := L.toList.insertionSort before

theorem sortLog_perm (L : Log P) : (sortLog L).Perm L.toList :=
  List.perm_insertionSort _ _

@[simp] theorem mem_sortLog {L : Log P} {o : Op P} : o ∈ sortLog L ↔ o ∈ L := by
  rw [(sortLog_perm L).mem_iff, Finset.mem_toList]

theorem sortLog_nodup (L : Log P) : (sortLog L).Nodup :=
  (sortLog_perm L).nodup_iff.2 (Finset.nodup_toList L)

theorem sortLog_sorted (L : Log P) : (sortLog L).Pairwise (before (P := P)) :=
  List.pairwise_insertionSort _ _

theorem sortLog_length (L : Log P) : (sortLog L).length = L.card := by
  rw [(sortLog_perm L).length_eq, Finset.length_toList]

@[simp] theorem sortLog_empty : sortLog (∅ : Log P) = [] := by
  simp [sortLog]

/-! ## Replay -/

variable {S : Type}

/-- The state a replica computes from a log: fold the step function over the
operations in canonical order. -/
noncomputable def replay (step : S → P → S) (init : S) (L : Log P) : S :=
  (sortLog L).foldl (fun s o => step s o.payload) init

@[simp] theorem replay_empty (step : S → P → S) (init : S) :
    replay step init (∅ : Log P) = init := by
  simp [replay]

/-- **Strong eventual consistency.**  Two replicas — a phone, a browser tab, a
Roblox server — that have received the same operations, in whatever order and
with whatever duplication, compute exactly the same state. -/
theorem eventual_consistency (step : S → P → S) (init : S) {L M : Log P}
    (h : ∀ o : Op P, o ∈ L ↔ o ∈ M) : replay step init L = replay step init M := by
  have : L = M := Finset.ext h
  rw [this]

/-- Merging is what a sync does, and merging the same operations twice is a
no-op: syncing an already-synced replica does not move it. -/
theorem replay_merge_self (step : S → P → S) (init : S) (L M : Log P) (h : M ⊆ L) :
    replay step init (merge L M) = replay step init L := by
  rw [merge_eq_self_of_subset h]

/-- **Cross-platform agreement.**  A port — Lua inside Roblox, hand-written
JavaScript, the WASM build — that implements the step function pointwise
correctly computes the same state as the reference implementation on every log.
This is what makes the same match playable across platforms. -/
theorem replay_impl_eq (step impl : S → P → S) (h : ∀ s p, impl s p = step s p)
    (init : S) (L : Log P) : replay impl init L = replay step init L := by
  have : (fun (s : S) (o : Op P) => impl s o.payload) =
      (fun (s : S) (o : Op P) => step s o.payload) := by
    funext s o; exact h s o.payload
  simp [replay, this]

omit [DecidableEq P] in
/-- When operations commute, replay does not even need the sort: any delivery
order gives the same state.  This is the criterion a payload has to meet to be
applied optimistically the moment it arrives, without rollback. -/
theorem replay_perm_eq (step : S → P → S)
    (hcomm : ∀ (s : S) (a b : P), step (step s a) b = step (step s b) a)
    (init : S) {l₁ l₂ : List (Op P)} (h : l₁.Perm l₂) :
    l₁.foldl (fun s o => step s o.payload) init =
      l₂.foldl (fun s o => step s o.payload) init := by
  haveI : RightCommutative (fun (s : S) (o : Op P) => step s o.payload) :=
    ⟨fun s a b => hcomm s a.payload b.payload⟩
  exact h.foldl_eq init

/-- With commuting operations, a replica may apply operations in arrival order
and still agree with the canonical replay. -/
theorem replay_eq_foldl_of_comm (step : S → P → S)
    (hcomm : ∀ (s : S) (a b : P), step (step s a) b = step (step s b) a)
    (init : S) (L : Log P) :
    replay step init L = L.toList.foldl (fun s o => step s o.payload) init :=
  replay_perm_eq step hcomm init (sortLog_perm L)

/-! ## Unambiguous logs -/

/-- A log is *consistent* when an operation id determines the operation: no two
different operations claim the same identity. -/
def Consistent (L : Log P) : Prop := ∀ a ∈ L, ∀ b ∈ L, a.id = b.id → a = b

theorem Consistent.subset {L M : Log P} (h : Consistent L) (hs : M ⊆ L) : Consistent M :=
  fun a ha b hb hab => h a (hs ha) b (hs hb) hab

/-- The peers that authored the operations of a log. -/
def authors (L : Log P) : Finset ℕ := L.image (fun o => o.id.author)

theorem mem_authors {L : Log P} {a : ℕ} : a ∈ authors L ↔ ∃ o ∈ L, o.id.author = a := by
  simp [authors]

/-- Peers that never share an author id never mint the same operation id, so
peer-to-peer gossip between them always produces an unambiguous log — no
central authority is needed to allocate identities. -/
theorem consistent_merge_of_authors_disjoint {L M : Log P}
    (hL : Consistent L) (hM : Consistent M)
    (hd : Disjoint (authors L) (authors M)) : Consistent (merge L M) := by
  intro a ha b hb hab
  rw [mem_merge] at ha hb
  rcases ha with ha | ha <;> rcases hb with hb | hb
  · exact hL a ha b hb hab
  · exact absurd (mem_authors.2 ⟨b, hb, by rw [← hab]⟩)
      (Finset.disjoint_left.1 hd (mem_authors.2 ⟨a, ha, rfl⟩))
  · exact absurd (mem_authors.2 ⟨a, ha, by rw [hab]⟩)
      (Finset.disjoint_left.1 hd (mem_authors.2 ⟨b, hb, rfl⟩))
  · exact hM a ha b hb hab

/-- In a consistent log the canonical replay order is *strictly* increasing in
the operation ids: the order is forced, not merely one of several. -/
theorem sortLog_strict_of_consistent {L : Log P} (h : Consistent L) :
    (sortLog L).Pairwise (fun a b => a.id < b.id) := by
  refine ((sortLog_sorted L).and (sortLog_nodup L)).imp_of_mem ?_
  intro a b ha hb hab
  rcases lt_or_eq_of_le hab.1 with h' | h'
  · exact h'
  · exact absurd (h a (mem_sortLog.1 ha) b (mem_sortLog.1 hb) h') hab.2

/-! ## Lamport clocks -/

/-- The largest Lamport stamp in a log (`0` for the empty log). -/
def maxLamport (L : Log P) : ℕ := L.sup (fun o => o.id.lamport)

theorem le_maxLamport {L : Log P} {o : Op P} (h : o ∈ L) : o.id.lamport ≤ maxLamport L :=
  Finset.le_sup (f := fun o : Op P => o.id.lamport) h

/-- The stamp a replica gives its next operation. -/
def nextStamp (L : Log P) : ℕ := maxLamport L + 1

/-- A newly issued operation is strictly later than everything the issuer had
seen, so appending it to the local log cannot disturb the replay order of what
is already there: an offline player's moves always land after the moves they
played offline on top of. -/
theorem lt_nextStamp {L : Log P} {o : Op P} (h : o ∈ L) : o.id.lamport < nextStamp L :=
  Nat.lt_succ_of_le (le_maxLamport h)

theorem maxLamport_merge (L M : Log P) :
    maxLamport (merge L M) = max (maxLamport L) (maxLamport M) := by
  simp [maxLamport, merge, Finset.sup_union]

theorem maxLamport_mono {L M : Log P} (h : L ⊆ M) : maxLamport L ≤ maxLamport M :=
  Finset.sup_mono h

end Net
end LifeTrac
