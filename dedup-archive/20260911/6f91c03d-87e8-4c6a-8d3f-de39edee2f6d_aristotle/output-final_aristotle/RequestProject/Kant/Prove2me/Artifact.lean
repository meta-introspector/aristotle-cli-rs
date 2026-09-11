/-
# Prove2me §3–§4 — signed, content-addressed artifacts

The P2P specification for Prove2me (see `docs/PROVE2ME-P2P.md`) is built
on one object: an **artifact**, which is a kind plus a list of fields,
canonically encoded, and identified by the address of those canonical
bytes.

Two corrections to the source specification are made here and carried
through the whole layer.

* **The envelope in the source specification is circular**: it contains
  `artifact_id` and is also the thing that is hashed.  Here the two are
  separated.  `Content` is the immutable object and its identity is
  `idOf A c = A.cid (canon c)`; a `Claim` is a *signed announcement*
  which merely *refers* to a content address and additionally carries an
  author, a timestamp and DAG links.  Because the timestamp lives in the
  announcement and not in the content, "the same statement published
  twice is the same artifact" is `announce_content_agnostic`, a theorem
  rather than a coincidence.

* **The address function is a hypothesis, never a construction.**  An
  `Addressing` bundles a function `Str → Str` *together with* its own
  injectivity, exactly as `Kant.Urania.HashFn` does.  No such value can
  be built from anything this repository ships:
  `no_addressing_is_witness` proves that the 64-hex witness — which is
  what the running client actually computes — cannot instantiate it.
  Every identity theorem below therefore states its idealisation
  visibly, in its own statement.

Also separated, against the source specification's single `parents`
field: `parents` are DAG links used for replication, `predecessors` are
the semantic "this supersedes that" relation.  Only the latter is part
of an artifact's meaning, and neither is part of its identity.
-/
import Mathlib
import RequestProject.Kant.Clipboard
import RequestProject.Kant.Urania.Crypto

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me

open Kant Kant.Bytes Kant.Text Kant.Clipboard Kant.Urania

/-! ## Names -/

/-- All artifact text is plain characters. -/
abbrev Str := List Char

/-- A content address.  Textual (hex, in practice), so that it can travel
in a URL fragment, a chat line or an API field. -/
abbrev Cid := Str

/-- A public key, printed. -/
abbrev Key := Str

/-! ## Addressing: an idealisation carried as a hypothesis -/

/-- A **symbolically idealised content addressing function**: a map from
canonical bytes to an address, together with a proof that it never
collides and that its output is printable ASCII.

As with `Kant.Urania.HashFn`, no finite-width function has the
injectivity field (`no_addressing_is_witness` below is the concrete
instance of that fact for the digest this project ships), so an
`Addressing` is a *hypothesis to be carried*, not a value to be
constructed.  A theorem taking one as an argument reads "if addressing
behaves ideally, then …". -/
structure Addressing where
  /-- The address of a canonical byte string. -/
  cid : Str → Cid
  /-- The idealisation: distinct canonical forms never share an address. -/
  injective : Function.Injective cid
  /-- Addresses are printable, so they survive any text channel. -/
  ascii : ∀ s, IsAscii (cid s)

/-- **Pigeonhole, for fixed-width text digests.**  The `List UInt8`
version is `Kant.Urania.fixedWidth_chars_not_injective`; this is the same
statement with a text domain, which is what an `Addressing` has. -/
theorem fixedWidth_str_not_injective {n : Nat} (f : Str → Str)
    (hlen : ∀ s, (f s).length = n) : ¬ Function.Injective f := by
  intro hinj
  have hinj' : Function.Injective (fun s => (fun i : Fin n => (f s).getD i 'x')) := by
    intro a b hab
    apply hinj
    apply List.ext_getElem (by rw [hlen, hlen])
    intro m h1 h2
    have := congrFun hab ⟨m, by rw [hlen] at h1; exact h1⟩
    simpa [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem, h1, h2] using this
  haveI := Finite.of_injective _ hinj'
  exact not_finite (List Char)

/-- The address the shipped client actually computes: the 64-character
hex witness of the canonical bytes. -/
def shippedCid (s : Str) : Cid := witness (asciiBytes s)

