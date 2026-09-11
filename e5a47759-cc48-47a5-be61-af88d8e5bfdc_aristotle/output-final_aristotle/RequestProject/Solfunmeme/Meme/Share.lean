import RequestProject.Solfunmeme.Onchain.Base58
import RequestProject.Solfunmeme.Meme.Engine

/-!
# Share codes: a game state as text

A play-through is shared as a short base-58 string — the same alphabet Solana
uses for addresses, reusing `Solana.Base58` and its round-trip proof.  The state
is serialised as nine little-endian 64-bit fields, so a code is exactly 72 bytes
of payload, and `decodeShare (encodeShare s) = some s` for every state whose
fields fit in 64 bits (`Proofs/Share.lean`).

This is the string that goes in the high-score channel, into the stego meme, and
into the signature.
-/

namespace Meme.Share

open Meme.Engine

/-- Field width: nothing in the game may exceed 64 bits. -/
def bound : Nat := 18446744073709551616

/-- Little-endian 8-byte encoding. -/
def natToLE8 (n : Nat) : List UInt8 :=
  (List.range 8).map (fun i => UInt8.ofNat (n / 256 ^ i % 256))

/-- Little-endian decoding. -/
def leToNat (bs : List UInt8) : Nat := bs.foldr (fun b acc => b.toNat + 256 * acc) 0

/-- The nine state fields, in serialisation order. -/
def fields (s : State) : List Nat :=
  [s.day, s.brainrot, s.parts, s.memes, s.blocks, s.stake, s.earned, s.spent, s.commit]

/-- Rebuild a state from its nine fields. -/
def ofFields : List Nat → Option State
  | [d, b, p, m, bl, st, e, sp, c] =>
      some { day := d, brainrot := b, parts := p, memes := m, blocks := bl,
             stake := st, earned := e, spent := sp, commit := c }
  | _ => none

/-- Serialise a state to 72 bytes. -/
def encodeBytes (s : State) : List UInt8 := (fields s).flatMap natToLE8

/-- Read `n` little-endian 64-bit fields off the front of a byte string. -/
def decodeNats : Nat → List UInt8 → List Nat
  | 0, _ => []
  | n + 1, bs => leToNat (bs.take 8) :: decodeNats n (bs.drop 8)

/-- Deserialise a state. -/
def decodeBytes (bs : List UInt8) : Option State := ofFields (decodeNats 9 bs)

/-- The textual share code of a state. -/
def encodeShare (s : State) : String := Solana.Base58.encode (encodeBytes s)

/-- Parse a share code. -/
def decodeShare (t : String) : Option State := do
  let bs ← Solana.Base58.decode t
  decodeBytes bs

end Meme.Share
