/-!
# The character layer of the standard proof codec

Every concrete syntax this codec emits — IPDL, XML, CSV, YAML, raw text — is a
line-oriented projection of the same canonical table (`Codec.Table`).  All of
them therefore need the same two things:

* a way to put an arbitrary string into a field **without** the field's
  delimiters ever appearing inside it, and
* a way to cut a line back into fields.

This file provides both, once, for every codec:

* `escape` / `unescape` — a backslash escape whose output contains none of the
  delimiter characters used by any of the five codecs (`unescape_escape`), so a
  naive splitter is enough and no codec needs quoting rules of its own;
* `joinFields` / `splitFields` — fixed-arity records on one line
  (`splitFields_joinFields`);
* `joinTerm` / `splitTerm` — terminator-separated lists, which unlike
  separator-joined lists distinguish `[]` from `[""]` (`splitTerm_joinTerm`);
* `encList`, `decList`, `encPairs`, `decPairs` — the two variable-length shapes
  the canonical model needs inside a single field.

The point of the whole file is that each of these is *invertible*, proved, so
the round-trip theorems of §17 of the specification never have to reason about
characters again.
-/

namespace Solfunmeme.Codec

/-! ## Escaping -/

/-- The escape letter of a character that must not appear raw in a field.  The
set covers the delimiters of every codec in this package: `\`, `,`, `;`, the
line breaks, tab, `"`, `<`, `>`, `&`, `:`, `#`, `|` and `=`.  When `sp` is true
the space is escaped too, which is what the token-oriented IPDL codec needs. -/
def escCode (sp : Bool) : Char → Option Char
  | '\\' => some '\\'
  | ','  => some 'c'
  | ';'  => some 's'
  | '\n' => some 'n'
  | '\r' => some 'r'
  | '\t' => some 't'
  | '"'  => some 'q'
  | '<'  => some 'l'
  | '>'  => some 'g'
  | '&'  => some 'a'
  | ':'  => some 'd'
  | '#'  => some 'h'
  | '|'  => some 'p'
  | '='  => some 'e'
  | '('  => some 'o'
  | ')'  => some 'k'
  | '{'  => some 'b'
  | '}'  => some 'y'
  | ' '  => if sp then some 'u' else none
  | _    => none

/-- The character an escape letter stands for.  It does not depend on `sp`: a
codec that does not escape spaces still reads `\u` as a space. -/
def unescCode : Char → Option Char
  | '\\' => some '\\'
  | 'c' => some ','
  | 's' => some ';'
  | 'n' => some '\n'
  | 'r' => some '\r'
  | 't' => some '\t'
  | 'q' => some '"'
  | 'l' => some '<'
  | 'g' => some '>'
  | 'a' => some '&'
  | 'd' => some ':'
  | 'h' => some '#'
  | 'p' => some '|'
  | 'e' => some '='
  | 'o' => some '('
  | 'k' => some ')'
  | 'b' => some '{'
  | 'y' => some '}'
  | 'u' => some ' '
  | _   => none

theorem unescCode_escCode {sp : Bool} {c d : Char} (h : escCode sp c = some d) :
    unescCode d = some c := by
  unfold escCode at h
  split at h <;> (try split at h) <;> first | (cases h; rfl) | simp at h

/-- An escape letter is either the backslash itself or a character that is not
escaped — which is why escaped text contains no delimiter. -/
theorem escCode_code_none {sp : Bool} {c d : Char} (h : escCode sp c = some d) :
    d = '\\' ∨ escCode sp d = none := by
  unfold escCode at h
  split at h <;> (try split at h) <;>
    first | (cases h; first | exact Or.inl rfl | exact Or.inr rfl) | simp at h

/-- Escape a list of characters. -/
def escapeL (sp : Bool) : List Char → List Char
  | [] => []
  | c :: cs => match escCode sp c with
    | some d => '\\' :: d :: escapeL sp cs
    | none => c :: escapeL sp cs

