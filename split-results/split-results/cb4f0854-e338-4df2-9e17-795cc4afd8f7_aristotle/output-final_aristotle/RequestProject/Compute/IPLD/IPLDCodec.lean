/-
# IPLD Codec Interface — Lean 4 Specification

This module defines the **codec interface** as a formal specification that
any implementation (Lean, Rust, Go, etc.) must satisfy. It provides:

1. **`IPLDNode`** — the IPLD Data Model, a sum type covering all seven
   data model kinds (Null, Bool, Int, Float, String, Bytes, List, Map, Link)

2. **`IPLDCodec`** — a typeclass specifying encode/decode with a **roundtrip law**

3. **`IPLDMulticodec`** — an extension for multi-codec environments (DAG-JSON,
   DAG-CBOR, etc.) with codec-specific laws

4. **Formal laws** stated as propositions — these are the precise contracts
   that a Rust (or any) implementation must uphold

## Architecture

```
                  ┌─────────────────────┐
                  │   Lean (this file)  │
                  │                     │
                  │  IPLDNode (Data Model)
                  │  IPLDCodec (Laws)   │
                  │  Roundtrip proofs   │
                  └────────┬────────────┘
                           │ spec
                           ▼
              ┌────────────────────────────┐
              │  Rust / Go / etc.          │
              │  impl Codec for DagJson    │
              │  impl Codec for DagCbor    │
              │  (tested against the spec) │
              └────────────────────────────┘
```
-/

namespace IPLD

-- ============================================================================
-- § 1  IPLD Data Model
-- ============================================================================

/-- A Content Identifier (CID) — the fundamental addressing primitive of IPLD.
    In a full implementation this would carry the multicodec, multihash, and
    digest; here we model it as an opaque wrapper for specification purposes. -/
structure CID where
  /-- Raw bytes of the CID (includes version, codec, hash prefix + digest). -/
  bytes : ByteArray
  deriving BEq, Inhabited

instance : Repr CID where
  reprPrec c _ := s!"CID({c.bytes.toList})"

/-- The seven IPLD Data Model kinds, plus Null and Link.

    This is the universal representation that all IPLD codecs must be able
    to serialize and deserialize. Every IPLD value, regardless of its schema
    type, must be representable as an `IPLDNode`.

    Reference: <https://ipld.io/docs/data-model/> -/
inductive IPLDNode where
  | null
  | bool   (v : Bool)
  | int    (v : Int)
  | float  (v : Float)
  | string (v : String)
  | bytes  (v : ByteArray)
  | list   (vs : List IPLDNode)
  | map    (kvs : List (String × IPLDNode))
  | link   (cid : CID)
  deriving BEq, Inhabited

-- ============================================================================
-- § 2  Serialized representation
-- ============================================================================

/-- Raw serialized bytes — the output of encoding or input of decoding. -/
abbrev SerializedBytes := ByteArray

/-- A codec identifier — corresponds to the multicodec table.
    Common values: 0x0129 = DAG-JSON, 0x0071 = DAG-CBOR -/
structure CodecId where
  code : UInt64
  deriving BEq, Repr, Inhabited

/-- Well-known codec identifiers. -/
def CodecId.dagJson : CodecId := ⟨0x0129⟩
def CodecId.dagCbor : CodecId := ⟨0x0071⟩
def CodecId.dagPb   : CodecId := ⟨0x0070⟩

-- ============================================================================
-- § 3  IPLDCodec — the core codec typeclass
-- ============================================================================

/-- `IPLDCodec C` specifies that `C` is an IPLD codec capable of encoding
    `IPLDNode` values to bytes and decoding bytes back to `IPLDNode` values.

    **Laws** (formal contracts for any implementation):

    - `roundtrip`: Encoding then decoding yields the original node.
      `∀ node, decode (encode node) = .ok node`

    - `decode_encode`: If decoding succeeds, re-encoding the result yields
      the same bytes. This captures *canonical form* for codecs that have it.
      `∀ bs node, decode bs = .ok node → encode node = bs`

    Not all codecs satisfy `decode_encode` (e.g., non-canonical JSON).
    The `canonical` field indicates whether this law holds.

    **A Rust implementation** would implement `Codec` as a trait:
    ```rust
    trait Codec {
        fn encode(node: &IPLDNode) -> Vec<u8>;
        fn decode(bytes: &[u8]) -> Result<IPLDNode, CodecError>;
    }
    ```
    and the laws become test properties (via proptest/quickcheck) or
    verified via an FFI bridge to this Lean spec. -/
