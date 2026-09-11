/-
# Urania §3.3 / §4 — the chain, and catching a relay that forks it

The Tier-2 ground truth is the relay's append-only chain: a node submits
`hash(content) + source_ref + timestamp + author_pubkey`, signed, and the
relay appends it **unconditionally**.  Per §3.3 the relay is deliberately
*not* a policy engine: it does not decide whether a submission is
admissible, because a refusal would be invisible.  Validity is
client-checkable — every node filters the log itself with the signature
scheme, so two nodes holding the same prefix hold the same accepted set.

The one thing a single relay can still do is **equivocate**: serve
different chains to different clients.  §4 asks for signed-head gossip,
a *transferable* fork certificate, and first-seen pinning.  All three are
here, relative to the abstract signature scheme of `Kant.Urania.Crypto`.

Proved here:

* `append_keeps_history`, `getElem?_append_left` — appending never
  rewrites what is already in the log;
* `accepted_authentic` — an entry a client accepts really was signed by
  the key it names (no forgery, symbolically);
* `accepted_prefix_agree` — **two nodes with the same prefix accept the
  same entries**: the relay contributes nothing to the verdict;
* `accepted_append_stable` — later appends cannot change the verdict on
  an earlier prefix;
* `fork_sound` — a certificate that checks out proves the relay signed
  two different roots at one index: offline-verifiable, transferable, no
  cooperating second verifier needed;
* `observe_pins_first`, `observe_first_seen_wins` — a client pins the
  first head it sees at each index and never revises it;
* `observe_detects_equivocation` — and therefore detects a fork *on its
  own*, over time, emitting a certificate that passes `checkFork`;
* `observe_no_false_alarm` — an agreeing head raises nothing.
-/
import Mathlib
import RequestProject.Kant.Urania.Crypto

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Urania

/-- A public key.  Per §5 this is a **per-room or per-topic pseudonym**,
not a global identity: the trust graph needs long-lived keys, and making
them global would make authorship permanently linkable across rooms. -/
abbrev Key := List Char

/-! ## Submissions and the chain -/

/-- The signed payload of a Tier-2 submission (`POST /submit`).  The
relay only ever sees a hash and a pointer — never the content. -/
structure Submission where
  /-- Content address of the blob being announced. -/
  contentHash : List Char
  /-- What external source the content annotates, if any. -/
  sourceRef : List Char
  /-- The submitter's clock. -/
  timestamp : Nat
  /-- The pseudonym accountable for it. -/
  author : Key
deriving DecidableEq, Repr

/-- A chain entry: a payload and its signature. -/
structure Entry (Sig : Type) where
  /-- What was signed. -/
  payload : Submission
  /-- The signature over it. -/
  sig : Sig
deriving Repr

/-- The relay's append-only log. -/
abbrev Chain (Sig : Type) := List (Entry Sig)

/-- `POST /submit`: the relay appends, unconditionally.  There is no
trust argument to this function — that is the point of §3.3. -/
def submit {Sig : Type} (c : Chain Sig) (e : Entry Sig) : Chain Sig := c ++ [e]

/-- `GET /chain?from=&to=`: the entries with index in `[from, to]`. -/
def chainRange {Sig : Type} (c : Chain Sig) (from_ to_ : Nat) : Chain Sig :=
  (c.drop from_).take (to_ + 1 - from_)

variable {Sig : Type}

/-- **Appending never rewrites history.** -/
@[simp] theorem append_keeps_history (c : Chain Sig) (e : Entry Sig) :
    (submit c e).take c.length = c := by
  simp [submit]

theorem submit_mem (c : Chain Sig) (e : Entry Sig) : e ∈ submit c e := by
  simp [submit]

/-- Old indices keep their entries. -/
theorem submit_getElem_left {c : Chain Sig} {e : Entry Sig} {i : Nat} (h : i < c.length) :
    getElem? (submit c e) i = getElem? c i := by
  simp [submit, List.getElem?_append_left h]

theorem chainRange_length (c : Chain Sig) (from_ to_ : Nat) :
    (chainRange c from_ to_).length = min (to_ + 1 - from_) (c.length - from_) := by
  simp [chainRange]

