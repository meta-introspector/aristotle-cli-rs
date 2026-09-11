/-
# A small parser toolkit, with round-trip lemmas

Every codec in this package (canonical, IPDL, XML, CSV, YAML, raw text)
has to write a string out and read it back.  The three recurring pieces
are developed once, here, together with the lemma that makes each of them
lossless:

* backslash escaping up to a terminator (`escL` / `readEsc`);
* doubling escaping inside quotes, the CSV/RFC-4180 convention
  (`escDbl` / `readDbl`);
* decimal integers up to a terminator (`intChars` / `readInt`).

Each `read*` is a total function on `List Char` returning the value and
the unconsumed remainder, so parsers can be composed without fuel except
where the *structure* is recursive.
-/
import RequestProject.Edge.Cf.Digits

namespace CfDeploy
namespace Codec
namespace Parse

/-! ## Backslash escaping up to a terminator -/

/-- Escape one character for a `term`-terminated field. -/
def escChar (term c : Char) : List Char :=
  if c = '\\' then ['\\', '\\'] else if c = term then ['\\', term] else [c]

/-- Escape a character list so that it contains no unescaped `term`. -/
def escL (term : Char) (s : List Char) : List Char := s.flatMap (escChar term)

/-- Read an escaped character list up to and including its terminator. -/
def readEsc (term : Char) : List Char → Option (List Char × List Char)
  | [] => none
  | c :: r =>
      if c = term then some ([], r)
      else if c = '\\' then
        match r with
        | [] => none
        | d :: r' => (readEsc term r').map (fun p => (d :: p.1, p.2))
      else (readEsc term r).map (fun p => (c :: p.1, p.2))
termination_by l => l.length
decreasing_by
  · simp; omega
  · simp

theorem readEsc_term (term : Char) (r : List Char) :
    readEsc term (term :: r) = some ([], r) := by
  rw [readEsc.eq_def]; simp

theorem readEsc_bs {term : Char} (h : term ≠ '\\') (d : Char) (r : List Char) :
    readEsc term ('\\' :: d :: r) = (readEsc term r).map (fun p => (d :: p.1, p.2)) := by
  rw [readEsc.eq_def]; simp [Ne.symm h]

theorem readEsc_other {term c : Char} (h1 : c ≠ term) (h2 : c ≠ '\\') (r : List Char) :
    readEsc term (c :: r) = (readEsc term r).map (fun p => (c :: p.1, p.2)) := by
  rw [readEsc.eq_def]; simp [h1, h2]

/-- **Lossless.**  An escaped field reads back exactly, leaving whatever
followed the terminator. -/
theorem readEsc_escL {term : Char} (h : term ≠ '\\') (s rest : List Char) :
    readEsc term (escL term s ++ term :: rest) = some (s, rest) := by
  induction s with
  | nil => simp [escL, readEsc_term]
  | cons c cs ih =>
      have hstep : escL term (c :: cs) = escChar term c ++ escL term cs := by
        simp [escL, List.flatMap_cons]
      rw [hstep, List.append_assoc]
      by_cases h1 : c = '\\'
      · subst h1
        have he : escChar term '\\' = ['\\', '\\'] := by simp [escChar]
        rw [he]
        simp only [List.cons_append, List.nil_append]
        rw [readEsc_bs h, ih]
        simp
      · by_cases h2 : c = term
        · subst h2
          have he : escChar c c = ['\\', c] := by simp [escChar, h1]
          rw [he]
          simp only [List.cons_append, List.nil_append]
          rw [readEsc_bs h, ih]
          simp
        · have he : escChar term c = [c] := by simp [escChar, h1, h2]
          rw [he]
          simp only [List.cons_append, List.nil_append]
          rw [readEsc_other h2 h1, ih]
          simp

/-! ## Doubling escaping inside quotes (the CSV convention) -/

/-- Escape a character list by doubling the quote character. -/
def escDbl (q : Char) (s : List Char) : List Char :=
  s.flatMap (fun c => if c = q then [q, q] else [c])

/-- Read a doubling-escaped field up to its closing quote (the opening
quote must already have been consumed). -/
def readDbl (q : Char) : List Char → Option (List Char × List Char)
  | [] => none
  | c :: r =>
      if c = q then
        match r with
        | c' :: r' =>
            if c' = q then (readDbl q r').map (fun p => (q :: p.1, p.2))
            else some ([], c' :: r')
        | [] => some ([], [])
      else (readDbl q r).map (fun p => (c :: p.1, p.2))