@[simp] theorem shippedCid_length (s : Str) : (shippedCid s).length = 64 :=
  witness_length _

/-- **The address this project computes cannot instantiate the
interface.**  Every identity result below is therefore conditional on an
`Addressing` supplied from outside — in deployment, a real
collision-resistant hash — and none of them is a statement about the
digest in `Kant.Bytes`. -/
theorem no_addressing_is_witness (A : Addressing) : A.cid ≠ shippedCid := by
  intro h
  exact fixedWidth_str_not_injective shippedCid shippedCid_length (h ▸ A.injective)

/-! ## Artifact kinds -/

/-- The kinds of artifact exchanged by the network. -/
inductive Kind where
  /-- A definition the statement of a theorem depends on. -/
  | defn
  /-- A theorem: the formal target. -/
  | thm
  /-- A proof submission against a target. -/
  | submission
  /-- One verifier's result for one submission in one environment. -/
  | verification
  /-- A reduction of a parent theorem to children. -/
  | decomposition
  /-- A curated collection of theorems. -/
  | mission
  /-- A comment. -/
  | comment
  /-- An environment manifest: toolchain, library revisions, limits. -/
  | environment
  /-- A signed name record. -/
  | name
deriving DecidableEq, Repr

/-- The wire code of a kind. -/
def Kind.code : Kind → Nat
  | .defn => 1
  | .thm => 2
  | .submission => 3
  | .verification => 4
  | .decomposition => 5
  | .mission => 6
  | .comment => 7
  | .environment => 8
  | .name => 9

/-- Read a kind back from its wire code. -/
def Kind.ofCode : Nat → Option Kind
  | 1 => some .defn
  | 2 => some .thm
  | 3 => some .submission
  | 4 => some .verification
  | 5 => some .decomposition
  | 6 => some .mission
  | 7 => some .comment
  | 8 => some .environment
  | 9 => some .name
  | _ => none

@[simp] theorem Kind.ofCode_code (k : Kind) : Kind.ofCode k.code = some k := by
  cases k <;> rfl

theorem Kind.code_injective : Function.Injective Kind.code := by
  intro a b h
  have := Kind.ofCode_code a
  rw [h, Kind.ofCode_code b] at this
  exact (Option.some.inj this).symm

/-! ## Lists of strings as one field -/

/-- Tag of a packed list of strings. -/
def tagList : Blob := asciiBytes "p2mlist".toList

/-- Pack a list of strings into a single field. -/
def packList (xs : List Str) : Blob :=
  asciiBytes (Envelope.mk tagList (xs.map asciiBytes)).encode

/-- Read a packed list of strings back. -/
def unpackList (b : Blob) : Option (List Str) :=
  match Envelope.decode (asciiChars b) with
  | none => none
  | some e => if e.tag ≠ tagList then none else some (e.fields.map asciiChars)

theorem map_asciiChars_map_asciiBytes {xs : List Str} (h : ∀ x ∈ xs, IsAscii x) :
    (xs.map asciiBytes).map asciiChars = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
      simp only [List.map_cons, List.map_map, Function.comp_def]
      rw [asciiChars_asciiBytes (h x (by simp))]
      have hxs : (xs.map asciiBytes).map asciiChars = xs :=
        ih (fun y hy => h y (by simp [hy]))
      simp only [List.map_map, Function.comp_def] at hxs
      rw [hxs]

/-- Packing a list of printable strings round-trips. -/
theorem unpackList_packList {xs : List Str} (h : ∀ x ∈ xs, IsAscii x) :
    unpackList (packList xs) = some xs := by
  have henc : IsAscii (Envelope.mk tagList (xs.map asciiBytes)).encode :=
    Envelope.isAscii_encode _
  unfold unpackList packList
  rw [asciiChars_asciiBytes henc, Envelope.decode_encode]
  simp only [ne_eq, not_true_eq_false, if_false]
  rw [map_asciiChars_map_asciiBytes h]

