/-
# Urania §3.1 / §4 — the snapshot manifest, and inclusion-checked coverage

A snapshot is a folder anybody can host.  Its `manifest.json` declares
what the snapshot covers; §4 is emphatic that a declaration is not
evidence:

* the manifest has a **canonical serialisation**, so its content address
  is well defined rather than depending on key order or number
  formatting (`canon`, `parseCanon`, `canon_inj`);
* `snapshot_id` **is** that content address — the DNS slug is only a
  mutable pointer to whichever id is live (`snapshotId_of_body`,
  `pointer_is_mutable`);
* coverage is **inclusion-checked**: a verifier demands a `MerklePath`
  for *every* chain entry in the claimed range and checks the referenced
  submission hashes to that leaf.  A manifest that publishes a root over
  a strict subset of its claimed range fails
  (`coverage_no_silent_drop`, `coverage_rejects_omission`);
* Tier-1 coverage is anchored to a **revision cutoff**, so the diff does
  not go noisy with edits made after the snapshot
  (`tier1_diff_ignores_later_revisions`), and any page carrying Tier-1
  content carries its licence attribution — reusing the property
  `Kant.GeoRef` already proves (`tier1_page_has_attribution`).
-/
import Mathlib
import RequestProject.Kant.Text
import RequestProject.Kant.Clipboard
import RequestProject.Kant.GeoRef
import RequestProject.Kant.Urania.Chain
import RequestProject.Kant.Urania.Merkle

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Urania

open Kant Kant.Bytes Kant.Text Kant.Clipboard

/-! ## The manifest -/

/-- Everything a manifest says about a snapshot.  The `snapshot_id` is
deliberately *not* a field: it is the content address of this record
(below), so it cannot disagree with what it names. -/
structure Body where
  /-- When the snapshot was built. -/
  createdAt : Nat
  /-- The operator's pseudonymous key. -/
  operator : Key
  /-- Merkle root over the Tier-1 source references. -/
  tier1Root : List Char
  /-- Merkle root over the Tier-2 generated content. -/
  tier2Root : List Char
  /-- First chain index claimed. -/
  chainFrom : Nat
  /-- Last chain index claimed. -/
  chainTo : Nat
  /-- The snapshot this one replaces, or `[]`. -/
  supersedes : List Char
  /-- The Tier-1 revision cutoff `R`: coverage is over `(article,
  revision ≤ R)`, not over "Wikipedia as it is right now". -/
  revisionCutoff : Nat
deriving DecidableEq, Repr

/-- A manifest is transmissible when its text fields are ASCII. -/
structure Body.Wire (b : Body) : Prop where
  /-- The operator key is ASCII. -/
  operator : IsAscii b.operator
  /-- The Tier-1 root is ASCII (hex, in practice). -/
  tier1Root : IsAscii b.tier1Root
  /-- The Tier-2 root is ASCII. -/
  tier2Root : IsAscii b.tier2Root
  /-- The superseded id is ASCII. -/
  supersedes : IsAscii b.supersedes

/-- Tag of a manifest on the wire. -/
def tagManifest : Blob := asciiBytes "kzmanifest".toList

/-- **The canonical form of a manifest.**  Every field is length-framed
and hex-encoded, so there is exactly one serialisation of a given record:
no key ordering, number formatting or normalisation can change it. -/
def canon (b : Body) : List Char :=
  (Envelope.mk tagManifest
    [natToBytesBE b.createdAt, asciiBytes b.operator, asciiBytes b.tier1Root,
      asciiBytes b.tier2Root, natToBytesBE b.chainFrom, natToBytesBE b.chainTo,
      asciiBytes b.supersedes, natToBytesBE b.revisionCutoff]).encode

/-- Read a canonical manifest back. -/
def parseCanon (s : List Char) : Option Body :=
  match Envelope.decode s with
  | none => none
  | some e =>
      if e.tag ≠ tagManifest then none
      else
        match e.fields with
        | [c, op, r1, r2, cf, ct, sup, rev] =>
            some ⟨bytesBEToNat c, asciiChars op, asciiChars r1, asciiChars r2,
              bytesBEToNat cf, bytesBEToNat ct, asciiChars sup, bytesBEToNat rev⟩
        | _ => none

/-- The canonical form reads back exactly. -/
theorem parseCanon_canon {b : Body} (h : b.Wire) : parseCanon (canon b) = some b := by
  unfold parseCanon canon
  rw [Envelope.decode_encode]
  cases b with
  | mk c op r1 r2 cf ct sup rev =>
    simp only [ne_eq, not_true_eq_false, if_false, bytesBEToNat_natToBytesBE,
      asciiChars_asciiBytes h.operator, asciiChars_asciiBytes h.tier1Root,
      asciiChars_asciiBytes h.tier2Root, asciiChars_asciiBytes h.supersedes]