class IPLDCodec (C : Type) where
  /-- The multicodec identifier for this codec. -/
  codecId : CodecId

  /-- Encode an `IPLDNode` to its serialized byte representation. -/
  encode : IPLDNode → SerializedBytes

  /-- Decode serialized bytes back to an `IPLDNode`.
      Returns `Except String IPLDNode` — `Except.error` carries a
      human-readable error message. -/
  decode : SerializedBytes → Except String IPLDNode

  /-- **Roundtrip law**: encoding then decoding is the identity.
      This is the fundamental correctness property. -/
  roundtrip : ∀ (node : IPLDNode), decode (encode node) = .ok node

  /-- Whether this codec has a canonical encoding. -/
  canonical : Bool

  /-- **Canonical form law** (only required when `canonical = true`):
      if decoding succeeds, re-encoding yields the original bytes. -/
  decode_encode : canonical = true →
    ∀ (bs : SerializedBytes) (node : IPLDNode),
      decode bs = .ok node → encode node = bs

-- ============================================================================
-- § 4  Schema-aware codec (typed layer)
-- ============================================================================

/-- `IPLDTypedCodec C T` extends `IPLDCodec C` with schema-aware
    encoding/decoding for a specific Lean type `T`.

    This is the typed layer that sits above the raw Data Model codec:
    ```
      T  ──toNode──▶  IPLDNode  ──encode──▶  bytes
      T  ◀──fromNode── IPLDNode ◀──decode──  bytes
    ```

    **Laws**:
    - `toNode_fromNode`: Converting to a node and back is the identity.
    - `typed_roundtrip`: The full encode/decode roundtrip preserves typed values.

    **In Rust**, this corresponds to `impl Serialize/Deserialize for T`
    with serde, where `toNode` is the Serialize impl and `fromNode` is
    the Deserialize impl.
-/
class IPLDTypedCodec (C : Type) (T : Type) [IPLDCodec C] where
  /-- Convert a typed value to its Data Model representation. -/
  toNode   : T → IPLDNode

  /-- Parse a Data Model node into a typed value.
      Fails if the node doesn't match the expected schema structure. -/
  fromNode : IPLDNode → Except String T

  /-- **Node roundtrip**: `toNode` followed by `fromNode` is the identity. -/
  toNode_fromNode : ∀ (v : T), fromNode (toNode v) = .ok v

  /-- **Full roundtrip**: encoding a typed value and decoding yields the original.
      This follows from `toNode_fromNode` and `IPLDCodec.roundtrip` but is
      stated explicitly as the key property implementors must verify. -/
  typed_roundtrip : ∀ (v : T),
    (IPLDCodec.decode C (IPLDCodec.encode C (toNode v))).bind fromNode = .ok v

-- ============================================================================
-- § 5  Block — the fundamental IPLD storage unit
-- ============================================================================

/-- An IPLD Block is a (CID, data) pair.

    The CID contains the codec identifier and content hash, so given a Block
    you know exactly how to decode it and can verify data integrity.

    Reference: <https://ipld.io/docs/blocks/> -/
structure Block where
  /-- The content identifier — includes codec, hash function, and digest. -/
  cid  : CID
  /-- The raw serialized bytes. -/
  data : SerializedBytes
  deriving BEq, Inhabited

-- ============================================================================
-- § 6  BlockCodec — encoding/decoding at the block level
-- ============================================================================

/-- `BlockCodec C` extends `IPLDCodec C` to operate at the block level,
    bundling CID computation with encoding.

    **Law**: `block_integrity` — decoding a block's data yields the node
    that was encoded to produce it.

    **In Rust**, this is the `Store` or `BlockService` abstraction:
    ```rust
    trait BlockCodec: Codec {
        fn encode_block(node: &IPLDNode) -> Block;
        fn decode_block(block: &Block) -> Result<IPLDNode, CodecError>;
    }
    ```
