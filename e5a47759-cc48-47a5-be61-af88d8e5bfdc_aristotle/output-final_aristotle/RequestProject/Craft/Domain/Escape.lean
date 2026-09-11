/-
# Domain data codec — escaping and line splitting

Every emitted representation (IPDL, XML, CSV, YAML, raw text) writes domain
strings into a delimited textual grammar.  To make all five grammars parseable
— and provably so — every string written out is first *escaped*: the escape
function removes every delimiter character used by any of the grammars, and is
inverted exactly by `unesc`.

This file provides:

* `esc` / `unesc` and `unesc_esc`, the escaping round trip;
* `escL_delim_free`, the fact that no delimiter survives escaping;
* `joinWith` / `splitOnChar` and `splitOnChar_joinWith`, the splitting round
  trip used by every format parser.
-/
import Mathlib

namespace Domain

/-! ## Escaping -/

/-- Escape one character.  Backslash is the escape character; every delimiter
used by any emitted grammar is mapped to a two-character sequence. -/
def escC : Char → List Char
  | '\\' => ['\\', '\\']
  | '\n' => ['\\', 'n']
  | '\r' => ['\\', 'r']
  | '\t' => ['\\', 't']
  | '"'  => ['\\', 'q']
  | '\'' => ['\\', 'Q']
  | ','  => ['\\', 'c']
  | '|'  => ['\\', 'p']
  | '<'  => ['\\', 'l']
  | '>'  => ['\\', 'g']
  | '&'  => ['\\', 'a']
  | c    => [c]

/-- Decode the character following a backslash. -/
def unescChar : Char → Char
  | 'n' => '\n'
  | 'r' => '\r'
  | 't' => '\t'
  | 'q' => '"'
  | 'Q' => '\''
  | 'c' => ','
  | 'p' => '|'
  | 'l' => '<'
  | 'g' => '>'
  | 'a' => '&'
  | c   => c

/-- Escape a character list. -/
def escL (cs : List Char) : List Char := cs.flatMap escC

/-- Unescape a character list. -/
def unescL : List Char → List Char
  | [] => []
  | c :: rest =>
      if c = '\\' then
        match rest with
        | [] => ['\\']
        | d :: rest' => unescChar d :: unescL rest'
      else c :: unescL rest

theorem unescL_cons_of_ne {c : Char} (h : c ≠ '\\') (rest : List Char) :
    unescL (c :: rest) = c :: unescL rest := by
  rw [unescL.eq_def]; simp [h]

theorem unescL_bs (d : Char) (rest : List Char) :
    unescL ('\\' :: d :: rest) = unescChar d :: unescL rest := by
  rw [unescL.eq_def]; simp

theorem unescL_escC (c : Char) (rest : List Char) :
    unescL (escC c ++ rest) = c :: unescL rest := by
  unfold escC
  split <;> simp_all [unescL_bs, unescChar, unescL_cons_of_ne]

theorem unescL_escL (cs : List Char) : unescL (escL cs) = cs := by
  induction cs with
  | nil => rfl
  | cons c cs ih =>
      have h : escL (c :: cs) = escC c ++ escL cs := by simp [escL]
      rw [h, unescL_escC, ih]

/-- The delimiter characters used by the emitted grammars.  Backslash is *not*
a delimiter (it survives escaping as the escape marker). -/
def delims : List Char :=
  ['\n', '\r', '\t', '"', '\'', ',', '|', '<', '>', '&']

theorem escL_delim_free {d : Char} (hd : d ∈ delims) (cs : List Char) :
    d ∉ escL cs := by
  simp only [delims, List.mem_cons, List.not_mem_nil, or_false] at hd
  induction cs with
  | nil => simp [escL]
  | cons c cs ih =>
      have hstep : escL (c :: cs) = escC c ++ escL cs := by simp [escL]
      rw [hstep]
      simp only [List.mem_append, not_or]
      refine ⟨?_, ih⟩
      unfold escC
      split <;> rcases hd with h|h|h|h|h|h|h|h|h|h <;> subst h <;> simp_all <;>
        try exact Ne.symm (by assumption)

/-! ## Strings -/