/-- An entry of the claimed range is an entry of the chain. -/
theorem mem_chainRange {c : Chain Sig} {from_ to_ : Nat} {e : Entry Sig}
    (h : e ∈ chainRange c from_ to_) : e ∈ c :=
  List.mem_of_mem_drop (List.mem_of_mem_take h)

/-! ## Client-side validity

The relay appends everything; the client decides what counts. -/

/-- Whether a client accepts an entry: its signature verifies against the
author it names. -/
def accepts (S : SigScheme Key Submission Sig) (e : Entry Sig) : Bool :=
  S.verify e.payload.author e.payload e.sig

/-- The entries a client accepts out of a log. -/
def accepted (S : SigScheme Key Submission Sig) (c : Chain Sig) : Chain Sig :=
  c.filter (accepts S)

/-- **What a client accepts really was signed by the key it names.** -/
theorem accepted_authentic {S : SigScheme Key Submission Sig} {c : Chain Sig} {e : Entry Sig}
    (h : e ∈ accepted S c) : S.signedBy e.payload.author e.payload e.sig :=
  S.noForgery _ _ _ (List.mem_filter.mp h).2

theorem mem_accepted_iff {S : SigScheme Key Submission Sig} {c : Chain Sig} {e : Entry Sig} :
    e ∈ accepted S c ↔ e ∈ c ∧ accepts S e = true := by
  simp [accepted, List.mem_filter]

