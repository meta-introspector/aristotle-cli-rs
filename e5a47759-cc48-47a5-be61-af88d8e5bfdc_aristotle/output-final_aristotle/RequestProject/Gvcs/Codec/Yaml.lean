import RequestProject.Gvcs.Codec.Doc

/-!
# The YAML codec

The YAML projection is written in flow style, which is ordinary YAML and is what makes
the projection machine-checkable here:

```yaml
{tag: "proof", attrs: {"id": "proof-001", }, kids: [{tag: "status", attrs: {}, text: "VALID"}, ]}
```

Scalars are double-quoted, so an empty scalar is `""` and stays a string rather than
becoming a YAML null; a trailing `, ` inside a flow collection is permitted by YAML and
keeps the grammar uniform, which is what lets the parser be a single loop.

`Yaml.decode_encode` is the round-trip theorem.
-/

namespace LifeTrac.Codec
namespace Yaml

/-! ## Rendering -/

/-- `{tag: ` -/
def kTag : List Char := ['{', 't', 'a', 'g', ':', ' ']
/-- `, attrs: {` -/
def kAttrs : List Char := [',', ' ', 'a', 't', 't', 'r', 's', ':', ' ', '{']
/-- `}, text: ` -/
def kText : List Char := ['}', ',', ' ', 't', 'e', 'x', 't', ':', ' ']
/-- `}, kids: [` -/
def kKids : List Char := ['}', ',', ' ', 'k', 'i', 'd', 's', ':', ' ', '[']
/-- `}` closing a leaf mapping. -/
def kEndLeaf : List Char := ['}']
/-- `]}` closing a node mapping. -/
def kEndNode : List Char := [']', '}']
/-- `: ` between a key and its value. -/
def kColon : List Char := [':', ' ']
/-- `, ` between collection items. -/
def kComma : List Char := [',', ' ']

/-- Render a scalar as a double-quoted YAML string. -/
def renderAtom (s : String) : List Char := ('"' :: (esc s).toList) ++ ['"']

/-- Render the entries of a flow mapping. -/
def renderAttrs : List (String × String) → List Char
  | [] => []
  | (k, v) :: t => renderAtom k ++ (kColon ++ renderAtom v) ++ (kComma ++ renderAttrs t)

mutual

/-- Render a document as flow-style YAML. -/
def renderDoc : Doc → List Char
  | .leaf tg as s =>
      kTag ++ renderAtom tg ++ kAttrs ++ renderAttrs as ++ kText ++ renderAtom s ++ kEndLeaf
  | .node tg as ks =>
      kTag ++ renderAtom tg ++ kAttrs ++ renderAttrs as ++ kKids ++ renderDocs ks ++ kEndNode

/-- Render a list of documents as a flow sequence body. -/
def renderDocs : List Doc → List Char
  | [] => []
  | d :: t => renderDoc d ++ (kComma ++ renderDocs t)

end

/-- Encode a document as YAML text. -/
def encode (d : Doc) : String := String.ofList (renderDoc d)

/-! ## Parsing -/

/-- Parse a double-quoted scalar. -/
def parseAtom : List Char → Option (String × List Char)
  | '"' :: t =>
      let r := unesc t
      match r.2 with
      | '"' :: t2 => some (r.1, t2)
      | _ => none
  | _ => none

mutual

/-- Parse one document. -/
def parseDoc : Nat → List Char → Option (Doc × List Char)
  | 0, _ => none
  | f + 1, l =>
      match expect kTag l with
      | none => none
      | some l1 =>
          match parseAtom l1 with
          | none => none
          | some (tg, l2) =>
              match expect kAttrs l2 with
              | none => none
              | some l3 =>
                  match parseAttrs f l3 with
                  | none => none
                  | some (as, l4) =>
                      match expect kText l4 with
                      | some l5 =>
                          match parseAtom l5 with
                          | none => none
                          | some (s, l6) =>
                              match expect kEndLeaf l6 with
                              | none => none
                              | some l7 => some (.leaf tg as s, l7)
                      | none =>
                          match expect kKids l4 with
                          | none => none
                          | some l5 =>
                              match parseKids f l5 with
                              | none => none
                              | some (ks, l6) =>
                                  match expect kEndNode l6 with
                                  | none => none
                                  | some l7 => some (.node tg as ks, l7)