termination_by l => l.length
decreasing_by
  · simp; omega
  · simp

theorem readDbl_close {q : Char} (r : List Char) (hr : ∀ c ∈ r.head?, c ≠ q) :
    readDbl q (q :: r) = some ([], r) := by
  rw [readDbl.eq_def]
  cases r with
  | nil => simp
  | cons c r' =>
      have : c ≠ q := hr c (by simp)
      simp [this]

/-- **Lossless.**  A quoted field with doubled quotes reads back exactly,
provided what follows the closing quote is not another quote. -/
theorem readDbl_escDbl {q : Char} (s rest : List Char) (hrest : ∀ c ∈ rest.head?, c ≠ q) :
    readDbl q (escDbl q s ++ q :: rest) = some (s, rest) := by
  induction s with
  | nil => simpa [escDbl] using readDbl_close rest hrest
  | cons c cs ih =>
      have hstep : escDbl q (c :: cs) = (if c = q then [q, q] else [c]) ++ escDbl q cs := by
        simp [escDbl, List.flatMap_cons]
      rw [hstep, List.append_assoc]
      by_cases h1 : c = q
      · subst h1
        rw [if_pos rfl]
        rw [readDbl.eq_def]
        simp [ih]
      · simp only [if_neg h1, List.cons_append, List.nil_append]
        rw [readDbl.eq_def]
        simp [h1, ih]

/-! ## Decimal integers up to a terminator -/

open Digits in
/-- The characters of an integer: an optional `-` then decimal digits. -/
def intChars (i : Int) : List Char :=
  if i < 0 then '-' :: toDigits i.natAbs else toDigits i.natAbs

/-- Read decimal digits, most significant first, stopping at the first
non-digit. -/
def readNatAux (acc : Nat) : List Char → Nat × List Char
  | [] => (acc, [])
  | c :: cs =>
      match Digits.charDigit c with
      | some d => readNatAux (acc * 10 + d) cs
      | none => (acc, c :: cs)

theorem readNatAux_toDigits (n acc : Nat) (rest : List Char) :
    readNatAux acc (Digits.toDigits n ++ rest)
      = readNatAux (acc * 10 ^ (Digits.toDigits n).length + n) rest := by
  induction n using Digits.toDigits.induct generalizing acc rest with
  | case1 n h =>
      rw [Digits.toDigits, if_pos h]
      simp [readNatAux, Digits.charDigit_digitChar h]
  | case2 n h ih =>
      rw [Digits.toDigits, if_neg h]
      have hd : n % 10 < 10 := Nat.mod_lt _ (by omega)
      rw [List.append_assoc, ih]
      simp only [List.singleton_append, readNatAux, Digits.charDigit_digitChar hd,
        List.length_append, List.length_cons, List.length_nil, Nat.zero_add]
      congr 1
      have hpow : acc * 10 ^ ((Digits.toDigits (n / 10)).length + 1)
          = acc * 10 ^ (Digits.toDigits (n / 10)).length * 10 := by
        rw [Nat.pow_succ, Nat.mul_assoc]
      rw [hpow]
      generalize acc * 10 ^ (Digits.toDigits (n / 10)).length = Y
      omega

theorem toDigits_head_digit (n : Nat) :
    ∃ c cs d, Digits.toDigits n = c :: cs ∧ Digits.charDigit c = some d := by
  induction n using Digits.toDigits.induct with
  | case1 n h =>
      exact ⟨_, _, n, by rw [Digits.toDigits, if_pos h], Digits.charDigit_digitChar h⟩
  | case2 n h ih =>
      obtain ⟨c, cs, d, hcs, hd⟩ := ih
      refine ⟨c, cs ++ [Digits.digitChar (n % 10)], d, ?_, hd⟩
      rw [Digits.toDigits, if_neg h, hcs]; simp

theorem toDigits_ne_nil (n : Nat) : Digits.toDigits n ≠ [] := by
  rw [Digits.toDigits]; split <;> simp

theorem intChars_ne_nil (i : Int) : intChars i ≠ [] := by
  unfold intChars
  split
  · simp
  · exact toDigits_ne_nil _

theorem intChars_length_pos (i : Int) : 1 ≤ (intChars i).length := by
  cases h : intChars i with
  | nil => exact absurd h (intChars_ne_nil i)
  | cons a l => simp

/-- Read at least one decimal digit followed by `term`. -/
def readNatDigits (term : Char) : List Char → Option (Nat × List Char)
  | [] => none
  | c :: cs =>
      match Digits.charDigit c with
      | some d =>
          match readNatAux d cs with
          | (n, t :: r) => if t = term then some (n, r) else none
          | _ => none
      | none => none

