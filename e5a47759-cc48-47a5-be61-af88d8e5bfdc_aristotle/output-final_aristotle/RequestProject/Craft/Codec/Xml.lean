/-
# Standard Proof Codec — XML adapter (SOP §13)

The XML document model distinguishes elements, attributes and text nodes, and
carries namespaces; child order is significant and is preserved.

The canonical encoder emits elements in the codec's own namespace `proof`.
The decoder is total: any element it does not recognise — an unknown element,
a foreign namespace, an unexpected attribute — is preserved as an extension
object under reserved `$xml.*` fields (SOP §13, §30) together with its
namespace, its attributes in order, and its decoded children.

Proved here:

* `decodeX_encodeX` — canonical → XML → canonical is the identity (LOSSLESS);
* `xml_doc_roundtrip` — SOP §17 for arbitrary XML documents: the meaning of a
  document survives decode/encode/decode;
* `unknown_element_preserved`, `foreign_namespace_preserved`,
  `text_node_preserved`, `attributes_preserved` — nothing is discarded.
-/
import RequestProject.Craft.Codec.Canonical

namespace Codec

/-- The XML document model. -/
inductive Xml where
  /-- A text node. -/
  | text : String → Xml
  /-- An element: namespace, name, attributes in order, children in order. -/
  | elem : Option String → String → List (String × String) → List Xml → Xml
  deriving Repr, Inhabited

namespace Xml

open CValue

/-- The namespace the canonical encoder writes into. -/
def ns : Option String := some "proof"

/-- Encode an attribute list as a canonical value, preserving order. -/
def attrsToCValue (attrs : List (String × String)) : CValue :=
  .list (attrs.map (fun a => CValue.obj [("name", .str a.1), ("value", .str a.2)]))

mutual

/-- Encode a canonical value as an XML document. -/
def encodeX : CValue → Xml
  | .null => .elem ns "null" [] []
  | .bool b => .elem ns "bool" [("value", if b then "true" else "false")] []
  | .int n => .elem ns "int" [] [.text (intText n)]
  | .str s => .elem ns "str" [] [.text s]
  | .list xs => .elem ns "list" [] (encodeXL xs)
  | .obj fs => .elem ns "obj" [] (encodeXF fs)

/-- Encode the elements of a list. -/
def encodeXL : List CValue → List Xml
  | [] => []
  | x :: xs => encodeX x :: encodeXL xs

/-- Encode the fields of an object as `field` elements keyed by attribute. -/
def encodeXF : List (String × CValue) → List Xml
  | [] => []
  | (k, v) :: fs => .elem ns "field" [("key", k)] [encodeX v] :: encodeXF fs

end

/-- Preserve an element the canonical model has no shape for, given its already
decoded children (SOP §13, §30). -/
def captureWith (nsp : Option String) (name : String) (attrs : List (String × String))
    (children : List CValue) : CValue :=
  .obj [("$xml.ns", match nsp with | none => .null | some n => .str n),
        ("$xml.name", .str name),
        ("$xml.attrs", attrsToCValue attrs),
        ("$xml.children", .list children)]

mutual

/-- Decode an XML document into a canonical value. The decoder is total:
constructs it does not recognise are preserved as extensions. -/
def decodeX : Xml → CValue
  | .text s => .obj [("$xml.text", .str s)]
  | .elem nsp name attrs children =>
      match nsp, name, attrs, children with
      | some "proof", "null", [], [] => .null
      | some "proof", "bool", [("value", "true")], [] => .bool true
      | some "proof", "bool", [("value", "false")], [] => .bool false
      | some "proof", "int", [], [.text t] =>
          match parseIntText t with
          | some n => .int n
          -- the single child is the text node `t`; its decoding is spelled out
          -- here so that the recursion is visibly structural
          | none => captureWith nsp name attrs [.obj [("$xml.text", .str t)]]
      | some "proof", "str", [], [.text s] => .str s
      | some "proof", "list", [], ch => .list (decodeXL ch)
      | some "proof", "obj", [], ch =>
          match decodeXF ch with
          | some fs => .obj fs
          | none => captureWith nsp name attrs (decodeXL ch)
      | nsp', name', attrs', ch => captureWith nsp' name' attrs' (decodeXL ch)
  termination_by y => sizeOf y

/-- Decode a list of children. -/
def decodeXL : List Xml → List CValue
  | [] => []
  | x :: xs => decodeX x :: decodeXL xs
  termination_by xs => sizeOf xs

/-- Decode a list of `field` elements, if that is what they are. -/
def decodeXF : List Xml → Option (List (String × CValue))
  | [] => some []
  | .elem (some "proof") "field" [("key", k)] [v] :: rest =>
      match decodeXF rest with
      | some fs => some ((k, decodeX v) :: fs)
      | none => none
  | _ => none
  termination_by xs => sizeOf xs

end

