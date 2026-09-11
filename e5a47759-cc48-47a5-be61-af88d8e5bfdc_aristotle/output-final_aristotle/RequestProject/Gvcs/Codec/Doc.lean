import RequestProject.Gvcs.Codec.Atom

/-!
# Documents: the shared tree the text codecs render

`Doc` is the tree that sits between the canonical proof object and the three text
formats (IPDL, XML, YAML).  It is deliberately close to XML's data model — an element
has a tag, an ordered list of attributes, and either character content or child
elements — because that is the poorest of the three; anything `Doc` can carry, all
three codecs can carry.

Nothing in `Doc` is proof-specific.  The canonical object is mapped into it in
`RequestProject.Codec.Encode`, and the codecs only ever see `Doc`.  That is what keeps
format-specific assumptions out of the proof model: a codec is an adapter between text
and `Doc`, never between text and the proof object.
-/

namespace LifeTrac.Codec

/-- A document tree: the common shape rendered by the IPDL, XML and YAML codecs. -/
inductive Doc where
  /-- An element with character content. -/
  | leaf (tag : String) (attrs : List (String × String)) (text : String)
  /-- An element with child elements. -/
  | node (tag : String) (attrs : List (String × String)) (kids : List Doc)
  deriving Repr, Inhabited

namespace Doc

/-- Tag of a document. -/
def tag : Doc → String
  | .leaf t _ _ => t
  | .node t _ _ => t

/-- Attributes of a document, in order. -/
def attrs : Doc → List (String × String)
  | .leaf _ a _ => a
  | .node _ a _ => a

/-- Children of a document; a leaf has none. -/
def kids : Doc → List Doc
  | .leaf _ _ _ => []
  | .node _ _ k => k

/-- Look an attribute up by name; the first occurrence wins. -/
def attr? (d : Doc) (k : String) : Option String :=
  (d.attrs.find? (fun kv => kv.1 == k)).map Prod.snd

end Doc

/-!
## Literal matching

Codecs that spell out keywords (`tag: `, `</`, and so on) share this helper.
-/

/-- Consume an exact literal from the front of the input. -/
def expect : List Char → List Char → Option (List Char)
  | [], l => some l
  | c :: p, x :: l => if c = x then expect p l else none
  | _ :: _, [] => none

@[simp] theorem expect_append (p rest : List Char) : expect p (p ++ rest) = some rest := by
  induction p with
  | nil => rfl
  | cons c t ih => simp [expect, ih]

/-! ## List heads

Small helpers used by every codec proof: what the first character of a rendered
fragment can be.
-/

theorem head?_append_some {α : Type*} {A : List α} {B : List α} {c : α}
    (h : A.head? = some c) : (A ++ B).head? = some c := by
  cases A <;> simp_all

theorem eq_nil_of_head?_none {α : Type*} {A : List α} (h : A.head? = none) : A = [] := by
  cases A <;> simp_all

theorem head?_append_of_none {α : Type*} {A B : List α} (h : A.head? = none) :
    (A ++ B).head? = B.head? := by
  rw [eq_nil_of_head?_none h, List.nil_append]

end LifeTrac.Codec
