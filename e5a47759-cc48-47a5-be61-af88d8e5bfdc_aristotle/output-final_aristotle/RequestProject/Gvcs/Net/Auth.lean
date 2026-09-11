import RequestProject.Gvcs.Net.Compaction

/-!
# Signed authorship: forging an id is the only way to break a log

`RequestProject/Net/Log.lean` proves that peer-to-peer gossip produces an
unambiguous log when the peers' author ids are disjoint
(`consistent_merge_of_authors_disjoint`), and `GAMEPLAN.md` §6.4 says why that
holds in practice: an author id is a public-key fingerprint, moves are signed,
and peers cannot forge each other's ids.  This file turns that sentence into
theorems.

* `Ids` — who actually issued which operation, with the rule that a peer only
  ever issues operations carrying its own author id.
* `Ids.Honest` — a peer that never issues two different operations under one
  id (never *equivocates*).
* `Ids.Unforged` — a log in which every operation was really issued by the peer
  it names.
* `consistent_of_unforged` — an unforged log of honest peers is consistent, with
  no disjointness assumption at all: this strictly strengthens
  `consistent_merge_of_authors_disjoint`, since unforgedness is closed under
  merge (`Unforged.merge`).
* `forged_or_dishonest_of_not_consistent` — the converse, and the headline: a
  log can only be ambiguous if some operation was forged or some peer
  equivocated under its own id.  Nothing else can break it.
* `Sigs` — a signature layer on top: signatures of an author verify, and a
  verifying signature can only come from the peer holding that key.
  `Sigs.unforged_of_verified` and `Sigs.consistent_of_verified` carry the
  results across.
* `replay_compact_of_verified` — a peer may sign, gossip and compact at once
  (`RequestProject/Net/Compaction.lean`).
-/

namespace LifeTrac
namespace Net

variable {P : Type} [DecidableEq P] {S : Type}

/-! ## Who issued what -/

/-- The ground truth behind author ids: which operations each peer actually
issued.  A peer signs with its own key, so everything it issues carries its own
author id — that is the only structural rule. -/
structure Ids (P : Type) where
  /-- The operations peer `p` has issued. -/
  issued : ℕ → Set (Op P)
  /-- A peer issues only operations that name it as author. -/
  author_eq : ∀ p o, o ∈ issued p → o.id.author = p

variable (I : Ids P)

/-- A peer is *honest* when it never issues two different operations under the
same operation id: its Lamport stamp and sequence number identify its move.
A peer that breaks this is *equivocating*. -/
def Ids.Honest (I : Ids P) (p : ℕ) : Prop :=
  ∀ a ∈ I.issued p, ∀ b ∈ I.issued p, a.id = b.id → a = b

/-- A log is *unforged* when every operation in it really was issued by the
peer it names as author. -/
def Ids.Unforged (I : Ids P) (L : Log P) : Prop :=
  ∀ o ∈ L, o ∈ I.issued o.id.author

theorem Ids.Unforged.subset {L M : Log P} (h : I.Unforged L) (hs : M ⊆ L) : I.Unforged M :=
  fun o ho => h o (hs ho)

/-- Unforgedness survives gossip: merging two unforged logs gives an unforged
log, whoever the peers are. -/
theorem Ids.Unforged.merge {L M : Log P} (hL : I.Unforged L) (hM : I.Unforged M) :
    I.Unforged (Net.merge L M) := by
  intro o ho
  rcases mem_merge.1 ho with h | h
  · exact hL o h
  · exact hM o h

theorem Ids.unforged_empty : I.Unforged (∅ : Log P) := by
  intro o ho
  exact absurd ho (Finset.notMem_empty o)

/-- **Signed authorship makes logs unambiguous.**  If no peer equivocates and
no operation is forged, the log is consistent — an operation id determines the
operation.  Unlike `consistent_merge_of_authors_disjoint` this needs no
assumption about which peers met which: identity does the work. -/
theorem consistent_of_unforged {L : Log P} (hon : ∀ p, I.Honest p)
    (hu : I.Unforged L) : Consistent L := by
  intro a ha b hb hab
  have ha' : a ∈ I.issued a.id.author := hu a ha
  have hb' : b ∈ I.issued b.id.author := hu b hb
  rw [← hab] at hb'
  exact hon a.id.author a ha' b hb' hab

/-- Gossip between honest peers, however they pair up, always produces an
unambiguous log. -/
theorem consistent_merge_of_unforged {L M : Log P} (hon : ∀ p, I.Honest p)
    (hL : I.Unforged L) (hM : I.Unforged M) : Consistent (Net.merge L M) :=
  consistent_of_unforged I hon (hL.merge I hM)

