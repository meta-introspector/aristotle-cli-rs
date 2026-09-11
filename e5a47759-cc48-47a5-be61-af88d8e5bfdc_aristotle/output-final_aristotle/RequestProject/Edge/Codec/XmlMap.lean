/-
# Canonical values as XML, and XML as canonical values

`Xml` gives an XML syntax layer with a proved round trip.  This file is
the *mapping* layer that connects it to the canonical model:

```text
canonical value  --ofVal-->  XML document  --toVal-->  canonical value
```

Every canonical constructor has its own element, and the three things XML
distinguishes stay distinguished — a string becomes character data, a
number becomes an attribute, structure becomes elements:

```xml
<obj><field key="n"><int value="144"/></field>
     <field key="note"><str>hello</str></field></obj>
```

An element this schema does not recognise (someone else's namespace, a
dialect, a mistyped attribute) is *not* dropped.  It is represented by
the reserved shape

```text
{ "@xml.attributes": { … }, "@xml.children": [ … ], "@xml.element": "…" }
```

and `ofVal` turns that shape back into the original element, so foreign
XML survives a trip through the canonical model.  The price of that
extension mechanism is that a canonical object which *is* exactly that
shape denotes an element rather than an object; `noReserved` identifies
the values for which the mapping is the identity, and the round-trip
theorem is stated for them.
-/
import RequestProject.Edge.Codec.Xml

namespace CfDeploy
namespace Codec
namespace Xml

/-! ## Numbers as attribute values -/

/-- An integer as an attribute value. -/
abbrev intStr := Parse.intStr

/-- Read an integer attribute value. -/
abbrev parseIntStr := Parse.parseIntStr

/-- Attribute values are strings; this reads them back out of the
canonical representation of an element's attributes. -/
def attrsOfVals : List (String × CVal) → Option (List (String × String))
  | [] => some []
  | (k, .str v) :: r => (attrsOfVals r).map (fun as => (k, v) :: as)
  | _ => none

theorem attrsOfVals_map (attrs : List (String × String)) :
    attrsOfVals (attrs.map (fun a => (a.1, CVal.str a.2))) = some attrs := by
  induction attrs with
  | nil => rfl
  | cons a as ih => obtain ⟨k, v⟩ := a; simp [attrsOfVals, ih]

/-! ## The reserved shape -/

/-- Does this object denote an XML node rather than a canonical object? -/
def reservedFields : List (String × CVal) → Bool
  | [("@xml.text", .str _)] => true
  | [("@xml.attributes", .obj as), ("@xml.children", .list _), ("@xml.element", .str _)] =>
      (attrsOfVals as).isSome
  | _ => false

/-! ## Canonical value to XML -/

mutual

/-- Write a canonical value as XML. -/
def ofVal : CVal → XNode
  | .null => .elem "null" [] []
  | .bool b => .elem "bool" [("value", if b then "true" else "false")] []
  | .int i => .elem "int" [("value", intStr i)] []
  | .num m e => .elem "dec" [("exponent", intStr e), ("mantissa", intStr m)] []
  | .str s => if s = "" then .elem "str" [] [] else .elem "str" [] [.text s]
  | .ref r => .elem "ref" [("id", r)] []
  | .list xs => .elem "list" [] (ofValItems xs)
  | .obj fs =>
      if reservedFields fs then ofReserved fs else .elem "obj" [] (ofValFields fs)

/-- Rebuild the XML node a reserved-shape object denotes. -/
def ofReserved : List (String × CVal) → XNode
  | [("@xml.text", .str s)] => .text s
  | [("@xml.attributes", .obj as), ("@xml.children", .list ks), ("@xml.element", .str n)] =>
      match attrsOfVals as with
      | some a => .elem n a (ofValItems ks)
      | none => .elem "obj" [] []
  | _ => .elem "obj" [] []

def ofValItems : List CVal → List XNode
  | [] => []
  | x :: xs => ofVal x :: ofValItems xs

