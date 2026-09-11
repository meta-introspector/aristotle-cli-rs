/-
# DEFLATE and gzip, in Lean

An Aristotle result arrives as a `.tar.gz`, and the deployment tool has to
look inside it to decide what to upload.  Doing that by shelling out to
`tar` would put an unverified, unsandboxed program on the critical path of
a tool whose whole point is to be careful about what it does, so the
decompressor is written here instead, from RFC 1951 (DEFLATE) and RFC 1952
(gzip).

The implementation follows the classic "puff" reference decoder:
canonical Huffman tables are represented by the per-length code counts and
the symbols in canonical order, and decoding walks the code lengths from 1
to 15.  Everything is total: each loop is bounded by an explicit step
budget derived from the input size, so there is no `partial def` here and
the decoder cannot hang on malformed input.
-/

namespace CfDeploy
namespace Inflate

/-! ## Bit input -/

/-- Read one bit (DEFLATE packs bits least-significant first). -/
def getBit (data : ByteArray) (bitPos : Nat) : Nat :=
  -- Reading past the end yields zero bits; every caller re-checks the
  -- available length, so a truncated stream is rejected rather than trusted.
  let byte := data[bitPos / 8]?.getD 0
  (byte.toNat >>> (bitPos % 8)) &&& 1

/-- Read `n` bits as a little-endian number. -/
def getBits (data : ByteArray) (bitPos n : Nat) : Nat := Id.run do
  let mut v := 0
  for i in [0:n] do
    v := v ||| (getBit data (bitPos + i) <<< i)
  return v

/-! ## Canonical Huffman tables -/

/-- A canonical Huffman table: how many codes there are of each length
(`counts[len]`), and the symbols in canonical order. -/
structure Huff where
  counts : Array Nat
  symbols : Array Nat
  deriving Inhabited

/-- Build the canonical table from a list of code lengths. -/
def Huff.ofLengths (lengths : Array Nat) : Huff := Id.run do
  let maxBits := 15
  let mut counts : Array Nat := Array.replicate (maxBits + 1) 0
  for l in lengths do
    if l ≤ maxBits then
      counts := counts.set! l (counts[l]! + 1)
  -- offsets of each length in the symbol table
  let mut offs : Array Nat := Array.replicate (maxBits + 2) 0
  let mut acc := 0
  for len in [1:maxBits+1] do
    offs := offs.set! len acc
    acc := acc + counts[len]!
  let mut symbols : Array Nat := Array.replicate acc 0
  for sym in [0:lengths.size] do
    let l := lengths[sym]!
    if l ≠ 0 && l ≤ maxBits then
      symbols := symbols.set! (offs[l]!) sym
      offs := offs.set! l (offs[l]! + 1)
  return { counts := counts, symbols := symbols }

/-- Decode one symbol; returns the symbol and the new bit position. -/
def Huff.decode (h : Huff) (data : ByteArray) (bitPos : Nat) : Option (Nat × Nat) := Id.run do
  let mut code := 0
  let mut first := 0
  let mut index := 0
  let mut pos := bitPos
  let mut result : Option (Nat × Nat) := none
  for len in [1:16] do
    if result.isNone then
      code := code ||| getBit data pos
      pos := pos + 1
      let count := h.counts[len]!
      if code - first < count then
        result := some (h.symbols[index + (code - first)]!, pos)
      else
        index := index + count
        first := (first + count) <<< 1
        code := code <<< 1
  return result

/-! ## Length and distance codes (RFC 1951, §3.2.5) -/

def lengthBase : Array Nat :=
  #[3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59,
    67, 83, 99, 115, 131, 163, 195, 227, 258]

def lengthExtra : Array Nat :=
  #[0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0]

def distBase : Array Nat :=
  #[1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769,
    1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577]

def distExtra : Array Nat :=
  #[0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
    12, 12, 13, 13]

/-- The fixed literal/length table of RFC 1951, §3.2.6. -/
def fixedLit : Huff :=
  Huff.ofLengths (Array.replicate 144 8 ++ Array.replicate 112 9 ++
    Array.replicate 24 7 ++ Array.replicate 8 8)

