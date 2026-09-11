import RequestProject.Gvcs.Codec.Doc

/-!
# The XML codec

```xml
<proof id="proof-001" kind="theorem"><inputs><input id="n">144</input></inputs></proof>
```

The mapping is the obvious one, and it keeps the three XML notions the specification
asks to be kept apart (§13):

* **attributes** are rendered as `key="value"` on the element and read back in order;
* **elements** are rendered as nested elements, in order;
* **text** is rendered as the character content of an element.

An element with no children is written self-closing, `<tag />`; an element whose
character content is empty is written `<tag></tag>`, so the two are distinguishable and
neither collapses into the other.  Namespace-qualified names round-trip like any other
name, since `:` is escaped inside an atom rather than being structural.

`Xml.decode_encode` is the round-trip theorem.
-/

namespace LifeTrac.Codec
namespace Xml

/-! ## Rendering -/

/-- Render attributes as ` key="value"`, in order. -/
def renderAttrs : List (String × String) → List Char
  | [] => []
  | (k, v) :: t =>
      (' ' :: (esc k).toList) ++ ('=' :: '"' :: (esc v).toList) ++ ('"' :: renderAttrs t)

/-- Render a closing tag. -/
def renderClose (tg : String) : List Char := ('<' :: '/' :: (esc tg).toList) ++ ['>']

mutual

/-- Render a document as XML. -/
def renderDoc : Doc → List Char
  | .leaf tg as s =>
      ('<' :: (esc tg).toList) ++ renderAttrs as ++ ('>' :: (esc s).toList) ++ renderClose tg
  | .node tg as ks =>
      match ks with
      | [] => ('<' :: (esc tg).toList) ++ renderAttrs as ++ [' ', '/', '>']
      | _ :: _ =>
          ('<' :: (esc tg).toList) ++ renderAttrs as ++ ('>' :: renderDocs ks) ++ renderClose tg

/-- Render a list of documents, in order. -/
def renderDocs : List Doc → List Char
  | [] => []
  | d :: t => renderDoc d ++ renderDocs t

end

/-- Encode a document as XML text. -/
def encode (d : Doc) : String := String.ofList (renderDoc d)

/-! ## Parsing -/

/-- Parse a closing tag for the given element name. -/
def parseClose (tg : String) : List Char → Option (List Char)
  | '<' :: '/' :: t =>
      let r := unesc t
      if r.1 = tg then
        match r.2 with
        | '>' :: t2 => some t2
        | _ => none
      else none
  | _ => none

mutual

/-- Parse one element. -/
def parseDoc : Nat → List Char → Option (Doc × List Char)
  | 0, _ => none
  | f + 1, l =>
      match l with
      | '<' :: t =>
          let tg := unesc t
          match parseAttrs f tg.2 with
          | none => none
          | some (as, t2) =>
              match t2 with
              | ' ' :: '/' :: '>' :: t3 => some (.node tg.1 as [], t3)
              | '>' :: t3 =>
                  if t3.head? = some '<' then
                    if t3.tail.head? = some '/' then
                      match parseClose tg.1 t3 with
                      | some t4 => some (.leaf tg.1 as "", t4)
                      | none => none
                    else
                      match parseKids f t3 with
                      | none => none
                      | some (ks, t4) =>
                          match parseClose tg.1 t4 with
                          | some t5 => some (.node tg.1 as ks, t5)
                          | none => none
                  else
                    let s := unesc t3
                    match parseClose tg.1 s.2 with
                    | some t4 => some (.leaf tg.1 as s.1, t4)
                    | none => none
              | _ => none
      | _ => none

/-- Parse a run of attributes. -/
def parseAttrs : Nat → List Char → Option (List (String × String) × List Char)
  | 0, _ => none
  | f + 1, l =>
      match l with
      | ' ' :: '/' :: u => some ([], ' ' :: '/' :: u)
      | ' ' :: t =>
          let k := unesc t
          match k.2 with
          | '=' :: '"' :: t2 =>
              let v := unesc t2
              match v.2 with
              | '"' :: t3 =>
                  match parseAttrs f t3 with
                  | none => none
                  | some (as, t4) => some ((k.1, v.1) :: as, t4)
              | _ => none
          | _ => none
      | _ => some ([], l)

/-- Parse a run of child elements. -/
def parseKids : Nat → List Char → Option (List Doc × List Char)
  | 0, _ => none
  | f + 1, l =>
      if l.head? = some '<' ∧ l.tail.head? ≠ some '/' then
        match parseDoc f l with
        | none => none
        | some (d, t1) =>
            match parseKids f t1 with
            | none => none
            | some (ds, t2) => some (d :: ds, t2)
      else some ([], l)