/-- Parse the entries of a flow mapping. -/
def parseAttrs : Nat → List Char → Option (List (String × String) × List Char)
  | 0, _ => none
  | f + 1, l =>
      if l.head? = some '}' then some ([], l)
      else
        match parseAtom l with
        | none => none
        | some (k, l1) =>
            match expect kColon l1 with
            | none => none
            | some l2 =>
                match parseAtom l2 with
                | none => none
                | some (v, l3) =>
                    match expect kComma l3 with
                    | none => none
                    | some l4 =>
                        match parseAttrs f l4 with
                        | none => none
                        | some (as, l5) => some ((k, v) :: as, l5)

/-- Parse the items of a flow sequence. -/
def parseKids : Nat → List Char → Option (List Doc × List Char)
  | 0, _ => none
  | f + 1, l =>
      if l.head? = some ']' then some ([], l)
      else
        match parseDoc f l with
        | none => none
        | some (d, l1) =>
            match expect kComma l1 with
            | none => none
            | some l2 =>
                match parseKids f l2 with
                | none => none
                | some (ks, l3) => some (d :: ks, l3)

end

/-- Decode YAML text into a document; the whole input must be consumed. -/
def decode (s : String) : Option Doc :=
  match parseDoc (s.toList.length + 1) s.toList with
  | some (d, []) => some d
  | _ => none

/-! ## Parser steps -/

theorem parseAtom_render (s : String) (rest : List Char) :
    parseAtom (renderAtom s ++ rest) = some (s, rest) := by
  simp only [renderAtom, List.cons_append, List.append_assoc,
    List.nil_append, parseAtom]
  rw [unesc_esc_append s ('"' :: rest) (by
    simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
    rintro c rfl; decide)]
  rfl

theorem renderAtom_head (s : String) (rest : List Char) :
    (renderAtom s ++ rest).head? = some '"' := by
  simp [renderAtom]

theorem renderAttrs_cons_head (k v : String) (t : List (String × String)) (rest : List Char) :
    (renderAttrs ((k, v) :: t) ++ rest).head? = some '"' := by
  simp only [renderAttrs, List.append_assoc]
  exact renderAtom_head k _

theorem renderDoc_head (d : Doc) (rest : List Char) :
    (renderDoc d ++ rest).head? = some '{' := by
  cases d <;> simp [renderDoc, kTag]

theorem expect_kText_kKids (X : List Char) : expect kText (kKids ++ X) = none := rfl

theorem renderAttrs_length_cons (k v : String) (t : List (String × String)) :
    (renderAttrs ((k, v) :: t)).length
      = 8 + (esc k).toList.length + (esc v).toList.length + (renderAttrs t).length := by
  simp [renderAttrs, renderAtom, kColon, kComma]
  omega

theorem renderDocs_length_cons (d : Doc) (t : List Doc) :
    (renderDocs (d :: t)).length = (renderDoc d).length + 2 + (renderDocs t).length := by
  simp [renderDocs, kComma]
  omega

theorem renderDoc_length_pos (d : Doc) : 1 ≤ (renderDoc d).length := by
  cases d <;> simp [renderDoc, kTag]

/-! ## Round trip -/

