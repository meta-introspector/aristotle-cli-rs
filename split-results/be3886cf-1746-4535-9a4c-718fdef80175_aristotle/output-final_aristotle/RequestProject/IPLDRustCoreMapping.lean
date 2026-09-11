/-
# IPLD Rust `ipld-core` Crate ↔ Lean Formalization Mapping

This module establishes the formal correspondence between the Rust
[`ipld-core`](https://crates.io/crates/ipld-core) crate (v0.4.x) and
the Lean formalization in this project.

## Crate overview

`ipld-core` is the canonical Rust implementation of IPLD core types.
It provides:
- `Ipld` — the IPLD Data Model enum (src/ipld.rs)
- `IpldKind` — type-tag enum without values (src/ipld.rs)
- `Codec` / `Links` traits — codec interface (src/codec.rs)
- Serde serialization/deserialization (src/serde/)
- Type conversions `From`/`TryFrom` (src/convert.rs)
- Property-based testing support (src/arb.rs)
- `ipld!` macro for literal construction (src/macros.rs)

## Structural correspondence

```
┌──────────────────────────────┬──────────────────────────────────────┐
│  Rust (`ipld-core`)          │  Lean (this project)                 │
├──────────────────────────────┼──────────────────────────────────────┤
│  Ipld (enum, 9 variants)    │  IPLDNode (inductive, 9 constructors)│
│  IpldKind (enum, 9 variants)│  IpldKind (inductive, 9 constructors)│
│  Cid (from `cid` crate)     │  CID (structure, in IPLDCodec.lean)  │
│  Codec<T> (trait)            │  IPLDCodec (typeclass)               │
│  Links (trait)               │  IPLDNode.references (function)      │
│  IpldIndex (enum)            │  PathSegment (inductive)             │
│  IpldIter (struct)           │  IPLDNode.iter (via List recursion)  │
│  Block                       │  Block (structure)                   │
│  Serialize/Deserialize       │  IPLDTypedCodec (typeclass)          │
│  ConversionError             │  (modeled as Except String)          │
│  SerdeError                  │  (modeled as Except String)          │
│  from_ipld / to_ipld         │  IPLDTypedCodec.fromNode / toNode   │
└──────────────────────────────┴──────────────────────────────────────┘
```
-/

import RequestProject.IPLDCodec
import RequestProject.IPLD

namespace IPLD

-- ============================================================================
-- § 1  Ipld ↔ IPLDNode — the Data Model correspondence
-- ============================================================================

/-!
### Rust `Ipld` enum (src/ipld.rs)

```rust
pub enum Ipld {
    Null,              // ↔ IPLDNode.null
    Bool(bool),        // ↔ IPLDNode.bool
    Integer(i128),     // ↔ IPLDNode.int     (Int subsumes i128)
    Float(f64),        // ↔ IPLDNode.float
    String(String),    // ↔ IPLDNode.string
    Bytes(Vec<u8>),    // ↔ IPLDNode.bytes   (ByteArray ≃ Vec<u8>)
    List(Vec<Ipld>),   // ↔ IPLDNode.list
    Map(BTreeMap<String, Ipld>), // ↔ IPLDNode.map (List (String × IPLDNode))
    Link(Cid),         // ↔ IPLDNode.link
}
```

**Key differences:**
- Rust uses `i128` for integers; Lean uses `Int` (arbitrary precision).
  `Int` is strictly more general — every `i128` value embeds into `Int`.
- Rust uses `BTreeMap<String, Ipld>` for maps (sorted by key);
  Lean uses `List (String × IPLDNode)` (insertion order preserved).
  IPLD maps preserve insertion order, so the Lean model is more faithful.
  In practice, DAG-CBOR sorts keys, so `BTreeMap` works there.
- Rust `Vec<u8>` ≃ Lean `ByteArray` (both are byte sequences).
- Rust `Cid` is from the `cid` crate; Lean `CID` wraps `ByteArray`.

**NaN equality:** The Rust `Ipld` has a custom `PartialEq` that treats
NaN floats as equal (even though NaN ≠ NaN in IEEE 754). The Lean `IPLDNode`
derives `BEq` which also uses `Float.beq`, giving the same behavior.
-/

-- ============================================================================
-- § 2  IpldKind — type tag without values
-- ============================================================================

/-!
### Rust `IpldKind` (src/ipld.rs)

```rust
pub enum IpldKind {
    Null, Bool, Integer, Float, String, Bytes, List, Map, Link,
}
```

This is the "kind" of an `Ipld` value — the variant tag without payload.
-/

/-- The kind (variant tag) of an IPLD node, without payload.
    Corresponds to Rust's `IpldKind`. -/
inductive IpldKind where
  | null | bool | integer | float | string | bytes | list | map | link
  deriving Repr, BEq, Inhabited, DecidableEq

/-- Extract the kind from an `IPLDNode`.
    Corresponds to Rust's `Ipld::kind(&self) -> IpldKind`. -/
def ipldNodeKind : IPLDNode → IpldKind
  | .null     => .null
  | .bool _   => .bool
  | .int _    => .integer
  | .float _  => .float
  | .string _ => .string
  | .bytes _  => .bytes
  | .list _   => .list
  | .map _    => .map
  | .link _   => .link

-- ============================================================================
-- § 3  IpldIndex ↔ PathSegment — indexing into IPLD values
-- ============================================================================

/-!
### Rust `IpldIndex` (src/ipld.rs)

```rust
pub enum IpldIndex<'a> {
    List(usize),
    Map(String),
    MapRef(&'a str),
}
```

This maps to `PathSegment` in the Lean formalization. The Rust version
distinguishes owned vs borrowed string keys; in Lean there's no such
distinction.

| Rust                    | Lean                      |
|-------------------------|---------------------------|
| `IpldIndex::List(i)`   | `PathSegment.index i`     |
| `IpldIndex::Map(k)`    | `PathSegment.key k`       |
| `IpldIndex::MapRef(k)` | `PathSegment.key k`       |
-/

-- ============================================================================
-- § 4  Ipld::get / Ipld::take ↔ IPLDNode.getPath
-- ============================================================================

/-!
### Rust indexing methods

```rust
impl Ipld {
    pub fn get<'a, T: Into<IpldIndex<'a>>>(&self, index: T)
        -> Result<Option<&Self>, IndexError>;
    pub fn take<'a, T: Into<IpldIndex<'a>>>(mut self, index: T)
        -> Result<Option<Self>, IndexError>;
}
```

These perform single-step indexing into lists and maps.
The Lean equivalent `IPLDNode.getPath` generalizes to multi-step paths.
Single-step indexing is `getPath` with a one-element path.
-/

/-- Single-step indexing into an `IPLDNode`.
    Corresponds to Rust's `Ipld::get`. -/
def ipldGet (node : IPLDNode) (seg : PathSegment) : Option IPLDNode :=
  node.getPath [seg]

-- ============================================================================
-- § 5  Ipld::iter / Ipld::references ↔ node traversal
-- ============================================================================

/-!
### Rust `IpldIter` and `references`

```rust
impl Ipld {
    pub fn iter(&self) -> IpldIter<'_>;
    pub fn references<E: Extend<Cid>>(&self, set: &mut E);
}
```

`iter` performs a depth-first traversal of the IPLD DAG.
`references` collects all `Link` CIDs reachable from a node.

In Lean, we model these as pure recursive functions.
-/

/-- Collect all nodes in a depth-first traversal.
    Corresponds to Rust's `Ipld::iter()`. -/
partial def ipldFlatten : IPLDNode → List IPLDNode
  | node@(.list vs) => node :: (vs.flatMap ipldFlatten)
  | node@(.map kvs) => node :: ((kvs.map (·.2)).flatMap ipldFlatten)
  | node => [node]

/-- Collect all CID links reachable from a node.
    Corresponds to Rust's `Ipld::references`. -/
partial def ipldReferences : IPLDNode → List CID
  | .link cid  => [cid]
  | .list vs   => vs.flatMap ipldReferences
  | .map kvs   => (kvs.map (·.2)).flatMap ipldReferences
  | _          => []

-- ============================================================================
-- § 6  Codec trait ↔ IPLDCodec typeclass
-- ============================================================================

/-!
### Rust `Codec<T>` trait (src/codec.rs)

```rust
pub trait Codec<T>: Links {
    const CODE: u64;
    type Error;
    fn decode<R: BufRead>(reader: R) -> Result<T, Self::Error>;
    fn encode<W: Write>(writer: W, data: &T) -> Result<(), Self::Error>;
    fn decode_from_slice(bytes: &[u8]) -> Result<T, Self::Error>;
    fn encode_to_vec(data: &T) -> Result<Vec<u8>, Self::Error>;
}
```

**Mapping to Lean `IPLDCodec`:**

| Rust `Codec<T>`         | Lean `IPLDCodec C`                    |
|--------------------------|---------------------------------------|
| `const CODE: u64`        | `codecId : CodecId`                   |
| `fn encode`              | `encode : IPLDNode → SerializedBytes` |
| `fn decode`              | `decode : SerializedBytes → Except …` |
| (implicit, via testing)  | `roundtrip` law (formal proof)        |
| (implicit, via testing)  | `decode_encode` law (canonical form)  |

**Key difference:** The Rust `Codec<T>` is generic over `T` (any serializable
type), while Lean `IPLDCodec` operates on `IPLDNode` directly. The typed
layer is handled by `IPLDTypedCodec C T`, which corresponds to the Rust
pattern of `Codec<T>` where `T: Serialize + Deserialize`.

**Error handling:** Rust uses `Result<T, Self::Error>` with codec-specific
error types. Lean uses `Except String` for simplicity — the string carries
the error message.
-/

-- ============================================================================
-- § 7  Links trait ↔ references extraction
-- ============================================================================

/-!
### Rust `Links` trait (src/codec.rs)

```rust
pub trait Links {
    type LinksError;
    fn links(bytes: &[u8]) -> Result<impl Iterator<Item = Cid>, Self::LinksError>;
}
```

This extracts CID links from serialized bytes *without* full deserialization.
In the Lean formalization, this corresponds to decoding then collecting links.

### Rust `ExtractLinks` (src/serde/extract_links.rs)

The `ExtractLinks<S>` visitor is a serde `Deserialize` implementation that
extracts `CidGeneric<S>` links during deserialization without constructing
the full `Ipld` tree. This is an optimization — the formal spec only
requires that the result matches `references` on the decoded node.
-/

/-- Extract links from serialized bytes via decode + references.
    Corresponds to Rust's `Links::links` / `ExtractLinks`. -/
def extractLinks (C : Type) [codec : IPLDCodec C]
    (bs : SerializedBytes) : Except String (List CID) :=
  (codec.decode bs).map ipldReferences

-- ============================================================================
-- § 8  Serde layer ↔ IPLDTypedCodec
-- ============================================================================

/-!
### Rust Serde integration (src/serde/)

The `serde` feature of `ipld-core` provides:

```rust
// src/serde/ser.rs
pub fn to_ipld<T: Serialize>(value: T) -> Result<Ipld, SerdeError>;

// src/serde/de.rs
pub fn from_ipld<T: DeserializeOwned>(value: Ipld) -> Result<T, SerdeError>;
```

**Mapping to `IPLDTypedCodec`:**

| Rust                        | Lean                                |
|-----------------------------|-------------------------------------|
| `to_ipld::<T>(v)`          | `IPLDTypedCodec.toNode v`           |
| `from_ipld::<T>(ipld)`     | `IPLDTypedCodec.fromNode node`      |
| `T: Serialize`             | (part of `IPLDTypedCodec` instance) |
| `T: DeserializeOwned`      | (part of `IPLDTypedCodec` instance) |
| `SerdeError`               | `Except String` error channel       |
| roundtrip property (tested) | `toNode_fromNode` law (proven)      |

### Serializer behavior (src/serde/ser.rs)

The `Serializer` maps Rust types to `Ipld` variants:

| Rust type              | `Ipld` variant    | `IPLDNode` constructor |
|------------------------|-------------------|------------------------|
| `bool`                 | `Ipld::Bool`      | `IPLDNode.bool`        |
| `i8..i128, isize`      | `Ipld::Integer`   | `IPLDNode.int`         |
| `u8..u64, usize`       | `Ipld::Integer`   | `IPLDNode.int`         |
| `f32, f64`             | `Ipld::Float`     | `IPLDNode.float`       |
| `char, String, &str`   | `Ipld::String`    | `IPLDNode.string`      |
| `[u8]` (serde_bytes)   | `Ipld::Bytes`     | `IPLDNode.bytes`       |
| `Vec<T>`, sequences    | `Ipld::List`      | `IPLDNode.list`        |
| `BTreeMap<String, T>`  | `Ipld::Map`       | `IPLDNode.map`         |
| `Cid`                  | `Ipld::Link`      | `IPLDNode.link`        |
| `Option<T>` (None)     | `Ipld::Null`      | `IPLDNode.null`        |
| `Option<T>` (Some)     | inner value       | inner node             |
| unit `()`              | **error**         | —                      |
| unit struct            | **error**         | —                      |
| newtype struct         | inner value       | inner node             |
| enum unit variant      | `Ipld::String`    | `IPLDNode.string`      |
| enum newtype variant   | single-entry Map  | `IPLDNode.map`         |
| enum tuple variant     | Map → List        | `IPLDNode.map`         |
| enum struct variant    | Map → Map         | `IPLDNode.map`         |

### Deserializer behavior (src/serde/de.rs)

The `Deserializer` enforces strict type checking:
- `Ipld::Integer` → integers: range-checked, errors if value too large
- `Ipld::Float` → `f32`: errors if precision would be lost
- `Ipld::Float` → `f64`: errors if NaN or Infinity
- `Ipld::Link` → `Cid`: only through the CID serde identifier
- `Ipld::Bytes` → `Cid`: **rejected** (prevents accidental CID creation)
- Duplicate map keys: **rejected** during deserialization
-/

-- ============================================================================
-- § 9  From/TryFrom conversions ↔ IPLDNode coercions
-- ============================================================================

/-!
### Rust conversions (src/convert.rs)

The `convert` module provides `From<T> for Ipld` and `TryFrom<Ipld> for T`
implementations for all primitive types.

In Lean, these correspond to coercion functions:
-/

namespace RustCoreMapping

/-- Convert a Lean `Bool` to `IPLDNode`. Corresponds to `From<bool> for Ipld`. -/
def ofBool (b : Bool) : IPLDNode := .bool b

/-- Convert a Lean `Int` to `IPLDNode`. Corresponds to `From<i128> for Ipld`. -/
def ofInt (n : Int) : IPLDNode := .int n

/-- Convert a Lean `Float` to `IPLDNode`. Corresponds to `From<f64> for Ipld`. -/
def ofFloat (f : Float) : IPLDNode := .float f

/-- Convert a Lean `String` to `IPLDNode`. Corresponds to `From<String> for Ipld`. -/
def ofString (s : String) : IPLDNode := .string s

/-- Convert a `ByteArray` to `IPLDNode`. Corresponds to `From<Vec<u8>> for Ipld`. -/
def ofBytes (bs : ByteArray) : IPLDNode := .bytes bs

/-- Convert a list of nodes to `IPLDNode`. Corresponds to `From<Vec<Ipld>> for Ipld`. -/
def ofList (vs : List IPLDNode) : IPLDNode := .list vs

/-- Convert an assoc list to `IPLDNode`.
    Corresponds to `From<BTreeMap<String,Ipld>> for Ipld`. -/
def ofMap (kvs : List (String × IPLDNode)) : IPLDNode := .map kvs

/-- Try to extract a `Bool` from an `IPLDNode`.
    Corresponds to `TryFrom<Ipld> for bool`. -/
def toBool : IPLDNode → Except String Bool
  | .bool b => .ok b
  | other   => .error s!"expected Bool, got {repr (ipldNodeKind other)}"

/-- Try to extract an `Int` from an `IPLDNode`.
    Corresponds to `TryFrom<Ipld> for i128`. -/
def toInt : IPLDNode → Except String Int
  | .int n => .ok n
  | other  => .error s!"expected Integer, got {repr (ipldNodeKind other)}"

/-- Try to extract a `Float` from an `IPLDNode`.
    Corresponds to `TryFrom<Ipld> for f64`. -/
def toFloat : IPLDNode → Except String Float
  | .float f => .ok f
  | other    => .error s!"expected Float, got {repr (ipldNodeKind other)}"

/-- Try to extract a `String` from an `IPLDNode`.
    Corresponds to `TryFrom<Ipld> for String`. -/
def toStr : IPLDNode → Except String String
  | .string s => .ok s
  | other     => .error s!"expected String, got {repr (ipldNodeKind other)}"

/-- Try to extract `ByteArray` from an `IPLDNode`.
    Corresponds to `TryFrom<Ipld> for Vec<u8>`. -/
def toBytes : IPLDNode → Except String ByteArray
  | .bytes bs => .ok bs
  | other     => .error s!"expected Bytes, got {repr (ipldNodeKind other)}"

/-- Try to extract a list from an `IPLDNode`.
    Corresponds to `TryFrom<Ipld> for Vec<Ipld>`. -/
def toListVal : IPLDNode → Except String (List IPLDNode)
  | .list vs => .ok vs
  | other    => .error s!"expected List, got {repr (ipldNodeKind other)}"

/-- Try to extract a map from an `IPLDNode`.
    Corresponds to `TryFrom<Ipld> for BTreeMap<String, Ipld>`. -/
def toMap : IPLDNode → Except String (List (String × IPLDNode))
  | .map kvs => .ok kvs
  | other    => .error s!"expected Map, got {repr (ipldNodeKind other)}"

/-- Try to extract a CID from an `IPLDNode`.
    Corresponds to `TryFrom<Ipld> for Cid`. -/
def toCID : IPLDNode → Except String CID
  | .link cid => .ok cid
  | other     => .error s!"expected Link, got {repr (ipldNodeKind other)}"

end RustCoreMapping

-- ============================================================================
-- § 10  ConversionError ↔ error model
-- ============================================================================

/-!
### Rust `ConversionError` (src/convert.rs)

```rust
pub enum ConversionError {
    WrongIpldKind { expected: IpldKind, found: IpldKind },
    FromIpld { from: IpldKind, into: TypeId },
}
```

In the Lean model, we capture the same information in our `Except String`
error messages. The `WrongIpldKind` case corresponds to our "expected X,
got Y" messages in the `toXxx` functions above.

The `FromIpld` case (range errors, e.g., `i128` value too large for `u8`)
would require bounded integer types in Lean. Since Lean's `Int` is arbitrary
precision, this case doesn't arise for the core model — it's a concern
only when projecting to fixed-width types.
-/

/-- Model of Rust's `ConversionError::WrongIpldKind`. -/
structure WrongIpldKind where
  expected : IpldKind
  found    : IpldKind
  deriving Repr, BEq

-- ============================================================================
-- § 11  ipld! macro ↔ Lean DSL
-- ============================================================================

/-!
### Rust `ipld!` macro (src/macros.rs)

The `ipld!` macro provides JSON-like literal syntax for constructing `Ipld`
values in Rust:

```rust
let value = ipld!({
    "code": 200,
    "success": true,
    "payload": {
        "features": ["serde", "json"]
    }
});
```

In Lean, we can construct `IPLDNode` values directly:

```lean
def value : IPLDNode := .map [
  ("code", .int 200),
  ("success", .bool true),
  ("payload", .map [
    ("features", .list [.string "serde", .string "json"])
  ])
]
```

A Lean macro providing similar syntactic sugar could be added, but the
direct constructor syntax is already quite readable.
-/

-- Example matching the Rust ipld! macro usage
private def exampleNode : IPLDNode := .map [
  ("code", .int 200),
  ("success", .bool true),
  ("payload", .map [
    ("features", .list [.string "serde", .string "json"])
  ])
]

-- ============================================================================
-- § 12  Property-based testing (src/arb.rs) ↔ formal properties
-- ============================================================================

/-!
### Rust `quickcheck::Arbitrary` for `Ipld` (src/arb.rs)

The `arb` module provides random generation of `Ipld` values for
property-based testing. The generator:

1. Uses a size budget to prevent infinite recursion
2. Generates all 9 variants with equal probability
3. Recursively generates list/map elements with decreasing budget

In the Lean formalization, we don't need random testing — instead we
state properties as theorems and prove them. The key properties that
the Rust crate tests via quickcheck are formalized as:

| Rust quickcheck property          | Lean theorem / law                  |
|-----------------------------------|-------------------------------------|
| `decode(encode(x)) == Ok(x)`     | `IPLDCodec.roundtrip`               |
| `decode(bs).map(encode) == bs`    | `IPLDCodec.decode_encode` (canon.)  |
| `get_path(decode(encode(x)), p)   | `traversal_preservation`            |
|   == get_path(x, p)`             |                                     |
| `from_ipld(to_ipld(x)) == Ok(x)` | `IPLDTypedCodec.toNode_fromNode`    |
-/

-- ============================================================================
-- § 13  Feature flags mapping
-- ============================================================================

/-!
### `ipld-core` feature flags

| Feature flag | Rust behavior                        | Lean equivalent                    |
|-------------|--------------------------------------|------------------------------------|
| `std`       | `std::error::Error` impls            | (always available)                 |
| `codec`     | `Codec` trait available              | `IPLDCodec` typeclass              |
| `serde`     | Serde ser/de for `Ipld`              | `IPLDTypedCodec`                   |
| `arb`       | `quickcheck::Arbitrary` for `Ipld`   | Formal proofs replace testing      |

In Lean, all functionality is always available — there's no conditional
compilation. The separation exists in Rust due to dependency management
and `no_std` support.
-/

-- ============================================================================
-- § 14  Schema types mapping (IPLD.lean ↔ ipld-core types)
-- ============================================================================

/-!
### How IPLD Schema types relate to `ipld-core`

The IPLD Schema types (defined in `IPLD.lean`) describe the *schema
language itself*. The `ipld-core` crate doesn't implement schemas —
it provides only the Data Model layer (`Ipld` enum).

The relationship is:

```
IPLD Schema types (IPLD.lean)
    │
    │ describe schemas that constrain
    ▼
IPLD Data Model (IPLDNode / Ipld)  ← ipld-core provides this
    │
    │ serialized/deserialized by
    ▼
Codecs (DAG-CBOR, DAG-JSON, etc.)  ← separate crates
```

Schema types like `TypeDefnStruct`, `TypeDefnUnion`, etc. define the
*structure* of data. The `ipld-core` `Ipld` type is the *untyped*
runtime representation that those structures compile down to.

The `IPLDRustCodeGen` module in this project generates Rust `struct`/`enum`
definitions from schemas — these generated types then use `ipld-core`'s
`Ipld` type as their serialization target via Serde.
-/

-- ============================================================================
-- § 15  Verified roundtrip properties
-- ============================================================================

open RustCoreMapping

/-- The `kind` function is consistent: it returns the same kind for any
    value constructed by `ofXxx`. These correspond to the Rust property
    that `Ipld::from(x).kind()` returns the expected `IpldKind`. -/
theorem kind_ofBool (b : Bool) : ipldNodeKind (ofBool b) = .bool := rfl
theorem kind_ofInt (n : Int) : ipldNodeKind (ofInt n) = .integer := rfl
theorem kind_ofFloat (f : Float) : ipldNodeKind (ofFloat f) = .float := rfl
theorem kind_ofString (s : String) : ipldNodeKind (ofString s) = .string := rfl
theorem kind_ofBytes (bs : ByteArray) : ipldNodeKind (ofBytes bs) = .bytes := rfl
theorem kind_ofList (vs : List IPLDNode) : ipldNodeKind (ofList vs) = .list := rfl
theorem kind_ofMap (kvs : List (String × IPLDNode)) :
    ipldNodeKind (ofMap kvs) = .map := rfl

/-- Extracting a value from a node constructed with the matching constructor
    always succeeds. This corresponds to the Rust property:
    `bool::try_from(Ipld::Bool(b)) == Ok(b)` -/
theorem toBool_ofBool (b : Bool) : toBool (ofBool b) = .ok b := rfl
theorem toInt_ofInt (n : Int) : toInt (ofInt n) = .ok n := rfl
theorem toFloat_ofFloat (f : Float) : toFloat (ofFloat f) = .ok f := rfl
theorem toStr_ofString (s : String) : toStr (ofString s) = .ok s := rfl
theorem toBytes_ofBytes (bs : ByteArray) : toBytes (ofBytes bs) = .ok bs := rfl
theorem toListVal_ofList (vs : List IPLDNode) :
    toListVal (ofList vs) = .ok vs := rfl
theorem toMap_ofMap (kvs : List (String × IPLDNode)) :
    toMap (ofMap kvs) = .ok kvs := rfl
theorem toCID_ofLink (cid : CID) : toCID (.link cid) = .ok cid := rfl

/-- Wrong-kind extraction always fails. Corresponds to the Rust tests
    like `try_into_wrong_type` in src/convert.rs. -/
theorem toBool_ofInt_fails (n : Int) :
    (toBool (ofInt n)).isOk = false := rfl
theorem toInt_ofBool_fails (b : Bool) :
    (toInt (ofBool b)).isOk = false := rfl
theorem toFloat_ofString_fails (s : String) :
    (toFloat (ofString s)).isOk = false := rfl

-- ============================================================================
-- § 16  Single-step get corresponds to Rust's Ipld::get
-- ============================================================================

/-- Indexing into a list by position.
    Corresponds to Rust: `Ipld::List(vec).get(i)`. -/
theorem get_list_index (vs : List IPLDNode) (i : Nat) :
    ipldGet (.list vs) (.index i) = vs[i]? := by
  simp [ipldGet, IPLDNode.getPath]
  cases h : vs[i]? <;> simp

/-- Indexing into a map by key.
    Corresponds to Rust: `Ipld::Map(map).get("key")`. -/
theorem get_map_key (kvs : List (String × IPLDNode)) (k : String) :
    ipldGet (.map kvs) (.key k) =
      (kvs.find? (·.1 == k)).map (·.2) := by
  simp [ipldGet, IPLDNode.getPath]
  cases kvs.find? (·.1 == k) <;> simp

end IPLD
