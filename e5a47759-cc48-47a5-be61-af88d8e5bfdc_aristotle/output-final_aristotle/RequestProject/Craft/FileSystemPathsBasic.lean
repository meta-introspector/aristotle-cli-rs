import Mathlib

/-!
# ComputerCraft virtual file-system paths: definitions and basic lemmas

This file formalises the path-normalisation logic of ComputerCraft
(`src/main/java/dan200/computercraft/core/filesystem/FileSystem.java`): the
private `sanitizePath` routine together with the public helpers `combine`,
`getDirectory`, `getName`, `contains` and `toLocal`.

Paths are modelled as `List Char` (the Java implementation works on `String`,
whose characters are exactly what is inspected here).

The Java routine proceeds in three stages:

1. backslashes are replaced by forward slashes;
2. characters below `' '`, the six "special" characters `" : < > ? |` and
   (unless wildcards are allowed) `*` are deleted;
3. the remainder is split on `'/'` and the components are pushed on a stack,
   dropping empty components, `"."` and runs of three or more dots, letting
   `".."` cancel the component below it (unless that component is itself
   `".."`), and truncating components of length `≥ 255` to 255 characters.
   The stack is then re-joined with `'/'`.

This file sets up the definitions and the supporting lemmas about splitting,
joining, character cleaning and the component stack; the main theorems are in
`RequestProject.FileSystemPaths`.
-/

set_option maxRecDepth 10000

namespace CCFileSystem

/-- A path component. -/
abbrev Part := List Char

/-- The `".."` component. -/
def dd : Part := ['.', '.']

/-! ## Character cleaning -/

/-- The characters ComputerCraft rejects outright (`specialChars` in the Java source). -/
def isSpecialChar (c : Char) : Bool :=
  c == '"' || c == ':' || c == '<' || c == '>' || c == '?' || c == '|'

/-- The character filter of `sanitizePath`: keep printable, non-special characters,
and keep `'*'` only when wildcards are allowed. -/
def keepChar (allowWildcards : Bool) (c : Char) : Bool :=
  decide (32 ≤ c.val) && !isSpecialChar c && (allowWildcards || c != '*')

/-- Java's `path.replace('\\', '/')`. -/
def replaceBackslash (p : List Char) : List Char :=
  p.map (fun c => if c = '\\' then '/' else c)

/-- Stages 1 and 2 of `sanitizePath`. -/
def cleanChars (allowWildcards : Bool) (p : List Char) : List Char :=
  (replaceBackslash p).filter (keepChar allowWildcards)

/-- A string all of whose characters survive stages 1 and 2. -/
def GoodChars (allowWildcards : Bool) (s : List Char) : Prop :=
  ∀ c ∈ s, keepChar allowWildcards c = true ∧ c ≠ '\\'

/-! ## Splitting and joining -/

/-- Split a path on `'/'`, keeping empty components (Java's `path.split("/")`,
whose dropping of trailing empty components is irrelevant because empty
components are ignored anyway). -/
def splitSlash : List Char → List Part
  | [] => [[]]
  | c :: cs =>
      if c = '/' then [] :: splitSlash cs
      else
        match splitSlash cs with
        | [] => [[c]]
        | p :: ps => (c :: p) :: ps

/-- Join components with `'/'`. -/
def joinParts : List Part → List Char
  | [] => []
  | [p] => p
  | p :: ps => p ++ '/' :: joinParts ps

/-- The components of an already-sanitised path. -/
def pathParts (s : List Char) : List Part :=
  if s = [] then [] else splitSlash s

/-! ## The component stack -/

/-- `"..."`, `"...."`, ... are treated like `"."`. -/
def isDotsRun (p : Part) : Bool := decide (3 ≤ p.length) && p.all (· == '.')

/-- One step of the stack machine of `sanitizePath`.  The stack is stored with
its top at the head of the list. -/
def pushPart (st : List Part) (p : Part) : List Part :=
  if p = [] ∨ p = ['.'] ∨ isDotsRun p then st
  else if p = dd then
    match st with
    | [] => [dd]
    | top :: rest => if top = dd then dd :: top :: rest else rest
  else if 255 ≤ p.length then p.take 255 :: st
  else p :: st

/-- Stage 3 of `sanitizePath`: normalise a list of components. -/
def normParts (ps : List Part) : List Part := (ps.foldl pushPart []).reverse

/-! ## The public interface -/