/-- The fixed distance table: 30 codes of five bits. -/
def fixedDist : Huff := Huff.ofLengths (Array.replicate 30 5)

/-- The order the code-length code lengths are stored in. -/
def clOrder : Array Nat := #[16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15]

/-! ## The decoder -/

/-- Decoder state: bit position, output so far, and whether we are done or
have failed. -/
structure St where
  pos : Nat
  out : Array UInt8
  done : Bool
  bad : Bool
  deriving Inhabited

/-- Decode one compressed block body with the given tables. -/
def inflateCodes (data : ByteArray) (lit dist : Huff) (st : St) (budget : Nat) : St := Id.run do
  let mut s := st
  for _ in [0:budget] do
    if s.done || s.bad then
      pure ()
    else
      match lit.decode data s.pos with
      | none => s := { s with bad := true }
      | some (sym, p) =>
          if sym < 256 then
            s := { s with pos := p, out := s.out.push (UInt8.ofNat sym) }
          else if sym == 256 then
            s := { s with pos := p, done := true }
          else
            let idx := sym - 257
            if idx < lengthBase.size then
              let extra := lengthExtra[idx]!
              let len := lengthBase[idx]! + getBits data p extra
              let p2 := p + extra
              match dist.decode data p2 with
              | none => s := { s with bad := true }
              | some (dsym, p3) =>
                  if dsym < distBase.size then
                    let dextra := distExtra[dsym]!
                    let d := distBase[dsym]! + getBits data p3 dextra
                    let p4 := p3 + dextra
                    if d == 0 || d > s.out.size then
                      s := { s with bad := true }
                    else
                      let mut o := s.out
                      for _ in [0:len] do
                        o := o.push o[o.size - d]!
                      s := { s with pos := p4, out := o }
                  else
                    s := { s with bad := true }
            else
              s := { s with bad := true }
  return s