theorem toList_ofList (cs : List Char) : (String.ofList cs).toList = cs :=
  String.toList_ofList

theorem ofList_toList (s : String) : String.ofList s.toList = s :=
  String.ofList_toList

/-- Escape a string. -/
def esc (s : String) : String := String.ofList (escL s.toList)

/-- Unescape a string. -/
def unesc (s : String) : String := String.ofList (unescL s.toList)

theorem unesc_esc (s : String) : unesc (esc s) = s := by
  unfold unesc esc
  rw [toList_ofList, unescL_escL, ofList_toList]

theorem esc_delim_free {d : Char} (hd : d ∈ delims) (s : String) :
    d ∉ (esc s).toList := by
  rw [esc, toList_ofList]
  exact escL_delim_free hd _

/-! ## Splitting and joining -/

/-- Join pieces with a separator character. -/
def joinWith (d : Char) : List (List Char) → List Char
  | [] => []
  | [p] => p
  | p :: ps => p ++ d :: joinWith d ps

/-- Split a character list on a separator; always returns a non-empty list. -/
def splitOnChar (d : Char) : List Char → List (List Char)
  | [] => [[]]
  | c :: cs =>
      if c = d then [] :: splitOnChar d cs
      else
        match splitOnChar d cs with
        | [] => [[c]]
        | p :: ps => (c :: p) :: ps

theorem splitOnChar_ne_nil (d : Char) (cs : List Char) :
    splitOnChar d cs ≠ [] := by
  induction cs with
  | nil => simp [splitOnChar]
  | cons c cs ih =>
      by_cases h : c = d
      · simp [splitOnChar, h]
      · simp only [splitOnChar, h, if_false]
        cases hs : splitOnChar d cs with
        | nil => simp
        | cons p ps => simp

theorem splitOnChar_free (d : Char) {cs : List Char} (h : d ∉ cs) :
    splitOnChar d cs = [cs] := by
  induction cs with
  | nil => rfl
  | cons c cs ih =>
      simp only [List.mem_cons, not_or] at h
      simp only [splitOnChar, ih h.2]
      rw [if_neg (fun hh => h.1 hh.symm)]

theorem splitOnChar_append (d : Char) {p : List Char} (hp : d ∉ p)
    (rest : List Char) :
    splitOnChar d (p ++ d :: rest) = p :: splitOnChar d rest := by
  induction p with
  | nil => simp [splitOnChar]
  | cons c p ih =>
      simp only [List.mem_cons, not_or] at hp
      have h2 := ih hp.2
      simp only [List.cons_append, splitOnChar, h2]
      rw [if_neg (fun hh => hp.1 hh.symm)]

theorem splitOnChar_joinWith (d : Char) :
    ∀ (ps : List (List Char)), ps ≠ [] → (∀ p ∈ ps, d ∉ p) →
      splitOnChar d (joinWith d ps) = ps := by
  intro ps
  induction ps with
  | nil => intro h; exact absurd rfl h
  | cons p ps ih =>
      intro _ hfree
      cases ps with
      | nil =>
          simpa [joinWith] using splitOnChar_free d (hfree p (by simp))
      | cons q qs =>
          have hp : d ∉ p := hfree p (by simp)
          have hrest : ∀ r ∈ q :: qs, d ∉ r := fun r hr => hfree r (by simp [hr])
          have hj : joinWith d (p :: q :: qs) = p ++ d :: joinWith d (q :: qs) := rfl
          rw [hj, splitOnChar_append d hp, ih (by simp) hrest]

/-- Split a string on a separator, returning the pieces as strings. -/
def splitStr (d : Char) (s : String) : List String :=
  (splitOnChar d s.toList).map String.ofList

/-- Join strings with a separator. -/
def joinStr (d : Char) (ps : List String) : String :=
  String.ofList (joinWith d (ps.map String.toList))

theorem splitStr_joinStr (d : Char) (ps : List String) (hne : ps ≠ [])
    (hfree : ∀ p ∈ ps, d ∉ p.toList) :
    splitStr d (joinStr d ps) = ps := by
  unfold splitStr joinStr
  rw [toList_ofList]
  rw [splitOnChar_joinWith d (ps.map String.toList)
    (by simpa using hne)
    (by
      intro p hp
      simp only [List.mem_map] at hp
      obtain ⟨q, hq, rfl⟩ := hp
      exact hfree q hq)]
  simp only [List.map_map]
  exact List.map_id'' (fun q => ofList_toList q) ps