def ofValFields : List (String × CVal) → List XNode
  | [] => []
  | (k, v) :: fs => .elem "field" [("key", k)] [ofVal v] :: ofValFields fs

end

/-! ## XML to canonical value -/

/-- The reserved representation of an element this schema does not
recognise: nothing about it is discarded. -/
def generic (n : String) (attrs : List (String × String)) (kids : List CVal) : CVal :=
  .obj [ ("@xml.attributes", .obj (attrs.map (fun a => (a.1, CVal.str a.2))))
       , ("@xml.children", .list kids)
       , ("@xml.element", .str n) ]

mutual

/-- Read any XML document as a canonical value. -/
def toVal : XNode → CVal
  | .text s => .obj [("@xml.text", .str s)]
  | .elem n attrs kids =>
      let g := generic n attrs (toValKids kids)
      match n, attrs, kids with
      | "null", [], [] => .null
      | "bool", [("value", v)], [] =>
          if v = "true" then .bool true
          else if v = "false" then .bool false
          else g
      | "int", [("value", v)], [] =>
          match parseIntStr v with
          | some i => .int i
          | none => g
      | "dec", [("exponent", e), ("mantissa", m)], [] =>
          match parseIntStr m, parseIntStr e with
          | some m', some e' => .num m' e'
          | _, _ => g
      | "str", [], [] => .str ""
      | "str", [], [.text s] => .str s
      | "ref", [("id", r)], [] => .ref r
      | "list", [], ks => .list (toValKids ks)
      | "obj", [], ks =>
          match toValFields ks with
          | some fs => .obj fs
          | none => g
      | _, _, _ => g

def toValKids : List XNode → List CVal
  | [] => []
  | k :: ks => toVal k :: toValKids ks

def toValFields : List XNode → Option (List (String × CVal))
  | [] => some []
  | .elem "field" [("key", k)] [v] :: ks =>
      (toValFields ks).map (fun fs => (k, toVal v) :: fs)
  | _ => none

end

/-! ## Values for which the mapping is the identity -/

mutual

/-- A value that does not itself use the reserved XML shape, at any
depth. -/
def noReserved : CVal → Bool
  | .list xs => noReservedItems xs
  | .obj fs => !reservedFields fs && noReservedFields fs
  | _ => true

def noReservedItems : List CVal → Bool
  | [] => true
  | x :: xs => noReserved x && noReservedItems xs

def noReservedFields : List (String × CVal) → Bool
  | [] => true
  | (_, v) :: fs => noReserved v && noReservedFields fs

end

/-! ## The mapping is lossless -/

/-- The canonical → XML → canonical round trip.  Stated for the values
that do not themselves use the reserved shape, which is exactly the
condition under which `ofVal` is injective. -/
theorem toVal_ofVal_all :
    (∀ v : CVal, noReserved v = true → toVal (ofVal v) = v) ∧
    (∀ fs : List (String × CVal), noReservedFields fs = true →
        toValFields (ofValFields fs) = some fs) ∧
    (∀ _ : List (String × CVal), True) ∧
    (∀ xs : List CVal, noReservedItems xs = true → toValKids (ofValItems xs) = xs) := by
  refine @ofVal.mutual_induct
    (fun v => noReserved v = true → toVal (ofVal v) = v)
    (fun fs => noReservedFields fs = true → toValFields (ofValFields fs) = some fs)
    (fun _ => True)
    (fun xs => noReservedItems xs = true → toValKids (ofValItems xs) = xs)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;> intros <;>
    simp_all [ofVal, toVal, ofValItems, ofValFields, toValKids, toValFields,
      noReserved, noReservedItems, noReservedFields] <;>
    (try (split <;> simp_all))

/-- Canonical → XML → canonical is the identity. -/
theorem toVal_ofVal (v : CVal) (h : noReserved v = true) : toVal (ofVal v) = v :=
  toVal_ofVal_all.1 v h

