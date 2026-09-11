import RequestProject.Solfunmeme.Onchain.Digits

/-!
Bitcoin/Solana flavoured base-58.

Solana addresses (mints, token accounts, owners) are 32-byte public keys rendered
in base 58 with the alphabet below.  We need this to *validate* a mint argument
before spending a network round trip on it, and to sanity check the addresses that
come back from the validator.
-/

namespace Solana.Base58

open Solana.Digits

/-- The Bitcoin base-58 alphabet, as used by Solana. `0`, `O`, `I` and `l` are
omitted so that visually similar characters cannot be confused. -/
def alphabet : String :=
  "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

/-- The alphabet as a list of characters. -/
def alphabetList : List Char := alphabet.toList

/-- Digit value of a base-58 character, if it is one. -/
def charValue (c : Char) : Option Nat :=
  alphabetList.idxOf? c

/-- The character standing for digit `d` (any `d ≥ 58` is reported as `'?'`). -/
def valueChar (d : Nat) : Char :=
  alphabetList[d]?.getD '?'

/-- Big-endian byte value of a list of bytes. -/
def bytesToNat (bs : List UInt8) : Nat :=
  ofDigitsBE 256 (bs.map UInt8.toNat)

/-- Minimal-length big-endian byte expansion of a natural number. -/
def natToBytes (n : Nat) : List UInt8 :=
  (digitsBE 256 n).map (fun d => UInt8.ofNat d)

/-- Base-58 encoding: each leading zero byte becomes a literal `'1'`, and the
remaining bytes are re-expanded as a big-endian base-58 numeral. -/
def encode (bs : List UInt8) : String :=
  let zeros := bs.takeWhile (· == 0)
  let rest := bs.dropWhile (· == 0)
  let ds := digitsBE 58 (bytesToNat rest)
  String.ofList (zeros.map (fun _ => '1') ++ ds.map valueChar)

/-- Base-58 decoding; `none` if any character is outside the alphabet. -/
def decode (s : String) : Option (List UInt8) := do
  let cs := s.toList
  let zeros := cs.takeWhile (· == '1')
  let rest := cs.dropWhile (· == '1')
  let ds ← rest.mapM charValue
  let bytes := natToBytes (ofDigitsBE 58 ds)
  return zeros.map (fun _ => (0 : UInt8)) ++ bytes

/-- A syntactically valid Solana public key: base-58 text decoding to 32 bytes. -/
def isValidPubkey (s : String) : Bool :=
  match decode s with
  | some bs => bs.length == 32
  | none => false

end Solana.Base58
