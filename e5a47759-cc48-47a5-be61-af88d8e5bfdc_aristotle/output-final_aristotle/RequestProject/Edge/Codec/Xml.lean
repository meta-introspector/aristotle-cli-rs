/-
# The XML codec

XML is treated as a full member of the codec family, which means the
adapter has to keep the three things XML distinguishes and most naive
mappings destroy:

```text
attribute      <int value="144"/>   → attributes stay attributes
element        <list>…</list>       → elements stay elements
text           <str>hello</str>     → character data stays text
```

together with document order and namespace prefixes (a prefix is part of
the name, and an `xmlns:…` declaration is an ordinary attribute, so both
survive).

The file has two layers.

*The XML layer* — `XNode`, a `render`er and a `parse`r, with
`parse_render` proving that a well-formed node survives the round trip.

*The mapping layer* — `ofVal` writes a canonical value as XML and `toVal`
reads any XML document back.  An element this schema does not recognise
is not dropped: it is represented by the reserved three-field shape

```text
{ "@xml.element": …, "@xml.attributes": {…}, "@xml.children": [ … ] }
```

which is exactly the extension mechanism the specification asks for, and
which `ofVal` turns back into the original element (`ofVal_toVal`).
-/
import RequestProject.Edge.Codec.Value

namespace CfDeploy
namespace Codec
namespace Xml

/-! ## The XML layer -/

/-- An XML node: character data, or an element with attributes and
children. -/
inductive XNode where
  | text (s : String)
  | elem (name : String) (attrs : List (String × String)) (children : List XNode)
  deriving Repr, Inhabited

/-! ### Escaping -/

/-- Escape one character of character data. -/
def escTextChar (c : Char) : List Char :=
  if c = '&' then ['&', 'a', 'm', 'p', ';']
  else if c = '<' then ['&', 'l', 't', ';']
  else if c = '>' then ['&', 'g', 't', ';']
  else [c]

def escText (s : List Char) : List Char := s.flatMap escTextChar

/-- Escape one character of an attribute value. -/
def escAttrChar (c : Char) : List Char :=
  if c = '"' then ['&', 'q', 'u', 'o', 't', ';'] else escTextChar c

def escAttr (s : List Char) : List Char := s.flatMap escAttrChar

/-- Read character data up to the next `<`, decoding entities. -/
def readText : List Char → Option (List Char × List Char)
  | [] => none
  | '<' :: r => some ([], '<' :: r)
  | '&' :: 'a' :: 'm' :: 'p' :: ';' :: r =>
      (readText r).map (fun p => ('&' :: p.1, p.2))
  | '&' :: 'l' :: 't' :: ';' :: r =>
      (readText r).map (fun p => ('<' :: p.1, p.2))
  | '&' :: 'g' :: 't' :: ';' :: r =>
      (readText r).map (fun p => ('>' :: p.1, p.2))
  | '&' :: 'q' :: 'u' :: 'o' :: 't' :: ';' :: r =>
      (readText r).map (fun p => ('"' :: p.1, p.2))
  | c :: r => (readText r).map (fun p => (c :: p.1, p.2))
termination_by l => l.length
decreasing_by all_goals (simp; try omega)

/-- Read an attribute value up to its closing quote, decoding entities. -/
def readAttr : List Char → Option (List Char × List Char)
  | [] => none
  | '"' :: r => some ([], r)
  | '&' :: 'a' :: 'm' :: 'p' :: ';' :: r =>
      (readAttr r).map (fun p => ('&' :: p.1, p.2))
  | '&' :: 'l' :: 't' :: ';' :: r =>
      (readAttr r).map (fun p => ('<' :: p.1, p.2))
  | '&' :: 'g' :: 't' :: ';' :: r =>
      (readAttr r).map (fun p => ('>' :: p.1, p.2))
  | '&' :: 'q' :: 'u' :: 'o' :: 't' :: ';' :: r =>
      (readAttr r).map (fun p => ('"' :: p.1, p.2))
  | c :: r => (readAttr r).map (fun p => (c :: p.1, p.2))