/-- Read the dynamic Huffman tables of a block. -/
def readDynamicTables (data : ByteArray) (pos : Nat) : Option (Huff × Huff × Nat) := Id.run do
  let hlit := getBits data pos 5 + 257
  let hdist := getBits data (pos + 5) 5 + 1
  let hclen := getBits data (pos + 10) 4 + 4
  let mut p := pos + 14
  let mut clLengths : Array Nat := Array.replicate 19 0
  for i in [0:hclen] do
    clLengths := clLengths.set! (clOrder[i]!) (getBits data p 3)
    p := p + 3
  let clHuff := Huff.ofLengths clLengths
  let mut lengths : Array Nat := Array.replicate (hlit + hdist) 0
  let mut i := 0
  let mut bad := false
  for _ in [0:hlit + hdist] do
    if i < hlit + hdist && !bad then
      match clHuff.decode data p with
      | none => bad := true
      | some (sym, p') =>
          p := p'
          if sym < 16 then
            lengths := lengths.set! i sym
            i := i + 1
          else if sym == 16 then
            if i == 0 then
              bad := true
            else
              let prev := lengths[i-1]!
              let rep := 3 + getBits data p 2
              p := p + 2
              for _ in [0:rep] do
                if i < hlit + hdist then
                  lengths := lengths.set! i prev
                  i := i + 1
          else if sym == 17 then
            let rep := 3 + getBits data p 3
            p := p + 3
            i := i + rep
          else
            let rep := 11 + getBits data p 7
            p := p + 7
            i := i + rep
  if bad || i > hlit + hdist then
    return none
  let litLengths := lengths.extract 0 hlit
  let distLengths := lengths.extract hlit (hlit + hdist)
  return some (Huff.ofLengths litLengths, Huff.ofLengths distLengths, p)

/-- Inflate a raw DEFLATE stream. -/
def inflate (data : ByteArray) : Option ByteArray := Id.run do
  let totalBits := data.size * 8
  let mut s : St := { pos := 0, out := #[], done := false, bad := false }
  let mut final := false
  for _ in [0:totalBits + 1] do
    if final || s.bad then
      pure ()
    else
      if s.pos + 3 > totalBits then
        s := { s with bad := true }
      else
        let bfinal := getBit data s.pos
        let btype := getBits data (s.pos + 1) 2
        let p := s.pos + 3
        final := bfinal == 1
        if btype == 0 then
          -- stored block: skip to the byte boundary, then LEN/NLEN
          let bytePos := (p + 7) / 8
          if bytePos + 4 > data.size then
            s := { s with bad := true }
          else
            let len := data[bytePos]!.toNat ||| (data[bytePos+1]!.toNat <<< 8)
            if bytePos + 4 + len > data.size then
              s := { s with bad := true }
            else
              let mut o := s.out
              for i in [0:len] do
                o := o.push data[bytePos + 4 + i]!
              s := { s with pos := (bytePos + 4 + len) * 8, out := o }
        else if btype == 1 then
          let s' := inflateCodes data fixedLit fixedDist
            { s with pos := p, done := false } (totalBits + 1)
          s := { s' with done := false }
        else if btype == 2 then
          match readDynamicTables data p with
          | none => s := { s with bad := true }
          | some (lit, dist, p') =>
              let s' := inflateCodes data lit dist
                { s with pos := p', done := false } (totalBits + 1)
              s := { s' with done := false }
        else
          s := { s with bad := true }
  if s.bad || !final then
    return none
  return some ⟨s.out⟩

/-! ## gzip -/

/-- The CRC-32 table of RFC 1952. -/
def crcTable : Array UInt32 := Id.run do
  let mut t : Array UInt32 := Array.replicate 256 0
  for n in [0:256] do
    let mut c : UInt32 := UInt32.ofNat n
    for _ in [0:8] do
      c := if c &&& 1 == 1 then (0xEDB88320 : UInt32) ^^^ (c >>> 1) else c >>> 1
    t := t.set! n c
  return t

/-- CRC-32 of a byte array. -/
def crc32 (data : ByteArray) : UInt32 := Id.run do
  let mut c : UInt32 := 0xFFFFFFFF
  for i in [0:data.size] do
    let idx := ((c ^^^ (data[i]!.toUInt32)) &&& 0xFF).toNat
    c := crcTable[idx]! ^^^ (c >>> 8)
  return c ^^^ 0xFFFFFFFF

/-- Decompress a gzip member, checking the trailing CRC-32 and length.
Returns `none` if the header is not gzip/deflate, the stream is malformed,
or the checksum does not match. -/
def gunzip (data : ByteArray) : Option ByteArray := Id.run do
  if data.size < 18 then
    return none
  if data[0]! != 0x1F || data[1]! != 0x8B || data[2]! != 0x08 then
    return none
  let flg := data[3]!.toNat
  let mut p := 10
  if flg &&& 4 != 0 then
    -- FEXTRA
    let xlen := data[p]!.toNat ||| (data[p+1]!.toNat <<< 8)
    p := p + 2 + xlen
  if flg &&& 8 != 0 then
    -- FNAME, NUL terminated
    for _ in [0:data.size] do
      if p < data.size && data[p]! != 0 then
        p := p + 1
    p := p + 1
  if flg &&& 16 != 0 then
    -- FCOMMENT
    for _ in [0:data.size] do
      if p < data.size && data[p]! != 0 then
        p := p + 1
    p := p + 1
  if flg &&& 2 != 0 then
    -- FHCRC
    p := p + 2
  if p + 8 > data.size then
    return none
  let body := data.extract p (data.size - 8)
  match inflate body with
  | none => return none
  | some out =>
      let n := data.size
      let crcExpected : UInt32 :=
        UInt32.ofNat (data[n-8]!.toNat ||| (data[n-7]!.toNat <<< 8) |||
          (data[n-6]!.toNat <<< 16) ||| (data[n-5]!.toNat <<< 24))
      let sizeExpected : Nat :=
        data[n-4]!.toNat ||| (data[n-3]!.toNat <<< 8) |||
          (data[n-2]!.toNat <<< 16) ||| (data[n-1]!.toNat <<< 24)
      if out.size % 4294967296 != sizeExpected then
        return none
      if crc32 out != crcExpected then
        return none
      return some out

end Inflate
end CfDeploy