theorem readNatDigits_toDigits {term : Char} (hterm : Digits.charDigit term = none)
    (n : Nat) (rest : List Char) :
    readNatDigits term (Digits.toDigits n ++ term :: rest) = some (n, rest) := by
  have hsemi : readNatAux 0 (Digits.toDigits n ++ term :: rest) = (n, term :: rest) := by
    rw [readNatAux_toDigits]
    simp [readNatAux, hterm]
  obtain ⟨c, cs, d, hcs, hd⟩ := toDigits_head_digit n
  rw [hcs] at hsemi ⊢
  simp only [List.cons_append, readNatAux, hd, Nat.zero_mul, Nat.zero_add] at hsemi
  simp only [List.cons_append, readNatDigits, hd]
  rw [hsemi]
  simp

/-- Read an integer followed by `term`. -/
def readInt (term : Char) : List Char → Option (Int × List Char)
  | [] => none
  | '-' :: cs => (readNatDigits term cs).map (fun p => (-(p.1 : Int), p.2))
  | cs => (readNatDigits term cs).map (fun p => ((p.1 : Int), p.2))

/-- **Lossless.**  A terminated decimal integer reads back exactly. -/
theorem readInt_intChars {term : Char} (hterm : Digits.charDigit term = none)
    (i : Int) (rest : List Char) :
    readInt term (intChars i ++ term :: rest) = some (i, rest) := by
  obtain ⟨c, cs, d, hcs, hd⟩ := toDigits_head_digit i.natAbs
  have hne : c ≠ '-' := by
    intro hc; subst hc; simp [Digits.charDigit] at hd
  by_cases h : i < 0
  · simp only [intChars, if_pos h, List.cons_append]
    rw [readInt, readNatDigits_toDigits hterm]
    have : -(i.natAbs : Int) = i := by omega
    simp [this]
  · simp only [intChars, if_neg h]
    rw [hcs, List.cons_append, readInt.eq_def]
    split
    · simp_all
    · rename_i heq; injection heq with h1 _; exact absurd h1 hne
    · rw [← List.cons_append, ← hcs, readNatDigits_toDigits hterm]
      have : ((i.natAbs : Int)) = i := by omega
      simp [this]

/-! ## Integers as whole strings

A number carried in a *field* of some other format — an XML attribute, a
CSV cell — is a complete string rather than a prefix of a longer stream.
These wrappers turn the streaming integer reader into a total-field
reader, and keep the round trip. -/

/-- An integer as a complete string. -/
def intStr (i : Int) : String := String.ofList (intChars i)

/-- Read an integer that occupies a whole string. -/
def parseIntStr (s : String) : Option Int :=
  match readInt ';' (s.toList ++ [';']) with
  | some (i, []) => some i
  | _ => none

@[simp] theorem parseIntStr_intStr (i : Int) : parseIntStr (intStr i) = some i := by
  have h := readInt_intChars (by decide : Digits.charDigit ';' = none) i []
  simp only [parseIntStr, intStr, String.toList_ofList]
  rw [show intChars i ++ [';'] = intChars i ++ ';' :: [] from rfl, h]

/-- Two integers in one string, as `mantissa;exponent;`. -/
def intPairStr (m e : Int) : String :=
  String.ofList (intChars m ++ ';' :: (intChars e ++ [';']))

/-- Read a pair of integers that occupies a whole string. -/
def parseIntPairStr (s : String) : Option (Int × Int) :=
  match readInt ';' s.toList with
  | some (m, r) =>
      match readInt ';' r with
      | some (e, []) => some (m, e)
      | _ => none
  | none => none