end

/-- Decode XML text into a document; the whole input must be consumed. -/
def decode (s : String) : Option Doc :=
  match parseDoc (s.toList.length + 1) s.toList with
  | some (d, []) => some d
  | _ => none

/-! ## Shape of rendered text -/

theorem renderAttrs_head_cases {P : Char → Prop} (as : List (String × String))
    (X : List Char) (hX : ∀ c ∈ X.head?, P c) (hspace : P ' ') :
    ∀ c ∈ (renderAttrs as ++ X).head?, P c := by
  cases as with
  | nil => simpa [renderAttrs] using hX
  | cons kv t =>
    obtain ⟨k, v⟩ := kv
    intro c hc
    rw [head?_append_some (by simp [renderAttrs] : (renderAttrs ((k, v) :: t)).head? = some ' ')]
      at hc
    simp only [Option.mem_def, Option.some.injEq] at hc
    exact hc ▸ hspace

theorem renderDoc_length_pos (d : Doc) : 1 ≤ (renderDoc d).length := by
  cases d with
  | leaf tg as s => simp [renderDoc]
  | node tg as ks => cases ks <;> simp [renderDoc]

theorem renderDocs_length_cons (d : Doc) (t : List Doc) :
    (renderDocs (d :: t)).length = (renderDoc d).length + (renderDocs t).length := by
  simp [renderDocs]

theorem renderAttrs_length_cons (k v : String) (t : List (String × String)) :
    (renderAttrs ((k, v) :: t)).length
      = 4 + (esc k).toList.length + (esc v).toList.length + (renderAttrs t).length := by
  simp [renderAttrs]
  omega

/-- The first character of a rendered atom, when there is one, is an atom character. -/
theorem esc_head_atom {s : String} {x : Char} {xs : List Char} (h : (esc s).toList = x :: xs) :
    isAtomChar x = true := by
  have hmem : x ∈ escChars s.toList := by
    have : x ∈ (esc s).toList := by rw [h]; simp
    simpa [esc] using this
  exact escChars_atomChars _ x hmem

theorem esc_toList_eq_nil {s : String} (h : (esc s).toList = []) : s = "" := by
  have hemp : escChars s.toList = [] := by simpa [esc] using h
  have hnil : s.toList = [] := by
    cases hl : s.toList with
    | nil => rfl
    | cons x xs =>
      rw [hl] at hemp
      simp only [escChars, List.flatMap_cons] at hemp
      have h1 : escChar x = [] := (List.append_eq_nil_iff.mp hemp).1
      cases hx : isSafeChar x <;> simp [escChar, hx] at h1
  have := congrArg String.ofList hnil
  rwa [String.ofList_toList] at this

/-- A rendered element begins with `<`, and its second character is never `/`. -/
theorem renderDoc_cons (d : Doc) :
    ∃ u, renderDoc d = '<' :: u ∧ u.head? ≠ some '/' := by
  have hesc : ∀ (s : String) (X : List Char), X.head? ≠ some '/' →
      ((esc s).toList ++ X).head? ≠ some '/' := by
    intro s X hX
    cases hl : (esc s).toList with
    | nil => simpa using hX
    | cons x xs =>
      simp only [List.cons_append, List.head?_cons, ne_eq, Option.some.injEq]
      intro hx
      have := esc_head_atom hl
      rw [hx] at this
      simp [isAtomChar, isSafeChar, escMark] at this
  cases d with
  | leaf tg as s =>
    refine ⟨(esc tg).toList ++ (renderAttrs as ++ (('>' :: (esc s).toList) ++ renderClose tg)),
      by simp [renderDoc], ?_⟩
    refine hesc tg _ ?_
    intro hcontra
    exact absurd (renderAttrs_head_cases (P := fun c => c ≠ '/') as _
      (by simp only [List.cons_append, List.head?_cons, Option.mem_def, Option.some.injEq]
          rintro c rfl; decide) (by decide) '/' hcontra) (by simp)
  | node tg as ks =>
    cases ks with
    | nil =>
      refine ⟨(esc tg).toList ++ (renderAttrs as ++ [' ', '/', '>']), by simp [renderDoc], ?_⟩
      refine hesc tg _ ?_
      intro hcontra
      exact absurd (renderAttrs_head_cases (P := fun c => c ≠ '/') as _
        (by simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
            rintro c rfl; decide) (by decide) '/' hcontra) (by simp)
    | cons d0 t0 =>
      refine ⟨(esc tg).toList ++ (renderAttrs as ++
        (('>' :: renderDocs (d0 :: t0)) ++ renderClose tg)), by simp [renderDoc], ?_⟩
      refine hesc tg _ ?_
      intro hcontra
      exact absurd (renderAttrs_head_cases (P := fun c => c ≠ '/') as _
        (by simp only [List.cons_append, List.head?_cons, Option.mem_def, Option.some.injEq]
            rintro c rfl; decide) (by decide) '/' hcontra) (by simp)

