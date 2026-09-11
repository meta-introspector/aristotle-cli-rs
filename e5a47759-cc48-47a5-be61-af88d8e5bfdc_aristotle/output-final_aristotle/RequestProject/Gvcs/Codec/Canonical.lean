import RequestProject.Gvcs.Codec.Encode

/-!
# Canonical serialization, hashing, envelopes and the transformation ledger

This module supplies the parts of the specification that make an exchange auditable
(§16, §19, §21):

* `canonicalText` — the deterministic serialization of a canonical object.  Field
  ordering is fixed by the encoding, identifiers and numerals are normalized by the atom
  layer, and every character survives escaping, so the serialization is suitable for
  hashing.  `canonicalText_inj` proves that it is injective: equal serializations mean
  equal objects, which is exactly what a content identity has to guarantee.
* `canonicalHash` — a content hash of that serialization (FNV-1a, rendered in hex).
  Hashing cannot be injective, so the theorem available is the sound direction:
  different hashes imply different objects (`ne_of_hash_ne`).
* `Envelope` sealing and opening, with `open_seal` recovering the payload and
  `seal_integrity` recording the payload hash.
* Transformation ledger entries, and `chain` — the property that a ledger's entries
  hand the same hash from one step to the next.
-/

namespace LifeTrac.Codec

/-! ## Deterministic serialization -/

/-- The canonical serialization of a proof object (§16). -/
def canonicalText (p : ProofObject) : String := Ipdl.encode p.toDoc

/-- Reading a canonical serialization back. -/
def ofCanonicalText (s : String) : Option ProofObject :=
  (Ipdl.decode s).bind ProofObject.ofDoc

@[simp] theorem ofCanonicalText_canonicalText (p : ProofObject) :
    ofCanonicalText (canonicalText p) = some p := by
  simp [ofCanonicalText, canonicalText, Ipdl.decode_encode, ProofObject.ofDoc_toDoc]

/-- **Canonical serialization is injective**, so it can carry content identity. -/
theorem canonicalText_inj {p q : ProofObject} (h : canonicalText p = canonicalText q) :
    p = q := by
  have hp := ofCanonicalText_canonicalText p
  rw [h, ofCanonicalText_canonicalText q] at hp
  exact (Option.some_inj.mp hp).symm

theorem canonicalText_eq_iff {p q : ProofObject} : canonicalText p = canonicalText q ↔ p = q :=
  ⟨canonicalText_inj, fun h => by rw [h]⟩

/-! ## Hashing -/

/-- FNV-1a offset basis. -/
def fnvOffset : Nat := 14695981039346656037

/-- FNV-1a prime. -/
def fnvPrime : Nat := 1099511628211

/-- FNV-1a over the code points of a character list, modulo `2 ^ 64`. -/
def hashChars (l : List Char) : Nat :=
  l.foldl (fun h c => ((h ^^^ c.toNat) * fnvPrime) % 18446744073709551616) fnvOffset

/-- Sixteen hex digits of a natural number, most significant first. -/
def hex16 (n : Nat) : List Char :=
  (List.range 16).map (fun i => hexDigit (n / 16 ^ (15 - i) % 16))

/-- Hash of a string, rendered as sixteen hex digits. -/
def hashText (s : String) : String := String.ofList (hex16 (hashChars s.toList))

/-- The content hash of a canonical object (§16). -/
def canonicalHash (p : ProofObject) : String := hashText (canonicalText p)

theorem hash_congr {p q : ProofObject} (h : p = q) : canonicalHash p = canonicalHash q := by
  rw [h]

/-- The sound direction of hashing: different hashes mean different objects. -/
theorem ne_of_hash_ne {p q : ProofObject} (h : canonicalHash p ≠ canonicalHash q) : p ≠ q :=
  fun he => h (hash_congr he)

/-! ## Envelopes -/

/-- Seal a canonical object into an exchange envelope (§19). -/
def sealEnvelope (source destination timestamp : String) (p : ProofObject)
    (diagnostics : List Diagnostic := []) (transformations : List Transformation := []) :
    Envelope :=
  { source := source, destination := destination, timestamp := timestamp,
    objectId := p.id, payload := p, diagnostics := diagnostics,
    transformations := transformations, integrity := canonicalHash p }

/-- Open an envelope, checking its integrity token. -/
def openEnvelope (e : Envelope) : Option ProofObject :=
  if e.integrity = canonicalHash e.payload then some e.payload else none

@[simp] theorem open_sealEnvelope (source destination timestamp : String) (p : ProofObject)
    (ds : List Diagnostic) (ts : List Transformation) :
    openEnvelope (sealEnvelope source destination timestamp p ds ts) = some p := by
  simp [openEnvelope, sealEnvelope]

theorem seal_integrity (source destination timestamp : String) (p : ProofObject) :
    (sealEnvelope source destination timestamp p).integrity = canonicalHash p := rfl

/-- An envelope whose integrity token does not match its payload is rejected rather
than being accepted with a repaired token. -/
theorem open_tampered (e : Envelope) (h : e.integrity ≠ canonicalHash e.payload) :
    openEnvelope e = none := by
  simp [openEnvelope, h]

/-! ## Transformation ledger -/

/-- A ledger entry for one conversion (§21). -/
def transformation (id operation codec source destination : String) (lossiness : Lossiness)
    (inputHash outputHash : String) : Transformation :=
  { id := id, operation := operation, source := source, destination := destination,
    inputHash := inputHash, outputHash := outputHash, codec := codec,
    codecVersion := "proof-codec/1.0", lossiness := lossiness }

/-- A ledger is chained when each entry starts from the hash the previous one produced. -/
def chained : List Transformation → Prop
  | [] => True
  | [_] => True
  | a :: b :: t => a.outputHash = b.inputHash ∧ chained (b :: t)

theorem chained_singleton (t : Transformation) : chained [t] := trivial

theorem chained_cons {a b : Transformation} {t : List Transformation}
    (h : a.outputHash = b.inputHash) (ht : chained (b :: t)) : chained (a :: b :: t) :=
  ⟨h, ht⟩

/-- A conversion that does not change the canonical object is recorded as lossless with
equal input and output hashes. -/
theorem identity_transformation_chained (p : ProofObject) :
    chained [transformation "t1" "decode" "IPDL" "file" "canonical" .lossless
        (canonicalHash p) (canonicalHash p),
      transformation "t2" "encode" "YAML" "canonical" "file" .lossless
        (canonicalHash p) (canonicalHash p)] :=
  chained_cons rfl (chained_singleton _)

end LifeTrac.Codec
