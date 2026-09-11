import RequestProject.Solfunmeme.Codec.Formats

/-!
# §16 Canonical serialization and content identity

The canonical object must have *one* serialization, so that

```text
CanonicalObject → CanonicalSerialize → Hash
```

is a stable content identity.  Two things are needed and both are proved here.

* The serialization must determine the object — otherwise the hash identifies
  nothing.  `canonicalSerialize_inj` is that statement, and it follows from the
  round trip rather than from any property of the hash.
* The identity must not depend on which codec the object arrived in.  Since
  every codec of the registry decodes to the same canonical object
  (`Codec.Formats`), `contentId_of_any_codec` says that a document written as
  IPDL, XML, CSV, YAML or text yields the same content identity.

The field ordering is stable by construction: `encodeTable` writes the fields
of §3 in a fixed order, so nothing here has to sort anything.  Values are
*not* renormalised — §4 requires the original representation to be preserved —
so `"1.0"` and `"1.00"` are different content, deliberately.
-/

namespace Solfunmeme.Codec

/-- The canonical serialization: the tabular projection in the plain-text
codec, one row per field, in the fixed order of §3. -/
def canonicalSerialize (p : ProofObject) : String := text.encode p

/-- Read a canonical serialization back. -/
def canonicalParse (s : String) : Option ProofObject := text.decode s

@[simp] theorem canonicalParse_serialize (p : ProofObject) :
    canonicalParse (canonicalSerialize p) = some p :=
  RowSyntax.decode_encode text_wf p

/-- The serialization determines the object. -/
theorem canonicalSerialize_inj {p q : ProofObject} (h : canonicalSerialize p = canonicalSerialize q) :
    p = q := by
  have hp := canonicalParse_serialize p
  rw [h, canonicalParse_serialize q] at hp
  exact (Option.some.inj hp).symm

theorem canonicalSerialize_eq_iff (p q : ProofObject) :
    canonicalSerialize p = canonicalSerialize q ↔ p = q :=
  ⟨canonicalSerialize_inj, fun h => by rw [h]⟩

/-! ## The hash -/

/-- FNV-1a, 64 bit: a small, deterministic, byte-oriented hash. -/
def fnvOffsetBasis : UInt64 := 14695981039346656037

/-- The FNV-1a multiplier. -/
def fnvPrime : UInt64 := 1099511628211

/-- One byte of FNV-1a. -/
def fnvStep (h : UInt64) (b : UInt8) : UInt64 := (h ^^^ b.toUInt64) * fnvPrime

/-- FNV-1a of a list of bytes. -/
def hashBytes (bs : List UInt8) : UInt64 := bs.foldl fnvStep fnvOffsetBasis

/-- FNV-1a of the UTF-8 bytes of a string. -/
def hashString (s : String) : UInt64 := hashBytes s.toUTF8.toList

/-- The content identity of a canonical object. -/
def contentId (p : ProofObject) : UInt64 := hashString (canonicalSerialize p)

/-- Hashing is a function of the canonical object alone: same object, same
identity, on every system. -/
theorem contentId_congr {p q : ProofObject} (h : p = q) : contentId p = contentId q := by rw [h]

/-- Different identities mean different objects.  (The converse is not claimed:
a 64-bit hash can collide, and the specification does not require otherwise.) -/
theorem ne_of_contentId_ne {p q : ProofObject} (h : contentId p ≠ contentId q) : p ≠ q :=
  fun hpq => h (contentId_congr hpq)

/-- The identity is the identity of the *canonical* object, so it does not
depend on the format the object travelled in. -/
theorem contentId_of_any_codec (r : RowSyntax) (hr : r ∈ codecs) (p : ProofObject) :
    (r.decode (r.encode p)).map contentId = some (contentId p) := by
  rw [codecs_lossless r hr p]
  rfl

/-- Two objects that serialise the same have the same identity — the useful
direction for a receiver that only has bytes. -/
theorem contentId_of_serialize_eq {p q : ProofObject}
    (h : canonicalSerialize p = canonicalSerialize q) : contentId p = contentId q := by
  rw [contentId, contentId, h]

end Solfunmeme.Codec