/-! ## Parser steps -/

theorem parseClose_render (tg : String) (rest : List Char) :
    parseClose tg ('<' :: '/' :: ((esc tg).toList ++ '>' :: rest)) = some rest := by
  simp only [parseClose]
  rw [unesc_esc_append tg ('>' :: rest) (by
    simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
    rintro c rfl; decide)]
  simp

theorem renderClose_eq (tg : String) (rest : List Char) :
    renderClose tg ++ rest = '<' :: '/' :: ((esc tg).toList ++ '>' :: rest) := by
  simp [renderClose]

theorem parseAttrs_nil (f : Nat) : parseAttrs (f + 1) [] = some ([], []) := by
  rw [parseAttrs]
  · simp
  · simp

theorem parseAttrs_stop_gt (f : Nat) (t : List Char) :
    parseAttrs (f + 1) ('>' :: t) = some ([], '>' :: t) := by
  rw [parseAttrs]
  · intro u heq; simp at heq
  · intro u heq; simp at heq

theorem parseAttrs_stop_slash (f : Nat) (u : List Char) :
    parseAttrs (f + 1) (' ' :: '/' :: u) = some ([], ' ' :: '/' :: u) := by
  rw [parseAttrs]

theorem parseKids_stop (f : Nat) (l : List Char) (h : ¬ (l.head? = some '<' ∧
    l.tail.head? ≠ some '/')) : parseKids (f + 1) l = some ([], l) := by
  rw [parseKids, if_neg h]

theorem parseKids_open (f : Nat) (l : List Char) (h : l.head? = some '<' ∧
    l.tail.head? ≠ some '/') :
    parseKids (f + 1) l =
      (match parseDoc f l with
        | none => none
        | some (d, t1) =>
            match parseKids f t1 with
            | none => none
            | some (ds, t2) => some (d :: ds, t2)) := by
  rw [parseKids, if_pos h]

/-! ## Round trip -/