/-- `FileSystem.sanitizePath`. -/
def sanitizeL (allowWildcards : Bool) (p : List Char) : List Char :=
  joinParts (normParts (splitSlash (cleanChars allowWildcards p)))

/-- `FileSystem.combine`. -/
def combineL (path childPath : List Char) : List Char :=
  let a := sanitizeL true path
  let b := sanitizeL true childPath
  if a = [] then b else if b = [] then a else sanitizeL true (a ++ '/' :: b)

/-- Everything before the last `'/'` (empty if there is none). -/
def beforeLastSlash (p : List Char) : List Char :=
  match p.reverse.dropWhile (· ≠ '/') with
  | [] => []
  | _ :: rest => rest.reverse

/-- Everything after the last `'/'` (the whole string if there is none). -/
def afterLastSlash (p : List Char) : List Char :=
  (p.reverse.takeWhile (· ≠ '/')).reverse

/-- `FileSystem.getDirectory`. -/
def getDirectoryL (path : List Char) : List Char :=
  let p := sanitizeL true path
  if p = [] then dd else beforeLastSlash p

/-- `FileSystem.getName`. -/
def getNameL (path : List Char) : List Char :=
  let p := sanitizeL true path
  if p = [] then ['r', 'o', 'o', 't'] else afterLastSlash p

/-- `FileSystem.contains`: is `pathB` inside `pathA`? -/
def containsL (pathA pathB : List Char) : Bool :=
  let a := sanitizeL false pathA
  let b := sanitizeL false pathB
  if b = dd then false
  else if (dd ++ ['/']).isPrefixOf b then false
  else if b = a then true
  else if a = [] then true
  else (a ++ ['/']).isPrefixOf b

/-- `FileSystem.toLocal`: `path` relative to `location`. -/
def toLocalL (path location : List Char) : List Char :=
  let p := sanitizeL false path
  let loc := sanitizeL false location
  let rest := p.drop loc.length
  if rest.head? = some '/' then rest.tail else rest

/-! ## Well-formedness of components -/

/-- A component that `sanitizePath` can output. -/
def ValidPart (p : Part) : Prop :=
  p ≠ [] ∧ p ≠ ['.'] ∧ p.length ≤ 255 ∧ '/' ∉ p

/-- The `".."` components of a list form a prefix of it. -/
def DDPrefix (ps : List Part) : Prop :=
  ∃ k rest, ps = List.replicate k dd ++ rest ∧ dd ∉ rest

/-- A normalised component list. -/
def Normalized (ps : List Part) : Prop :=
  (∀ p ∈ ps, ValidPart p) ∧ DDPrefix ps

/-- No component is a run of three or more dots. -/
def NoDotRuns (ps : List Part) : Prop := ∀ p ∈ ps, isDotsRun p = false

/-- A path that is already in sanitised form. -/
def Sanitized (allowWildcards : Bool) (s : List Char) : Prop :=
  GoodChars allowWildcards s ∧ Normalized (pathParts s) ∧ NoDotRuns (pathParts s)

/-! ## Basic sanity checks -/

section Examples

private def s (x : String) : List Char := x.toList

/-- info: "a/b" -/
#guard_msgs in
#eval String.ofList (sanitizeL false (s "/a//./b/"))

/-- info: "a/c" -/
#guard_msgs in
#eval String.ofList (sanitizeL false (s "a/b/../c"))

/-- info: "../x" -/
#guard_msgs in
#eval String.ofList (sanitizeL false (s "../x"))

/-- info: "../b" -/
#guard_msgs in
#eval String.ofList (sanitizeL false (s "a/../../b/../b"))

/-- info: "rom/programs" -/
#guard_msgs in
#eval String.ofList (combineL (s "rom") (s "programs"))

/-- info: false -/
#guard_msgs in
#eval containsL (s "rom") (s "rom/../secret")

/-- info: true -/
#guard_msgs in
#eval containsL (s "rom") (s "rom/programs/shell")

/-- info: "programs/shell" -/
#guard_msgs in
#eval String.ofList (toLocalL (s "rom/programs/shell") (s "rom"))

end Examples

/-! ## Splitting and joining: basic lemmas -/

theorem splitSlash_ne_nil (s : List Char) : splitSlash s ≠ [] := by
  cases s with
  | nil => simp [splitSlash]
  | cons c cs =>
    simp only [splitSlash]
    split
    · simp
    · split <;> simp