/-- **The canonical form determines the manifest**: two wire-safe
manifests with the same serialisation are the same manifest. -/
theorem canon_inj {b b' : Body} (h : b.Wire) (h' : b'.Wire) (heq : canon b = canon b') :
    b = b' := by
  have := parseCanon_canon h
  rw [heq, parseCanon_canon h'] at this
  exact (Option.some.inj this).symm

/-! ## Content-addressed identity, mutable slugs -/

/-- The snapshot id: the hash of the canonical manifest.  A `HashFn` is
required, which by `no_hashFn_is_digest` the FNV-1a digest cannot
supply. -/
def snapshotId {Hash : Type} (H : HashFn (List Char) Hash) (b : Body) : Hash :=
  H.hash (canon b)

/-- **Snapshot identity is content, not location.** -/
theorem snapshotId_inj {Hash : Type} (H : HashFn (List Char) Hash) {b b' : Body}
    (h : b.Wire) (h' : b'.Wire) (heq : snapshotId H b = snapshotId H b') : b = b' :=
  canon_inj h h' (H.injective heq)

/-- The hosting layer: a DNS slug points at whichever snapshot is
currently live there.  Slugs are opaque (§3.1) and, unlike ids, mutable. -/
abbrev Pointers (Hash : Type) := List (List Char × Hash)

/-- What a slug currently resolves to. -/
def resolve {Hash : Type} (ps : Pointers Hash) (slug : List Char) : Option Hash :=
  (ps.find? (fun p => p.1 = slug)).map Prod.snd

/-- Repointing a slug. -/
def repoint {Hash : Type} (ps : Pointers Hash) (slug : List Char) (id : Hash) :
    Pointers Hash := (slug, id) :: ps

/-- **A slug is a mutable pointer**: repointing changes where a name
leads… -/
theorem resolve_repoint {Hash : Type} (ps : Pointers Hash) (slug : List Char) (id : Hash) :
    resolve (repoint ps slug id) slug = some id := by
  simp [resolve, repoint, List.find?_cons_of_pos]

/-- …and repointing one slug leaves every other name alone, so the
mutable layer stays confined to the hosting names. -/
theorem resolve_repoint_other {Hash : Type} (ps : Pointers Hash) {slug other : List Char}
    (h : other ≠ slug) (id : Hash) :
    resolve (repoint ps slug id) other = resolve ps other := by
  have hne : ¬ ((slug, id).1 = other) := fun hh => h hh.symm
  rw [resolve, repoint, List.find?_cons_of_neg (by simpa using hne), resolve]

/-! ## Tier-2 coverage, checked by inclusion proof -/

variable {Sig Hash : Type}

/-- The indices a manifest claims to cover. -/
def claimedRange (b : Body) : List Nat :=
  List.range' b.chainFrom (b.chainTo + 1 - b.chainFrom)

theorem mem_claimedRange {b : Body} {i : Nat}
    (h : i ∈ claimedRange b) : b.chainFrom ≤ i ∧ i ≤ b.chainTo := by
  simp only [claimedRange, List.mem_range'_1] at h
  omega

/-- **The coverage check.**  For every index in the claimed range the
archiver must produce the chain entry and a `MerklePath` for its
submission against the published Tier-2 root.  A missing entry, or a
missing proof, fails the check outright. -/
def coverageVerified [DecidableEq Hash] (M : MerkleHash Submission Hash)
    (b : Body) (root : Hash) (chain : Chain Sig)
    (proofs : Nat → Option (MerklePath Hash)) : Bool :=
  (claimedRange b).all (fun i =>
    match getElem? chain i, proofs i with
    | some e, some p => M.verifyInclusion root e.payload p
    | _, _ => false)

/-- **Nothing in the claimed range was silently dropped.**  If the check
passes against the root of a tree, every entry of the range really is a
leaf of that tree. -/
theorem coverage_no_silent_drop [DecidableEq Hash] {M : MerkleHash Submission Hash}
    {b : Body} {t : MerkleTree Submission} {chain : Chain Sig}
    {proofs : Nat → Option (MerklePath Hash)}
    (h : coverageVerified M b (M.root t) chain proofs = true) :
    ∀ i ∈ claimedRange b, ∃ e, getElem? chain i = some e ∧ e.payload ∈ t.leaves := by
  intro i hi
  have hall := List.all_eq_true.mp h i hi
  cases hc : getElem? chain i with
  | none =>
    rw [hc] at hall
    cases hp : proofs i <;> rw [hp] at hall <;> simp at hall
  | some e =>
    cases hp : proofs i with
    | none => rw [hc, hp] at hall; simp at hall
    | some p =>
      rw [hc, hp] at hall
      refine ⟨e, rfl, inclusion_sound M (p := p) ?_⟩
      simpa [MerkleHash.verifyInclusion] using hall

/-- **A manifest cannot cover a range with a root over a subset of it.**
If any entry of the claimed range is missing from the tree, the check
fails — the archiver has no proof to offer. -/
theorem coverage_rejects_omission [DecidableEq Hash] {M : MerkleHash Submission Hash}
    {b : Body} {t : MerkleTree Submission} {chain : Chain Sig}
    {proofs : Nat → Option (MerklePath Hash)} {i : Nat} {e : Entry Sig}
    (hi : i ∈ claimedRange b) (hc : getElem? chain i = some e)
    (hmiss : e.payload ∉ t.leaves) :
    coverageVerified M b (M.root t) chain proofs = false := by
  by_contra hcon
  simp only [Bool.not_eq_false] at hcon
  obtain ⟨e', he', hmem⟩ := coverage_no_silent_drop hcon i hi
  rw [hc] at he'
  exact hmiss (Option.some.inj he' ▸ hmem)

/-- An honest archiver can always pass the check: it has the tree. -/
theorem coverage_complete [DecidableEq Hash] {M : MerkleHash Submission Hash}
    {b : Body} {t : MerkleTree Submission} {chain : Chain Sig}
    (hin : ∀ i ∈ claimedRange b, ∃ e, getElem? chain i = some e ∧ e.payload ∈ t.leaves) :
    ∃ proofs, coverageVerified M b (M.root t) chain proofs = true := by
  classical
  have key : ∀ i, ∃ p : MerklePath Hash, i ∈ claimedRange b →
      ∃ e : Entry Sig, getElem? chain i = some e ∧
        M.applyPath (M.hleaf e.payload) p = M.root t := by
    intro i
    by_cases hi : i ∈ claimedRange b
    · obtain ⟨e, he, hmem⟩ := hin i hi
      obtain ⟨p, hp⟩ := inclusion_complete M hmem
      exact ⟨p, fun _ => ⟨e, he, hp⟩⟩
    · exact ⟨[], fun h => absurd h hi⟩
  choose f hf using key
  refine ⟨fun i => some (f i), List.all_eq_true.mpr ?_⟩
  intro i hi
  obtain ⟨e, he, hp⟩ := hf i hi
  rw [he]
  simpa [MerkleHash.verifyInclusion] using hp

/-! ## Tier-1 coverage, anchored to a revision -/

/-- One external source article, at a revision. -/
structure Tier1Item where
  /-- The article's title (or other stable identifier). -/
  article : List Char
  /-- The revision covered. -/
  revision : Nat
deriving DecidableEq, Repr

/-- The canonical list as of the cutoff: revisions after `R` are simply
not part of what this snapshot claims. -/
def anchored (R : Nat) (items : List Tier1Item) : List Tier1Item :=
  items.filter (fun x => x.revision ≤ R)

/-- What a snapshot covering `covered` is missing, measured against the
canonical list at the cutoff. -/
def tier1Missing (R : Nat) (canonical covered : List Tier1Item) : List Tier1Item :=
  (anchored R canonical).filter (fun x => !(covered.contains x))

/-- **The diff finds exactly what is missing**: nothing uncovered is
hidden, nothing covered is reported. -/
theorem mem_tier1Missing_iff {R : Nat} {canonical covered : List Tier1Item} {x : Tier1Item} :
    x ∈ tier1Missing R canonical covered ↔
      (x ∈ canonical ∧ x.revision ≤ R) ∧ x ∉ covered := by
  simp only [tier1Missing, anchored, List.mem_filter, Bool.not_eq_true',
    List.contains_eq_mem, decide_eq_false_iff_not, decide_eq_true_eq]

/-- **The anchor is what makes the diff quiet.**  Edits made after the
cutoff — new revisions of the same or other articles — do not appear in
the diff, so a snapshot is not reported as incomplete for failing to
contain the future. -/
theorem tier1_diff_ignores_later_revisions {R : Nat} {canonical covered : List Tier1Item}
    {y : Tier1Item} (hy : R < y.revision) :
    tier1Missing R (y :: canonical) covered = tier1Missing R canonical covered := by
  simp [tier1Missing, anchored, Nat.not_le.mpr hy]

/-! ## Attribution of Tier-1 material

Redistributing CC BY-SA text at any scale means every page carrying it
must carry its attribution.  The codebase already proves this of its
citation renderer; a Tier-1 page is that renderer. -/

/-- A rendered Tier-1 citation, exactly as `Kant.GeoRef` renders one. -/
def tier1Citation (r : Kant.GeoRef.Ref) (label : List Char) : List Char :=
  Kant.GeoRef.citation r label

/-- **Every exported page carrying Tier-1-derived content carries its
licence attribution.** -/
theorem tier1_page_has_attribution (r : Kant.GeoRef.Ref) (label : List Char) :
    containsSub (Kant.Erdfa.escape r.attribution) (tier1Citation r label) = true :=
  Kant.GeoRef.citation_has_attribution r label

end Kant.Urania
