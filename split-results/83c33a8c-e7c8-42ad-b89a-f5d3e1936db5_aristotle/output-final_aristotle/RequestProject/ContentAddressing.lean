/-
# ContentAddressing.lean — Identity via Multihash/CID Families

`asciiSum` is just one hash function — a single coordinate projection among many.
The real source of truth is the **family** of content-addressed witnesses:
payload, multihashes, CIDs, and proofs that they all refer to the same object.

## Key Theorem

One hash can *suggest* identity, but only a stable set of
content-addressed witnesses can *establish* it.
-/

import Mathlib

set_option maxHeartbeats 400000

namespace ContentAddressing

/-! ## §1. Hash Functions as Coordinate Projections -/

/-- A hash function is just a map from strings to natural numbers. -/
structure HashFunction where
  name : String
  apply : String → ℕ
  deriving Inhabited

/-- The original asciiSum — one hash among many. -/
def asciiSum : HashFunction where
  name := "asciiSum"
  apply := fun s => (s.toList.map Char.toNat).sum

/-- A simple multiplicative hash (another witness). -/
def multHash : HashFunction where
  name := "multHash"
  apply := fun s => (s.toList.map Char.toNat).foldl (· * 31 + ·) 0

/-- Length-based hash (trivial but illustrative). -/
def lengthHash : HashFunction where
  name := "lengthHash"
  apply := fun s => s.length

/-! ## §2. Multihash — Self-Describing Hash -/

/-- Multihash codec identifiers (simplified). -/
inductive MultihashCodec where
  | identity
  | sha2_256
  | sha3_256
  | blake2b_256
  | asciiSum
  deriving DecidableEq, Repr

/-- A multihash bundles a codec identifier with a digest. -/
structure Multihash where
  codec : MultihashCodec
  digestSize : ℕ
  digest : ℕ
  deriving DecidableEq, Repr

/-- Compute a multihash from a hash function and payload. -/
def mkMultihash (codec : MultihashCodec) (h : HashFunction) (payload : String) : Multihash where
  codec := codec
  digestSize := 8
  digest := h.apply payload

/-! ## §3. CID — Content Identifier -/

inductive CIDVersion where | v0 | v1
  deriving DecidableEq, Repr

inductive Multicodec where | raw | dagPB | dagCBOR | leanTerm
  deriving DecidableEq, Repr

/-- A Content Identifier (CID) bundles version, codec, and multihash. -/
structure CID where
  version : CIDVersion
  contentCodec : Multicodec
  hash : Multihash
  deriving DecidableEq, Repr

def mkCID (ver : CIDVersion) (cc : Multicodec) (hc : MultihashCodec)
    (h : HashFunction) (payload : String) : CID where
  version := ver
  contentCodec := cc
  hash := mkMultihash hc h payload

/-! ## §4. Content-Addressed Record -/

structure ContentRecord where
  payload : String
  hashes : List Multihash
  cids : List CID
  deriving Repr

def ContentRecord.hashesConsistent (r : ContentRecord)
    (hashFns : List (MultihashCodec × HashFunction)) : Prop :=
  ∀ i : Fin r.hashes.length,
    ∃ j : Fin hashFns.length,
      let (codec, h) := hashFns[j]
      r.hashes[i] = mkMultihash codec h r.payload

def mkContentRecord (payload : String)
    (hashFns : List (MultihashCodec × HashFunction))
    (ver : CIDVersion := .v1) (cc : Multicodec := .raw) : ContentRecord where
  payload := payload
  hashes := hashFns.map fun (codec, h) => mkMultihash codec h payload
  cids := hashFns.map fun (codec, h) => mkCID ver cc codec h payload

/-! ## §5. Identity -/

/-- Two payloads are identified by a hash family if all hashes agree. -/
def identifiedByFamily (hashFns : List HashFunction) (s t : String) : Prop :=
  ∀ h ∈ hashFns, h.apply s = h.apply t

/-- A single hash can only suggest identity. -/
def suggestedIdentity (h : HashFunction) (s t : String) : Prop :=
  h.apply s = h.apply t

/-- Family identification implies each individual hash agrees. -/
theorem family_implies_individual (hashFns : List HashFunction)
    (h : HashFunction) (hm : h ∈ hashFns) (s t : String)
    (hfam : identifiedByFamily hashFns s t) :
    suggestedIdentity h s t :=
  hfam h hm

/-- The converse is NOT true: one hash agreeing does not imply the family agrees. -/
theorem single_hash_insufficient :
    ∃ (hashFns : List HashFunction) (h : HashFunction) (s t : String),
      h ∈ hashFns ∧ suggestedIdentity h s t ∧
      ¬ identifiedByFamily hashFns s t := by
  refine ⟨[⟨"len", String.length⟩,
           ⟨"sum", fun s => (s.toList.map Char.toNat).sum⟩],
          ⟨"len", String.length⟩, "ab", "cd",
          .head _, ?_, ?_⟩
  · -- "ab" and "cd" both have length 2
    rfl
  · -- But their ascii sums differ (97+98=195 vs 99+100=199)
    intro hfam
    have := hfam ⟨"sum", fun s => (s.toList.map Char.toNat).sum⟩ (.tail _ (.head _))
    exact absurd this (by decide)

/-! ## §6. Acceptance Rule -/

def acceptRecord (r : ContentRecord) : Bool :=
  r.hashes.all (fun mh => mh.digest > 0) &&
  decide (r.hashes.length ≥ 2)

structure VerifiedRecord where
  record : ContentRecord
  hashFns : List (MultihashCodec × HashFunction)
  consistent : record.hashesConsistent hashFns
  accepted : acceptRecord record = true

/-! ## §7. Moonshine Connection -/

def residueHash (p : ℕ) : HashFunction where
  name := s!"mod_{p}"
  apply := fun s => (s.toList.map Char.toNat).sum % p

def moonshineFamily : List HashFunction :=
  [residueHash 71, residueHash 59, residueHash 47]

theorem asciiSum_recoverable (s : String)
    (hlt : asciiSum.apply s < 71 * 59 * 47) :
    asciiSum.apply s % (71 * 59 * 47) = asciiSum.apply s := by omega

/-! ## §8. Summary -/

theorem content_addressing_principle :
    (∀ h : HashFunction, ∀ s t : String,
      suggestedIdentity h s t → h.apply s = h.apply t) ∧
    (∃ (hashFns : List HashFunction) (h : HashFunction) (s t : String),
      h ∈ hashFns ∧ suggestedIdentity h s t ∧
      ¬ identifiedByFamily hashFns s t) :=
  ⟨fun _ _ _ hst => hst, single_hash_insufficient⟩

end ContentAddressing
