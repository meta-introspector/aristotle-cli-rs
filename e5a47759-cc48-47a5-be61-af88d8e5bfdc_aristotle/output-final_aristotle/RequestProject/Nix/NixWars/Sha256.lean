/-!
# SHA-256

A plain implementation of SHA-256 (FIPS 180-4), so that a page emitted by this
project can carry a commitment a chain would recognise, computed by Lean
itself rather than by a script.

Nothing about it is *proved* — it is an executable definition, checked against
the standard test vectors below with `#guard` and, outside Lean, against the
system's own SHA-256 by `www/empire-selftest.mjs`.
-/

namespace NixWars
namespace Sha256

/-- The sixty-four round constants: the first thirty-two bits of the fractional
parts of the cube roots of the first sixty-four primes. -/
def K : Array UInt32 := #[
  0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
  0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
  0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
  0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
  0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
  0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
  0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
  0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2]

/-- Rotate a word right. -/
def rotr (x : UInt32) (n : UInt32) : UInt32 := (x >>> n) ||| (x <<< (32 - n))

/-- The eight starting words: the fractional parts of the square roots of the
first eight primes. -/
def initState : Array UInt32 :=
  #[0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19]

/-- Expand a sixty-four byte block into the sixty-four word message schedule. -/
def schedule (block : Array UInt8) : Array UInt32 := Id.run do
  let mut w : Array UInt32 := Array.emptyWithCapacity 64
  for i in [0:16] do
    let b j := (block[4 * i + j]!).toUInt32
    w := w.push (((b 0) <<< 24) ||| ((b 1) <<< 16) ||| ((b 2) <<< 8) ||| (b 3))
  for i in [16:64] do
    let s0 := rotr w[i-15]! 7 ^^^ rotr w[i-15]! 18 ^^^ (w[i-15]! >>> 3)
    let s1 := rotr w[i-2]! 17 ^^^ rotr w[i-2]! 19 ^^^ (w[i-2]! >>> 10)
    w := w.push (w[i-16]! + s0 + w[i-7]! + s1)
  return w

/-- The compression function on one block. -/
def compress (st : Array UInt32) (block : Array UInt8) : Array UInt32 := Id.run do
  let w := schedule block
  let mut a := st[0]!; let mut b := st[1]!; let mut c := st[2]!; let mut d := st[3]!
  let mut e := st[4]!; let mut f := st[5]!; let mut g := st[6]!; let mut h := st[7]!
  for i in [0:64] do
    let s1 := rotr e 6 ^^^ rotr e 11 ^^^ rotr e 25
    let ch := (e &&& f) ^^^ ((~~~e) &&& g)
    let t1 := h + s1 + ch + K[i]! + w[i]!
    let s0 := rotr a 2 ^^^ rotr a 13 ^^^ rotr a 22
    let mj := (a &&& b) ^^^ (a &&& c) ^^^ (b &&& c)
    let t2 := s0 + mj
    h := g; g := f; f := e; e := d + t1; d := c; c := b; b := a; a := t1 + t2
  return #[st[0]! + a, st[1]! + b, st[2]! + c, st[3]! + d,
           st[4]! + e, st[5]! + f, st[6]! + g, st[7]! + h]

/-- Append the padding: a one bit, zeros, and the length in bits. -/
def pad (msg : Array UInt8) : Array UInt8 := Id.run do
  let bitLen : UInt64 := (UInt64.ofNat msg.size) * 8
  let mut out := msg.push 0x80
  while out.size % 64 != 56 do
    out := out.push 0
  for i in [0:8] do
    out := out.push (((bitLen >>> (UInt64.ofNat (8 * (7 - i)))) &&& 0xff).toUInt8)
  return out

/-- The digest of a byte string, as thirty-two bytes. -/
def hashBytes (msg : Array UInt8) : Array UInt8 := Id.run do
  let p := pad msg
  let mut st := initState
  for b in [0:p.size / 64] do
    st := compress st (p.extract (64 * b) (64 * b + 64))
  let mut out : Array UInt8 := Array.emptyWithCapacity 32
  for x in st do
    out := out.push ((x >>> 24) &&& 0xff).toUInt8
    out := out.push ((x >>> 16) &&& 0xff).toUInt8
    out := out.push ((x >>> 8) &&& 0xff).toUInt8
    out := out.push (x &&& 0xff).toUInt8
  return out

/-- One hexadecimal digit. -/
def hexDigit (n : UInt8) : Char :=
  let d := n.toNat
  if d < 10 then Char.ofNat (48 + d) else Char.ofNat (87 + d)

/-- Bytes as lower-case hexadecimal. -/
def toHex (bs : Array UInt8) : String :=
  bs.foldl (fun (s : String) (b : UInt8) =>
    (s.push (hexDigit ((b >>> 4) &&& 0xf))).push (hexDigit (b &&& 0xf))) ""

/-- The digest of a string, in hexadecimal. -/
def ofString (s : String) : String := toHex (hashBytes ⟨s.toUTF8.toList⟩)

/-! ## The standard test vectors -/

#guard ofString "" = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
#guard ofString "abc" = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
#guard ofString "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq" =
  "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1"
#guard ofString "The quick brown fox jumps over the lazy dog" =
  "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592"

end Sha256
end NixWars
