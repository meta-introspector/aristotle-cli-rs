/-
# The rendering kernel, §8–§10 and §14: share tokens, honestly

A share token describes a **computation**, not a state: it is a seed and
a move list, written in the canonical numeral codec and prefixed by a
digest of that text.  Opening a token replays it.

What is proved here, and what is deliberately *not*:

* `verify_share` — round trip: a minted token reads back as the history
  it was minted from;
* `share_injective` — the encoding is canonical, so two histories never
  share a token and one history never has two;
* `share_replay` — the world an opened token denotes is exactly the
  replay of its seed and moves, which is the statement §18 was reaching
  for;
* `verify_valid` — anything an opened token produces is a valid world,
  because the client recomputed it;
* `verify_eq_none_of_digest_mismatch` — a token whose recomputed digest
  differs from the digest it carries is rejected, *by construction*.

Not proved, and not provable from a digest: that no *forged* token
verifies.  Anyone can mint a token and recompute its digest, so the
digest is a checksum against corruption, not authenticity.  The trust
anchor of this design is replay: a page believes a world because it
recomputed it from the seed under the kernel.  (For authenticity there
is the signature-chain layer elsewhere in this project; that is a
strictly stronger, and separate, claim.)

The last section is the archive escape hatch for §14: a **checkpoint**
lets a long history be resumed from the middle.  A checkpoint that is
*honest* preserves every result above; a checkpoint that merely looks
valid does not, and `Kant.Kernel.Demo` exhibits a valid-but-wrong one.
-/
import Mathlib
import RequestProject.Kant.Kernel.Core
import RequestProject.Kant.Kernel.Codec

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Kernel

open GameKernel

variable {K : GameKernel}

/-- A history is everything a token carries: where to start, and what was
played. -/
structure History (K : GameKernel) where
  /-- The seed. -/
  seed : SeedId
  /-- The moves, in order. -/
  moves : List K.Move

namespace History

/-- The world a history denotes. -/
def world (h : History K) : Option K.World := K.replay h.seed h.moves

end History

namespace Share

/-! ## The canonical payload -/

/-- The numerals a token carries: seed, move count, then the moves. -/
def payloadNats (K : GameKernel) (h : History K) : List Nat :=
  h.seed :: h.moves.length :: K.encodeMoves h.moves

/-- The payload as text. -/
def payload (K : GameKernel) (h : History K) : List Char :=
  Codec.encNats (payloadNats K h)

/-- Read a payload back.  Trailing rubbish is refused, which is what
makes the encoding canonical. -/
def parsePayload (K : GameKernel) (cs : List Char) : Option (History K) :=
  match Codec.decNats cs with
  | some (s :: n :: rest, []) =>
      match K.decodeMoves n rest with
      | some (ms, []) => some ⟨s, ms⟩
      | _ => none
  | _ => none

theorem parsePayload_payload (h : History K) : parsePayload K (payload K h) = some h := by
  have hd : Codec.decNats (payload K h) = some (payloadNats K h, []) := by
    have := Codec.decNats_encNats (payloadNats K h) []
    simpa [payload] using this
  have hm : K.decodeMoves h.moves.length (K.encodeMoves h.moves) = some (h.moves, []) := by
    have := decodeMoves_encodeMoves (K := K) h.moves []
    simpa using this
  simp only [parsePayload, hd, payloadNats, hm]

/-! ## The digest and the token -/

/-- The digest a token carries: the project's hex witness of the payload
text.  A checksum, not a signature — see the module header. -/
def digestOf (cs : List Char) : List Char :=
  Kant.Bytes.witness (Codec.toBytes cs)

@[simp] theorem digestOf_length (cs : List Char) : (digestOf cs).length = 64 := by
  simp [digestOf]

/-- Mint a token: digest first, fixed width, then the payload. -/
def share (K : GameKernel) (h : History K) : List Char :=
  digestOf (payload K h) ++ payload K h

