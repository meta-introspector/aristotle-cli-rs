/-
# The rendering kernel: the canonical numeral codec

Share tokens and serialized render trees are text, and text has to be
parsed back with no ambiguity, or "a token names one history" is false.
This module is the small, proof-friendly numeral codec everything else in
the layer is built from:

* a natural is written little-endian in lowercase hex and closed with
  `';'` — `encNat`;
* a list of naturals is written length-first — `encNats`;
* both decoders are rest-passing, so encodings concatenate.

Proved: `decNat_encNat`, `decNats_encNats` (round trips against an
arbitrary suffix, which is what makes concatenation safe) and
`encNats_injective`.

The alphabet is `0-9a-f;`, so every token is ASCII and URL-safe once
`';'` is percent-escaped, or usable verbatim in a fragment.
-/
import Mathlib
import RequestProject.Kant.Bytes

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Kernel.Codec

open Kant.Bytes

/-- The terminator that closes a numeral. -/
def sep : Char := ';'

/-- Little-endian lowercase hex digits of a natural; `0` is the empty
list, which is why the terminator is needed. -/
def natChars (n : Nat) : List Char :=
  if h : n = 0 then [] else hexDigit (n % 16) :: natChars (n / 16)
termination_by n
decreasing_by exact Nat.div_lt_self (Nat.pos_of_ne_zero h) (by norm_num)

/-- A natural as text: digits, then the terminator. -/
def encNat (n : Nat) : List Char := natChars n ++ [sep]

/-- Read a little-endian hex numeral, accumulating `acc` with place value
`mul`, and return whatever follows the terminator. -/
def decNatAux (acc mul : Nat) : List Char → Option (Nat × List Char)
  | [] => none
  | c :: rest =>
      if c = sep then some (acc, rest)
      else match hexVal c with
        | some v => decNatAux (acc + mul * v) (mul * 16) rest
        | none => none

/-- Read a numeral. -/
def decNat (cs : List Char) : Option (Nat × List Char) := decNatAux 0 1 cs

theorem hexDigit_ne_sep {d : Nat} (h : d < 16) : hexDigit d ≠ sep := by
  interval_cases d <;> decide

theorem decNatAux_encNat (n : Nat) :
    ∀ (acc mul : Nat) (rest : List Char),
      decNatAux acc mul (natChars n ++ sep :: rest) = some (acc + mul * n, rest) := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
      intro acc mul rest
      by_cases hn : n = 0
      · subst hn
        simp [natChars, decNatAux]
      · have hmod : n % 16 < 16 := Nat.mod_lt _ (by norm_num)
        have hdiv : n / 16 < n := Nat.div_lt_self (Nat.pos_of_ne_zero hn) (by norm_num)
        rw [natChars, dif_neg hn, List.cons_append]
        simp only [decNatAux, if_neg (hexDigit_ne_sep hmod), hexVal_hexDigit hmod]
        rw [ih (n / 16) hdiv]
        have : acc + mul * (n % 16) + mul * 16 * (n / 16) = acc + mul * n := by
          have h16 : 16 * (n / 16) + n % 16 = n := Nat.div_add_mod n 16
          calc acc + mul * (n % 16) + mul * 16 * (n / 16)
              = acc + mul * (16 * (n / 16) + n % 16) := by ring
            _ = acc + mul * n := by rw [h16]
        rw [this]

/-- A numeral reads back, whatever follows it. -/
theorem decNat_encNat (n : Nat) (rest : List Char) :
    decNat (encNat n ++ rest) = some (n, rest) := by
  have := decNatAux_encNat n 0 1 rest
  simpa [decNat, encNat, sep] using this

/-! ## Lists of naturals -/

/-- A list of naturals: its length, then its elements. -/
def encNats (ns : List Nat) : List Char :=
  encNat ns.length ++ ns.flatMap encNat

