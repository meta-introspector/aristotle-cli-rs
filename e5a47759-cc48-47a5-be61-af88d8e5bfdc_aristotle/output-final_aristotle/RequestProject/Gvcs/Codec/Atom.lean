import Mathlib

/-!
# Atoms: the escaping layer shared by every codec

Every codec in `RequestProject.Codec` writes its scalars (identifiers, names, values,
messages, arbitrary user text) through one escaping scheme, defined here.

An *atom* is a string rendered so that it uses only characters from a small safe
alphabet — ASCII letters and digits together with `-`, `.`, `_`, `+` — plus the
escape marker `~`, which is always followed by exactly six hexadecimal digits giving the
Unicode code point of the escaped character.

Two consequences make the codecs above this layer easy to specify and to verify:

* No structural delimiter of any codec (`<`, `>`, `/`, `"`, `(`, `)`, `[`, `]`, `{`, `}`,
  `,`, `:`, `=`, whitespace, newline) can occur inside a rendered atom, so an atom can
  always be read back by scanning forward until the first character that is neither safe
  nor an escape.
* The scheme is total: every `String` — including one holding a stack trace, a Lean
  source fragment, or arbitrary Unicode — has a rendering, so nothing has to be dropped
  in order to be transported.

The main result is `unesc_esc_append`: reading an atom back off the front of
`esc s ++ rest` recovers `s` exactly and leaves `rest` untouched, provided `rest` does
not itself begin with an atom character (which every codec arranges, since a delimiter
always follows an atom).
-/

namespace LifeTrac.Codec

/-- Characters that may appear literally inside a rendered atom. -/
def isSafeChar (c : Char) : Bool :=
  c.isAlphanum || c = '-' || c = '.' || c = '_' || c = '+'

/-- The escape marker. Never safe, so it can start an escape unambiguously. -/
def escMark : Char := '~'

theorem escMark_not_safe : isSafeChar escMark = false := by decide

/-- Characters that can begin an atom: safe characters and the escape marker. -/
def isAtomChar (c : Char) : Bool := isSafeChar c || c == escMark

/-- Hexadecimal digit (upper case) for `n < 16`. -/
def hexDigit (n : Nat) : Char :=
  if n < 10 then Char.ofNat (48 + n) else Char.ofNat (55 + n)

/-- Value of a hexadecimal digit; `16` if the character is not one. -/
def hexVal (c : Char) : Nat :=
  let n := c.toNat
  if 48 ≤ n && n ≤ 57 then n - 48
  else if 65 ≤ n && n ≤ 70 then n - 55
  else if 97 ≤ n && n ≤ 102 then n - 87
  else 16

/-- The six hexadecimal digits of a code point, most significant first. -/
def hex6 (n : Nat) : List Char :=
  [hexDigit (n / 1048576 % 16), hexDigit (n / 65536 % 16), hexDigit (n / 4096 % 16),
   hexDigit (n / 256 % 16), hexDigit (n / 16 % 16), hexDigit (n % 16)]

/-- Value of six hexadecimal digits. -/
def unhex6 (a b c d e f : Char) : Nat :=
  ((((hexVal a * 16 + hexVal b) * 16 + hexVal c) * 16 + hexVal d) * 16 + hexVal e) * 16
    + hexVal f

theorem hexVal_hexDigit {n : Nat} (h : n < 16) : hexVal (hexDigit n) = n := by
  interval_cases n <;> rfl

theorem hexDigit_safe {n : Nat} (h : n < 16) : isSafeChar (hexDigit n) = true := by
  interval_cases n <;> rfl

theorem char_toNat_lt (c : Char) : c.toNat < 1114112 := by
  have := c.valid
  unfold Char.toNat
  rcases this with h | h <;> omega

theorem unhex6_hex6 {n : Nat} (h : n < 1114112) :
    unhex6 (hexDigit (n / 1048576 % 16)) (hexDigit (n / 65536 % 16)) (hexDigit (n / 4096 % 16))
      (hexDigit (n / 256 % 16)) (hexDigit (n / 16 % 16)) (hexDigit (n % 16)) = n := by
  simp only [unhex6]
  rw [hexVal_hexDigit (by omega), hexVal_hexDigit (by omega), hexVal_hexDigit (by omega),
    hexVal_hexDigit (by omega), hexVal_hexDigit (by omega), hexVal_hexDigit (by omega)]
  omega

/-- Rendering of a single character. -/
def escChar (c : Char) : List Char :=
  if isSafeChar c then [c] else escMark :: hex6 c.toNat

/-- Rendering of a character list as an atom. -/
def escChars (s : List Char) : List Char := s.flatMap escChar

/-- Rendering of a string as an atom. -/
def esc (s : String) : String := String.ofList (escChars s.toList)