/-! ### A tail-recursive implementation of splitting

`splitOnChar` is written for proof, not for execution: it recurses once per
character.  `splitOnCharTR` is the same function written with an accumulator,
and the `@[csimp]` lemma below replaces the former by the latter at run time,
so that splitting a multi-megabyte document does not exhaust the stack. -/

/-- Prepend a prefix to the first piece of a split. -/
def consFirst (pre : List Char) : List (List Char) → List (List Char)
  | [] => []
  | p :: ps => (pre ++ p) :: ps

/-- Accumulator loop of the tail-recursive splitter. -/
def splitLoop (d : Char) : List Char → List Char → List (List Char) → List (List Char)
  | [], cur, acc => (cur.reverse :: acc).reverse
  | c :: rest, cur, acc =>
      if c = d then splitLoop d rest [] (cur.reverse :: acc)
      else splitLoop d rest (c :: cur) acc

/-- Tail-recursive splitting. -/
def splitOnCharTR (d : Char) (cs : List Char) : List (List Char) := splitLoop d cs [] []

theorem splitLoop_eq (d : Char) : ∀ (cs cur : List Char) (acc : List (List Char)),
    splitLoop d cs cur acc = acc.reverse ++ consFirst cur.reverse (splitOnChar d cs) := by
  intro cs
  induction cs with
  | nil => intro cur acc; simp [splitLoop, splitOnChar, consFirst]
  | cons c cs ih =>
      intro cur acc
      by_cases h : c = d
      · simp only [splitLoop, h, ih, splitOnChar, List.reverse_cons, List.reverse_nil]
        cases hs : splitOnChar d cs with
        | nil => exact absurd hs (splitOnChar_ne_nil d cs)
        | cons p ps => simp [consFirst]
      · simp only [splitLoop, if_neg h, ih, splitOnChar]
        cases hs : splitOnChar d cs with
        | nil => exact absurd hs (splitOnChar_ne_nil d cs)
        | cons p ps => simp [consFirst]

@[csimp] theorem splitOnChar_eq_splitOnCharTR : @splitOnChar = @splitOnCharTR := by
  funext d cs
  have h := splitLoop_eq d cs [] []
  cases hs : splitOnChar d cs with
  | nil => exact absurd hs (splitOnChar_ne_nil d cs)
  | cons p ps =>
      rw [splitOnCharTR, h, hs]
      simp [consFirst]

theorem mem_joinWith {d c : Char} :
    ∀ ps : List (List Char), c ∈ joinWith d ps → c = d ∨ ∃ p ∈ ps, c ∈ p := by
  intro ps
  induction ps with
  | nil => intro h; simp [joinWith] at h
  | cons p ps ih =>
      cases ps with
      | nil => intro h; exact Or.inr ⟨p, by simp, by simpa [joinWith] using h⟩
      | cons q qs =>
          intro h
          have hj : joinWith d (p :: q :: qs) = p ++ d :: joinWith d (q :: qs) := rfl
          rw [hj] at h
          rcases List.mem_append.1 h with h1 | h1
          · exact Or.inr ⟨p, by simp, h1⟩
          · rcases List.mem_cons.1 h1 with h2 | h2
            · exact Or.inl h2
            · rcases ih h2 with h3 | ⟨r, hr, hcr⟩
              · exact Or.inl h3
              · exact Or.inr ⟨r, by simp [hr], hcr⟩

theorem notMem_joinStr {c d : Char} (hcd : c ≠ d) {ps : List String}
    (h : ∀ p ∈ ps, c ∉ p.toList) : c ∉ (joinStr d ps).toList := by
  rw [joinStr, toList_ofList]
  intro hc
  rcases mem_joinWith _ hc with h1 | ⟨p, hp, hcp⟩
  · exact hcd h1
  · simp only [List.mem_map] at hp
    obtain ⟨q, hq, rfl⟩ := hp
    exact h q hq hcp

end Domain