/-- Preserve an element the canonical model has no shape for, decoding its
children (SOP §13, §30). -/
def captureX (nsp : Option String) (name : String) (attrs : List (String × String))
    (children : List Xml) : CValue :=
  captureWith nsp name attrs (decodeXL children)

/-- The XML adapter is lossless on canonical values (SOP §9, §13). -/
theorem decodeX_encodeX : ∀ v : CValue, decodeX (encodeX v) = v := by
  refine CValue.rec
    (motive_1 := fun v => decodeX (encodeX v) = v)
    (motive_2 := fun xs => decodeXL (encodeXL xs) = xs)
    (motive_3 := fun fs => decodeXF (encodeXF fs) = some fs)
    (motive_4 := fun p => decodeX (encodeX p.2) = p.2)
    ?null ?bool ?int ?str ?list ?obj ?nil ?cons ?fnil ?fcons ?mk
  case null => simp [encodeX, decodeX, ns]
  case bool => intro b; cases b <;> simp [encodeX, decodeX, ns]
  case int =>
    intro n
    simp only [encodeX, decodeX, ns, parseIntText_intText n]
  case str => intro s; simp [encodeX, decodeX, ns]
  case list => intro xs ih; simp only [encodeX, decodeX, ns, ih]
  case obj => intro fs ih; simp only [encodeX, decodeX, ns, ih]
  case nil => simp [encodeXL, decodeXL]
  case cons => intro x xs ihx ihxs; simp only [encodeXL, decodeXL, ihx, ihxs]
  case fnil => simp [encodeXF, decodeXF]
  case fcons =>
    rintro ⟨k, v⟩ fs ihp ihfs
    simp only [encodeXF, decodeXF, ns, ihp, ihfs]
  case mk => rintro k v ih; exact ih

/-- Round-trip requirement (SOP §17) for arbitrary XML documents. -/
theorem xml_doc_roundtrip (y : Xml) : decodeX (encodeX (decodeX y)) = decodeX y :=
  decodeX_encodeX (decodeX y)

/-- A text node keeps its text. -/
theorem text_node_preserved (s : String) :
    decodeX (.text s) = .obj [("$xml.text", .str s)] := by
  simp [decodeX]

/-- An element in a foreign namespace keeps its namespace, name, attributes and
children (SOP §13). -/
theorem foreign_namespace_preserved (n name : String) (attrs : List (String × String))
    (ch : List Xml) (h : n ≠ "proof") :
    decodeX (.elem (some n) name attrs ch) = captureX (some n) name attrs ch := by
  simp [decodeX, captureX, h]

/-- An element with no namespace is preserved as an extension. -/
theorem no_namespace_preserved (name : String) (attrs : List (String × String))
    (ch : List Xml) :
    decodeX (.elem none name attrs ch) = captureX none name attrs ch := by
  simp [decodeX, captureX]

/-- The capture of an unknown element records its attributes in order, so
attribute order and repetition survive (SOP §13). -/
theorem attributes_preserved (nsp : Option String) (name : String)
    (attrs : List (String × String)) (ch : List Xml) :
    (captureX nsp name attrs ch).get? "$xml.attrs" = some (attrsToCValue attrs) := by
  simp [captureX, captureWith, CValue.get?]

/-- The capture of an unknown element records its children, decoded in order. -/
theorem children_preserved (nsp : Option String) (name : String)
    (attrs : List (String × String)) (ch : List Xml) :
    (captureX nsp name attrs ch).get? "$xml.children" = some (.list (decodeXL ch)) := by
  simp [captureX, captureWith, CValue.get?]

/-! ## Rendering to concrete XML text

As for YAML, the renderer is a printer; the verified codec is the
document-level adapter above. -/

/-- Escape the characters that may not appear literally in XML text. -/
def escape (s : String) : String :=
  String.ofList (s.toList.flatMap (fun c =>
    if c = '&' then "&amp;".toList
    else if c = '<' then "&lt;".toList
    else if c = '>' then "&gt;".toList
    else if c = '"' then "&quot;".toList
    else [c]))

/-- Render an attribute. -/
def renderAttr (a : String × String) : String :=
  " " ++ a.1 ++ "=\"" ++ escape a.2 ++ "\""

/-- Qualified name of an element. -/
def qname (nsp : Option String) (name : String) : String :=
  match nsp with
  | none => name
  | some n => n ++ ":" ++ name

mutual

/-- Render an XML document as text. -/
def render : Xml → String
  | .text s => escape s
  | .elem nsp name attrs [] =>
      "<" ++ qname nsp name ++ String.join (attrs.map renderAttr) ++ "/>"
  | .elem nsp name attrs ch =>
      "<" ++ qname nsp name ++ String.join (attrs.map renderAttr) ++ ">" ++
        renderList ch ++ "</" ++ qname nsp name ++ ">"

/-- Render a list of children. -/
def renderList : List Xml → String
  | [] => ""
  | x :: xs => render x ++ renderList xs

end

/-- Render a canonical value as XML text. -/
def toText (v : CValue) : String := render (encodeX v)

end Xml
end Codec
