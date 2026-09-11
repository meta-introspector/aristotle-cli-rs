import RequestProject.Gvcs.Codec.Doc

/-!
# The IPDL codec

IPDL is treated here as the native structured interchange syntax of the codec: a
bracketed, S-expression-like notation for `Doc`.

```text
(proof :id=proof-001 :kind=theorem (inputs [input :id=n =144]) [status =VALID])
```

* `( tag :k=v ... children )` is an element with child elements;
* `[ tag :k=v ... = text ]` is an element with character content;
* every identifier, attribute name, attribute value and text body is an atom in the
  sense of `RequestProject.Codec.Atom`, so no structural character can occur inside one.

The adapter is total in both directions on well-formed input, and `Ipdl.decode_encode`
proves the round trip: identifiers, attribute order, nesting, character content and the
element/attribute/text distinction all survive.

Parsing is driven by an explicit fuel argument so that the parser is a total function.
`Ipdl.decode` supplies fuel proportional to the length of the input, which
`Ipdl.decode_encode` shows is always enough.
-/

namespace LifeTrac.Codec
namespace Ipdl

/-! ## Rendering -/

/-- Render one attribute as `:key=value`. -/
def renderAttrs : List (String × String) → List Char
  | [] => []
  | (k, v) :: t => (':' :: (esc k).toList) ++ ('=' :: (esc v).toList) ++ renderAttrs t

mutual

/-- Render a document. -/
def renderDoc : Doc → List Char
  | .leaf tg as s =>
      ('[' :: (esc tg).toList) ++ renderAttrs as ++ ('=' :: (esc s).toList) ++ [']']
  | .node tg as ks =>
      ('(' :: (esc tg).toList) ++ renderAttrs as ++ renderDocs ks ++ [')']

/-- Render a list of documents, in order. -/
def renderDocs : List Doc → List Char
  | [] => []
  | d :: t => renderDoc d ++ renderDocs t

end

/-- Encode a document as IPDL text. -/
def encode (d : Doc) : String := String.ofList (renderDoc d)

/-! ## Parsing -/

mutual

/-- Parse one document. -/
def parseDoc : Nat → List Char → Option (Doc × List Char)
  | 0, _ => none
  | f + 1, l =>
      match l with
      | '[' :: t =>
          let r := unesc t
          match parseAttrs f r.2 with
          | none => none
          | some (as, t2) =>
              match t2 with
              | '=' :: t3 =>
                  let s := unesc t3
                  match s.2 with
                  | ']' :: t5 => some (.leaf r.1 as s.1, t5)
                  | _ => none
              | _ => none
      | '(' :: t =>
          let r := unesc t
          match parseAttrs f r.2 with
          | none => none
          | some (as, t2) =>
              match parseKids f t2 with
              | none => none
              | some (ks, t3) =>
                  match t3 with
                  | ')' :: t4 => some (.node r.1 as ks, t4)
                  | _ => none
      | _ => none

/-- Parse a run of attributes. -/
def parseAttrs : Nat → List Char → Option (List (String × String) × List Char)
  | 0, _ => none
  | f + 1, l =>
      match l with
      | ':' :: t =>
          let k := unesc t
          match k.2 with
          | '=' :: t2 =>
              let v := unesc t2
              match parseAttrs f v.2 with
              | none => none
              | some (rest, t4) => some ((k.1, v.1) :: rest, t4)
          | _ => none
      | _ => some ([], l)

/-- Parse a run of child documents. -/
def parseKids : Nat → List Char → Option (List Doc × List Char)
  | 0, _ => none
  | f + 1, l =>
      match l with
      | '(' :: _ =>
          match parseDoc f l with
          | none => none
          | some (d, t1) =>
              match parseKids f t1 with
              | none => none
              | some (ds, t2) => some (d :: ds, t2)
      | '[' :: _ =>
          match parseDoc f l with
          | none => none
          | some (d, t1) =>
              match parseKids f t1 with
              | none => none
              | some (ds, t2) => some (d :: ds, t2)
      | _ => some ([], l)

end

/-- Decode IPDL text into a document; the whole input must be consumed. -/
def decode (s : String) : Option Doc :=
  match parseDoc (s.toList.length + 1) s.toList with
  | some (d, []) => some d
  | _ => none

/-! ## Shape of rendered text -/

/-- Rendered attributes begin with `:`, if they are there at all. -/
theorem renderAttrs_head_cases {P : Char → Prop} (as : List (String × String))
    (X : List Char) (hX : ∀ c ∈ X.head?, P c) (hcolon : P ':') :
    ∀ c ∈ (renderAttrs as ++ X).head?, P c := by
  cases as with
  | nil => simpa [renderAttrs] using hX
  | cons kv t =>
    obtain ⟨k, v⟩ := kv
    intro c hc
    rw [head?_append_some (by simp [renderAttrs] : (renderAttrs ((k, v) :: t)).head? = some ':')]
      at hc
    simp only [Option.mem_def, Option.some.injEq] at hc
    exact hc ▸ hcolon