@[simp] theorem parseIntPairStr_intPairStr (m e : Int) :
    parseIntPairStr (intPairStr m e) = some (m, e) := by
  have hterm : Digits.charDigit ';' = none := by decide
  have h1 := readInt_intChars hterm m (intChars e ++ [';'])
  have h2 := readInt_intChars hterm e []
  have h2' : readInt ';' (intChars e ++ [';']) = some (e, []) := h2
  simp only [parseIntPairStr, intPairStr, String.toList_ofList, h1, h2']

/-! ## Integers that stop at the first non-digit -/

theorem readNatAux_stop (acc : Nat) (rest : List Char)
    (h : ∀ c ∈ rest.head?, Digits.charDigit c = none) : readNatAux acc rest = (acc, rest) := by
  cases rest with
  | nil => rfl
  | cons c r => simp only [readNatAux, h c (by simp)]

/-- Read an integer, stopping at (but not consuming) the first
non-digit. -/
def readIntOpen : List Char → Option (Int × List Char)
  | [] => none
  | '-' :: cs =>
      match cs with
      | [] => none
      | c :: cs' =>
          match Digits.charDigit c with
          | some d => some (-((readNatAux d cs').1 : Int), (readNatAux d cs').2)
          | none => none
  | c :: cs =>
      match Digits.charDigit c with
      | some d => some (((readNatAux d cs).1 : Int), (readNatAux d cs).2)
      | none => none

theorem readNatOpen_toDigits (n : Nat) (rest : List Char)
    (h : ∀ c ∈ rest.head?, Digits.charDigit c = none) :
    ∀ c cs d, Digits.toDigits n = c :: cs → Digits.charDigit c = some d →
      readNatAux d (cs ++ rest) = (n, rest) := by
  intro c cs d hcs hd
  have h0 : readNatAux 0 (Digits.toDigits n ++ rest) = (n, rest) := by
    rw [readNatAux_toDigits]
    simpa using readNatAux_stop n rest h
  rw [hcs] at h0
  simpa [readNatAux, hd] using h0

theorem readIntOpen_intChars (i : Int) (rest : List Char)
    (h : ∀ c ∈ rest.head?, Digits.charDigit c = none) :
    readIntOpen (intChars i ++ rest) = some (i, rest) := by
  obtain ⟨c, cs, d, hcs, hd⟩ := toDigits_head_digit i.natAbs
  have hne : c ≠ '-' := by
    intro hc; subst hc; simp [Digits.charDigit] at hd
  have hkey := readNatOpen_toDigits i.natAbs rest h c cs d hcs hd
  by_cases hneg : i < 0
  · simp only [intChars, if_pos hneg, hcs, List.cons_append, readIntOpen, hd, hkey]
    have : -(i.natAbs : Int) = i := by omega
    simp [this]
  · simp only [intChars, if_neg hneg, hcs, List.cons_append]
    rw [readIntOpen.eq_def]
    split
    · simp_all
    · rename_i heq; injection heq with h1 _; exact absurd h1 hne
    · rename_i heq
      injection heq with h1 h2
      subst h1; subst h2
      simp only [hd, hkey]
      have : ((i.natAbs : Int)) = i := by omega
      simp [this]

/-! ## YAML-style backslash escaping -/

/-- Escape one character for a double-quoted YAML scalar. -/
def escYChar (c : Char) : List Char :=
  if c = '"' then ['\\', '"']
  else if c = '\\' then ['\\', '\\']
  else if c = '\n' then ['\\', 'n']
  else [c]

/-- Escape a string for a double-quoted YAML scalar: the quote, the
backslash and the newline get backslash escapes. -/
def escY (s : List Char) : List Char := s.flatMap escYChar

/-- Read a double-quoted YAML scalar up to its closing quote (the
opening quote must already have been consumed). -/
def readY : List Char → Option (List Char × List Char)
  | [] => none
  | '"' :: r => some ([], r)
  | '\\' :: d :: r => (readY r).map (fun p => ((if d = 'n' then '\n' else d) :: p.1, p.2))
  | '\\' :: [] => none
  | c :: r => (readY r).map (fun p => (c :: p.1, p.2))
termination_by l => l.length

/-- **Lossless.**  A double-quoted YAML scalar reads back exactly. -/
theorem readY_escY (s rest : List Char) : readY (escY s ++ '"' :: rest) = some (s, rest) := by
  induction s with
  | nil => simp [escY, readY]
  | cons c cs ih =>
      have hstep : escY (c :: cs) = escYChar c ++ escY cs := by simp [escY, List.flatMap_cons]
      rw [hstep, List.append_assoc]
      by_cases h1 : c = '"'
      · subst h1
        simp only [escYChar]
        rw [readY.eq_def]
        simp [ih]
      · by_cases h2 : c = '\\'
        · subst h2
          simp only [escYChar, if_neg h1]
          rw [readY.eq_def]
          simp [ih]
        · by_cases h3 : c = '\n'
          · subst h3
            simp only [escYChar, if_neg h1, if_neg h2]
            rw [readY.eq_def]
            simp [ih]
          · simp only [escYChar, if_neg h1, if_neg h2, if_neg h3, List.cons_append,
              List.nil_append]
            rw [readY.eq_def]
            simp [h2, ih]

end Parse
end Codec
end CfDeploy