/-- Soundness of the YAML parser against the renderer. -/
theorem parse_render (f : Nat) :
    (∀ d rest, 1 + (renderDoc d).length ≤ f →
        parseDoc f (renderDoc d ++ rest) = some (d, rest))
      ∧ (∀ as rest, 2 + (renderAttrs as).length ≤ f → rest.head? = some '}' →
        parseAttrs f (renderAttrs as ++ rest) = some (as, rest))
      ∧ (∀ ks rest, 2 + (renderDocs ks).length ≤ f → rest.head? = some ']' →
        parseKids f (renderDocs ks ++ rest) = some (ks, rest)) := by
  induction f with
  | zero =>
    refine ⟨fun d rest h => by omega, fun as rest h _ => by omega, fun ks rest h _ => by omega⟩
  | succ f ih =>
    obtain ⟨ihD, ihA, ihK⟩ := ih
    refine ⟨?_, ?_, ?_⟩
    · -- documents
      intro d rest hlen
      cases d with
      | leaf tg as s =>
        have hA : 2 + (renderAttrs as).length ≤ f := by
          simp only [renderDoc, kTag, kAttrs, kText, kEndLeaf, renderAtom, List.length_append,
            List.length_cons, List.length_nil] at hlen
          omega
        show parseDoc (f + 1) (renderDoc (.leaf tg as s) ++ rest) = _
        simp only [renderDoc, List.append_assoc]
        rw [parseDoc]
        simp only [expect_append, parseAtom_render]
        rw [ihA as (kText ++ (renderAtom s ++ (kEndLeaf ++ rest))) hA (by simp [kText])]
        simp only [expect_append, parseAtom_render]
      | node tg as ks =>
        have hA : 2 + (renderAttrs as).length ≤ f := by
          simp only [renderDoc, kTag, kAttrs, kKids, kEndNode, renderAtom, List.length_append,
            List.length_cons, List.length_nil] at hlen
          omega
        have hK : 2 + (renderDocs ks).length ≤ f := by
          simp only [renderDoc, kTag, kAttrs, kKids, kEndNode, renderAtom, List.length_append,
            List.length_cons, List.length_nil] at hlen
          omega
        show parseDoc (f + 1) (renderDoc (.node tg as ks) ++ rest) = _
        simp only [renderDoc, List.append_assoc]
        rw [parseDoc]
        simp only [expect_append, parseAtom_render]
        rw [ihA as (kKids ++ (renderDocs ks ++ (kEndNode ++ rest))) hA (by simp [kKids])]
        simp only [expect_kText_kKids, expect_append]
        rw [ihK ks (kEndNode ++ rest) hK (by simp [kEndNode])]
        simp only [expect_append]
    · -- attributes
      intro as rest hlen hrest
      cases as with
      | nil =>
        simp only [renderAttrs, List.nil_append]
        rw [parseAttrs, if_pos hrest]
      | cons kv t =>
        obtain ⟨k, v⟩ := kv
        have hlen' : 2 + (renderAttrs t).length ≤ f := by
          rw [renderAttrs_length_cons] at hlen; omega
        rw [parseAttrs, if_neg (by rw [renderAttrs_cons_head]; simp)]
        simp only [renderAttrs, List.append_assoc]
        simp only [parseAtom_render, expect_append]
        rw [ihA t rest hlen' hrest]
    · -- children
      intro ks rest hlen hrest
      cases ks with
      | nil =>
        simp only [renderDocs, List.nil_append]
        rw [parseKids, if_pos hrest]
      | cons d t =>
        have hd : 1 + (renderDoc d).length ≤ f := by
          rw [renderDocs_length_cons] at hlen; omega
        have ht : 2 + (renderDocs t).length ≤ f := by
          rw [renderDocs_length_cons] at hlen
          have := renderDoc_length_pos d
          omega
        rw [parseKids, if_neg (by rw [show renderDocs (d :: t) ++ rest
            = renderDoc d ++ (kComma ++ renderDocs t ++ rest) by
              simp only [renderDocs, List.append_assoc], renderDoc_head]; simp)]
        simp only [renderDocs, List.append_assoc]
        rw [ihD d (kComma ++ (renderDocs t ++ rest)) hd]
        simp only [expect_append]
        rw [ihK t rest ht hrest]

/-- **The YAML codec round-trips.** -/
theorem decode_encode (d : Doc) : decode (encode d) = some d := by
  have h := (parse_render ((renderDoc d).length + 1)).1 d [] (by omega)
  simp only [List.append_nil] at h
  simp only [decode, encode, String.toList_ofList, h]

end Yaml
end LifeTrac.Codec