/-- Read exactly `k` numerals. -/
def decNatsN : Nat → List Char → Option (List Nat × List Char)
  | 0, cs => some ([], cs)
  | k + 1, cs => match decNat cs with
      | some (n, rest) => (decNatsN k rest).map (fun p => (n :: p.1, p.2))
      | none => none

/-- Read a length-prefixed list of numerals. -/
def decNats (cs : List Char) : Option (List Nat × List Char) :=
  match decNat cs with
  | some (k, rest) => decNatsN k rest
  | none => none

theorem decNatsN_flatMap (ns : List Nat) (rest : List Char) :
    decNatsN ns.length (ns.flatMap encNat ++ rest) = some (ns, rest) := by
  induction ns with
  | nil => simp [decNatsN]
  | cons n ns ih =>
      simp only [List.flatMap_cons, List.append_assoc, List.length_cons, decNatsN,
        decNat_encNat n]
      simp [ih]

/-- A list of naturals reads back, whatever follows it. -/
theorem decNats_encNats (ns : List Nat) (rest : List Char) :
    decNats (encNats ns ++ rest) = some (ns, rest) := by
  simp only [encNats, List.append_assoc, decNats, decNat_encNat]
  exact decNatsN_flatMap ns rest

theorem encNats_injective : Function.Injective encNats := by
  intro a b h
  have ha := decNats_encNats a []
  have hb := decNats_encNats b []
  rw [h, hb] at ha
  simpa using ha.symm

/-! ## Strings and attribute lists -/

/-- A run of characters: its length, then the characters.  Nothing is
escaped, so any text at all survives, including the separator. -/
def encStr (s : List Char) : List Char := encNat s.length ++ s

/-- Read a length-prefixed run of characters. -/
def decStr (cs : List Char) : Option (List Char × List Char) :=
  match decNat cs with
  | some (n, rest) => if n ≤ rest.length then some (rest.take n, rest.drop n) else none
  | none => none

theorem decStr_encStr (s rest : List Char) : decStr (encStr s ++ rest) = some (s, rest) := by
  simp only [encStr, List.append_assoc, decStr, decNat_encNat]
  rw [if_pos (by simp)]
  simp

/-- A key/value list: its length, then the pairs. -/
def encPairs (ps : List (List Char × List Char)) : List Char :=
  encNat ps.length ++ ps.flatMap (fun p => encStr p.1 ++ encStr p.2)

/-- Read exactly `k` key/value pairs. -/
def decPairsN : Nat → List Char → Option (List (List Char × List Char) × List Char)
  | 0, cs => some ([], cs)
  | k + 1, cs => match decStr cs with
      | some (a, cs₁) => match decStr cs₁ with
          | some (b, cs₂) => (decPairsN k cs₂).map (fun p => ((a, b) :: p.1, p.2))
          | none => none
      | none => none

/-- Read a length-prefixed key/value list. -/
def decPairs (cs : List Char) : Option (List (List Char × List Char) × List Char) :=
  match decNat cs with
  | some (k, rest) => decPairsN k rest
  | none => none

theorem decPairsN_flatMap (ps : List (List Char × List Char)) (rest : List Char) :
    decPairsN ps.length (ps.flatMap (fun p => encStr p.1 ++ encStr p.2) ++ rest)
      = some (ps, rest) := by
  induction ps with
  | nil => simp [decPairsN]
  | cons p ps ih =>
      simp only [List.flatMap_cons, List.append_assoc, List.length_cons, decPairsN,
        decStr_encStr]
      simp [ih]

theorem decPairs_encPairs (ps : List (List Char × List Char)) (rest : List Char) :
    decPairs (encPairs ps ++ rest) = some (ps, rest) := by
  simp only [encPairs, List.append_assoc, decPairs, decNat_encNat]
  exact decPairsN_flatMap ps rest

/-! ## Bytes, for digesting a token -/

/-- The tokens of this layer are ASCII, so their byte string is their
character codes. -/
def toBytes (cs : List Char) : Kant.Bytes.Blob := cs.map (fun c => UInt8.ofNat c.toNat)

end Kant.Kernel.Codec