/-- A rendered document begins with `(` or `[`. -/
theorem renderDoc_head (d : Doc) :
    (renderDoc d).head? = some '(' ∨ (renderDoc d).head? = some '[' := by
  cases d with
  | leaf tg as s => right; simp [renderDoc]
  | node tg as ks => left; simp [renderDoc]

/-- Rendered children begin with `(` or `[`, if they are there at all. -/
theorem renderDocs_head_cases {P : Char → Prop} (ks : List Doc)
    (X : List Char) (hX : ∀ c ∈ X.head?, P c) (hopen : P '(') (hbrack : P '[') :
    ∀ c ∈ (renderDocs ks ++ X).head?, P c := by
  cases ks with
  | nil => simpa [renderDocs] using hX
  | cons d t =>
    intro c hc
    have hd := renderDoc_head d
    have hdocs : (renderDocs (d :: t)).head? = (renderDoc d).head? := by
      rcases hd with h | h <;>
        · obtain ⟨x, xs, hx⟩ : ∃ x xs, renderDoc d = x :: xs := by
            cases hr : renderDoc d with
            | nil => rw [hr] at h; simp at h
            | cons x xs => exact ⟨x, xs, rfl⟩
          simp [renderDocs, hx]
    rcases hd with h | h <;>
      · rw [head?_append_some (hdocs.trans h)] at hc
        simp only [Option.mem_def, Option.some.injEq] at hc
        subst hc
        assumption

theorem renderDoc_length_pos (d : Doc) : 1 ≤ (renderDoc d).length := by
  cases d with
  | leaf tg as s => simp [renderDoc]
  | node tg as ks => simp [renderDoc]

theorem renderDocs_length_cons (d : Doc) (t : List Doc) :
    (renderDocs (d :: t)).length = (renderDoc d).length + (renderDocs t).length := by
  simp [renderDocs]

theorem renderAttrs_length_cons (k v : String) (t : List (String × String)) :
    (renderAttrs ((k, v) :: t)).length
      = 2 + (esc k).toList.length + (esc v).toList.length + (renderAttrs t).length := by
  simp [renderAttrs]
  omega

/-! ## Parser steps -/

theorem parseAttrs_nil (f : Nat) : parseAttrs (f + 1) [] = some ([], []) := by
  rw [parseAttrs]
  simp

theorem parseAttrs_stop {c : Char} (hc : c ≠ ':') (f : Nat) (t : List Char) :
    parseAttrs (f + 1) (c :: t) = some ([], c :: t) := by
  rw [parseAttrs]
  intro t' heq
  simp only [List.cons.injEq] at heq
  exact hc heq.1

theorem parseKids_nil (f : Nat) : parseKids (f + 1) [] = some ([], []) := by
  rw [parseKids]
  · simp
  · simp

theorem parseKids_stop {c : Char} (h1 : c ≠ '(') (h2 : c ≠ '[') (f : Nat) (t : List Char) :
    parseKids (f + 1) (c :: t) = some ([], c :: t) := by
  rw [parseKids]
  · intro t' heq
    simp only [List.cons.injEq] at heq
    exact h1 heq.1
  · intro t' heq
    simp only [List.cons.injEq] at heq
    exact h2 heq.1

theorem parseKids_open {x : Char} (hx : x = '(' ∨ x = '[') (f : Nat) (l : List Char) :
    parseKids (f + 1) (x :: l) =
      (match parseDoc f (x :: l) with
        | none => none
        | some (d, t1) =>
            match parseKids f t1 with
            | none => none
            | some (ds, t2) => some (d :: ds, t2)) := by
  rcases hx with rfl | rfl <;> rw [parseKids]

/-! ## Round trip -/

