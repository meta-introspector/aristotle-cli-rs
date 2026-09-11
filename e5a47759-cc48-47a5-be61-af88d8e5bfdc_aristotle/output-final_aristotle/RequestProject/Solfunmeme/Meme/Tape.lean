import RequestProject.Solfunmeme.Meme.Share

/-!
# Replay tapes as text

A share code names a *state*; a replay tape names the *game that got there*.  A
tape is serialised the same way a state is — a 64-bit length followed by one
64-bit field per input code — and rendered in the same base-58 alphabet, so a
whole play-through travels as one string: in a URL, in a high-score post, or
inside a stego meme.

`Proofs/Tape.lean` shows the codec round trips, which is what makes the tape a
replayable proof object rather than a claim.
-/

namespace Meme.Tape

open Meme.Engine Meme.Share

/-- Invert `Input.code`.  Codes `0,1,2` are the parameterless inputs; above that
the residue mod 3 selects the constructor and the quotient its argument. -/
def decodeInput (c : Nat) : Option Input :=
  if c = 0 then some .tap
  else if c = 1 then some .mint
  else if c = 2 then some .tick
  else if c % 3 = 0 then some (.steal ((c - 3) / 3))
  else if c % 3 = 1 then some (.build ((c - 4) / 3))
  else some (.hold ((c - 5) / 3))

/-- Serialise a tape: its length, then its input codes. -/
def encodeBytes (xs : List Input) : List UInt8 :=
  natToLE8 xs.length ++ (xs.map Input.code).flatMap natToLE8

/-- Deserialise a tape. -/
def decodeBytes (bs : List UInt8) : Option (List Input) :=
  (decodeNats (leToNat (bs.take 8)) (bs.drop 8)).mapM decodeInput

/-- A tape as a base-58 string. -/
def encodeTape (xs : List Input) : String := Solana.Base58.encode (encodeBytes xs)

/-- Parse a base-58 tape. -/
def decodeTape (t : String) : Option (List Input) := do
  let bs ← Solana.Base58.decode t
  decodeBytes bs

end Meme.Tape