/-- Open a token: split off the fixed-width digest, recompute it, and
refuse on mismatch. -/
def verify (K : GameKernel) (t : List Char) : Option (History K) :=
  if t.take 64 = digestOf (t.drop 64) then parsePayload K (t.drop 64) else none

theorem take_digest (cs p : List Char) (h : cs.length = 64) : (cs ++ p).take 64 = cs := by
  simp [← h]

theorem drop_digest (cs p : List Char) (h : cs.length = 64) : (cs ++ p).drop 64 = p := by
  simp [← h]

/-- **Round trip.**  A minted token reads back as the history it names. -/
theorem verify_share (h : History K) : verify K (share K h) = some h := by
  have hd : (digestOf (payload K h)).length = 64 := digestOf_length _
  simp only [verify, share, take_digest _ _ hd, drop_digest _ _ hd]
  exact parsePayload_payload h

/-- **Canonicity.**  Two histories never share a token. -/
theorem share_injective : Function.Injective (share K) := by
  intro a b hab
  have ha := verify_share (K := K) a
  rw [hab, verify_share] at ha
  simpa using ha.symm

/-- **The share property of §18, restated so that it says something.**
Opening a token yields exactly the replay of its seed and moves. -/
theorem share_replay (h : History K) :
    (verify K (share K h)).map History.world = some (K.replay h.seed h.moves) := by
  rw [verify_share]
  rfl

/-- Anything an opened token produces is a valid world — because it was
recomputed, not because the digest matched. -/
theorem verify_world_valid {t : List Char} {w : K.World}
    (h : (verify K t).bind History.world = some w) : K.validB w = true := by
  cases hv : verify K t with
  | none => rw [hv] at h; simp at h
  | some hist =>
      rw [hv] at h
      exact replay_valid (by simpa [History.world] using h)

/-- **Rejection by construction.**  A token carrying a digest that is not
the digest of its payload is refused. -/
theorem verify_eq_none_of_digest_mismatch {d p : List Char}
    (hlen : d.length = 64) (hne : d ≠ digestOf p) : verify K (d ++ p) = none := by
  simp only [verify, take_digest _ _ hlen, drop_digest _ _ hlen, if_neg hne]

/-- A truncated token — anything shorter than the digest — is refused,
unless the impossible happens and its own prefix digests to itself. -/
theorem verify_eq_none_of_short {t : List Char} (hshort : t.length < 64)
    (hne : t ≠ digestOf []) : verify K t = none := by
  have hdrop : t.drop 64 = [] := List.drop_eq_nil_of_le (le_of_lt hshort)
  have htake : t.take 64 = t := List.take_of_length_le (le_of_lt hshort)
  simp only [verify, hdrop, htake, if_neg hne]

/-! ## §14: checkpoints, so a long history need not be replayed whole -/

/-- An archive cell: "replaying this seed through these moves gives this
world".  The claim is what needs checking; the record is just a claim. -/
structure Checkpoint (K : GameKernel) where
  /-- The seed the claim is about. -/
  seed : SeedId
  /-- The move prefix the claim covers. -/
  covered : List K.Move
  /-- The world the archive says that prefix reaches. -/
  world : K.World

/-- A checkpoint is *honest* when replay agrees with it.  This is the
hypothesis every checkpoint result carries: it is discharged either by
recomputing the prefix once, or by trusting whoever wrote the cell. -/
def Checkpoint.Honest (c : Checkpoint K) : Prop := K.replay c.seed c.covered = some c.world

/-- Resume a history from a checkpoint instead of the seed. -/
def resume (K : GameKernel) (c : Checkpoint K) (rest : List K.Move) : Option K.World :=
  K.runFrom c.world rest

/-- **An honest checkpoint is a sound shortcut**: resuming from it gives
exactly what replaying the whole history from the seed gives. -/
theorem resume_eq_replay {c : Checkpoint K} (hc : c.Honest) (rest : List K.Move) :
    resume K c rest = K.replay c.seed (c.covered ++ rest) := by
  rw [replay_append, hc]
  rfl