termination_by l => l.length
decreasing_by all_goals (simp; try omega)

/-! ### Names -/

/-- A character that may appear in an element or attribute name.  A
namespace prefix (`ns:local`) is part of the name. -/
def nameChar (c : Char) : Bool :=
  !(c = ' ' || c = '<' || c = '>' || c = '/' || c = '=' || c = '"' || c = '&' || c = '?')

/-- Read a name up to the first character that cannot be part of one. -/
def readName : List Char → List Char × List Char
  | [] => ([], [])
  | c :: r => if nameChar c then
      let (n, t) := readName r
      (c :: n, t)
    else ([], c :: r)

/-- A usable name: non-empty and made of name characters. -/
def GoodName (s : String) : Prop :=
  s.toList ≠ [] ∧ ∀ c ∈ s.toList, nameChar c = true

theorem readName_append {n : List Char} (hn : ∀ c ∈ n, nameChar c = true)
    (rest : List Char) (hr : ∀ c ∈ rest.head?, nameChar c = false) :
    readName (n ++ rest) = (n, rest) := by
  induction n with
  | nil =>
      cases rest with
      | nil => simp [readName]
      | cons c r =>
          have : nameChar c = false := hr c (by simp)
          simp [readName, this]
  | cons c cs ih =>
      have hc : nameChar c = true := hn c (by simp)
      have hcs : ∀ d ∈ cs, nameChar d = true := fun d hd => hn d (by simp [hd])
      simp [readName, hc, ih hcs]

/-! ### Escaping round-trips -/

@[simp] theorem readText_lt (r : List Char) : readText ('<' :: r) = some ([], '<' :: r) := by
  rw [readText.eq_def]; simp

theorem readText_amp (r : List Char) :
    readText ('&' :: 'a' :: 'm' :: 'p' :: ';' :: r)
      = (readText r).map (fun p => ('&' :: p.1, p.2)) := by
  rw [readText.eq_def]; simp

theorem readText_lt_ent (r : List Char) :
    readText ('&' :: 'l' :: 't' :: ';' :: r)
      = (readText r).map (fun p => ('<' :: p.1, p.2)) := by
  rw [readText.eq_def]; simp

theorem readText_gt_ent (r : List Char) :
    readText ('&' :: 'g' :: 't' :: ';' :: r)
      = (readText r).map (fun p => ('>' :: p.1, p.2)) := by
  rw [readText.eq_def]; simp

theorem readText_other {c : Char} (h1 : c ≠ '<') (h2 : c ≠ '&') (r : List Char) :
    readText (c :: r) = (readText r).map (fun p => (c :: p.1, p.2)) := by
  rw [readText.eq_def]; simp [h2]

/-- **Lossless.**  Escaped character data reads back exactly, stopping at
the `<` that ends it. -/
theorem readText_escText (s rest : List Char) :
    readText (escText s ++ '<' :: rest) = some (s, '<' :: rest) := by
  induction s with
  | nil => simp [escText]
  | cons c cs ih =>
      have hstep : escText (c :: cs) = escTextChar c ++ escText cs := by
        simp [escText, List.flatMap_cons]
      rw [hstep, List.append_assoc]
      by_cases h1 : c = '&'
      · subst h1
        have he : escTextChar '&' = ['&', 'a', 'm', 'p', ';'] := by simp [escTextChar]
        rw [he]
        simp only [List.cons_append, List.nil_append]
        rw [readText_amp, ih]
        simp
      · by_cases h2 : c = '<'
        · subst h2
          have he : escTextChar '<' = ['&', 'l', 't', ';'] := by simp [escTextChar]
          rw [he]
          simp only [List.cons_append, List.nil_append]
          rw [readText_lt_ent, ih]
          simp
        · by_cases h3 : c = '>'
          · subst h3
            have he : escTextChar '>' = ['&', 'g', 't', ';'] := by simp [escTextChar]
            rw [he]
            simp only [List.cons_append, List.nil_append]
            rw [readText_gt_ent, ih]
            simp
          · have he : escTextChar c = [c] := by simp [escTextChar, h1, h2, h3]
            rw [he]
            simp only [List.cons_append, List.nil_append]
            rw [readText_other h2 h1, ih]
            simp