-/
class BlockCodec (C : Type) extends IPLDCodec C where
  /-- Compute the CID for a given byte payload (uses the codec's hash function). -/
  computeCID : SerializedBytes → CID

  /-- Encode a node into a full block (CID + data). -/
  encodeBlock (node : IPLDNode) : Block :=
    let data := encode node
    { cid := computeCID data, data }

  /-- Decode a block back to a node. -/
  decodeBlock (block : Block) : Except String IPLDNode :=
    decode block.data

  /-- **Block integrity**: decoding a block we just encoded gives back the
      original node. Follows from `roundtrip` but stated for the block API. -/
  block_roundtrip : ∀ (node : IPLDNode),
    decodeBlock (encodeBlock node) = .ok node

-- ============================================================================
-- § 7  Traversal specification
-- ============================================================================

/-- An IPLD path segment — either a string key (for maps) or an integer
    index (for lists). -/
inductive PathSegment where
  | key   : String → PathSegment
  | index : Nat    → PathSegment
  deriving BEq, Repr, Inhabited

/-- An IPLD path — a sequence of segments navigating through nested nodes. -/
abbrev IPLDPath := List PathSegment

/-- Traverse an `IPLDNode` by following a path.
    Returns `none` if any segment doesn't match the node structure. -/
def IPLDNode.getPath : IPLDNode → IPLDPath → Option IPLDNode
  | node, [] => some node
  | .map kvs, (.key k) :: rest =>
    match kvs.find? (·.1 == k) with
    | some (_, v) => v.getPath rest
    | none => none
  | .list vs, (.index i) :: rest =>
    match vs[i]? with
    | some v => v.getPath rest
    | none => none
  | _, _ :: _ => none

/-- **Traversal preservation**: codecs must preserve path-based traversal.
    If you encode a node, decode it, and traverse the result, you get the
    same sub-node as traversing the original.

    This is not a typeclass law but a derived property — stated as a
    theorem template that holds for any lawful codec. -/
theorem traversal_preservation (C : Type) [codec : IPLDCodec C]
    (node : IPLDNode) (path : IPLDPath) :
    (codec.decode (codec.encode node)).map (·.getPath path)
    = .ok (node.getPath path) := by
  simp [Except.map]
  rw [codec.roundtrip]

-- ============================================================================
-- § 8  Map ordering specification
-- ============================================================================

/-- IPLD maps preserve insertion order. This predicate asserts that a codec
    preserves the key ordering of map nodes through a roundtrip.

    DAG-CBOR requires sorted keys (RFC 7049 §3.9); DAG-JSON preserves
    insertion order. The `preservesMapOrder` predicate lets us state
    codec-specific ordering guarantees. -/
def preservesMapOrder (C : Type) [codec : IPLDCodec C] : Prop :=
  ∀ (kvs : List (String × IPLDNode)),
    codec.decode (codec.encode (.map kvs)) = .ok (.map kvs)

/-- A codec that sorts map keys (like DAG-CBOR). -/
def sortsMapKeys (C : Type) [codec : IPLDCodec C]
    (sortFn : List (String × IPLDNode) → List (String × IPLDNode)) : Prop :=
  ∀ (kvs : List (String × IPLDNode)),
    codec.decode (codec.encode (.map kvs)) = .ok (.map (sortFn kvs))

-- ============================================================================
-- § 9  Codec equivalence
-- ============================================================================

/-- Two codecs are **equivalent** if encoding with one and decoding with the
    other always succeeds and yields the original node.

    This is the key property that enables cross-codec interop — e.g.,
    reading a DAG-CBOR block with a DAG-JSON decoder after re-encoding.

    ```
    node ──encode_A──▶ bytes_A ──decode_A──▶ node   (trivially, by roundtrip_A)
    node ──encode_A──▶ bytes_A ──???──▶ ???          (not generally possible)

    but:
    node ──encode_A──▶ bytes_A ──decode_A──▶ node ──encode_B──▶ bytes_B ──decode_B──▶ node
    ```
-/
def codecEquivalent (A B : Type) [ca : IPLDCodec A] [cb : IPLDCodec B] : Prop :=
  ∀ (node : IPLDNode),
    cb.decode (cb.encode node) = ca.decode (ca.encode node)

/-- Codec equivalence is reflexive. -/
theorem codecEquivalent_refl (A : Type) [IPLDCodec A] :
    codecEquivalent A A := by
  intro _; rfl

/-- Codec equivalence is symmetric. -/
theorem codecEquivalent_symm (A B : Type) [IPLDCodec A] [IPLDCodec B]
    (h : codecEquivalent A B) : codecEquivalent B A := by
  intro node; exact (h node).symm

-- ============================================================================
-- § 10  Summary: What a Rust implementation must provide
-- ============================================================================

/-!
## Implementation checklist for Rust

A Rust crate implementing this spec should provide:

### Core traits (§3)
```rust
pub trait Codec {
    const CODEC_ID: u64;

    fn encode(node: &IpldNode) -> Vec<u8>;
    fn decode(bytes: &[u8]) -> Result<IpldNode, CodecError>;
}
```

### Typed layer (§4)
```rust
pub trait TypedCodec<T>: Codec {
    fn to_node(value: &T) -> IpldNode;
    fn from_node(node: &IpldNode) -> Result<T, CodecError>;
}
```
This is typically provided by `serde::Serialize` / `serde::Deserialize` impls,
with `IpldNode` as the intermediate serde data model.

### Block layer (§6)
```rust
pub trait BlockCodec: Codec {
    fn compute_cid(data: &[u8]) -> Cid;

    fn encode_block(node: &IpldNode) -> Block {
        let data = Self::encode(node);
        Block { cid: Self::compute_cid(&data), data }
    }

    fn decode_block(block: &Block) -> Result<IpldNode, CodecError> {
        Self::decode(&block.data)
    }
}
```

### Properties to test (via proptest/quickcheck)
1. **Roundtrip**: `∀ node. decode(encode(node)) == Ok(node)`
2. **Canonical form** (DAG-CBOR): `∀ bs. decode(bs).map(encode) == Some(bs)`
3. **Traversal**: `decode(encode(node)).get_path(p) == node.get_path(p)`
4. **Map ordering**: Codec-specific (DAG-CBOR sorts, DAG-JSON preserves)
5. **Block integrity**: `decode_block(encode_block(node)) == Ok(node)`

### Generated types
Use `IPLD.RustCodeGen.generate` to produce Rust struct/enum definitions
for any IPLD schema, then derive `Serialize`/`Deserialize` for codec support.
-/

end IPLD