/-- Honesty is checkable by replaying the prefix once — which is exactly
what a client that refuses to trust the archive does. -/
theorem honest_iff {c : Checkpoint K} :
    c.Honest ↔ K.replay c.seed c.covered = some c.world := Iff.rfl

/-- A checkpoint's key: the seed and the digest of the covered prefix, so
an index can find it and a client can tell two prefixes apart. -/
def checkpointKey (K : GameKernel) (s : SeedId) (covered : List K.Move) : List Char :=
  digestOf (payload K ⟨s, covered⟩)

/-- Different keys mean different histories: the index cannot silently
serve one prefix's cell for another (it can still serve a *wrong body*
for a key — that is the authentication gap stated in the header). -/
theorem checkpointKey_eq_of_history_eq {s : SeedId} {a b : List K.Move}
    (h : (⟨s, a⟩ : History K) = ⟨s, b⟩) : checkpointKey K s a = checkpointKey K s b := by
  rw [checkpointKey, checkpointKey, h]

/-! ### The index: one lookup from a seed and a prefix to a cell -/

/-- An archive index: cell keys to cells.  This is the whole of the
"archive-backed seed" machinery that the byte-range layer was missing. -/
abbrev Index (K : GameKernel) := List (List Char × Checkpoint K)

/-- Find the cell covering a given seed and prefix, if the index has
one. -/
def lookupCell (K : GameKernel) (idx : Index K) (s : SeedId) (covered : List K.Move) :
    Option (Checkpoint K) :=
  (idx.find? (fun p => p.1 = checkpointKey K s covered)).map Prod.snd

/-- Publishing a cell under its own key makes it findable. -/
theorem lookupCell_cons (K : GameKernel) (idx : Index K) (c : Checkpoint K) :
    lookupCell K ((checkpointKey K c.seed c.covered, c) :: idx) c.seed c.covered = some c := by
  simp [lookupCell, List.find?]

/-- Checking a cell by recomputing its prefix, relative to a sound
equality test on worlds.  A client that refuses to trust the archive runs
this once and then replays only the tail. -/
def verifyCell (K : GameKernel) (eq : K.World → K.World → Bool) (c : Checkpoint K) : Bool :=
  match K.replay c.seed c.covered with
  | some w => eq w c.world
  | none => false

/-- The checker is sound: if it accepts, the cell really is honest, and
then `resume_eq_replay` applies. -/
theorem honest_of_verifyCell {eq : K.World → K.World → Bool} {c : Checkpoint K}
    (heq : ∀ a b, eq a b = true → a = b) (h : verifyCell K eq c = true) : c.Honest := by
  unfold verifyCell at h
  cases hr : K.replay c.seed c.covered with
  | none => rw [hr] at h; simp at h
  | some w =>
      rw [hr] at h
      rw [Checkpoint.Honest, hr, heq w c.world h]

/-- What the index does **not** buy: a key names a prefix, but nothing
here authenticates the *body* served for that key.  Serving a wrong body
under a right key is exactly the dishonest cell of `Kant.Kernel.Demo`,
and the only defence is `verifyCell` — or an explicit trust assumption
about the archive. -/
theorem lookup_resume_eq_replay {idx : Index K} {s : SeedId} {covered : List K.Move}
    {c : Checkpoint K} (hhonest : ∀ p ∈ idx, (Prod.snd p).Honest)
    (hl : lookupCell K idx s covered = some c) (rest : List K.Move) :
    resume K c rest = K.replay c.seed (c.covered ++ rest) := by
  refine resume_eq_replay ?_ rest
  unfold lookupCell at hl
  cases hf : idx.find? (fun p => p.1 = checkpointKey K s covered) with
  | none => rw [hf] at hl; simp at hl
  | some p =>
      rw [hf] at hl
      simp only [Option.map_some, Option.some.injEq] at hl
      subst hl
      exact hhonest p (List.mem_of_find?_eq_some hf)

end Share

end Kant.Kernel