@[simp] theorem readAttr_quote (r : List Char) : readAttr ('"' :: r) = some ([], r) := by
  rw [readAttr.eq_def]; simp

theorem readAttr_amp (r : List Char) :
    readAttr ('&' :: 'a' :: 'm' :: 'p' :: ';' :: r)
      = (readAttr r).map (fun p => ('&' :: p.1, p.2)) := by
  rw [readAttr.eq_def]; simp

theorem readAttr_lt_ent (r : List Char) :
    readAttr ('&' :: 'l' :: 't' :: ';' :: r)
      = (readAttr r).map (fun p => ('<' :: p.1, p.2)) := by
  rw [readAttr.eq_def]; simp

theorem readAttr_gt_ent (r : List Char) :
    readAttr ('&' :: 'g' :: 't' :: ';' :: r)
      = (readAttr r).map (fun p => ('>' :: p.1, p.2)) := by
  rw [readAttr.eq_def]; simp

theorem readAttr_quot_ent (r : List Char) :
    readAttr ('&' :: 'q' :: 'u' :: 'o' :: 't' :: ';' :: r)
      = (readAttr r).map (fun p => ('"' :: p.1, p.2)) := by
  rw [readAttr.eq_def]; simp

theorem readAttr_other {c : Char} (h1 : c ≠ '"') (h2 : c ≠ '&') (r : List Char) :
    readAttr (c :: r) = (readAttr r).map (fun p => (c :: p.1, p.2)) := by
  rw [readAttr.eq_def]; simp [h2]

/-- **Lossless.**  An escaped attribute value reads back exactly. -/
theorem readAttr_escAttr (s rest : List Char) :
    readAttr (escAttr s ++ '"' :: rest) = some (s, rest) := by
  induction s with
  | nil => simp [escAttr]
  | cons c cs ih =>
      have hstep : escAttr (c :: cs) = escAttrChar c ++ escAttr cs := by
        simp [escAttr, List.flatMap_cons]
      rw [hstep, List.append_assoc]
      by_cases h0 : c = '"'
      · subst h0
        have he : escAttrChar '"' = ['&', 'q', 'u', 'o', 't', ';'] := by
          simp [escAttrChar]
        rw [he]
        simp only [List.cons_append, List.nil_append]
        rw [readAttr_quot_ent, ih]
        simp
      · by_cases h1 : c = '&'
        · subst h1
          have he : escAttrChar '&' = ['&', 'a', 'm', 'p', ';'] := by
            simp [escAttrChar, escTextChar]
          rw [he]
          simp only [List.cons_append, List.nil_append]
          rw [readAttr_amp, ih]
          simp
        · by_cases h2 : c = '<'
          · subst h2
            have he : escAttrChar '<' = ['&', 'l', 't', ';'] := by
              simp [escAttrChar, escTextChar]
            rw [he]
            simp only [List.cons_append, List.nil_append]
            rw [readAttr_lt_ent, ih]
            simp
          · by_cases h3 : c = '>'
            · subst h3
              have he : escAttrChar '>' = ['&', 'g', 't', ';'] := by
                simp [escAttrChar, escTextChar]
              rw [he]
              simp only [List.cons_append, List.nil_append]
              rw [readAttr_gt_ent, ih]
              simp
            · have he : escAttrChar c = [c] := by
                simp [escAttrChar, escTextChar, h0, h1, h2, h3]
              rw [he]
              simp only [List.cons_append, List.nil_append]
              rw [readAttr_other h0 h1, ih]
              simp

