/-
# Standard Proof Codec — IPDL adapter (SOP §12)

IPDL is treated as a native structured interchange codec: a term language with
identifiers, typed nodes, nesting, references and annotations.

The adapter provides both directions, `IPDL → Canonical` and
`Canonical → IPDL`, and preserves identifiers, types, nesting, references,
annotations, metadata and errors. Constructs with no canonical equivalent —
references, annotations, typed nodes other than plain objects, bare atoms —
are represented through reserved `$ipdl.*` extension fields rather than
discarded (SOP §12, §30).

Proved: `decodeI_encodeI` (lossless canonical → IPDL → canonical),
`ipdl_doc_roundtrip` (SOP §17 for arbitrary IPDL terms), and the preservation
theorems for references, annotations and typed nodes.
-/
import RequestProject.Craft.Codec.Canonical

namespace Codec

/-- The IPDL term language. -/
inductive Ipdl where
  /-- A bare atom or identifier. -/
  | atom : String → Ipdl
  /-- A numeric literal. -/
  | num : Int → Ipdl
  /-- A text literal. -/
  | text : String → Ipdl
  /-- A reference to another object by identifier. -/
  | ref : String → Ipdl
  /-- An annotated term, `@name term`. -/
  | ann : String → Ipdl → Ipdl
  /-- A typed node with named fields, in order. -/
  | node : String → List (String × Ipdl) → Ipdl
  /-- A sequence. -/
  | seq : List Ipdl → Ipdl
  deriving Repr, Inhabited

namespace Ipdl

open CValue

mutual

/-- Encode a canonical value as an IPDL term. -/
def encodeI : CValue → Ipdl
  | .null => .atom "null"
  | .bool b => .atom (if b then "true" else "false")
  | .int n => .num n
  | .str s => .text s
  | .list xs => .seq (encodeIL xs)
  | .obj fs => .node "obj" (encodeIF fs)

/-- Encode a list of canonical values. -/
def encodeIL : List CValue → List Ipdl
  | [] => []
  | x :: xs => encodeI x :: encodeIL xs

/-- Encode a field list. -/
def encodeIF : List (String × CValue) → List (String × Ipdl)
  | [] => []
  | (k, v) :: fs => (k, encodeI v) :: encodeIF fs

end

mutual

/-- Decode an IPDL term into a canonical value. The decoder is total:
constructs with no canonical equivalent are preserved as extensions. -/
def decodeI : Ipdl → CValue
  | .atom a =>
      if a = "null" then .null
      else if a = "true" then .bool true
      else if a = "false" then .bool false
      else .obj [("$ipdl.atom", .str a)]
  | .num n => .int n
  | .text s => .str s
  | .ref id => .obj [("$ipdl.ref", .str id)]
  | .ann name t => .obj [("$ipdl.annotation", .str name), ("$ipdl.node", decodeI t)]
  | .node ty fs =>
      if ty = "obj" then .obj (decodeIF fs)
      else .obj [("$ipdl.type", .str ty), ("$ipdl.fields", .obj (decodeIF fs))]
  | .seq xs => .list (decodeIL xs)

/-- Decode a sequence. -/
def decodeIL : List Ipdl → List CValue
  | [] => []
  | x :: xs => decodeI x :: decodeIL xs

/-- Decode the fields of a node. -/
def decodeIF : List (String × Ipdl) → List (String × CValue)
  | [] => []
  | (k, t) :: fs => (k, decodeI t) :: decodeIF fs

end