/-- Soundness of the XML parser against the renderer. -/
theorem parse_render (f : Nat) :
    (∀ d rest, 1 + (renderDoc d).length ≤ f →
        parseDoc f (renderDoc d ++ rest) = some (d, rest))
      ∧ (∀ as rest, 2 + (renderAttrs as).length ≤ f →
        (rest.head? = some '>' ∨ ∃ u, rest = ' ' :: '/' :: u) →
        parseAttrs f (renderAttrs as ++ rest) = some (as, rest))
      ∧ (∀ ks rest, 2 + (renderDocs ks).length ≤ f →
        (∃ u, rest = '<' :: '/' :: u) →
        parseKids f (renderDocs ks ++ rest) = some (ks, rest)) := by
  induction f with
  | zero =>
    refine ⟨fun d rest h => by omega, fun as rest h _ => by omega, fun ks rest h _ => by omega⟩
  | succ f ih =>
    obtain ⟨ihD, ihA, ihK⟩ := ih
    refine ⟨?_, ?_, ?_⟩
    · -- elements
      intro d rest hlen
      cases d with
      | leaf tg as s =>
        have hA : 2 + (renderAttrs as).length ≤ f := by
          simp only [renderDoc, renderClose, List.length_append, List.length_cons] at hlen
          omega
        have htail : ∀ c ∈ (renderAttrs as ++ ('>' :: ((esc s).toList ++
            (renderClose tg ++ rest)))).head?, isAtomChar c = false :=
          renderAttrs_head_cases as _
            (by simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
                rintro c rfl; decide) (by decide)
        show parseDoc (f + 1) (renderDoc (.leaf tg as s) ++ rest) = _
        simp only [renderDoc, List.cons_append, List.append_assoc]
        rw [parseDoc]
        rw [unesc_esc_append tg _ htail]
        simp only
        rw [ihA as _ hA (by simp)]
        simp only
        by_cases hemp : (esc s).toList = []
        · have hs0 : s = "" := esc_toList_eq_nil hemp
          subst hs0
          rw [hemp, List.nil_append, renderClose_eq]
          rw [if_pos (by simp), if_pos (by simp)]
          rw [parseClose_render tg rest]
        · obtain ⟨x, xs, hx⟩ := List.exists_cons_of_ne_nil hemp
          have hxatom : isAtomChar x = true := esc_head_atom hx
          have hxlt : x ≠ '<' := by
            intro h; rw [h] at hxatom; simp [isAtomChar, isSafeChar, escMark] at hxatom
          rw [if_neg (by rw [hx]; simp only [List.cons_append, List.head?_cons,
            Option.some.injEq]; exact hxlt)]
          rw [unesc_esc_append s (renderClose tg ++ rest) (by
            rw [renderClose_eq]
            simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
            rintro c rfl; decide)]
          simp only
          rw [renderClose_eq, parseClose_render tg rest]
      | node tg as ks =>
        cases ks with
        | nil =>
          have hA : 2 + (renderAttrs as).length ≤ f := by
            simp only [renderDoc, List.length_append, List.length_cons] at hlen; omega
          have htail : ∀ c ∈ (renderAttrs as ++ (' ' :: '/' :: '>' :: rest)).head?,
              isAtomChar c = false :=
            renderAttrs_head_cases as _
              (by simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
                  rintro c rfl; decide) (by decide)
          show parseDoc (f + 1) (renderDoc (.node tg as []) ++ rest) = _
          simp only [renderDoc, List.cons_append, List.append_assoc, List.nil_append]
          rw [parseDoc]
          rw [unesc_esc_append tg _ htail]
          simp only
          rw [ihA as _ hA (by right; exact ⟨'>' :: rest, rfl⟩)]
          rfl
        | cons d0 t0 =>
          have hA : 2 + (renderAttrs as).length ≤ f := by
            simp only [renderDoc, renderClose, List.length_append, List.length_cons] at hlen
            omega
          have hK : 2 + (renderDocs (d0 :: t0)).length ≤ f := by
            simp only [renderDoc, renderClose, List.length_append, List.length_cons] at hlen
            omega
          have htail : ∀ c ∈ (renderAttrs as ++ ('>' :: (renderDocs (d0 :: t0) ++
              (renderClose tg ++ rest)))).head?, isAtomChar c = false :=
            renderAttrs_head_cases as _
              (by simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
                  rintro c rfl; decide) (by decide)
          obtain ⟨u0, hu0, hu0'⟩ := renderDoc_cons d0
          have hshape : renderDocs (d0 :: t0) ++ (renderClose tg ++ rest)
              = '<' :: (u0 ++ (renderDocs t0 ++ (renderClose tg ++ rest))) := by
            simp only [renderDocs, hu0, List.cons_append, List.append_assoc]
          have hkids : parseKids f (renderDocs (d0 :: t0) ++ (renderClose tg ++ rest))
              = some (d0 :: t0, renderClose tg ++ rest) :=
            ihK (d0 :: t0) _ hK ⟨(esc tg).toList ++ '>' :: rest, renderClose_eq tg rest⟩
          have hhead : (renderDocs (d0 :: t0) ++ (renderClose tg ++ rest)).head? = some '<' := by
            rw [hshape]; simp
          have htl : (renderDocs (d0 :: t0) ++ (renderClose tg ++ rest)).tail.head?
              ≠ some '/' := by
            rw [hshape]
            simp only [List.tail_cons]
            cases hu2 : u0 with
            | nil =>
              exfalso
              have hlen0 : (renderDoc d0).length = 1 := by rw [hu0, hu2]; simp
              cases d0 with
              | leaf a b c => simp [renderDoc, renderClose] at hlen0
              | node a b c => cases c <;> simp [renderDoc, renderClose] at hlen0
            | cons y ys =>
              simp only [List.cons_append, List.head?_cons, ne_eq, Option.some.injEq]
              intro hy
              exact hu0' (by rw [hu2, hy]; simp)
          show parseDoc (f + 1) (renderDoc (.node tg as (d0 :: t0)) ++ rest) = _
          simp only [renderDoc, List.cons_append, List.append_assoc]
          rw [parseDoc]
          rw [unesc_esc_append tg _ htail]
          simp only
          rw [ihA as _ hA (by simp)]
          simp only
          rw [if_pos hhead, if_neg htl, hkids]
          simp only
          rw [renderClose_eq, parseClose_render tg rest]
    · -- attributes
      intro as rest hlen hrest
      cases as with
      | nil =>
        simp only [renderAttrs, List.nil_append]
        rcases hrest with h | ⟨u, rfl⟩
        · obtain ⟨t, ht⟩ : ∃ t, rest = '>' :: t := by
            cases rest with
            | nil => simp at h
            | cons c t => simp only [List.head?_cons, Option.some.injEq] at h; exact ⟨t, by rw [h]⟩
          rw [ht]; exact parseAttrs_stop_gt f t
        · exact parseAttrs_stop_slash f u
      | cons kv t =>
        obtain ⟨k, v⟩ := kv
        have hlen' : 2 + (renderAttrs t).length ≤ f := by
          rw [renderAttrs_length_cons] at hlen; omega
        have htail : ∀ c ∈ (renderAttrs t ++ rest).head?, isAtomChar c = false := by
          refine renderAttrs_head_cases t rest ?_ (by decide)
          rcases hrest with h | ⟨u, rfl⟩
          · rw [h]
            simp only [Option.mem_def, Option.some.injEq]
            rintro c rfl; decide
          · simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
            rintro c rfl; decide
        simp only [renderAttrs, List.cons_append, List.append_assoc]
        rw [parseAttrs]
        · rw [unesc_esc_append k ('=' :: '"' :: ((esc v).toList ++
            ('"' :: (renderAttrs t ++ rest)))) (by
            simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
            rintro c rfl; decide)]
          simp only
          rw [unesc_esc_append v ('"' :: (renderAttrs t ++ rest)) (by
            simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
            rintro c rfl; decide)]
          simp only
          rw [ihA t rest hlen' hrest]
        · intro u heq
          cases hk : (esc k).toList with
          | nil =>
            rw [hk, List.nil_append] at heq
            simp at heq
          | cons x xs =>
            rw [hk, List.cons_append] at heq
            simp only [List.cons.injEq] at heq
            have hxatom := esc_head_atom hk
            rw [heq.1] at hxatom
            simp [isAtomChar, isSafeChar, escMark] at hxatom
    · -- children
      intro ks rest hlen hrest
      obtain ⟨w, rfl⟩ := hrest
      cases ks with
      | nil =>
        simp only [renderDocs, List.nil_append]
        exact parseKids_stop f _ (by simp)
      | cons d t =>
        have hd : 1 + (renderDoc d).length ≤ f := by
          rw [renderDocs_length_cons] at hlen; omega
        have ht : 2 + (renderDocs t).length ≤ f := by
          rw [renderDocs_length_cons] at hlen
          have := renderDoc_length_pos d
          omega
        obtain ⟨u, hu, hu'⟩ := renderDoc_cons d
        have hstep : parseDoc f (renderDoc d ++ (renderDocs t ++ '<' :: '/' :: w))
            = some (d, renderDocs t ++ '<' :: '/' :: w) := ihD d _ hd
        have htail : parseKids f (renderDocs t ++ '<' :: '/' :: w) = some (t, '<' :: '/' :: w) :=
          ihK t _ ht ⟨w, rfl⟩
        have hshape : renderDocs (d :: t) ++ '<' :: '/' :: w
            = '<' :: (u ++ (renderDocs t ++ '<' :: '/' :: w)) := by
          simp only [renderDocs, hu, List.cons_append, List.append_assoc]
        have hcond : (renderDocs (d :: t) ++ '<' :: '/' :: w).head? = some '<'
            ∧ (renderDocs (d :: t) ++ '<' :: '/' :: w).tail.head? ≠ some '/' := by
          rw [hshape]
          refine ⟨by simp, ?_⟩
          simp only [List.tail_cons]
          cases hu2 : u with
          | nil =>
            exfalso
            have hlen0 : (renderDoc d).length = 1 := by rw [hu, hu2]; simp
            cases d with
            | leaf a b c => simp [renderDoc, renderClose] at hlen0
            | node a b c => cases c <;> simp [renderDoc, renderClose] at hlen0
          | cons y ys =>
            simp only [List.cons_append, List.head?_cons, ne_eq, Option.some.injEq]
            intro hy
            exact hu' (by rw [hu2, hy]; simp)
        rw [parseKids_open f _ hcond]
        rw [show renderDocs (d :: t) ++ '<' :: '/' :: w
            = renderDoc d ++ (renderDocs t ++ '<' :: '/' :: w) by
          simp only [renderDocs, List.append_assoc]]
        rw [hstep]
        simp only
        rw [htail]

/-- **The XML codec round-trips.** -/
theorem decode_encode (d : Doc) : decode (encode d) = some d := by
  have h := (parse_render ((renderDoc d).length + 1)).1 d [] (by omega)
  simp only [List.append_nil] at h
  simp only [decode, encode, String.toList_ofList, h]

end Xml
end LifeTrac.Codec