/--
Soundness of the parser against the renderer, for all three mutually recursive parsers
at once.  The fuel bounds are the ones `decode` supplies.
-/
theorem parse_render (f : Nat) :
    (∀ d rest, 1 + (renderDoc d).length ≤ f →
        parseDoc f (renderDoc d ++ rest) = some (d, rest))
      ∧ (∀ as rest, 2 + (renderAttrs as).length ≤ f →
        (∀ c ∈ rest.head?, isAtomChar c = false ∧ c ≠ ':') →
        parseAttrs f (renderAttrs as ++ rest) = some (as, rest))
      ∧ (∀ ks rest, 2 + (renderDocs ks).length ≤ f →
        (∀ c ∈ rest.head?, isAtomChar c = false ∧ c ≠ '(' ∧ c ≠ '[') →
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
          simp only [renderDoc, List.length_append, List.length_cons] at hlen; omega
        have hstop : ∀ c ∈ ('=' :: ((esc s).toList ++ ']' :: rest)).head?,
            isAtomChar c = false ∧ c ≠ ':' := by
          simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
          rintro c rfl
          exact ⟨by decide, by decide⟩
        have htail : ∀ c ∈ (renderAttrs as ++ '=' :: ((esc s).toList ++ ']' :: rest)).head?,
            isAtomChar c = false :=
          renderAttrs_head_cases as _
            (by simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
                rintro c rfl; decide)
            (by decide)
        show parseDoc (f + 1) (renderDoc (.leaf tg as s) ++ rest) = _
        simp only [renderDoc, List.cons_append, List.append_assoc, List.nil_append]
        rw [parseDoc]
        rw [unesc_esc_append tg _ htail]
        simp only
        rw [ihA as ('=' :: ((esc s).toList ++ ']' :: rest)) hA hstop]
        simp only
        rw [unesc_esc_append s (']' :: rest) (by
          simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
          rintro c rfl; decide)]
        rfl
      | node tg as ks =>
        have hA : 2 + (renderAttrs as).length ≤ f := by
          simp only [renderDoc, List.length_append, List.length_cons] at hlen; omega
        have hK : 2 + (renderDocs ks).length ≤ f := by
          simp only [renderDoc, List.length_append, List.length_cons] at hlen; omega
        have hclose : ∀ c ∈ (')' :: rest).head?, isAtomChar c = false ∧ c ≠ '(' ∧ c ≠ '[' := by
          simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
          rintro c rfl
          exact ⟨by decide, by decide, by decide⟩
        have hstopA : ∀ c ∈ (renderDocs ks ++ ')' :: rest).head?,
            isAtomChar c = false ∧ c ≠ ':' :=
          renderDocs_head_cases ks _
            (by simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
                rintro c rfl; exact ⟨by decide, by decide⟩)
            (by exact ⟨by decide, by decide⟩) (by exact ⟨by decide, by decide⟩)
        have htail : ∀ c ∈ (renderAttrs as ++ (renderDocs ks ++ ')' :: rest)).head?,
            isAtomChar c = false :=
          renderAttrs_head_cases as _ (fun c hc => (hstopA c hc).1) (by decide)
        show parseDoc (f + 1) (renderDoc (.node tg as ks) ++ rest) = _
        simp only [renderDoc, List.cons_append, List.append_assoc, List.nil_append]
        rw [parseDoc]
        rw [unesc_esc_append tg _ htail]
        simp only
        rw [ihA as (renderDocs ks ++ ')' :: rest) hA hstopA]
        simp only
        rw [ihK ks (')' :: rest) hK hclose]
        rfl
    · -- attributes
      intro as rest hlen hrest
      cases as with
      | nil =>
        simp only [renderAttrs, List.nil_append]
        cases rest with
        | nil => exact parseAttrs_nil f
        | cons c t => exact parseAttrs_stop (hrest c (by simp)).2 f t
      | cons kv t =>
        obtain ⟨k, v⟩ := kv
        have hlen' : 2 + (renderAttrs t).length ≤ f := by
          rw [renderAttrs_length_cons] at hlen; omega
        have htail : ∀ c ∈ (renderAttrs t ++ rest).head?, isAtomChar c = false :=
          renderAttrs_head_cases t rest (fun c hc => (hrest c hc).1) (by decide)
        simp only [renderAttrs, List.cons_append, List.append_assoc]
        rw [parseAttrs]
        rw [unesc_esc_append k ('=' :: ((esc v).toList ++ (renderAttrs t ++ rest))) (by
          simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
          rintro c rfl; decide)]
        simp only
        rw [unesc_esc_append v (renderAttrs t ++ rest) htail]
        simp only
        rw [ihA t rest hlen' hrest]
    · -- children
      intro ks rest hlen hrest
      cases ks with
      | nil =>
        simp only [renderDocs, List.nil_append]
        cases rest with
        | nil => exact parseKids_nil f
        | cons c t =>
          obtain ⟨-, h1, h2⟩ := hrest c (by simp)
          exact parseKids_stop h1 h2 f t
      | cons d t =>
        have hd : 1 + (renderDoc d).length ≤ f := by
          rw [renderDocs_length_cons] at hlen; omega
        have ht : 2 + (renderDocs t).length ≤ f := by
          rw [renderDocs_length_cons] at hlen
          have := renderDoc_length_pos d
          omega
        have hstep : parseDoc f (renderDoc d ++ (renderDocs t ++ rest))
            = some (d, renderDocs t ++ rest) := ihD d _ hd
        have htail : parseKids f (renderDocs t ++ rest) = some (t, rest) := ihK t rest ht hrest
        obtain ⟨x, xs, hx, hxc⟩ : ∃ x xs, renderDoc d = x :: xs ∧ (x = '(' ∨ x = '[') := by
          rcases renderDoc_head d with h | h <;>
            · cases hr : renderDoc d with
              | nil => rw [hr] at h; simp at h
              | cons y ys =>
                refine ⟨y, ys, rfl, ?_⟩
                rw [hr] at h
                simp only [List.head?_cons, Option.some.injEq] at h
                simp [h]
        simp only [renderDocs, List.append_assoc]
        rw [hx] at hstep ⊢
        simp only [List.cons_append]
        rw [parseKids_open hxc f (xs ++ (renderDocs t ++ rest))]
        rw [← List.cons_append, hstep]
        simp only
        rw [htail]

/-- **The IPDL codec round-trips.** -/
theorem decode_encode (d : Doc) : decode (encode d) = some d := by
  have h := (parse_render ((renderDoc d).length + 1)).1 d [] (by omega)
  simp only [List.append_nil] at h
  simp only [decode, encode, String.toList_ofList, h]

end Ipdl
end LifeTrac.Codec