/-- A packed list is printable, so it can be nested inside another
canonical form. -/
theorem isAscii_asciiChars_packList (xs : List Str) :
    IsAscii (asciiChars (packList xs)) := by
  have henc : IsAscii (Envelope.mk tagList (xs.map asciiBytes)).encode :=
    Envelope.isAscii_encode _
  unfold packList
  rw [asciiChars_asciiBytes henc]
  exact henc

/-- The packed form of a printable list of strings, as text. -/
def packText (xs : List Str) : Str := asciiChars (packList xs)

@[simp] theorem isAscii_packText (xs : List Str) : IsAscii (packText xs) :=
  isAscii_asciiChars_packList xs

/-- Read a packed text field back. -/
def unpackText (s : Str) : Option (List Str) := unpackList (asciiBytes s)

theorem bytesAscii_packList (xs : List Str) : BytesAscii (packList xs) := by
  unfold packList
  exact bytesAscii_asciiBytes (Envelope.isAscii_encode _)

theorem unpackText_packText {xs : List Str} (h : ∀ x ∈ xs, IsAscii x) :
    unpackText (packText xs) = some xs := by
  unfold unpackText packText
  rw [asciiBytes_asciiChars (bytesAscii_packList xs)]
  exact unpackList_packList h

/-- Packing is injective on printable lists: two different lists never
pack to the same field. -/
theorem packText_inj {xs ys : List Str} (hx : ∀ x ∈ xs, IsAscii x) (hy : ∀ y ∈ ys, IsAscii y)
    (h : packText xs = packText ys) : xs = ys := by
  have hround := unpackText_packText hx
  rw [h, unpackText_packText hy] at hround
  exact (Option.some.inj hround).symm

/-! ## Content: the immutable object -/

/-- The immutable half of an artifact: what kind of thing it is, and its
fields.  Nothing here names an author, a time, a title or a database
row. -/
structure Content where
  /-- What kind of artifact this is. -/
  kind : Kind
  /-- Its fields, in a kind-specific order. -/
  fields : List Str
deriving DecidableEq, Repr

/-- Content is transmissible when its fields are printable. -/
def Content.Wire (c : Content) : Prop := ∀ f ∈ c.fields, IsAscii f

/-- Tag of an artifact on the wire. -/
def tagArtifact : Blob := asciiBytes "p2mart".toList

/-- **The canonical form of an artifact.**  Kind code first, then every
field length-framed and hex-encoded: exactly one serialisation of a given
record, with no room for key ordering, whitespace or number formatting to
change the bytes. -/
def canon (c : Content) : Str :=
  (Envelope.mk tagArtifact (natToBytesBE c.kind.code :: c.fields.map asciiBytes)).encode

/-- Read a canonical artifact back. -/
def parseCanon (s : Str) : Option Content :=
  match Envelope.decode s with
  | none => none
  | some e =>
      if e.tag ≠ tagArtifact then none
      else match e.fields with
        | [] => none
        | k :: fs =>
            match Kind.ofCode (bytesBEToNat k) with
            | none => none
            | some kd => some ⟨kd, fs.map asciiChars⟩

/-- The canonical form reads back exactly. -/
theorem parseCanon_canon {c : Content} (h : c.Wire) : parseCanon (canon c) = some c := by
  unfold parseCanon canon
  rw [Envelope.decode_encode]
  cases c with
  | mk kd fs =>
      simp only [ne_eq, not_true_eq_false, if_false, bytesBEToNat_natToBytesBE,
        Kind.ofCode_code]
      rw [map_asciiChars_map_asciiBytes h]