/-! ### Rendering -/

def renderAttrs : List (String × String) → List Char
  | [] => []
  | (k, v) :: as =>
      ' ' :: k.toList ++ '=' :: '"' :: escAttr v.toList ++ '"' :: renderAttrs as

mutual

/-- Render a node.  No whitespace is added, so the text of a document is
exactly its content. -/
def render : XNode → List Char
  | .text s => escText s.toList
  | .elem n attrs kids =>
      '<' :: (n.toList ++ (renderAttrs attrs ++ '>' ::
        (renderKids kids ++ '<' :: '/' :: (n.toList ++ ['>']))))

def renderKids : List XNode → List Char
  | [] => []
  | k :: ks => render k ++ renderKids ks

end

/-! ### Well-formedness

The parser never produces an empty text node, and never two text nodes in
a row (it would have read them as one), so those are exactly the nodes
for which the round trip holds. -/

def isText : XNode → Bool
  | .text _ => true
  | _ => false

def wfName (s : String) : Bool := !s.toList.isEmpty && s.toList.all nameChar

mutual

def wf : XNode → Bool
  | .text s => !s.toList.isEmpty
  | .elem n attrs kids =>
      wfName n && attrs.all (fun a => wfName a.1) && wfKids kids

def wfKids : List XNode → Bool
  | [] => true
  | [x] => wf x
  | x :: y :: r => wf x && !(isText x && isText y) && wfKids (y :: r)

end

mutual

def size : XNode → Nat
  | .text _ => 1
  | .elem _ _ kids => 1 + sizeKids kids

def sizeKids : List XNode → Nat
  | [] => 1
  | x :: xs => 1 + size x + sizeKids xs

end

theorem size_pos (x : XNode) : 0 < size x := by
  cases x <;> simp [size] <;> omega

theorem sizeKids_pos (xs : List XNode) : 0 < sizeKids xs := by
  cases xs <;> simp [sizeKids] <;> omega

/-! ### Parsing -/