/-- Unescape a list of characters; `none` if the text is not a valid escaping. -/
def unescapeL : List Char → Option (List Char)
  | [] => some []
  | c :: cs =>
    if c = '\\' then
      match cs with
      | [] => none
      | d :: cs' => match unescCode d with
        | some c' => (unescapeL cs').map (c' :: ·)
        | none => none
    else (unescapeL cs).map (c :: ·)

theorem unescapeL_cons_ne {c : Char} (hc : c ≠ '\\') (cs : List Char) :
    unescapeL (c :: cs) = (unescapeL cs).map (c :: ·) := by
  rw [unescapeL.eq_def]; simp [hc]

theorem unescapeL_escapeL (sp : Bool) (s : List Char) : unescapeL (escapeL sp s) = some s := by
  induction s with
  | nil => rfl
  | cons c cs ih =>
    unfold escapeL
    cases h : escCode sp c with
    | some d => simp [unescapeL, unescCode_escCode h, ih]
    | none =>
      have hc : c ≠ '\\' := by intro hh; rw [hh] at h; simp [escCode] at h
      rw [unescapeL_cons_ne hc, ih]; rfl

theorem escapeL_chars {sp : Bool} {s : List Char} {c : Char} (h : c ∈ escapeL sp s) :
    c = '\\' ∨ escCode sp c = none := by
  induction s with
  | nil => simp [escapeL] at h
  | cons a as ih =>
    unfold escapeL at h
    cases hh : escCode sp a with
    | some d =>
      rw [hh] at h
      simp at h
      rcases h with h | h | h
      · exact Or.inl h
      · subst h; exact escCode_code_none hh
      · exact ih h
    | none =>
      rw [hh] at h
      simp at h
      rcases h with h | h
      · subst h; exact Or.inr hh
      · exact ih h

/-- Escape a string. -/
def escape (sp : Bool) (s : String) : String := String.ofList (escapeL sp s.toList)

/-- Unescape a string. -/
def unescape (s : String) : Option String := (unescapeL s.toList).map String.ofList

@[simp] theorem unescape_escape (sp : Bool) (s : String) : unescape (escape sp s) = some s := by
  simp [unescape, escape, unescapeL_escapeL]

/-- Escaped text contains no delimiter other than the backslash. -/
theorem escape_no_sep {sp : Bool} {s : String} {sep : Char}
    (h1 : escCode sp sep ≠ none) (h2 : sep ≠ '\\') : sep ∉ (escape sp s).toList := by
  intro h
  rw [escape, String.toList_ofList] at h
  rcases escapeL_chars h with h | h
  · exact h2 h
  · exact h1 h

/-! ## Splitting and joining -/

/-- Join with a separator between the elements. -/
def joinC (sep : Char) : List (List Char) → List Char
  | [] => []
  | [x] => x
  | x :: xs => x ++ sep :: joinC sep xs

/-- Cut at every occurrence of the separator.  The result is never empty. -/
def splitC (sep : Char) : List Char → List (List Char)
  | [] => [[]]
  | c :: cs =>
      if c = sep then [] :: splitC sep cs
      else match splitC sep cs with
        | [] => [[c]]
        | y :: ys => (c :: y) :: ys

/-! ### The same cut, in constant stack

`splitC` is the definition every theorem below is about, and it recurses once
per character: on a document of a few million characters that exhausts the
stack.  `splitCTR` is the same function written with accumulators, and
`splitC_eq_splitCTR` — a `csimp` lemma, so the kernel checks it — makes the
compiler use it.  Nothing about the proofs changes; only the machine code does.
-/

/-- Prepend a prefix to the first element of a non-empty split. -/
def prependFirst (p : List Char) : List (List Char) → List (List Char)
  | [] => []
  | x :: xs => (p ++ x) :: xs

/-- The tail-recursive worker: `cur` is the chunk being read, reversed, and
`acc` the chunks already read, reversed. -/
def splitCGo (sep : Char) : List Char → List Char → List (List Char) → List (List Char)
  | [], cur, acc => (cur.reverse :: acc).reverse
  | c :: cs, cur, acc =>
      if c = sep then splitCGo sep cs [] (cur.reverse :: acc)
      else splitCGo sep cs (c :: cur) acc

/-- `splitC`, in constant stack. -/
def splitCTR (sep : Char) (cs : List Char) : List (List Char) := splitCGo sep cs [] []

theorem splitC_ne_nil (sep : Char) (cs : List Char) : splitC sep cs ≠ [] := by
  induction cs with
  | nil => simp [splitC]
  | cons c cs ih =>
    rw [splitC]
    by_cases h : c = sep <;> simp [h]
    cases hh : splitC sep cs <;> simp

theorem splitCGo_eq (sep : Char) (cs : List Char) (cur : List Char) (acc : List (List Char)) :
    splitCGo sep cs cur acc = acc.reverse ++ prependFirst cur.reverse (splitC sep cs) := by
  induction cs generalizing cur acc with
  | nil => simp [splitCGo, splitC, prependFirst]
  | cons c cs ih =>
    by_cases h : c = sep
    · rw [splitCGo, if_pos h, ih, splitC, if_pos h]
      cases hs : splitC sep cs with
      | nil => exact absurd hs (splitC_ne_nil sep cs)
      | cons y ys => simp [prependFirst]
    · rw [splitCGo, if_neg h, ih, splitC, if_neg h]
      cases hs : splitC sep cs with
      | nil => exact absurd hs (splitC_ne_nil sep cs)
      | cons y ys => simp [prependFirst]

@[csimp] theorem splitC_eq_splitCTR : @splitC = @splitCTR := by
  funext sep cs
  rw [splitCTR, splitCGo_eq]
  cases hs : splitC sep cs with
  | nil => exact absurd hs (splitC_ne_nil sep cs)
  | cons y ys => simp [prependFirst]

theorem splitC_no_sep (sep : Char) {x : List Char} (hx : sep ∉ x) : splitC sep x = [x] := by
  induction x with
  | nil => rfl
  | cons c cs ih =>
    have hc : c ≠ sep := by intro h; exact hx (by simp [h])
    have hcs : sep ∉ cs := fun h => hx (by simp [h])
    rw [splitC, if_neg hc, ih hcs]

theorem splitC_append_sep (sep : Char) {x : List Char} (hx : sep ∉ x) (t : List Char) :
    splitC sep (x ++ sep :: t) = x :: splitC sep t := by
  induction x with
  | nil => simp [splitC]
  | cons c cs ih =>
    have hc : c ≠ sep := by intro h; exact hx (by simp [h])
    have hcs : sep ∉ cs := fun h => hx (by simp [h])
    rw [List.cons_append, splitC, if_neg hc, ih hcs]

theorem splitC_joinC (sep : Char) {xs : List (List Char)} (hne : xs ≠ [])
    (h : ∀ x ∈ xs, sep ∉ x) : splitC sep (joinC sep xs) = xs := by
  induction xs with
  | nil => exact absurd rfl hne
  | cons x xs ih =>
    cases xs with
    | nil => exact splitC_no_sep sep (h x (by simp))
    | cons y ys =>
      rw [joinC, splitC_append_sep sep (h x (by simp)),
        ih (by intro hcon; simp at hcon) (fun z hz => h z (List.mem_cons_of_mem x hz))]
      nofun

/-- Every character of a joined line is either the separator or a character of
one of the fields. -/
theorem joinC_mem (sep : Char) {xs : List (List Char)} {c : Char} (h : c ∈ joinC sep xs) :
    c = sep ∨ ∃ x ∈ xs, c ∈ x := by
  induction xs with
  | nil => simp [joinC] at h
  | cons x xs ih =>
    cases xs with
    | nil => exact Or.inr ⟨x, by simp, by simpa [joinC] using h⟩
    | cons y ys =>
      rw [joinC] at h
      rcases List.mem_append.mp h with hx | hrest
      · exact Or.inr ⟨x, by simp, hx⟩
      · rcases List.mem_cons.mp hrest with hs | hj
        · exact Or.inl hs
        · rcases ih hj with hs | ⟨z, hz, hcz⟩
          · exact Or.inl hs
          · exact Or.inr ⟨z, List.mem_cons_of_mem x hz, hcz⟩
      nofun

/-! ## Fixed-arity records on one line -/

/-- A record of fields on one line, separated by `sep`. -/
def joinFields (sep : Char) (fs : List String) : String :=
  String.ofList (joinC sep (fs.map String.toList))

/-- Cut a line into fields.  The result is never empty, so a fixed arity can be
checked by pattern matching. -/
def splitFields (sep : Char) (s : String) : List String :=
  (splitC sep s.toList).map String.ofList

theorem splitFields_joinFields (sep : Char) {fs : List String} (hne : fs ≠ [])
    (h : ∀ f ∈ fs, sep ∉ f.toList) : splitFields sep (joinFields sep fs) = fs := by
  have hmap : ∀ x ∈ fs.map String.toList, sep ∉ x := by
    intro x hx
    rcases List.mem_map.mp hx with ⟨f, hf, rfl⟩
    exact h f hf
  have hne' : fs.map String.toList ≠ [] := by
    intro hh; exact hne (List.eq_nil_of_map_eq_nil hh)
  simp [splitFields, joinFields, String.toList_ofList, splitC_joinC sep hne' hmap,
    List.map_map, Function.comp_def]

/-! ## Terminator-separated lists -/

/-- A list where every element is *followed* by the separator.  Unlike a joined
list this distinguishes `[]` from `[""]`. -/
def joinTerm (sep : Char) (xs : List String) : String :=
  String.ofList ((xs.map String.toList).flatMap (fun x => x ++ [sep]))

/-- Read back a terminator-separated list; `none` if the text does not end with
the separator. -/
def splitTerm (sep : Char) (s : String) : Option (List String) :=
  match (splitC sep s.toList).reverse with
  | [] => none
  | last :: rest => if last = [] then some (rest.reverse.map String.ofList) else none

theorem splitC_flatMap (sep : Char) {xs : List (List Char)} (h : ∀ x ∈ xs, sep ∉ x) :
    splitC sep (xs.flatMap (fun x => x ++ [sep])) = xs ++ [[]] := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    have hx : sep ∉ x := h x (by simp)
    have hrest : ∀ y ∈ xs, sep ∉ y := fun y hy => h y (by simp [hy])
    have hflat : (x :: xs).flatMap (fun x => x ++ [sep])
        = x ++ sep :: xs.flatMap (fun x => x ++ [sep]) := by simp
    rw [hflat, splitC_append_sep sep hx, ih hrest]
    simp

theorem splitTerm_joinTerm (sep : Char) {xs : List String} (h : ∀ x ∈ xs, sep ∉ x.toList) :
    splitTerm sep (joinTerm sep xs) = some xs := by
  have hmap : ∀ x ∈ xs.map String.toList, sep ∉ x := by
    intro x hx
    rcases List.mem_map.mp hx with ⟨f, hf, rfl⟩
    exact h f hf
  unfold splitTerm joinTerm
  rw [String.toList_ofList, splitC_flatMap sep hmap]
  simp [List.map_map, Function.comp_def]

/-! ## Optional maps -/

/-- `List.mapM` for `Option`, spelled out so its round-trip lemma is easy. -/
def mapOpt {α β : Type} (f : α → Option β) : List α → Option (List β)
  | [] => some []
  | x :: xs => match f x, mapOpt f xs with
    | some y, some ys => some (y :: ys)
    | _, _ => none

theorem mapOpt_map {α β : Type} (f : α → Option β) (g : β → α) (h : ∀ b, f (g b) = some b)
    (bs : List β) : mapOpt f (bs.map g) = some bs := by
  induction bs with
  | nil => rfl
  | cons b bs ih => simp [mapOpt, h b, ih]

/-! ## The two variable-length shapes a canonical field may hold -/

/-- A list of strings inside one field. -/
def encList (sp : Bool) (xs : List String) : String := joinTerm ';' (xs.map (escape sp))

/-- Read back a list of strings from one field. -/
def decList (s : String) : Option (List String) :=
  (splitTerm ';' s).bind (fun ps => mapOpt unescape ps)

theorem escape_no_semi (sp : Bool) (s : String) : ';' ∉ (escape sp s).toList :=
  escape_no_sep (by cases sp <;> simp [escCode]) (by decide)

@[simp] theorem decList_encList (sp : Bool) (xs : List String) :
    decList (encList sp xs) = some xs := by
  have h : ∀ x ∈ xs.map (escape sp), ';' ∉ x.toList := by
    intro x hx
    rcases List.mem_map.mp hx with ⟨y, _, rfl⟩
    exact escape_no_semi sp y
  simp [decList, encList, splitTerm_joinTerm ';' h, mapOpt_map unescape (escape sp)
    (fun b => unescape_escape sp b)]

theorem escape_no_eq (sp : Bool) (s : String) : '=' ∉ (escape sp s).toList :=
  escape_no_sep (by cases sp <;> simp [escCode]) (by decide)

/-- One key/value pair on one line. -/
def encPair (sp : Bool) (p : String × String) : String :=
  joinFields '=' [escape sp p.1, escape sp p.2]

/-- Read back one key/value pair. -/
def decPair (e : String) : Option (String × String) :=
  match splitFields '=' e with
  | [a, b] => match unescape a, unescape b with
    | some x, some y => some (x, y)
    | _, _ => none
  | _ => none

theorem encPair_no_semi (sp : Bool) (p : String × String) : ';' ∉ (encPair sp p).toList := by
  intro h
  rw [encPair, joinFields, String.toList_ofList] at h
  rcases joinC_mem '=' h with h | ⟨x, hx, hcx⟩
  · exact absurd h (by decide)
  · simp at hx
    rcases hx with rfl | rfl
    · exact escape_no_semi sp p.1 hcx
    · exact escape_no_semi sp p.2 hcx

@[simp] theorem decPair_encPair (sp : Bool) (p : String × String) :
    decPair (encPair sp p) = some p := by
  have hsplit : splitFields '=' (encPair sp p) = [escape sp p.1, escape sp p.2] := by
    refine splitFields_joinFields '=' (by intro hcon; simp at hcon) ?_
    intro f hf
    simp at hf
    rcases hf with rfl | rfl
    · exact escape_no_eq sp p.1
    · exact escape_no_eq sp p.2
  rw [decPair, hsplit]
  simp

/-- A list of key/value pairs inside one field. -/
def encPairs (sp : Bool) (ps : List (String × String)) : String :=
  joinTerm ';' (ps.map (encPair sp))

/-- Read back a list of key/value pairs from one field. -/
def decPairs (s : String) : Option (List (String × String)) :=
  (splitTerm ';' s).bind (mapOpt decPair)

@[simp] theorem decPairs_encPairs (sp : Bool) (ps : List (String × String)) :
    decPairs (encPairs sp ps) = some ps := by
  have h : ∀ x ∈ ps.map (encPair sp), ';' ∉ x.toList := by
    intro x hx
    rcases List.mem_map.mp hx with ⟨p, _, rfl⟩
    exact encPair_no_semi sp p
  rw [decPairs, encPairs, splitTerm_joinTerm ';' h, Option.bind,
    mapOpt_map decPair (encPair sp) (decPair_encPair sp)]

end Solfunmeme.Codec
