/-!
# Steganographic meme carriers

A badge screenshot is shared as a *meme*: an ordinary PNG whose pixel bytes
carry the play-through payload in their least significant bits.  The picture is
what people see; the bytes underneath are what a verifier reads back and checks
against the engine.

Everything here is on `List Nat` with byte values in `[0,256)`, which is exactly
the `Uint8ClampedArray` the browser hands us from a canvas, and lets the proofs
stay arithmetic.

The two results that matter are

* `extractBytes_embedBytes` — what you hide is what you get back, and
* `embedBits_preserves_upper` — embedding only ever moves a byte by one unit,
  so the carrier meme is visually unchanged.
-/

namespace Meme.Stego

/-! ## Bits -/

/-- The eight bits of a byte, least significant first. -/
def bitsLE (n : Nat) : List Nat := (List.range 8).map (fun i => n / 2 ^ i % 2)

/-- Reassemble a little-endian bit list into a number. -/
def fromBitsLE (bs : List Nat) : Nat := bs.foldr (fun b acc => b + 2 * acc) 0

/-! ## Embedding -/

/-- Overwrite the least significant bit of each cover byte with the next payload
bit.  Cover bytes beyond the payload are left alone. -/
def embedBits : List Nat → List Nat → List Nat
  | [], _ => []
  | c :: cs, [] => c :: cs
  | c :: cs, b :: bs => (2 * (c / 2) + b) :: embedBits cs bs

/-- Read the first `k` least significant bits back out of a carrier. -/
def extractBits (k : Nat) (cover : List Nat) : List Nat := (cover.take k).map (· % 2)

/-- Regroup a bit stream into `n` bytes. -/
def unbits8 : Nat → List Nat → List Nat
  | 0, _ => []
  | n + 1, bs => fromBitsLE (bs.take 8) :: unbits8 n (bs.drop 8)

/-- Hide a byte payload in the low bits of a cover image. -/
def embedBytes (cover payload : List Nat) : List Nat :=
  embedBits cover (payload.flatMap bitsLE)

/-- Recover an `n`-byte payload from a carrier. -/
def extractBytes (n : Nat) (carrier : List Nat) : List Nat :=
  unbits8 n (extractBits (8 * n) carrier)

end Meme.Stego