/-- **Two nodes holding the same prefix accept the same entries.**  The
verdict is a function of the log alone: nothing the relay says, and no
`GET /trust/:pubkey` answer, enters into it. -/
theorem accepted_prefix_agree {S : SigScheme Key Submission Sig} {c c' : Chain Sig} {n : Nat}
    (h : c.take n = c'.take n) : accepted S (c.take n) = accepted S (c'.take n) := by
  rw [h]

/-- A node that has seen more of the log still agrees about the prefix:
appends cannot retroactively change an earlier verdict. -/
theorem accepted_append_stable {S : SigScheme Key Submission Sig} {c extra : Chain Sig} {n : Nat}
    (h : n ≤ c.length) : accepted S ((c ++ extra).take n) = accepted S (c.take n) := by
  rw [List.take_append_of_le_length h]

/-! ## Signed heads, forks and pinning -/

/-- What a relay gossips about its own log: an index and the merkle root
of the log up to it. -/
structure Head (Hash : Type) where
  /-- The length of the chain being committed to. -/
  index : Nat
  /-- The merkle root of that prefix. -/
  root : Hash
deriving DecidableEq, Repr

/-- A head as signed by a relay key. -/
structure SignedHead (Hash Sig : Type) where
  /-- The head itself. -/
  head : Head Hash
  /-- The relay that signed it. -/
  relay : Key
  /-- The signature. -/
  sig : Sig
deriving Repr

variable {Hash : Type}

/-- Whether a gossiped head verifies. -/
def validHead (R : SigScheme Key (Head Hash) Sig) (sh : SignedHead Hash Sig) : Bool :=
  R.verify sh.relay sh.head sh.sig

/-- **Fork evidence**: two heads at the same index, signed by one relay
key, over different roots.  Self-contained — it travels by sneakernet
like everything else in this project, and needs no cooperating second
verifier. -/
structure ForkCertificate (Hash Sig : Type) where
  /-- The head seen first. -/
  left : SignedHead Hash Sig
  /-- The conflicting head. -/
  right : SignedHead Hash Sig
deriving Repr

/-- Offline check of a fork certificate. -/
def checkFork [DecidableEq Hash] (R : SigScheme Key (Head Hash) Sig)
    (cert : ForkCertificate Hash Sig) : Bool :=
  validHead R cert.left && validHead R cert.right &&
    (cert.left.relay == cert.right.relay) &&
    (cert.left.head.index == cert.right.head.index) &&
    (cert.left.head.root != cert.right.head.root)

/-- **A certificate that checks out proves the relay equivocated**: one
key, one index, two different roots, both really signed. -/
theorem fork_sound [DecidableEq Hash] {R : SigScheme Key (Head Hash) Sig}
    {cert : ForkCertificate Hash Sig} (h : checkFork R cert = true) :
    cert.left.relay = cert.right.relay ∧
      cert.left.head.index = cert.right.head.index ∧
      cert.left.head.root ≠ cert.right.head.root ∧
      R.signedBy cert.left.relay cert.left.head cert.left.sig ∧
      R.signedBy cert.left.relay cert.right.head cert.right.sig := by
  simp only [checkFork, Bool.and_eq_true, beq_iff_eq, bne_iff_ne, ne_eq] at h
  obtain ⟨⟨⟨⟨hl, hr⟩, hkey⟩, hidx⟩, hroot⟩ := h
  refine ⟨hkey, hidx, hroot, R.noForgery _ _ _ hl, ?_⟩
  rw [hkey]
  exact R.noForgery _ _ _ hr

/-! ### First-seen pinning

A client that remembers the first head it saw at each index detects
equivocation by itself, over time, rather than only when two clients
compare notes. -/

/-- The heads a client has pinned, newest first. -/
abbrev Pins (Hash Sig : Type) := List (Nat × SignedHead Hash Sig)

/-- The head pinned at an index, if any. -/
def pinnedAt (ps : Pins Hash Sig) (i : Nat) : Option (SignedHead Hash Sig) :=
  (ps.find? (fun p => p.1 == i)).map Prod.snd

/-- Observing a gossiped head: pin it if the index is fresh, ignore it if
it agrees, and otherwise emit a fork certificate. -/
def observe [DecidableEq Hash] (ps : Pins Hash Sig) (sh : SignedHead Hash Sig) :
    Pins Hash Sig × Option (ForkCertificate Hash Sig) :=
  match pinnedAt ps sh.head.index with
  | none => ((sh.head.index, sh) :: ps, none)
  | some old => if old.head.root = sh.head.root then (ps, none) else (ps, some ⟨old, sh⟩)

/-- A fresh index is pinned by the head that arrived first. -/
theorem observe_pins_first [DecidableEq Hash] {ps : Pins Hash Sig} {sh : SignedHead Hash Sig}
    (h : pinnedAt ps sh.head.index = none) :
    pinnedAt (observe ps sh).1 sh.head.index = some sh := by
  unfold observe
  rw [h]
  simp [pinnedAt, List.find?_cons_of_pos]

/-- **First seen wins**: once an index is pinned, no later head changes
it. -/
theorem observe_first_seen_wins [DecidableEq Hash] {ps : Pins Hash Sig}
    {sh old : SignedHead Hash Sig} (h : pinnedAt ps sh.head.index = some old) :
    (observe ps sh).1 = ps := by
  unfold observe
  rw [h]
  by_cases hr : old.head.root = sh.head.root <;> simp [hr]


/-- **A single client detects a fork on its own.**  If the head pinned at
an index and a newly gossiped head are both valid, come from the same
relay key, and disagree, the client emits a certificate that any third
party can check offline. -/
theorem observe_detects_equivocation [DecidableEq Hash] {R : SigScheme Key (Head Hash) Sig}
    {ps : Pins Hash Sig} {sh old : SignedHead Hash Sig}
    (hpin : pinnedAt ps sh.head.index = some old)
    (hidx : old.head.index = sh.head.index)
    (hkey : old.relay = sh.relay)
    (hold : validHead R old = true) (hnew : validHead R sh = true)
    (hroot : old.head.root ≠ sh.head.root) :
    ∃ cert, (observe ps sh).2 = some cert ∧ checkFork R cert = true := by
  refine ⟨⟨old, sh⟩, ?_, ?_⟩
  · unfold observe
    rw [hpin]
    simp [hroot]
  · simp [checkFork, hold, hnew, hkey, hidx, hroot]

/-- No false alarm: a head agreeing with the pin raises nothing. -/
theorem observe_no_false_alarm [DecidableEq Hash] {ps : Pins Hash Sig}
    {sh old : SignedHead Hash Sig} (hpin : pinnedAt ps sh.head.index = some old)
    (hroot : old.head.root = sh.head.root) : (observe ps sh).2 = none := by
  unfold observe
  rw [hpin]
  simp [hroot]

end Kant.Urania
