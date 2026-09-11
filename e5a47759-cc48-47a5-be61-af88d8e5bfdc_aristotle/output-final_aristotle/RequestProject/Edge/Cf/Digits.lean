/-
# Decimal digits, with a round-trip proof

Workflows are shared as flat token lists (see `RequestProject.Cf.Share`),
and some of the fields in them are numbers.  For the sharing format to be
lossless — the property `Share.decode_encode` states — the number encoding
has to round-trip, so it is developed here from scratch rather than taken
from `toString` / `String.toNat?`, which come with no such lemma.
-/

namespace CfDeploy
namespace Digits

/-- The character of a decimal digit. -/
def digitChar (d : Nat) : Char := Char.ofNat (48 + d % 10)

/-- The decimal digit of a character, if it is one. -/
def charDigit (c : Char) : Option Nat :=
  if 48 ≤ c.toNat && c.toNat ≤ 57 then some (c.toNat - 48) else none

theorem charDigit_digitChar {d : Nat} (h : d < 10) : charDigit (digitChar d) = some d := by
  have hmod : d % 10 = d := Nat.mod_eq_of_lt h
  have hval : (Char.ofNat (48 + d)).toNat = 48 + d := by
    have hv : (48 + d).isValidChar := Or.inl (by omega)
    simp [Char.ofNat, hv, Char.toNat, Char.ofNatAux, UInt32.toNat, Nat.mod_eq_of_lt]
    omega
  simp [charDigit, digitChar, hmod, hval]
  omega

/-- The decimal representation of a natural number, most significant digit
first. -/
def toDigits (n : Nat) : List Char :=
  if n < 10 then [digitChar n] else toDigits (n / 10) ++ [digitChar (n % 10)]
termination_by n
decreasing_by omega

/-- Left-to-right decoding with an accumulator. -/
def go : List Char → Nat → Option Nat
  | [], acc => some acc
  | c :: cs, acc =>
      match charDigit c with
      | some d => go cs (acc * 10 + d)
      | none => none

/-- Decode a decimal string; `none` if it is empty or has a non-digit. -/
def ofDigits : List Char → Option Nat
  | [] => none
  | c :: cs => go (c :: cs) 0

theorem go_append (l : List Char) (d : Nat) (hd : d < 10) (acc : Nat) :
    go (l ++ [digitChar d]) acc = (go l acc).bind (fun v => some (v * 10 + d)) := by
  induction l generalizing acc with
  | nil => simp [go, charDigit_digitChar hd]
  | cons c cs ih =>
      simp only [List.cons_append, go]
      cases h : charDigit c with
      | none => simp
      | some e => simp [ih]

/-- Decimal notation round-trips. -/
theorem ofDigits_toDigits (n : Nat) : ofDigits (toDigits n) = some n := by
  have key : ∀ n : Nat, go (toDigits n) 0 = some n := by
    intro n
    induction n using toDigits.induct with
    | case1 n h => simp [toDigits, h, go, charDigit_digitChar h]
    | case2 n h ih =>
        rw [toDigits, if_neg h, go_append _ _ (Nat.mod_lt _ (by omega)) 0, ih]
        simp
        omega
  have hne : toDigits n ≠ [] := by
    rw [toDigits]; split <;> simp
  cases hcs : toDigits n with
  | nil => exact absurd hcs hne
  | cons c cs =>
      have hk := key n
      rw [hcs] at hk
      simpa [ofDigits] using hk

/-- Decimal string of a number. -/
def natStr (n : Nat) : String := String.ofList (toDigits n)

/-- Parse a decimal string. -/
def natOf (s : String) : Option Nat := ofDigits s.toList

@[simp] theorem natOf_natStr (n : Nat) : natOf (natStr n) = some n := by
  simp [natOf, natStr, ofDigits_toDigits]

end Digits
end CfDeploy