theorem splitSlash_no_slash (s : List Char) : ∀ q ∈ splitSlash s, '/' ∉ q := by
  induction s with
  | nil => simp [splitSlash]
  | cons c cs ih =>
    simp only [splitSlash]
    by_cases h : c = '/'
    · subst h
      intro q hq
      rcases List.mem_cons.1 hq with rfl | hq
      · simp
      · exact ih q hq
    · simp only [h, if_false]
      cases hcs : splitSlash cs with
      | nil => exact absurd hcs (splitSlash_ne_nil cs)
      | cons p ps =>
        rw [hcs] at ih
        intro q hq
        rcases List.mem_cons.1 hq with rfl | hq
        · simp only [List.mem_cons, not_or]
          exact ⟨fun hc => h hc.symm, ih p (by simp)⟩
        · exact ih q (by simp [hq])

theorem splitSlash_of_no_slash {s : List Char} (h : '/' ∉ s) : splitSlash s = [s] := by
  induction s with
  | nil => simp [splitSlash]
  | cons c cs ih =>
    simp only [List.mem_cons, not_or] at h
    simp only [splitSlash, if_neg (Ne.symm h.1), ih h.2]

theorem splitSlash_append_slash {p : List Char} (t : List Char) (h : '/' ∉ p) :
    splitSlash (p ++ '/' :: t) = p :: splitSlash t := by
  induction p with
  | nil => simp [splitSlash]
  | cons c cs ih =>
    simp only [List.mem_cons, not_or] at h
    simp only [List.cons_append, splitSlash, if_neg (Ne.symm h.1), ih h.2]

theorem joinParts_splitSlash (s : List Char) : joinParts (splitSlash s) = s := by
  induction s with
  | nil => simp [splitSlash, joinParts]
  | cons c cs ih =>
    simp only [splitSlash]
    by_cases h : c = '/'
    · subst h
      rw [if_pos rfl]
      cases hcs : splitSlash cs with
      | nil => exact absurd hcs (splitSlash_ne_nil cs)
      | cons p ps =>
        rw [hcs] at ih
        rw [show joinParts ([] :: p :: ps) = [] ++ '/' :: joinParts (p :: ps) from rfl, ih]
        simp
    · rw [if_neg h]
      cases hcs : splitSlash cs with
      | nil => exact absurd hcs (splitSlash_ne_nil cs)
      | cons p ps =>
        rw [hcs] at ih
        cases ps with
        | nil =>
          simp only [joinParts] at ih ⊢
          rw [ih]
        | cons q qs =>
          rw [show joinParts ((c :: p) :: q :: qs) = (c :: p) ++ '/' :: joinParts (q :: qs) from rfl]
          rw [show joinParts (p :: q :: qs) = p ++ '/' :: joinParts (q :: qs) from rfl] at ih
          simp [ih]

theorem splitSlash_joinParts {ps : List Part} (hne : ps ≠ []) (h : ∀ p ∈ ps, '/' ∉ p) :
    splitSlash (joinParts ps) = ps := by
  induction ps with
  | nil => exact absurd rfl hne
  | cons p ps ih =>
    cases ps with
    | nil => simpa [joinParts] using splitSlash_of_no_slash (h p (by simp))
    | cons q qs =>
      rw [show joinParts (p :: q :: qs) = p ++ '/' :: joinParts (q :: qs) from rfl,
        splitSlash_append_slash _ (h p (by simp)),
        ih (by simp) (fun r hr => h r (by simp [hr]))]

theorem joinParts_eq_nil_iff {ps : List Part} (h : ∀ p ∈ ps, p ≠ []) :
    joinParts ps = [] ↔ ps = [] := by
  constructor
  · intro hj
    cases ps with
    | nil => rfl
    | cons p ps =>
      cases ps with
      | nil => exact absurd hj (h p (by simp))
      | cons q qs =>
        rw [show joinParts (p :: q :: qs) = p ++ '/' :: joinParts (q :: qs) from rfl] at hj
        simp at hj
  · rintro rfl; rfl

theorem pathParts_joinParts {ps : List Part} (h : ∀ p ∈ ps, p ≠ [] ∧ '/' ∉ p) :
    pathParts (joinParts ps) = ps := by
  unfold pathParts
  by_cases hne : ps = []
  · subst hne; simp [joinParts]
  · rw [if_neg ((joinParts_eq_nil_iff (fun p hp => (h p hp).1)).not.mpr hne)]
    exact splitSlash_joinParts hne (fun p hp => (h p hp).2)