/--
Read one atom off the front of a character list.  Returns the decoded characters and the
remaining input; stops at the first character that cannot continue an atom.
-/
def unescChars : List Char → List Char × List Char
  | [] => ([], [])
  | c₀ :: t =>
      if c₀ = escMark then
        match t with
        | a :: b :: c :: d :: e :: f :: t' =>
            let n := unhex6 a b c d e f
            if n < 1114112 then
              let r := unescChars t'
              (Char.ofNat n :: r.1, r.2)
            else ([], c₀ :: t)
        | _ => ([], c₀ :: t)
      else if isSafeChar c₀ then
        let r := unescChars t
        (c₀ :: r.1, r.2)
      else ([], c₀ :: t)

/-- Read one atom off the front of a character list, as a `String`. -/
def unesc (l : List Char) : String × List Char :=
  let r := unescChars l
  (String.ofList r.1, r.2)

theorem unescChars_nonatom {rest : List Char}
    (h : ∀ c ∈ rest.head?, isAtomChar c = false) : unescChars rest = ([], rest) := by
  match rest with
  | [] => rfl
  | c₀ :: t =>
    have hc : isAtomChar c₀ = false := h c₀ (by simp)
    simp only [isAtomChar, Bool.or_eq_false_iff, beq_eq_false_iff_ne] at hc
    rw [unescChars.eq_def]
    simp [hc.1, hc.2]

theorem unescChars_safe_cons {c : Char} (hs : isSafeChar c = true) (t : List Char) :
    unescChars (c :: t) = (c :: (unescChars t).1, (unescChars t).2) := by
  have hne : ¬ (c = escMark) := by
    intro hc; rw [hc, escMark_not_safe] at hs; exact Bool.noConfusion hs
  rw [unescChars.eq_def]
  simp [hne, hs]

theorem unescChars_escape_cons (c : Char) (t : List Char) :
    unescChars (escMark :: (hex6 c.toNat ++ t))
      = (c :: (unescChars t).1, (unescChars t).2) := by
  have hlt : c.toNat < 1114112 := char_toNat_lt c
  simp only [hex6, List.cons_append, List.nil_append, unescChars,
    unhex6_hex6 hlt, if_pos hlt, Char.ofNat_toNat, if_true]

theorem unescChars_escChars_append (s : List Char) (rest : List Char)
    (h : ∀ x ∈ rest.head?, isAtomChar x = false) :
    unescChars (escChars s ++ rest) = (s, rest) := by
  induction s with
  | nil => simpa [escChars] using unescChars_nonatom h
  | cons c t ih =>
    simp only [escChars, List.flatMap_cons, List.append_assoc] at ih ⊢
    by_cases hs : isSafeChar c
    · simp only [escChar, hs, if_true, List.cons_append, List.nil_append]
      rw [unescChars_safe_cons hs, ih]
    · simp only [escChar, hs, Bool.false_eq_true, if_false, List.cons_append]
      rw [unescChars_escape_cons c, ih]

/-- **Atoms round-trip.** An atom followed by any non-atom character is read back exactly. -/
theorem unesc_esc_append (s : String) (rest : List Char)
    (h : ∀ x ∈ rest.head?, isAtomChar x = false) :
    unesc ((esc s).toList ++ rest) = (s, rest) := by
  simp [unesc, esc, unescChars_escChars_append s.toList rest h]

theorem unesc_esc (s : String) : unesc (esc s).toList = (s, []) := by
  simpa using unesc_esc_append s [] (by simp)

/-- Every character of a rendered atom is an atom character. -/
theorem escChars_atomChars (s : List Char) : ∀ c ∈ escChars s, isAtomChar c = true := by
  intro c hc
  simp only [escChars, List.mem_flatMap] at hc
  obtain ⟨x, _, hx⟩ := hc
  by_cases hs : isSafeChar x
  · simp only [escChar, hs, if_true, List.mem_singleton] at hx
    simp [isAtomChar, hx ▸ hs]
  · simp only [escChar, hs, Bool.false_eq_true, if_false, List.mem_cons] at hx
    rcases hx with rfl | hx
    · simp [isAtomChar]
    · have hd : ∀ n : Nat, isSafeChar (hexDigit (n % 16)) = true := fun n =>
        hexDigit_safe (Nat.mod_lt _ (by norm_num))
      simp only [hex6, List.mem_cons, List.not_mem_nil, or_false] at hx
      rcases hx with rfl | rfl | rfl | rfl | rfl | rfl <;> simp [isAtomChar, hd]

/-!
## Numerals

Integers travel as atoms too, but their rendering must be readable and must round-trip,
so it is given explicitly here rather than borrowed from `toString`.  Digits and the
minus sign are safe characters, so a rendered numeral passes through `esc` unchanged.
-/

/-- The character for a decimal digit `d < 10`. -/
def digitChar (n : Nat) : Char := Char.ofNat (48 + n)

/-- The value of a decimal digit character. -/
def digitVal? (c : Char) : Option Nat :=
  if 48 ≤ c.toNat && c.toNat ≤ 57 then some (c.toNat - 48) else none

theorem digitVal_digitChar {d : Nat} (h : d < 10) : digitVal? (digitChar d) = some d := by
  interval_cases d <;> rfl

