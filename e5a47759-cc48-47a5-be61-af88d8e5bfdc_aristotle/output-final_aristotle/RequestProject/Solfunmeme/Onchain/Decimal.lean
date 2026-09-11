import RequestProject.Solfunmeme.Onchain.Digits

/-!
Decimal strings.

The Solana JSON-RPC returns token amounts as *decimal strings* (`"amount"`), not as
JSON numbers, precisely because they can exceed `2^53`.  We therefore parse them
exactly into `Nat`, and render them back with the mint's `decimals` scale.
-/

namespace Solana.Decimal

open Solana.Digits

/-- Digit value of an ASCII decimal character. -/
def digitOf (c : Char) : Option Nat :=
  if '0' ≤ c && c ≤ '9' then some (c.toNat - '0'.toNat) else none

/-- The ASCII character for a decimal digit. -/
def digitChar (d : Nat) : Char :=
  Char.ofNat ('0'.toNat + d)

/-- Exact parse of a non-empty run of decimal digits. -/
def parse (s : String) : Option Nat := do
  let ds ← s.toList.mapM digitOf
  if ds.isEmpty then none else some (ofDigitsBE 10 ds)

/-- Left-pad a digit list with zeros to length `n`. -/
def padLeft (n : Nat) (ds : List Nat) : List Nat :=
  List.replicate (n - ds.length) 0 ++ ds

/-- The integer and fractional digit groups of `n` scaled by `10 ^ decimals`,
e.g. `renderParts 1234 2 = ("12", "34")` and `renderParts 5 3 = ("0", "005")`. -/
def renderParts (n : Nat) (decimals : Nat) : String × String :=
  let ds := padLeft (decimals + 1) (digitsBE 10 n)
  let k := ds.length - decimals
  (String.ofList ((ds.take k).map digitChar), String.ofList ((ds.drop k).map digitChar))

/-- `render n d` prints `n * 10 ^ (-d)` exactly, e.g. `render 1234 2 = "12.34"`. -/
def render (n : Nat) (decimals : Nat) : String :=
  let (i, f) := renderParts n decimals
  if decimals = 0 then i else i ++ "." ++ f

/-- Render a rational as a fixed-point decimal string with `prec` places,
truncating towards zero.  Used only for human-readable percentages. -/
def renderRat (q : Rat) (prec : Nat) : String :=
  let scaled : Int := (q * (10 ^ prec : Nat)).floor
  if scaled < 0 then "-" ++ render (Int.toNat (-scaled)) prec
  else render (Int.toNat scaled) prec

end Solana.Decimal
