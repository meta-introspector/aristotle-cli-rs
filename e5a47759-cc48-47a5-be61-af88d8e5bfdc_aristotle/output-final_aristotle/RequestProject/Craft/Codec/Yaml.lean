/-
# Standard Proof Codec — YAML adapter (SOP §15)

YAML is the human-readable projection of the canonical model.  The adapter is
defined on a YAML document model (scalars with tags, sequences, mappings,
anchors and aliases) rather than on concrete YAML text, and it is proved to be

* **lossless** in the direction canonical → YAML → canonical
  (`decodeY_encodeY`), and
* **semantics preserving** on arbitrary YAML documents (`yaml_doc_roundtrip`,
  SOP §17): decoding, re-encoding and decoding again gives the same canonical
  object.

Constructs with no canonical equivalent — custom tags, anchors, aliases — are
never discarded: they are carried in reserved `$yaml.*` extension fields
(SOP §30), which is what makes the semantic round trip hold for them too.

A renderer to concrete YAML text is provided at the end; it is a printer, and
no claim is made here about parsing arbitrary YAML text.
-/
import RequestProject.Craft.Codec.Canonical

namespace Codec

/-- The YAML document model. -/
inductive Yaml where
  /-- A scalar with an optional tag, e.g. `!!int 144`. -/
  | scalar : Option String → String → Yaml
  /-- A sequence. -/
  | seq : List Yaml → Yaml
  /-- A mapping with string keys, in document order. -/
  | map : List (String × Yaml) → Yaml
  /-- An anchored node, `&name node`. -/
  | anchor : String → Yaml → Yaml
  /-- An alias, `*name`. -/
  | alias : String → Yaml
  deriving Repr, Inhabited

namespace Yaml

open CValue

mutual

/-- Encode a canonical value as a YAML document. -/
def encodeY : CValue → Yaml
  | .null => .scalar (some "null") ""
  | .bool b => .scalar (some "bool") (if b then "true" else "false")
  | .int n => .scalar (some "int") (CValue.intText n)
  | .str s => .scalar (some "str") s
  | .list xs => .seq (encodeYL xs)
  | .obj fs => .map (encodeYF fs)

/-- Encode a list of canonical values. -/
def encodeYL : List CValue → List Yaml
  | [] => []
  | x :: xs => encodeY x :: encodeYL xs

/-- Encode a field list. -/
def encodeYF : List (String × CValue) → List (String × Yaml)
  | [] => []
  | (k, v) :: fs => (k, encodeY v) :: encodeYF fs

end

/-- Capture a scalar the canonical model has no type for, preserving its tag
and text (SOP §30). -/
def captureScalar (tag : Option String) (text : String) : CValue :=
  .obj [("$yaml.tag", match tag with | none => .null | some t => .str t),
        ("$yaml.text", .str text)]

mutual

/-- Decode a YAML document into a canonical value. The decoder is total: a
construct it does not recognise is preserved as an extension object rather
than rejected (SOP §11, §30). -/
def decodeY : Yaml → CValue
  | .scalar tag text =>
      match tag, text with
      | some "null", "" => .null
      | some "bool", "true" => .bool true
      | some "bool", "false" => .bool false
      | some "int", t =>
          match CValue.parseIntText t with
          | some n => .int n
          | none => captureScalar (some "int") t
      | some "str", s => .str s
      | t, s => captureScalar t s
  | .seq xs => .list (decodeYL xs)
  | .map fs => .obj (decodeYF fs)
  | .anchor name node => .obj [("$yaml.anchor", .str name), ("$yaml.node", decodeY node)]
  | .alias name => .obj [("$yaml.alias", .str name)]

/-- Decode a sequence. -/
def decodeYL : List Yaml → List CValue
  | [] => []
  | x :: xs => decodeY x :: decodeYL xs

/-- Decode a mapping. -/
def decodeYF : List (String × Yaml) → List (String × CValue)
  | [] => []
  | (k, y) :: fs => (k, decodeY y) :: decodeYF fs

end