theorem digitChar_range {d : Nat} (h : d < 10) :
    48 ≤ (digitChar d).toNat ∧ (digitChar d).toNat ≤ 57 := by
  interval_cases d <;> exact ⟨by decide, by decide⟩

/-- Decimal rendering of a natural number, most significant digit first. -/
def natChars (n : Nat) : List Char :=
  if n = 0 then ['0'] else (Nat.digits 10 n).reverse.map digitChar

/-- Reading a decimal natural number; the empty string is not a numeral. -/
def parseNatChars? (l : List Char) : Option Nat :=
  match l with
  | [] => none
  | _ => (l.mapM digitVal?).map (fun ds => Nat.ofDigits 10 ds.reverse)

theorem mapM_digitVal (ds : List Nat) (h : ∀ d ∈ ds, d < 10) :
    (ds.map digitChar).mapM digitVal? = some ds := by
  induction ds with
  | nil => rfl
  | cons d t ih =>
    simp only [List.map_cons, List.mapM_cons, digitVal_digitChar (h d (by simp)),
      ih (fun x hx => h x (by simp [hx]))]
    rfl

theorem parseNatChars_natChars (n : Nat) : parseNatChars? (natChars n) = some n := by
  by_cases h : n = 0
  · subst h; rfl
  · have hd : ∀ d ∈ Nat.digits 10 n, d < 10 := fun d hd => Nat.digits_lt_base (by norm_num) hd
    have hne : (Nat.digits 10 n) ≠ [] := Nat.digits_ne_nil_iff_ne_zero.mpr h
    have hmap : ((Nat.digits 10 n).reverse.map digitChar).mapM digitVal?
        = some (Nat.digits 10 n).reverse :=
      mapM_digitVal _ (fun d hd' => hd d (List.mem_reverse.mp hd'))
    have hnil : ((Nat.digits 10 n).reverse.map digitChar) ≠ [] := by
      simp only [ne_eq, List.map_eq_nil_iff, List.reverse_eq_nil_iff]
      exact hne
    simp only [natChars, if_neg h]
    unfold parseNatChars?
    split
    · exact absurd ‹_› hnil
    · rw [hmap]
      simp [Nat.ofDigits_digits]

theorem natChars_mem_digit {n : Nat} {c : Char} (hc : c ∈ natChars n) :
    48 ≤ c.toNat ∧ c.toNat ≤ 57 := by
  by_cases h : n = 0
  · subst h
    have h0 : natChars 0 = ['0'] := rfl
    rw [h0, List.mem_singleton] at hc
    subst hc
    exact ⟨by decide, by decide⟩
  · simp only [natChars, if_neg h, List.mem_map] at hc
    obtain ⟨d, hd, rfl⟩ := hc
    exact digitChar_range (Nat.digits_lt_base (by norm_num) (List.mem_reverse.mp hd))

theorem natChars_head_ne_minus (n : Nat) : (natChars n).head? ≠ some '-' := by
  intro h
  have hmem : '-' ∈ natChars n := List.mem_of_mem_head? h
  have hdig := natChars_mem_digit hmem
  have h45 : ('-' : Char).toNat = 45 := by decide
  rw [h45] at hdig
  omega

/-- Decimal rendering of an integer. -/
def intChars (i : Int) : List Char :=
  if i < 0 then '-' :: natChars i.natAbs else natChars i.natAbs

/-- Reading a decimal integer. -/
def parseIntChars? (l : List Char) : Option Int :=
  if l.head? = some '-' then (parseNatChars? l.tail).map (fun n => -(n : Int))
  else (parseNatChars? l).map (fun n => (n : Int))

theorem parseIntChars_intChars (i : Int) : parseIntChars? (intChars i) = some i := by
  by_cases h : i < 0
  · simp only [intChars, if_pos h, parseIntChars?, List.head?_cons, List.tail_cons]
    simp [parseNatChars_natChars, abs_of_neg h]
  · simp only [intChars, if_neg h, parseIntChars?, if_neg (natChars_head_ne_minus i.natAbs)]
    simp [parseNatChars_natChars, abs_of_nonneg (not_lt.mp h)]

/-- Rendering of an integer as an atom string. -/
def intAtom (i : Int) : String := String.ofList (intChars i)

/-- Reading an integer atom. -/
def parseIntAtom? (s : String) : Option Int := parseIntChars? s.toList

@[simp] theorem parseIntAtom_intAtom (i : Int) : parseIntAtom? (intAtom i) = some i := by
  simp [parseIntAtom?, intAtom, parseIntChars_intChars]

/-- Rendering of a boolean as an atom string. -/
def boolAtom (b : Bool) : String := if b then "true" else "false"

/-- Reading a boolean atom. -/
def parseBoolAtom? (s : String) : Option Bool :=
  if s = "true" then some true else if s = "false" then some false else none

@[simp] theorem parseBoolAtom_boolAtom (b : Bool) : parseBoolAtom? (boolAtom b) = some b := by
  cases b <;> rfl

end LifeTrac.Codec