theorem joinParts_pathParts (s : List Char) : joinParts (pathParts s) = s := by
  unfold pathParts
  by_cases h : s = []
  · subst h; rfl
  · rw [if_neg h]; exact joinParts_splitSlash s

theorem mem_joinParts_of_mem {ps : List Part} {p : Part} {c : Char} (hp : p ∈ ps) (hc : c ∈ p) :
    c ∈ joinParts ps := by
  induction ps with
  | nil => simp at hp
  | cons x xs ih =>
    cases xs with
    | nil =>
      rcases List.mem_cons.1 hp with rfl | h
      · simpa [joinParts] using hc
      · simp at h
    | cons y ys =>
      rw [show joinParts (x :: y :: ys) = x ++ '/' :: joinParts (y :: ys) from rfl]
      rcases List.mem_cons.1 hp with rfl | h
      · exact List.mem_append.2 (Or.inl hc)
      · exact List.mem_append.2 (Or.inr (List.mem_cons.2 (Or.inr (ih h))))

theorem mem_joinParts {ps : List Part} {c : Char} (hc : c ∈ joinParts ps) :
    c = '/' ∨ ∃ p ∈ ps, c ∈ p := by
  induction ps with
  | nil => simp [joinParts] at hc
  | cons p ps ih =>
    cases ps with
    | nil => exact Or.inr ⟨p, by simp, by simpa [joinParts] using hc⟩
    | cons q qs =>
      rw [show joinParts (p :: q :: qs) = p ++ '/' :: joinParts (q :: qs) from rfl] at hc
      rcases List.mem_append.1 hc with h1 | h1
      · exact Or.inr ⟨p, by simp, h1⟩
      · rcases List.mem_cons.1 h1 with rfl | h1
        · exact Or.inl rfl
        · rcases ih h1 with h2 | ⟨r, hr, hcr⟩
          · exact Or.inl h2
          · exact Or.inr ⟨r, by simp [hr], hcr⟩

/-! ## Character cleaning: basic lemmas -/

theorem cleanChars_goodChars (aw : Bool) (p : List Char) : GoodChars aw (cleanChars aw p) := by
  intro c hc
  rw [cleanChars, List.mem_filter] at hc
  refine ⟨hc.2, ?_⟩
  rcases List.mem_map.1 hc.1 with ⟨d, _, hd⟩
  by_cases h : d = '\\' <;> simp [h] at hd <;> intro hbad <;> simp [hbad] at hd
  · exact absurd hd h

theorem cleanChars_eq_self {aw : Bool} {s : List Char} (h : GoodChars aw s) :
    cleanChars aw s = s := by
  have h1 : replaceBackslash s = s := by
    rw [replaceBackslash, List.map_eq_iff]
    intro i
    cases hi : s[i]? with
    | none => simp
    | some c =>
      have hc : c ∈ s := List.mem_of_getElem? hi
      simp [if_neg (h c hc).2]
  rw [cleanChars, h1, List.filter_eq_self]
  exact fun c hc => (h c hc).1

theorem goodChars_mono {s : List Char} (h : GoodChars false s) : GoodChars true s := by
  intro c hc
  refine ⟨?_, (h c hc).2⟩
  have := (h c hc).1
  simp [keepChar] at this ⊢
  tauto

/-! ## The stack machine -/

/-- The invariant maintained by `pushPart`: all entries are valid components and
the `".."` entries sit at the bottom of the stack. -/
def StackOk : List Part → Prop
  | [] => True
  | p :: rest => ValidPart p ∧ (p = dd → ∀ q ∈ rest, q = dd) ∧ StackOk rest

theorem dd_valid : ValidPart dd := ⟨by simp [dd], by simp [dd], by simp [dd], by simp [dd]⟩

theorem stackOk_nil : StackOk [] := trivial