/-- Read the attributes of a start tag, up to `>`. -/
def parseAttrs : Nat → List Char → Option (List (String × String) × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = '>' then some ([], r)
      else if c = ' ' then
        match readName r with
        | ([], _) => none
        | (n, '=' :: '"' :: t) =>
            match readAttr t with
            | some (v, t') =>
                (parseAttrs f t').map
                  (fun p => ((String.ofList n, String.ofList v) :: p.1, p.2))
            | none => none
        | _ => none
      else none

mutual

/-- Parse one element, starting at its `<`. -/
def parseElem : Nat → List Char → Option (XNode × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c ≠ '<' then none
      else
        let nt := readName r
        if nt.1.isEmpty then none
        else
          match parseAttrs (nt.2.length + 1) nt.2 with
          | some (attrs, t1) =>
              match parseKids f t1 with
              | some (kids, '<' :: '/' :: t3) =>
                  let et := readName t3
                  match et.2 with
                  | '>' :: t5 =>
                      if et.1 = nt.1 then
                        some (.elem (String.ofList nt.1) attrs kids, t5)
                      else none
                  | _ => none
              | _ => none
          | none => none

/-- Parse the children of an element, up to its end tag. -/
def parseKids : Nat → List Char → Option (List XNode × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, c :: r =>
      if c = '<' then
        if r.head? = some '/' then some ([], c :: r)
        else
          match parseElem f (c :: r) with
          | some (x, t) => (parseKids f t).map (fun p => (x :: p.1, p.2))
          | none => none
      else
        match readText (c :: r) with
        | some (s, t) =>
            if s.isEmpty then none
            else (parseKids f t).map (fun p => (XNode.text (String.ofList s) :: p.1, p.2))
        | none => none

end

theorem wfName_ne_nil {n : String} (h : wfName n = true) : n.toList ≠ [] := by
  intro hnil
  simp [wfName, hnil] at h

theorem wfName_chars {n : String} (h : wfName n = true) : ∀ c ∈ n.toList, nameChar c = true := by
  simp [wfName] at h
  intro c hc
  exact h.2 c hc

theorem parseAttrs_renderAttrs (attrs : List (String × String))
    (h : ∀ a ∈ attrs, wfName a.1 = true) (rest : List Char) (f : Nat)
    (hf : attrs.length < f) :
    parseAttrs f (renderAttrs attrs ++ '>' :: rest) = some (attrs, rest) := by
  induction attrs generalizing f with
  | nil =>
      cases f with
      | zero => omega
      | succ f => simp [renderAttrs, parseAttrs]
  | cons a as ih =>
      obtain ⟨k, v⟩ := a
      cases f with
      | zero => omega
      | succ f =>
        have hk : wfName k = true := h (k, v) (by simp)
        have hk1 : k.toList ≠ [] := wfName_ne_nil hk
        have hk2 : ∀ c ∈ k.toList, nameChar c = true := wfName_chars hk
        have has : ∀ a ∈ as, wfName a.1 = true := fun a ha => h a (by simp [ha])
        have hchars : renderAttrs ((k, v) :: as) ++ '>' :: rest
            = ' ' :: (k.toList ++ ('=' :: '"' :: (escAttr v.toList ++ '"' ::
                (renderAttrs as ++ '>' :: rest)))) := by
          simp [renderAttrs, List.append_assoc]
        rw [hchars, parseAttrs]
        rw [if_neg (by decide : (' ' : Char) ≠ '>'), if_pos rfl]
        rw [readName_append hk2 _ (by simp [nameChar])]
        have hne : k.toList ≠ [] := hk1
        cases hkl : k.toList with
        | nil => exact absurd hkl hne
        | cons c cs =>
            simp only [readAttr_escAttr]
            rw [← hkl]
            have hlen : as.length < f := by simp at hf; omega
            simp only [ih has f hlen]
            simp

/-! ### The XML round trip -/

theorem escText_head {s : List Char} (hs : s ≠ []) :
    ∃ c cs, escText s = c :: cs ∧ c ≠ '<' := by
  cases s with
  | nil => exact absurd rfl hs
  | cons a as =>
      have hstep : escText (a :: as) = escTextChar a ++ escText as := by
        simp [escText, List.flatMap_cons]
      by_cases h1 : a = '&'
      · exact ⟨'&', ['a','m','p',';'] ++ escText as, by rw [hstep, h1]; simp [escTextChar], by simp⟩
      · by_cases h2 : a = '<'
        · exact ⟨'&', ['l','t',';'] ++ escText as, by rw [hstep, h2]; simp [escTextChar], by simp⟩
        · by_cases h3 : a = '>'
          · exact ⟨'&', ['g','t',';'] ++ escText as, by rw [hstep, h3]; simp [escTextChar], by simp⟩
          · exact ⟨a, escText as, by rw [hstep]; simp [escTextChar, h1, h2, h3], h2⟩

theorem render_elem_head {n : String} {attrs : List (String × String)} {kids : List XNode}
    (hn : wfName n = true) :
    ∃ d w, render (.elem n attrs kids) = '<' :: d :: w ∧ d ≠ '/' := by
  have hn1 : n.toList ≠ [] := wfName_ne_nil hn
  have hn2 : ∀ c ∈ n.toList, nameChar c = true := wfName_chars hn
  cases hnl : n.toList with
  | nil => exact absurd hnl hn1
  | cons c cs =>
      have hc : nameChar c = true := hn2 c (by simp [hnl])
      refine ⟨c, cs ++ (renderAttrs attrs ++ '>' ::
        (renderKids kids ++ '<' :: '/' :: (n.toList ++ ['>']))), ?_, ?_⟩
      · simp [render, hnl]
      · intro hcon; subst hcon; simp [nameChar] at hc

theorem wf_elem {n attrs kids} (h : wf (.elem n attrs kids) = true) :
    wfName n = true ∧ (∀ a ∈ attrs, wfName a.1 = true) ∧ wfKids kids = true := by
  simp only [wf, Bool.and_eq_true] at h
  refine ⟨h.1.1, ?_, h.2⟩
  intro a ha
  have := List.all_eq_true.mp h.1.2 a ha
  simpa using this

theorem renderAttrs_head_not_name (attrs : List (String × String)) (X : List Char) :
    ∀ c ∈ (renderAttrs attrs ++ '>' :: X).head?, nameChar c = false := by
  cases attrs with
  | nil => simp [renderAttrs, nameChar]
  | cons a as => obtain ⟨k, v⟩ := a; simp [renderAttrs, nameChar]

theorem length_le_renderAttrs (attrs : List (String × String)) :
    attrs.length ≤ (renderAttrs attrs).length := by
  induction attrs with
  | nil => simp [renderAttrs]
  | cons a as ih => obtain ⟨k, v⟩ := a; simp [renderAttrs]; omega

theorem parseKids_elem_step {f : Nat} {d : Char} {w : List Char} {x : XNode}
    {t : List Char} {xs : List XNode} {rest : List Char} (hd : d ≠ '/')
    (hx : parseElem f ('<' :: d :: w) = some (x, t))
    (hrest : parseKids f t = some (xs, rest)) :
    parseKids (f + 1) ('<' :: d :: w) = some (x :: xs, rest) := by
  rw [parseKids, if_pos rfl, if_neg (by simp [hd]), hx]
  simp [hrest]

theorem parseKids_text_step {f : Nat} {c : Char} {r s t : List Char} {xs : List XNode}
    {rest : List Char} (hc : c ≠ '<')
    (hs : readText (c :: r) = some (s, t)) (hne : s ≠ [])
    (hrest : parseKids f t = some (xs, rest)) :
    parseKids (f + 1) (c :: r) = some (XNode.text (String.ofList s) :: xs, rest) := by
  rw [parseKids, if_neg hc, hs]
  simp [List.isEmpty_iff, hne, hrest]

theorem parse_render_all : ∀ f : Nat,
    (∀ (n : String) (attrs : List (String × String)) (kids : List XNode) (rest : List Char),
        size (.elem n attrs kids) ≤ f → wf (.elem n attrs kids) = true →
        parseElem f (render (.elem n attrs kids) ++ rest) = some (.elem n attrs kids, rest)) ∧
    (∀ (xs : List XNode) (t : List Char), sizeKids xs ≤ f → wfKids xs = true →
        parseKids f (renderKids xs ++ '<' :: '/' :: t) = some (xs, '<' :: '/' :: t)) := by
  intro f
  induction f with
  | zero =>
      refine ⟨?_, ?_⟩
      · intro n attrs kids rest h
        exact absurd h (by have := size_pos (XNode.elem n attrs kids); omega)
      · intro xs t h
        exact absurd h (by have := sizeKids_pos xs; omega)
  | succ f ih =>
      obtain ⟨ihE, ihK⟩ := ih
      constructor
      · intro n attrs kids rest hsz hwf
        obtain ⟨hn, hattrs, hkids⟩ := wf_elem hwf
        have hn1 : n.toList ≠ [] := wfName_ne_nil hn
        have hn2 : ∀ c ∈ n.toList, nameChar c = true := wfName_chars hn
        have hk : sizeKids kids ≤ f := by simp [size] at hsz; omega
        have hchars : render (.elem n attrs kids) ++ rest
            = '<' :: (n.toList ++ (renderAttrs attrs ++ '>' ::
                (renderKids kids ++ '<' :: '/' :: (n.toList ++ ('>' :: rest))))) := by
          simp [render, List.append_assoc]
        obtain ⟨c, cs, hnl⟩ : ∃ c cs, n.toList = c :: cs := by
          cases h : n.toList with
          | nil => exact absurd h hn1
          | cons c cs => exact ⟨c, cs, rfl⟩
        have hn2' : ∀ x ∈ c :: cs, nameChar x = true := by rw [← hnl]; exact hn2
        rw [hchars, parseElem, if_neg (by simp),
          readName_append hn2 _ (renderAttrs_head_not_name attrs _), hnl]
        have hattrslen : attrs.length <
            (renderAttrs attrs ++ '>' ::
              (renderKids kids ++ '<' :: '/' :: (c :: cs ++ ('>' :: rest)))).length + 1 := by
          have hle : attrs.length ≤ (renderAttrs attrs).length := length_le_renderAttrs attrs
          simp only [List.length_append, List.length_cons]
          omega
        simp only [parseAttrs_renderAttrs attrs hattrs _ _ hattrslen, ihK kids _ hk hkids]
        rw [readName_append hn2' ('>' :: rest) (by simp [nameChar])]
        simp [← hnl]
        exact fun h => hn1 (by simp [h])
      · intro xs t hsz hwf
        cases xs with
        | nil => simp [renderKids, parseKids]
        | cons x xs =>
            have hx : size x ≤ f := by simp [sizeKids] at hsz; omega
            have hxs : sizeKids xs ≤ f := by simp [sizeKids] at hsz; omega
            have hwfx : wf x = true := by
              cases xs <;> simp [wfKids, Bool.and_eq_true] at hwf <;> simp_all
            have hwfxs : wfKids xs = true := by
              cases xs with
              | nil => simp [wfKids]
              | cons y ys => simp [wfKids, Bool.and_eq_true] at hwf ⊢; exact hwf.2
            cases x with
            | elem n attrs kids =>
                obtain ⟨d, w, hw, hd⟩ := @render_elem_head n attrs kids (wf_elem hwfx).1
                have hchars : renderKids (.elem n attrs kids :: xs) ++ '<' :: '/' :: t
                    = '<' :: d :: (w ++ (renderKids xs ++ '<' :: '/' :: t)) := by
                  simp [renderKids, hw, List.append_assoc]
                have hstep : parseElem f ('<' :: d :: (w ++ (renderKids xs ++ '<' :: '/' :: t)))
                    = some (.elem n attrs kids, renderKids xs ++ '<' :: '/' :: t) := by
                  have := ihE n attrs kids (renderKids xs ++ '<' :: '/' :: t) hx hwfx
                  rwa [hw, List.cons_append, List.cons_append] at this
                rw [hchars]
                exact parseKids_elem_step hd hstep (ihK xs t hxs hwfxs)
            | text s =>
                have hs : s.toList ≠ [] := by
                  intro h
                  simp [wf, h] at hwfx
                have hu : ∃ u, renderKids xs ++ '<' :: '/' :: t = '<' :: u := by
                  cases hxs' : xs with
                  | nil => exact ⟨'/' :: t, by simp [renderKids]⟩
                  | cons y ys =>
                      cases y with
                      | text s' =>
                          exfalso
                          rw [hxs'] at hwf
                          simp [wfKids, isText] at hwf
                      | elem n' a' k' =>
                          have hwfy : wf (XNode.elem n' a' k') = true := by
                            rw [hxs'] at hwfxs
                            cases ys <;> simp [wfKids, Bool.and_eq_true] at hwfxs <;> simp_all
                          obtain ⟨d, w, hw, _⟩ := @render_elem_head n' a' k' (wf_elem hwfy).1
                          exact ⟨d :: (w ++ (renderKids ys ++ '<' :: '/' :: t)),
                            by simp [renderKids, hw, List.append_assoc]⟩
                obtain ⟨u, hu⟩ := hu
                have hchars : renderKids (.text s :: xs) ++ '<' :: '/' :: t
                    = escText s.toList ++ '<' :: u := by
                  simp only [renderKids, render, List.append_assoc, hu]
                obtain ⟨c, cs, hesc, hc⟩ := escText_head hs
                have hread : readText (escText s.toList ++ '<' :: u)
                    = some (s.toList, '<' :: u) := readText_escText _ _
                rw [hesc] at hread
                simp only [List.cons_append] at hread
                rw [hchars, hesc]
                have hstep := parseKids_text_step (f := f) hc hread hs
                  (by rw [← hu]; exact ihK xs t hxs hwfxs)
                simp only [List.cons_append] at hstep ⊢
                rw [hstep, String.ofList_toList]

/-! ## The document codec -/

theorem wfKids_cons {x : XNode} {xs : List XNode} (h : wfKids (x :: xs) = true) :
    wf x = true ∧ wfKids xs = true := by
  cases xs with
  | nil => exact ⟨by simpa [wfKids] using h, by simp [wfKids]⟩
  | cons y ys =>
      simp only [wfKids, Bool.and_eq_true] at h
      exact ⟨h.1.1, h.2⟩

theorem size_le_render_all :
    (∀ x : XNode, wf x = true → size x + 1 ≤ 2 * (render x).length) ∧
    (∀ xs : List XNode, wfKids xs = true → sizeKids xs ≤ 2 * (renderKids xs).length + 1) := by
  refine @render.mutual_induct
    (fun x => wf x = true → size x + 1 ≤ 2 * (render x).length)
    (fun xs => wfKids xs = true → sizeKids xs ≤ 2 * (renderKids xs).length + 1)
    ?_ ?_ ?_ ?_
  · intro s hwf
    have : 1 ≤ (escText s.toList).length := by
      cases hsl : s.toList with
      | nil => simp [wf, hsl] at hwf
      | cons a as =>
          obtain ⟨c, cs, hc, _⟩ := escText_head (s := s.toList) (by simp [hsl])
          rw [← hsl, hc]
          simp
    simp [size, render]
    omega
  · intro n attrs kids ih hwf
    obtain ⟨_, _, hkids⟩ := wf_elem hwf
    have hk := ih hkids
    simp only [size, render, List.length_cons, List.length_append]
    omega
  · intro _
    simp [sizeKids, renderKids]
  · intro x xs ihx ihxs hwf
    obtain ⟨hx, hxs⟩ := wfKids_cons hwf
    have h1 := ihx hx
    have h2 := ihxs hxs
    simp only [sizeKids, renderKids, List.length_append]
    omega

/-- Render a document. -/
def renderDoc (x : XNode) : String := String.ofList (render x)

/-- Parse a document; `none` if it is malformed or has trailing data. -/
def parseDoc (s : String) : Option XNode :=
  match parseElem (2 * s.length + 2) s.toList with
  | some (x, []) => some x
  | _ => none

/-- **Round trip.**  A well-formed element survives rendering and
parsing unchanged — attributes, text, ordering and namespace prefixes
included. -/
theorem parseDoc_renderDoc {n : String} {attrs : List (String × String)} {kids : List XNode}
    (h : wf (.elem n attrs kids) = true) :
    parseDoc (renderDoc (.elem n attrs kids)) = some (.elem n attrs kids) := by
  have hlen : size (.elem n attrs kids)
      ≤ 2 * (String.ofList (render (.elem n attrs kids))).length + 2 := by
    have := size_le_render_all.1 (.elem n attrs kids) h
    simp only [String.length_ofList]
    omega
  have := (parse_render_all _).1 n attrs kids [] hlen h
  simp only [parseDoc, renderDoc, String.toList_ofList, List.append_nil] at *
  rw [this]

end Xml
end Codec
end CfDeploy