/-- **The only way to break a log.**  If a log is ambiguous then either one of
its operations was forged — put there under a peer's id without that peer
issuing it — or some peer equivocated under its own id.  There is no third
failure mode, so unforgeable signatures plus honest clients are exactly what
consistency needs. -/
theorem forged_or_dishonest_of_not_consistent {L : Log P} (h : ¬ Consistent L) :
    (∃ o ∈ L, o ∉ I.issued o.id.author) ∨ ∃ p, ¬ I.Honest p := by
  by_cases hu : I.Unforged L
  · refine Or.inr ?_
    by_contra hall
    push_neg at hall
    exact h (consistent_of_unforged I (fun p => hall p) hu)
  · refine Or.inl ?_
    unfold Ids.Unforged at hu
    push_neg at hu
    exact hu

/-- Conversely, an ambiguous log really is evidence of misbehaviour: if all
peers are honest, an ambiguous log contains a forged operation. -/
theorem exists_forged_of_not_consistent {L : Log P} (hon : ∀ p, I.Honest p)
    (h : ¬ Consistent L) : ∃ o ∈ L, o ∉ I.issued o.id.author := by
  rcases forged_or_dishonest_of_not_consistent I h with hf | ⟨p, hp⟩
  · exact hf
  · exact absurd (hon p) hp

/-! ## The signature layer -/

/-- A signature scheme over operations, at the level of detail the log needs:
each peer can sign, its own signatures verify, and — this is the cryptographic
assumption, stated as a field rather than assumed silently — a signature that
verifies for an operation can only have been made by the peer the operation
names, so the operation was issued by that peer. -/
structure Sigs (P : Type) extends Ids P where
  /-- The type of signatures. -/
  Tag : Type
  /-- Peer `p` signing an operation with its own key. -/
  sign : ℕ → Op P → Tag
  /-- Checking a signature against the operation's claimed author. -/
  verify : Op P → Tag → Prop
  /-- An author's signature on an operation it issues verifies. -/
  verify_sign : ∀ o, o ∈ issued o.id.author → verify o (sign o.id.author o)
  /-- Unforgeability: only the holder of the named author's key can produce a
  signature that verifies, and it does so on operations it issues. -/
  unforgeable : ∀ o t, verify o t → o ∈ issued o.id.author

/-- A log is *verified* when every operation in it carries a signature that
checks out. -/
def Sigs.Verified (G : Sigs P) (L : Log P) : Prop := ∀ o ∈ L, ∃ t, G.verify o t

/-- A verified log is unforged: signatures are exactly what rules out forgery. -/
theorem Sigs.unforged_of_verified (G : Sigs P) {L : Log P} (h : G.Verified L) :
    G.toIds.Unforged L := by
  intro o ho
  obtain ⟨t, ht⟩ := h o ho
  exact G.unforgeable o t ht

/-- Conversely, honest peers can always sign what they issue, so an unforged
log can be presented verified. -/
theorem Sigs.verified_of_unforged (G : Sigs P) {L : Log P} (h : G.toIds.Unforged L) :
    G.Verified L :=
  fun o ho => ⟨G.sign o.id.author o, G.verify_sign o (h o ho)⟩

theorem Sigs.verified_merge (G : Sigs P) {L M : Log P} (hL : G.Verified L)
    (hM : G.Verified M) : G.Verified (Net.merge L M) := by
  intro o ho
  rcases mem_merge.1 ho with h | h
  · exact hL o h
  · exact hM o h

/-- **Signatures give unambiguous logs.**  Among honest peers, a log of
verified operations is consistent, and therefore has the forced canonical
replay order of `sortLog_strict_of_consistent`. -/
theorem Sigs.consistent_of_verified (G : Sigs P) {L : Log P}
    (hon : ∀ p, G.toIds.Honest p) (h : G.Verified L) : Consistent L :=
  consistent_of_unforged G.toIds hon (G.unforged_of_verified h)

/-! ## Consequences for replay and compaction -/

/-- A peer may sign, gossip *and* compact: with a valid snapshot at any
watermark, a verified log of honest peers replays from the snapshot to exactly
the state of the whole log. -/
theorem replay_compact_of_verified (G : Sigs P) (step : S → P → S) (init : S) {L : Log P}
    (hon : ∀ p, G.toIds.Honest p) (hV : G.Verified L) {snap : Snapshot S}
    (hv : snap.Valid step init L) :
    replay step snap.state (compact L snap.watermark) = replay step init L :=
  replay_compact step init (G.consistent_of_verified hon hV) hv

end Net
end LifeTrac