theorem pushPart_stackOk {st : List Part} {p : Part} (hp : '/' ∉ p) (h : StackOk st) :
    StackOk (pushPart st p) := by
  unfold pushPart
  by_cases h1 : p = [] ∨ p = ['.'] ∨ isDotsRun p
  · rw [if_pos h1]; exact h
  · rw [if_neg h1]
    push_neg at h1
    by_cases h2 : p = dd
    · subst h2
      rw [if_pos rfl]
      cases st with
      | nil => exact ⟨dd_valid, by simp, trivial⟩
      | cons top rest =>
        show StackOk (if top = dd then dd :: top :: rest else rest)
        by_cases h3 : top = dd
        · rw [if_pos h3]
          refine ⟨dd_valid, ?_, h⟩
          intro _ q hq
          rcases List.mem_cons.1 hq with rfl | hq
          · exact h3
          · exact h.2.1 h3 q hq
        · rw [if_neg h3]; exact h.2.2
    · rw [if_neg h2]
      by_cases h3 : 255 ≤ p.length
      · rw [if_pos h3]
        have hlen : (p.take 255).length = 255 := by rw [List.length_take]; omega
        refine ⟨⟨?_, ?_, by omega, fun hc => hp (List.mem_of_mem_take hc)⟩, ?_, h⟩
        · intro hc; simp [hc] at hlen
        · intro hc; rw [hc] at hlen; simp at hlen
        · intro hc; rw [hc] at hlen; simp [dd] at hlen
      · rw [if_neg h3]
        exact ⟨⟨h1.1, h1.2.1, by omega, hp⟩, fun hc => absurd hc h2, h⟩

theorem foldl_pushPart_stackOk (ps : List Part) {st : List Part}
    (h : ∀ p ∈ ps, '/' ∉ p) (hst : StackOk st) : StackOk (ps.foldl pushPart st) := by
  induction ps generalizing st with
  | nil => simpa using hst
  | cons p ps ih =>
    simp only [List.foldl_cons]
    exact ih (fun q hq => h q (by simp [hq])) (pushPart_stackOk (h p (by simp)) hst)

theorem stackOk_append_right {l t : List Part} (h : StackOk (l ++ t)) : StackOk t := by
  induction l with
  | nil => simpa using h
  | cons x xs ih => exact ih (by exact h.2.2)

theorem stackOk_replicate (k : ℕ) : StackOk (List.replicate k dd) := by
  induction k with
  | zero => exact trivial
  | succ n ihn =>
    rw [List.replicate_succ]
    exact ⟨dd_valid, fun _ q hq => List.eq_of_mem_replicate hq, ihn⟩

theorem stackOk_append_of_no_dd {l t : List Part} (hl : ∀ p ∈ l, ValidPart p ∧ p ≠ dd)
    (ht : StackOk t) : StackOk (l ++ t) := by
  induction l with
  | nil => simpa using ht
  | cons x xs ih =>
    refine ⟨(hl x (by simp)).1, fun hc => absurd hc (hl x (by simp)).2, ?_⟩
    exact ih (fun p hp => hl p (by simp [hp]))

theorem eq_replicate_of_all_dd {l : List Part} (h : ∀ q ∈ l, q = dd) :
    l = List.replicate l.length dd := by
  rw [List.eq_replicate_iff]; exact ⟨rfl, h⟩