/-- **The canonical form determines the artifact.** -/
theorem canon_inj {c c' : Content} (h : c.Wire) (h' : c'.Wire) (heq : canon c = canon c') :
    c = c' := by
  have hround := parseCanon_canon h
  rw [heq, parseCanon_canon h'] at hround
  exact (Option.some.inj hround).symm

/-- Canonical bytes are printable. -/
theorem isAscii_canon (c : Content) : IsAscii (canon c) := Envelope.isAscii_encode _

/-! ## Identity -/

/-- The artifact id: the address of the canonical bytes. -/
def idOf (A : Addressing) (c : Content) : Cid := A.cid (canon c)

/-- **Identity is content.**  Same address, same artifact. -/
theorem idOf_inj (A : Addressing) {c c' : Content} (h : c.Wire) (h' : c'.Wire)
    (heq : idOf A c = idOf A c') : c = c' :=
  canon_inj h h' (A.injective heq)

/-- Addresses are printable. -/
theorem isAscii_idOf (A : Addressing) (c : Content) : IsAscii (idOf A c) := A.ascii _

/-! ## Announcements: the mutable, signed half -/

/-- A **signed announcement**: the claim that a named key published a
particular content address at a particular time, with DAG links for
replication and semantic predecessors for supersession.

None of these fields is part of the artifact's identity, which is why
this is a separate record from `Content`. -/
structure Claim where
  /-- The address of the content being announced. -/
  content : Cid
  /-- Its kind, repeated here so a peer can decide whether to fetch. -/
  kind : Kind
  /-- Who is announcing it. -/
  author : Key
  /-- Advisory wall-clock time.  Never semantic. -/
  timestamp : Nat
  /-- Replication links: other artifacts fetched alongside this one. -/
  parents : List Cid
  /-- Semantic supersession: artifacts this one claims to correct. -/
  predecessors : List Cid
deriving DecidableEq, Repr

/-- An announcement together with the author's signature over it. -/
structure Announcement (Sig : Type) where
  /-- What is being claimed. -/
  claim : Claim
  /-- The author's signature over exactly that claim. -/
  signature : Sig
deriving Repr

/-- Announce a piece of content.  The address is computed from the
content; the author, clock and links are attached around it. -/
def announce (A : Addressing) (c : Content) (author : Key) (timestamp : Nat)
    (parents predecessors : List Cid) : Claim :=
  { content := idOf A c, kind := c.kind, author, timestamp, parents, predecessors }

/-- **Identity does not depend on who published, when, or alongside
what.**  This is the property the source specification's circular
envelope could not have: the same theorem, announced by two people at two
times, is one artifact. -/
theorem announce_content_agnostic (A : Addressing) (c : Content)
    (a₁ a₂ : Key) (t₁ t₂ : Nat) (p₁ p₂ q₁ q₂ : List Cid) :
    (announce A c a₁ t₁ p₁ q₁).content = (announce A c a₂ t₂ p₂ q₂).content := rfl

/-- Conversely, two announcements carrying the same address really are
about the same artifact. -/
theorem announce_content_inj (A : Addressing) {c c' : Content} (h : c.Wire) (h' : c'.Wire)
    {a a' : Key} {t t' : Nat} {p p' q q' : List Cid}
    (heq : (announce A c a t p q).content = (announce A c' a' t' p' q').content) : c = c' :=
  idOf_inj A h h' heq

/-- A peer accepts an announcement only if the signature verifies under
the claimed author's key. -/
def validAnnouncement {Sig : Type} (S : SigScheme Key Claim Sig)
    (a : Announcement Sig) : Bool :=
  S.verify a.claim.author a.claim a.signature

/-- **Authorship, and nothing more.**  A verifying announcement is
attributable to its key.  It says nothing about whether the artifact is
correct, nor whether any verifier has looked at it. -/
theorem announcement_authentic {Sig : Type} {S : SigScheme Key Claim Sig}
    {a : Announcement Sig} (h : validAnnouncement S a = true) :
    S.signedBy a.claim.author a.claim a.signature :=
  S.noForgery _ _ _ h

/-- A peer accepts a fetched body for a claimed address only if it
re-derives the address from the bytes it received. -/
def addressMatches (A : Addressing) (cid : Cid) (c : Content) : Prop := idOf A c = cid

/-- **Bytes are checked, not trusted.**  Whatever a relay hands over, at
most one artifact can pass the address check for a given address. -/
theorem addressMatches_unique (A : Addressing) {cid : Cid} {c c' : Content}
    (h : c.Wire) (h' : c'.Wire)
    (hc : addressMatches A cid c) (hc' : addressMatches A cid c') : c = c' :=
  idOf_inj A h h' (by rw [hc, hc'])

end Kant.Prove2me