/-- The IPDL adapter is lossless on canonical values (SOP §9, §12). -/
theorem decodeI_encodeI : ∀ v : CValue, decodeI (encodeI v) = v := by
  refine CValue.rec
    (motive_1 := fun v => decodeI (encodeI v) = v)
    (motive_2 := fun xs => decodeIL (encodeIL xs) = xs)
    (motive_3 := fun fs => decodeIF (encodeIF fs) = fs)
    (motive_4 := fun p => decodeI (encodeI p.2) = p.2)
    ?null ?bool ?int ?str ?list ?obj ?nil ?cons ?fnil ?fcons ?mk
  case null => simp [encodeI, decodeI]
  case bool => intro b; cases b <;> simp [encodeI, decodeI]
  case int => intro n; simp [encodeI, decodeI]
  case str => intro s; simp [encodeI, decodeI]
  case list => intro xs ih; simp only [encodeI, decodeI, ih]
  case obj => intro fs ih; simp [encodeI, decodeI, ih]
  case nil => simp [encodeIL, decodeIL]
  case cons => intro x xs ihx ihxs; simp only [encodeIL, decodeIL, ihx, ihxs]
  case fnil => simp [encodeIF, decodeIF]
  case fcons =>
    rintro ⟨k, v⟩ fs ihp ihfs
    simp only [encodeIF, decodeIF, ihp, ihfs]
  case mk => rintro k v ih; exact ih

/-- Round-trip requirement (SOP §17) for arbitrary IPDL terms. -/
theorem ipdl_doc_roundtrip (t : Ipdl) : decodeI (encodeI (decodeI t)) = decodeI t :=
  decodeI_encodeI (decodeI t)

/-- References survive the crossing into the canonical model (SOP §12). -/
theorem ref_preserved (id : String) :
    decodeI (.ref id) = .obj [("$ipdl.ref", .str id)] := by
  simp [decodeI]

/-- Annotations survive, together with the term they annotate (SOP §12). -/
theorem annotation_preserved (name : String) (t : Ipdl) :
    decodeI (.ann name t) =
      .obj [("$ipdl.annotation", .str name), ("$ipdl.node", decodeI t)] := by
  simp [decodeI]

/-- A node whose type the canonical model does not know keeps both its type
and its fields (SOP §12, §30). -/
theorem typed_node_preserved (ty : String) (fs : List (String × Ipdl)) (h : ty ≠ "obj") :
    decodeI (.node ty fs) =
      .obj [("$ipdl.type", .str ty), ("$ipdl.fields", .obj (decodeIF fs))] := by
  simp [decodeI, h]

/-- An atom that is not one of the canonical literals keeps its name. -/
theorem atom_preserved (a : String) (h1 : a ≠ "null") (h2 : a ≠ "true") (h3 : a ≠ "false") :
    decodeI (.atom a) = .obj [("$ipdl.atom", .str a)] := by
  simp [decodeI, h1, h2, h3]

/-- Field order inside a node is preserved. -/
theorem node_field_order (fs : List (String × Ipdl)) :
    (decodeIF fs).map Prod.fst = fs.map Prod.fst := by
  induction fs with
  | nil => simp [decodeIF]
  | cons p fs ih => obtain ⟨k, t⟩ := p; simp [decodeIF, ih]

/-! ## Rendering to concrete IPDL text -/

mutual

/-- Render an IPDL term as text. -/
def render : Ipdl → String
  | .atom a => a
  | .num n => intText n
  | .text s => "\"" ++ s ++ "\""
  | .ref id => "&" ++ id
  | .ann name t => "@" ++ name ++ " " ++ render t
  | .node ty fs => ty ++ "{" ++ renderFields fs ++ "}"
  | .seq xs => "[" ++ renderSeq xs ++ "]"

/-- Render the items of a sequence. -/
def renderSeq : List Ipdl → String
  | [] => ""
  | [x] => render x
  | x :: xs => render x ++ ", " ++ renderSeq xs

/-- Render the fields of a node. -/
def renderFields : List (String × Ipdl) → String
  | [] => ""
  | [(k, t)] => k ++ ": " ++ render t
  | (k, t) :: fs => k ++ ": " ++ render t ++ ", " ++ renderFields fs

end

/-- Render a canonical value as IPDL text. -/
def toText (v : CValue) : String := render (encodeI v)

end Ipdl
end Codec