theorem stackOk_reverse_normalized {st : List Part} (h : StackOk st) : Normalized st.reverse := by
  induction st with
  | nil => exact ⟨by simp, 0, [], by simp, by simp⟩
  | cons p rest ih =>
    obtain ⟨hval, hdd, hrest⟩ := h
    obtain ⟨hv, k, r, hr, hdr⟩ := ih hrest
    have hvall : ∀ q ∈ (p :: rest).reverse, ValidPart q := by
      intro q hq
      rcases List.mem_cons.1 (List.mem_reverse.1 hq) with rfl | h'
      · exact hval
      · exact hv q (List.mem_reverse.2 h')
    by_cases hp : p = dd
    · refine ⟨hvall, rest.length + 1, [], ?_, by simp⟩
      have hall : rest = List.replicate rest.length dd := eq_replicate_of_all_dd (hdd hp)
      simp only [List.reverse_cons, List.append_nil, hp]
      rw [hall]
      simp [List.replicate_succ']
    · refine ⟨hvall, k, r ++ [p], ?_, ?_⟩
      · simp only [List.reverse_cons, hr, List.append_assoc]
      · simp [hdr, Ne.symm hp]

theorem normalized_reverse_stackOk {ps : List Part} (h : Normalized ps) : StackOk ps.reverse := by
  obtain ⟨hval, k, rest, hps, hdr⟩ := h
  subst hps
  rw [List.reverse_append, List.reverse_replicate]
  refine stackOk_append_of_no_dd ?_ (stackOk_replicate k)
  intro p hp
  have hpr : p ∈ rest := List.mem_reverse.1 hp
  exact ⟨hval p (by simp [hpr]), fun hc => hdr (hc ▸ hpr)⟩

/-- On an already normalised list, the stack machine is the identity. -/
theorem foldl_pushPart_of_stackOk (ps : List Part) (st : List Part)
    (hnd : NoDotRuns ps) (h : StackOk (ps.reverse ++ st)) :
    ps.foldl pushPart st = ps.reverse ++ st := by
  induction ps generalizing st with
  | nil => simp
  | cons p ps ih =>
    have h' : StackOk (ps.reverse ++ p :: st) := by simpa using h
    have hsuf : StackOk (p :: st) := stackOk_append_right h'
    have hpush : pushPart st p = p :: st := by
      obtain ⟨hval, hdd, hst⟩ := hsuf
      unfold pushPart
      rw [if_neg (by push_neg; exact ⟨hval.1, hval.2.1, by simp [hnd p (by simp)]⟩)]
      by_cases h2 : p = dd
      · subst h2
        rw [if_pos rfl]
        cases hs : st with
        | nil => rfl
        | cons top rest =>
          show (if top = dd then dd :: top :: rest else rest) = dd :: top :: rest
          rw [if_pos (hdd rfl top (by rw [hs]; simp))]
      · rw [if_neg h2]
        by_cases h3 : 255 ≤ p.length
        · rw [if_pos h3, List.take_of_length_le hval.2.2.1]
        · rw [if_neg h3]
    simp only [List.foldl_cons, hpush]
    rw [ih (p :: st) (fun q hq => hnd q (by simp [hq])) h']
    simp

theorem normParts_of_normalized {ps : List Part} (h : Normalized ps) (hnd : NoDotRuns ps) :
    normParts ps = ps := by
  unfold normParts
  rw [foldl_pushPart_of_stackOk ps [] hnd (by simpa using normalized_reverse_stackOk h)]
  simp

theorem normParts_normalized {ps : List Part} (hs : ∀ p ∈ ps, '/' ∉ p) :
    Normalized (normParts ps) :=
  stackOk_reverse_normalized (foldl_pushPart_stackOk ps hs stackOk_nil)

theorem pushPart_mem {st : List Part} {p q : Part} (hq : q ∈ pushPart st p) :
    q ∈ st ∨ q = p ∨ q = p.take 255 := by
  unfold pushPart at hq
  split_ifs at hq with h1 h2 h3
  · exact Or.inl hq
  · cases st with
    | nil => right; left; simp at hq; rw [hq, h2]
    | cons top rest =>
      simp only at hq
      split_ifs at hq with h4
      · rcases List.mem_cons.1 hq with rfl | hq
        · exact Or.inr (Or.inl h2.symm)
        · exact Or.inl hq
      · exact Or.inl (List.mem_cons_of_mem _ hq)
  · rcases List.mem_cons.1 hq with rfl | hq
    · exact Or.inr (Or.inr rfl)
    · exact Or.inl hq
  · rcases List.mem_cons.1 hq with rfl | hq
    · exact Or.inr (Or.inl rfl)
    · exact Or.inl hq

theorem foldl_pushPart_mem {ps : List Part} {st : List Part} {q : Part}
    (hq : q ∈ ps.foldl pushPart st) : q ∈ st ∨ ∃ p ∈ ps, q = p ∨ q = p.take 255 := by
  induction ps generalizing st with
  | nil => exact Or.inl (by simpa using hq)
  | cons p ps ih =>
    rcases ih (by simpa using hq) with h | ⟨r, hr, hrq⟩
    · rcases pushPart_mem h with h | h
      · exact Or.inl h
      · exact Or.inr ⟨p, by simp, h⟩
    · exact Or.inr ⟨r, by simp [hr], hrq⟩

theorem mem_normParts_char {ps : List Part} {q : Part} {c : Char}
    (hq : q ∈ normParts ps) (hc : c ∈ q) : ∃ p ∈ ps, c ∈ p := by
  rw [normParts, List.mem_reverse] at hq
  rcases foldl_pushPart_mem hq with h | ⟨p, hp, hpq⟩
  · simp at h
  · refine ⟨p, hp, ?_⟩
    rcases hpq with rfl | rfl
    · exact hc
    · exact List.mem_of_mem_take hc

end CCFileSystem