/-! ## Well-formedness, and the complete `CVal ↔ String` XML codec -/

theorem toList_ne_nil {s : String} (h : s ≠ "") : s.toList ≠ [] := by
  intro hc
  apply h
  have : String.ofList s.toList = String.ofList [] := by rw [hc]
  simpa [String.ofList_toList] using this

theorem wfName_schema :
    wfName "null" = true ∧ wfName "bool" = true ∧ wfName "int" = true ∧
    wfName "dec" = true ∧ wfName "str" = true ∧ wfName "ref" = true ∧
    wfName "list" = true ∧ wfName "obj" = true ∧ wfName "field" = true ∧
    wfName "value" = true ∧ wfName "exponent" = true ∧ wfName "mantissa" = true ∧
    wfName "id" = true ∧ wfName "key" = true := by decide

theorem wfKids_of_elems : ∀ xs : List XNode,
    (∀ x ∈ xs, wf x = true ∧ isText x = false) → wfKids xs = true := by
  intro xs
  induction xs with
  | nil => intro _; rfl
  | cons a as ih =>
      intro h
      cases as with
      | nil => exact (h a (by simp)).1
      | cons b bs =>
          simp only [wfKids, Bool.and_eq_true]
          refine ⟨⟨(h a (by simp)).1, ?_⟩, ih (fun x hx => h x (by simp [hx]))⟩
          simp [(h a (by simp)).2]

theorem wf_ofVal_all :
    (∀ v : CVal, noReserved v = true → wf (ofVal v) = true ∧ isText (ofVal v) = false) ∧
    (∀ fs : List (String × CVal), noReservedFields fs = true →
        ∀ x ∈ ofValFields fs, wf x = true ∧ isText x = false) ∧
    (∀ _ : List (String × CVal), True) ∧
    (∀ xs : List CVal, noReservedItems xs = true →
        ∀ x ∈ ofValItems xs, wf x = true ∧ isText x = false) := by
  refine @ofVal.mutual_induct
    (fun v => noReserved v = true → wf (ofVal v) = true ∧ isText (ofVal v) = false)
    (fun fs => noReservedFields fs = true →
        ∀ x ∈ ofValFields fs, wf x = true ∧ isText x = false)
    (fun _ => True)
    (fun xs => noReservedItems xs = true →
        ∀ x ∈ ofValItems xs, wf x = true ∧ isText x = false)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;> intros <;>
    simp_all [ofVal, ofValItems, ofValFields, wf, isText, wfName_schema, wfKids,
      noReserved, noReservedItems, noReservedFields, wfKids_of_elems] <;>
    (try (apply wfKids_of_elems; simp_all)) <;>
    (try (simp_all [List.isEmpty_iff, toList_ne_nil]))

theorem wf_ofVal (v : CVal) (h : noReserved v = true) : wf (ofVal v) = true :=
  (wf_ofVal_all.1 v h).1


/-- Encode a canonical value as an XML document. -/
def encode (v : CVal) : String := renderDoc (ofVal v)

/-- Decode an XML document into a canonical value.  Any document the
schema does not recognise still decodes — into the reserved shape. -/
def decode (s : String) : Option CVal := (parseDoc s).map toVal

/-- **The XML codec is lossless** on the canonical values that do not
themselves use the reserved XML shape: rendering to XML text and parsing
it back returns exactly the value. -/
theorem decode_encode (v : CVal) (h : noReserved v = true) : decode (encode v) = some v := by
  have hw := wf_ofVal_all.1 v h
  cases hx : ofVal v with
  | text s => rw [hx] at hw; simp [isText] at hw
  | elem n a k =>
      rw [hx] at hw
      have hr := parseDoc_renderDoc (n := n) (attrs := a) (kids := k) hw.1
      have ht := toVal_ofVal v h
      rw [hx] at ht
      simp only [encode, decode, hx, hr, Option.map_some, ht]

end Xml
end Codec
end CfDeploy