/-- The YAML adapter is lossless on canonical values (SOP §9, §15). -/
theorem decodeY_encodeY : ∀ v : CValue, decodeY (encodeY v) = v := by
  refine CValue.rec
    (motive_1 := fun v => decodeY (encodeY v) = v)
    (motive_2 := fun xs => decodeYL (encodeYL xs) = xs)
    (motive_3 := fun fs => decodeYF (encodeYF fs) = fs)
    (motive_4 := fun p => decodeY (encodeY p.2) = p.2)
    ?null ?bool ?int ?str ?list ?obj ?nil ?cons ?fnil ?fcons ?mk
  case null => rfl
  case bool => intro b; cases b <;> rfl
  case int =>
    intro n
    simp only [encodeY, decodeY, CValue.parseIntText_intText n]
  case str => intro s; rfl
  case list => intro xs ih; simp only [encodeY, decodeY, ih]
  case obj => intro fs ih; simp only [encodeY, decodeY, ih]
  case nil => rfl
  case cons => intro x xs ihx ihxs; simp only [encodeYL, decodeYL, ihx, ihxs]
  case fnil => rfl
  case fcons =>
    rintro ⟨k, v⟩ fs ihp ihfs
    simp only [encodeYF, decodeYF, ihp, ihfs]
  case mk => rintro k v ih; exact ih

/-- Round-trip requirement (SOP §17) for arbitrary YAML documents: the meaning
of a document — its canonical decoding — survives a full decode/encode cycle,
including anchors, aliases and custom tags. -/
theorem yaml_doc_roundtrip (y : Yaml) : decodeY (encodeY (decodeY y)) = decodeY y :=
  decodeY_encodeY (decodeY y)

/-- An anchored node keeps both its anchor name and its content (SOP §15, §30). -/
theorem anchor_preserved (name : String) (node : Yaml) :
    decodeY (.anchor name node) =
      .obj [("$yaml.anchor", .str name), ("$yaml.node", decodeY node)] := rfl

/-- An alias keeps its name (SOP §15, §30). -/
theorem alias_preserved (name : String) :
    decodeY (.alias name) = .obj [("$yaml.alias", .str name)] := rfl

/-- A scalar carrying a tag the canonical model does not know keeps both the
tag and the original text (SOP §30). -/
theorem custom_tag_preserved (t s : String) (h : t ∉ ["null", "bool", "int", "str"]) :
    decodeY (.scalar (some t) s) = captureScalar (some t) s := by
  simp only [List.mem_cons, List.not_mem_nil, or_false] at h
  push_neg at h
  obtain ⟨h1, h2, h3, h4⟩ := h
  unfold decodeY
  split
  · rename_i heq; simp_all
  · rename_i heq; simp_all
  · rename_i heq; simp_all
  · rename_i heq; simp_all
  · rename_i heq; simp_all
  · rfl

/-! ## Rendering to concrete YAML text

The renderer below is a printer only: it is used to emit human-readable
artifacts. The verified codec is the document-level adapter above. -/

/-- Indentation helper. -/
def indent (n : Nat) : String := String.ofList (List.replicate (2 * n) ' ')

mutual

/-- Render a YAML document as text. -/
def render (n : Nat) : Yaml → String
  | .scalar _ text => text
  | .seq [] => "[]"
  | .seq xs => "\n" ++ renderSeq (n + 1) xs
  | .map [] => "{}"
  | .map fs => "\n" ++ renderMap (n + 1) fs
  | .anchor name node => "&" ++ name ++ " " ++ render n node
  | .alias name => "*" ++ name

/-- Render the items of a sequence. -/
def renderSeq (n : Nat) : List Yaml → String
  | [] => ""
  | x :: xs => indent n ++ "- " ++ render n x ++ "\n" ++ renderSeq n xs

/-- Render the entries of a mapping. -/
def renderMap (n : Nat) : List (String × Yaml) → String
  | [] => ""
  | (k, y) :: fs => indent n ++ k ++ ": " ++ render n y ++ "\n" ++ renderMap n fs

end

/-- Render a canonical value as YAML text. -/
def toText (v : CValue) : String := render 0 (encodeY v)

end Yaml
end Codec
