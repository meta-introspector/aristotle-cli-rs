import Mathlib

/-!
# The steganographic layer

The formal counterpart of `web/js/stego.js`: data carried *inside* a rendering.

A picture that leaves the studio normally forgets everything it knows about
itself — the playbook it came from, the proof object behind it.  The stego layer
puts that back, inside the picture, without changing what the picture looks
like.  Three carriers are modelled here, exactly the three the runtime uses:

* **raster** (`setLow`, `embedList`, `embedPixels`) — the low bits of the red,
  green and blue samples of a frame.  Alpha is never touched and a sample moves
  by at most `2^bits - 1` steps, so at one bit per sample the picture changes by
  a single step out of 256.
* **palette** (`pairPalette`, `embedIndices`) — for GIF: the colour table is
  written twice, so the *index* of a pixel has a spare low bit while the colour
  it decodes to is bit-for-bit the colour it would have been.  Here nothing
  about the image changes at all.
* **svg** (`nudgeDigit`) — the third decimal of a coordinate carries a bit, so a
  coordinate moves by less than `0.001` user units.

Around all three sits one container, `pack`/`unpack`:

```text
"HSTG" | version | flags | length (4, big endian) | crc32 (4) | payload
```

so a reader can tell a carrier from ordinary pixels, and a damaged carrier
fails its checksum instead of returning noise.

The main results:

* `unpack_pack` — a packed message reads back, intact, with its own version and
  flags;
* `unpack_pack_tampered` — a message whose body was altered is reported as
  damaged, not returned as data (given a checksum that separates the two);
* `unpack_eq_none_of_magic_ne` — what is not a container is not read as one;
* `bytesOf_bitsOf` — the bit packing is a bijection on bytes;
* `extractList_embedList` — what was written into the low bits is what comes
  back out, and `embedList_distortion` / `embedList_high_bits` bound what that
  did to the picture;
* `embedPixels_alpha` — alpha is untouched;
* `pairPalette_getElem?` — a paired palette decodes every index to the colour it
  stood for, so the palette carrier changes no pixel at all, and
  `extractIndices_embedIndices` reads the message back;
* `nudgeDigit_parity`, `nudgeDigit_close` — the SVG carrier sets the parity it
  was asked for and moves the digit by at most one.
-/

namespace Hesper.Stego

/-! ## Bytes and bits -/

/-- A byte: a natural number below 256. -/
def IsByte (b : Nat) : Prop := b < 256

/-- The eight bits of a byte, most significant first (`bitsOf` in the runtime). -/
def bitsOfByte (b : Nat) : List Bool :=
  [b.testBit 7, b.testBit 6, b.testBit 5, b.testBit 4,
   b.testBit 3, b.testBit 2, b.testBit 1, b.testBit 0]

/-- A byte read back from bits, most significant first. -/
def byteOf (l : List Bool) : Nat :=
  l.foldl (fun acc b => acc * 2 + (if b then 1 else 0)) 0

theorem bitsOfByte_length (b : Nat) : (bitsOfByte b).length = 8 := rfl

set_option maxRecDepth 4000 in
/-- Unpacking the bits of a byte gives the byte back. -/
theorem byteOf_bitsOfByte {b : Nat} (h : IsByte b) : byteOf (bitsOfByte b) = b := by
  have : ∀ n < 256, byteOf (bitsOfByte n) = n := by decide
  exact this b h

/-- The bit stream of a list of bytes. -/
def bitsOf (bs : List Nat) : List Bool := bs.flatMap bitsOfByte

/-- The bytes of a bit stream; a trailing partial byte is dropped, exactly as
the runtime's `bytesOf` does. -/
def bytesOf : List Bool → List Nat
  | b7 :: b6 :: b5 :: b4 :: b3 :: b2 :: b1 :: b0 :: rest =>
      byteOf [b7, b6, b5, b4, b3, b2, b1, b0] :: bytesOf rest
  | _ => []

theorem bitsOf_length (bs : List Nat) : (bitsOf bs).length = 8 * bs.length := by
  induction bs with
  | nil => rfl
  | cons b bs ih => simp [bitsOf, List.flatMap_cons, bitsOfByte] at *; omega

/-- **The bit packing is lossless.**  Bytes turned into bits and read back are
the bytes we started with. -/
theorem bytesOf_bitsOf {bs : List Nat} (h : ∀ b ∈ bs, IsByte b) :
    bytesOf (bitsOf bs) = bs := by
  induction bs with
  | nil => rfl
  | cons b bs ih =>
    have hb : IsByte b := h b (by simp)
    have hrest : ∀ x ∈ bs, IsByte x := fun x hx => h x (by simp [hx])
    show bytesOf (bitsOfByte b ++ bitsOf bs) = b :: bs
    simp only [bitsOfByte, List.cons_append, List.nil_append]
    show byteOf (bitsOfByte b) :: bytesOf (bitsOf bs) = b :: bs
    rw [byteOf_bitsOfByte hb, ih hrest]

/-! ## The container -/

/-- The four magic bytes, `"HSTG"`. -/
def magic : List Nat := [0x48, 0x53, 0x54, 0x47]

/-- The container's header length: magic, version, flags, length, checksum. -/
def headerLen : Nat := 14

/-- A 32-bit number, big endian. -/
def be32 (n : Nat) : List Nat :=
  [n / 16777216 % 256, n / 65536 % 256, n / 256 % 256, n % 256]

/-- A big-endian 32-bit number read back. -/
def ofBe32 : List Nat → Nat
  | [a, b, c, d] => a * 16777216 + b * 65536 + c * 256 + d
  | _ => 0

theorem ofBe32_be32 {n : Nat} (h : n < 4294967296) : ofBe32 (be32 n) = n := by
  simp only [be32, ofBe32]
  omega

/-- What a reader gets back from a container. -/
structure Frame where
  version : Nat
  flags : Nat
  bytes : List Nat
  /-- `false` when the checksum did not match: the data is returned, and the
  reader is told it is damaged.  A damaged message is never silently passed off
  as an intact one. -/
  ok : Bool
  deriving Repr, DecidableEq

/-- Wrap a payload in the container (`pack`). -/
def pack (crc : List Nat → Nat) (version flags : Nat) (body : List Nat) : List Nat :=
  magic ++ [version, flags] ++ be32 body.length ++ be32 (crc body) ++ body

/-- Read a container back (`unpack`); `none` when this is not one. -/
def unpack (crc : List Nat → Nat) (bytes : List Nat) : Option Frame :=
  if bytes.take 4 = magic ∧ headerLen ≤ bytes.length then
    let version := bytes[4]!
    let flags := bytes[5]!
    let len := ofBe32 ((bytes.drop 6).take 4)
    let sum := ofBe32 ((bytes.drop 10).take 4)
    if len ≤ bytes.length - headerLen then
      let body := (bytes.drop headerLen).take len
      some ⟨version, flags, body, decide (crc body = sum)⟩
    else none
  else none

private theorem pack_take_four (crc : List Nat → Nat) (v f : Nat) (body : List Nat) :
    (pack crc v f body).take 4 = magic := by
  simp [pack, magic, be32]

private theorem pack_length (crc : List Nat → Nat) (v f : Nat) (body : List Nat) :
    (pack crc v f body).length = headerLen + body.length := by
  simp [pack, magic, be32, headerLen]
  omega

/-- **A packed message reads back.**  Version, flags and payload survive the
container, and the reader reports it intact. -/
theorem unpack_pack (crc : List Nat → Nat) {v f : Nat} {body : List Nat}
    (hlen : body.length < 4294967296) (hcrc : crc body < 4294967296) :
    unpack crc (pack crc v f body) = some ⟨v, f, body, true⟩ := by
  have h4 : (pack crc v f body).take 4 = magic := pack_take_four crc v f body
  have hl : (pack crc v f body).length = headerLen + body.length := pack_length crc v f body
  have hv : (pack crc v f body)[4]! = v := by simp [pack, magic, be32]
  have hf : (pack crc v f body)[5]! = f := by simp [pack, magic, be32]
  have hdrop6 : ((pack crc v f body).drop 6).take 4 = be32 body.length := by
    simp [pack, magic, be32]
  have hdrop10 : ((pack crc v f body).drop 10).take 4 = be32 (crc body) := by
    simp [pack, magic, be32]
  have hbody : (pack crc v f body).drop headerLen = body := by
    simp [pack, magic, be32, headerLen]
  simp only [unpack, h4, hl, hv, hf, hdrop6, hdrop10, hbody, ofBe32_be32 hlen,
    ofBe32_be32 hcrc, true_and, if_pos, le_refl, Nat.add_sub_cancel_left,
    List.take_length, decide_true]
  simp

/-- **A tampered message is reported as damaged.**  If the payload was changed
after packing — and the checksum tells the two apart, which is what a checksum
is for — the reader hands back the data it found *and* says it is not intact. -/
theorem unpack_pack_tampered (crc : List Nat → Nat) {v f : Nat} {body body' : List Nat}
    (hlen : body.length < 4294967296) (hcrc : crc body < 4294967296)
    (hsame : body'.length = body.length) (hne : crc body' ≠ crc body) :
    unpack crc (magic ++ [v, f] ++ be32 body.length ++ be32 (crc body) ++ body')
      = some ⟨v, f, body', false⟩ := by
  set p := magic ++ [v, f] ++ be32 body.length ++ be32 (crc body) ++ body' with hp
  have h4 : p.take 4 = magic := by simp [hp, magic, be32]
  have hl : p.length = headerLen + body.length := by
    simp [hp, magic, be32, headerLen, hsame]; omega
  have hv : p[4]! = v := by simp [hp, magic, be32]
  have hf : p[5]! = f := by simp [hp, magic, be32]
  have hdrop6 : (p.drop 6).take 4 = be32 body.length := by simp [hp, magic, be32]
  have hdrop10 : (p.drop 10).take 4 = be32 (crc body) := by simp [hp, magic, be32]
  have hbody : p.drop headerLen = body' := by simp [hp, magic, be32, headerLen]
  simp only [unpack, h4, hl, hv, hf, hdrop6, hdrop10, hbody, ofBe32_be32 hlen,
    ofBe32_be32 hcrc, true_and, le_refl, Nat.add_sub_cancel_left, if_pos]
  have : body'.take body.length = body' := by
    rw [← hsame]; exact List.take_length
  simp [this, hne]

/-- What is not a container is not read as one. -/
theorem unpack_eq_none_of_magic_ne (crc : List Nat → Nat) {bytes : List Nat}
    (h : bytes.take 4 ≠ magic) : unpack crc bytes = none := by
  simp [unpack, h]

/-- Too short to be a container is not a container. -/
theorem unpack_eq_none_of_short (crc : List Nat → Nat) {bytes : List Nat}
    (h : bytes.length < headerLen) : unpack crc bytes = none := by
  simp [unpack, Nat.not_le.2 h]

/-! ## The raster carrier -/

/-- Replace the low `bits` bits of a sample with `c`. -/
def setLow (bits v c : Nat) : Nat := v - v % 2 ^ bits + c

/-- Read the low `bits` bits of a sample. -/
def getLow (bits v : Nat) : Nat := v % 2 ^ bits

theorem setLow_eq (bits v c : Nat) : setLow bits v c = 2 ^ bits * (v / 2 ^ bits) + c := by
  have h := Nat.div_add_mod v (2 ^ bits)
  simp only [setLow]
  omega

/-- What was written into the low bits is what is read back. -/
theorem getLow_setLow {bits v c : Nat} (h : c < 2 ^ bits) : getLow bits (setLow bits v c) = c := by
  rw [getLow, setLow_eq, Nat.mul_add_mod, Nat.mod_eq_of_lt h]

/-- Everything above the low bits is left alone. -/
theorem setLow_div {bits v c : Nat} (h : c < 2 ^ bits) :
    setLow bits v c / 2 ^ bits = v / 2 ^ bits := by
  rw [setLow_eq, Nat.mul_add_div (Nat.two_pow_pos bits), Nat.div_eq_of_lt h, Nat.add_zero]

/-- **The picture barely moves.**  A sample changes by at most `2^bits - 1`
steps — one step out of 256 at a single bit per sample. -/
theorem setLow_close {bits v c : Nat} (h : c < 2 ^ bits) :
    setLow bits v c ≤ v + (2 ^ bits - 1) ∧ v ≤ setLow bits v c + (2 ^ bits - 1) := by
  have hpos : 0 < 2 ^ bits := Nat.two_pow_pos bits
  have hmod : v % 2 ^ bits < 2 ^ bits := Nat.mod_lt _ hpos
  have hle : v % 2 ^ bits ≤ v := Nat.mod_le _ _
  simp only [setLow]
  omega

/-- At one bit per sample the change is at most one step. -/
theorem setLow_one_bit {v c : Nat} (h : c < 2) :
    setLow 1 v c ≤ v + 1 ∧ v ≤ setLow 1 v c + 1 := by
  have := setLow_close (bits := 1) (v := v) (c := c) (by simpa using h)
  simpa using this

/-- Write a list of chunks into the low bits of a list of samples. -/
def embedList (bits : Nat) : List Nat → List Nat → List Nat
  | [], _ => []
  | v :: vs, [] => v :: vs
  | v :: vs, c :: cs => setLow bits v c :: embedList bits vs cs

/-- Read the low bits of every sample. -/
def extractList (bits : Nat) (vs : List Nat) : List Nat := vs.map (getLow bits)

theorem embedList_length (bits : Nat) (vs cs : List Nat) :
    (embedList bits vs cs).length = vs.length := by
  induction vs generalizing cs with
  | nil => rfl
  | cons v vs ih =>
    cases cs with
    | nil => rfl
    | cons c cs => simpa [embedList] using ih cs

/-- **The message comes back.**  Reading the low bits of the carrier returns the
chunks that were written, in order, as long as the frame had room for them. -/
theorem extractList_embedList {bits : Nat} {vs cs : List Nat}
    (hfit : cs.length ≤ vs.length) (hc : ∀ c ∈ cs, c < 2 ^ bits) :
    (extractList bits (embedList bits vs cs)).take cs.length = cs := by
  induction vs generalizing cs with
  | nil =>
    have : cs = [] := List.eq_nil_of_length_eq_zero (Nat.le_zero.1 (by simpa using hfit))
    simp [this]
  | cons v vs ih =>
    cases cs with
    | nil => simp
    | cons c cs =>
      have hfit' : cs.length ≤ vs.length := by simpa using hfit
      have hc' : ∀ x ∈ cs, x < 2 ^ bits := fun x hx => hc x (by simp [hx])
      have hhead : c < 2 ^ bits := hc c (by simp)
      simp only [embedList, extractList, List.map_cons, List.take_succ_cons,
        getLow_setLow hhead, List.cons.injEq, true_and, List.length_cons]
      exact ih hfit' hc'

/-- Every sample of the carrier is within `2^bits - 1` of the sample it replaced. -/
theorem embedList_distortion {bits : Nat} {vs cs : List Nat}
    (hc : ∀ c ∈ cs, c < 2 ^ bits) :
    ∀ i : Nat,
      (embedList bits vs cs)[i]! ≤ vs[i]! + (2 ^ bits - 1) ∧
      vs[i]! ≤ (embedList bits vs cs)[i]! + (2 ^ bits - 1) := by
  induction vs generalizing cs with
  | nil => intro i; simp [embedList]
  | cons v vs ih =>
    intro i
    cases cs with
    | nil => simp [embedList]
    | cons c cs =>
      cases i with
      | zero =>
        simpa [embedList] using setLow_close (bits := bits) (v := v) (c := c) (hc c (by simp))
      | succ j =>
        have hc' : ∀ x ∈ cs, x < 2 ^ bits := fun x hx => hc x (by simp [hx])
        simpa [embedList] using ih hc' j

/-- Nothing above the low bits of any sample changes. -/
theorem embedList_high_bits {bits : Nat} {vs cs : List Nat}
    (hc : ∀ c ∈ cs, c < 2 ^ bits) :
    (embedList bits vs cs).map (fun v => v / 2 ^ bits) = vs.map (fun v => v / 2 ^ bits) := by
  induction vs generalizing cs with
  | nil => rfl
  | cons v vs ih =>
    cases cs with
    | nil => rfl
    | cons c cs =>
      have hc' : ∀ x ∈ cs, x < 2 ^ bits := fun x hx => hc x (by simp [hx])
      simp only [embedList, List.map_cons, setLow_div (hc c (by simp)), List.cons.injEq,
        true_and]
      exact ih hc'

/-! ### Frames -/

/-- One pixel of an RGBA frame. -/
structure Pixel where
  r : Nat
  g : Nat
  b : Nat
  a : Nat
  deriving Repr, DecidableEq

/-- The colour samples of a frame, in order; alpha is not among them. -/
def rgbList (px : List Pixel) : List Nat := px.flatMap (fun p => [p.r, p.g, p.b])

/-- Put colour samples back into a frame, keeping every pixel's alpha. -/
def withRGB : List Pixel → List Nat → List Pixel
  | [], _ => []
  | p :: ps, r :: g :: b :: rest => { p with r := r, g := g, b := b } :: withRGB ps rest
  | p :: ps, _ => p :: ps

/-- Hide a message in the low bits of a frame's colour samples. -/
def embedPixels (bits : Nat) (px : List Pixel) (cs : List Nat) : List Pixel :=
  withRGB px (embedList bits (rgbList px) cs)

theorem rgbList_length (px : List Pixel) : (rgbList px).length = 3 * px.length := by
  induction px with
  | nil => rfl
  | cons p ps ih => simp [rgbList, List.flatMap_cons] at *; omega

theorem withRGB_alpha (px : List Pixel) (vs : List Nat) :
    (withRGB px vs).map Pixel.a = px.map Pixel.a := by
  induction px generalizing vs with
  | nil => rfl
  | cons p ps ih =>
    match vs with
    | [] => rfl
    | [_] => rfl
    | [_, _] => rfl
    | r :: g :: b :: rest => simpa [withRGB] using ih rest

/-- **Alpha is never touched.**  Whatever the message, every pixel keeps the
opacity it had. -/
theorem embedPixels_alpha (bits : Nat) (px : List Pixel) (cs : List Nat) :
    (embedPixels bits px cs).map Pixel.a = px.map Pixel.a :=
  withRGB_alpha _ _

theorem withRGB_length (px : List Pixel) (vs : List Nat) :
    (withRGB px vs).length = px.length := by
  induction px generalizing vs with
  | nil => rfl
  | cons p ps ih =>
    match vs with
    | [] => rfl
    | [_] => rfl
    | [_, _] => rfl
    | r :: g :: b :: rest => simpa [withRGB] using ih rest

theorem embedPixels_length (bits : Nat) (px : List Pixel) (cs : List Nat) :
    (embedPixels bits px cs).length = px.length :=
  withRGB_length _ _

/-- The colour samples of a frame are exactly what was written into them: a
frame is put back together from its samples without disturbing them. -/
theorem rgbList_withRGB {px : List Pixel} {vs : List Nat} (h : vs.length = 3 * px.length) :
    rgbList (withRGB px vs) = vs := by
  induction px generalizing vs with
  | nil =>
    have : vs = [] := List.eq_nil_of_length_eq_zero (by simpa using h)
    simp [this, rgbList, withRGB]
  | cons p ps ih =>
    match vs with
    | [] => simp at h
    | [_] => simp only [List.length_cons, List.length_nil] at h; omega
    | [_, _] => simp only [List.length_cons, List.length_nil] at h; omega
    | r :: g :: b :: rest =>
      have hrest : rest.length = 3 * ps.length := by
        simp only [List.length_cons] at h
        omega
      simp only [rgbList] at ih
      simp only [withRGB, rgbList, List.flatMap_cons, ih hrest]
      rfl

/-- **The message comes back out of the frame.**  Reading the low bits of the
carrier's colour samples returns what was hidden there. -/
theorem extract_embedPixels {bits : Nat} {px : List Pixel} {cs : List Nat}
    (hfit : cs.length ≤ 3 * px.length) (hc : ∀ c ∈ cs, c < 2 ^ bits) :
    (extractList bits (rgbList (embedPixels bits px cs))).take cs.length = cs := by
  have hlen : (embedList bits (rgbList px) cs).length = 3 * px.length := by
    rw [embedList_length, rgbList_length]
  rw [embedPixels, rgbList_withRGB hlen]
  exact extractList_embedList (by rw [rgbList_length]; exact hfit) hc

/-! ## The palette carrier -/

/-- Double a colour table, so every colour sits at both `2i` and `2i+1`. -/
def pairPalette {α : Type*} (pal : List α) : List α := pal.flatMap (fun c => [c, c])

theorem pairPalette_length {α : Type*} (pal : List α) :
    (pairPalette pal).length = 2 * pal.length := by
  induction pal with
  | nil => rfl
  | cons c cs ih => simp [pairPalette, List.flatMap_cons] at *; omega

/-- **The palette carrier changes no pixel at all.**  Both halves of a paired
entry decode to the colour the unpaired index stood for, so a pixel written at
`2i` or at `2i+1` is drawn in exactly the colour `pal[i]`. -/
theorem pairPalette_getElem? {α : Type*} (pal : List α) (i b : Nat) (hb : b < 2) :
    (pairPalette pal)[2 * i + b]? = pal[i]? := by
  induction pal generalizing i with
  | nil => simp [pairPalette]
  | cons c cs ih =>
    cases i with
    | zero =>
      interval_cases b <;> simp [pairPalette]
    | succ j =>
      have : 2 * (j + 1) + b = (2 * j + b) + 2 := by omega
      simp only [pairPalette, List.flatMap_cons, this]
      simpa [pairPalette] using ih j

/-- Carry one bit per pixel in the low bit of the palette index. -/
def embedIndices : List Nat → List Bool → List Nat
  | [], _ => []
  | i :: is, [] => 2 * i :: embedIndices is []
  | i :: is, b :: bs => (2 * i + (if b then 1 else 0)) :: embedIndices is bs

/-- Read the bits back from the paired indices. -/
def extractIndices (is : List Nat) : List Bool := is.map (fun i => i % 2 = 1)

/-- The colour of a paired index is the colour of its half. -/
def unpairIndex (i : Nat) : Nat := i / 2

theorem embedIndices_length (is : List Nat) (bs : List Bool) :
    (embedIndices is bs).length = is.length := by
  induction is generalizing bs with
  | nil => rfl
  | cons i is ih =>
    cases bs with
    | nil => simpa [embedIndices] using ih []
    | cons b bs => simpa [embedIndices] using ih bs

/-- **The picture is untouched.**  Every embedded index still points at the
colour its original index pointed at. -/
theorem unpair_embedIndices (is : List Nat) (bs : List Bool) :
    (embedIndices is bs).map unpairIndex = is := by
  induction is generalizing bs with
  | nil => rfl
  | cons i is ih =>
    cases bs with
    | nil =>
      simp only [embedIndices, List.map_cons, unpairIndex, List.cons.injEq]
      exact ⟨by omega, ih []⟩
    | cons b bs =>
      simp only [embedIndices, List.map_cons, unpairIndex, List.cons.injEq]
      refine ⟨?_, ih bs⟩
      cases b
      · show (2 * i + 0) / 2 = i
        omega
      · show (2 * i + 1) / 2 = i
        omega

/-- And the message comes back. -/
theorem extractIndices_embedIndices {is : List Nat} {bs : List Bool}
    (hfit : bs.length ≤ is.length) :
    (extractIndices (embedIndices is bs)).take bs.length = bs := by
  induction is generalizing bs with
  | nil =>
    have : bs = [] := List.eq_nil_of_length_eq_zero (Nat.le_zero.1 (by simpa using hfit))
    simp [this]
  | cons i is ih =>
    cases bs with
    | nil => simp
    | cons b bs =>
      have hfit' : bs.length ≤ is.length := by simpa using hfit
      simp only [embedIndices, extractIndices, List.map_cons, List.take_succ_cons,
        List.cons.injEq, List.length_cons]
      refine ⟨by cases b <;> simp, ih hfit'⟩

/-! ## The SVG carrier -/

/-- Set the parity of the last decimal digit of a coordinate, moving it by at
most one (`embedSVG`: `9` steps down to `8`, anything else steps up). -/
def nudgeDigit (d : Nat) (bit : Bool) : Nat :=
  if (d % 2 = 1) = bit then d else if d = 9 then 8 else d + 1

/-- The digit the SVG carrier writes has the parity the message asked for. -/
theorem nudgeDigit_parity {d : Nat} (hd : d ≤ 9) (bit : Bool) :
    ((nudgeDigit d bit) % 2 = 1) = bit := by
  have : ∀ n ≤ 9, ∀ b : Bool, ((nudgeDigit n b) % 2 = 1) = b := by decide
  exact this d hd bit

/-- And it is at most one step away from the digit that was there, so a
coordinate moves by less than `0.001` user units. -/
theorem nudgeDigit_close {d : Nat} (hd : d ≤ 9) (bit : Bool) :
    nudgeDigit d bit ≤ d + 1 ∧ d ≤ nudgeDigit d bit + 1 := by
  have : ∀ n ≤ 9, ∀ b : Bool, nudgeDigit n b ≤ n + 1 ∧ n ≤ nudgeDigit n b + 1 := by decide
  exact this d hd bit

/-- It is still a digit. -/
theorem nudgeDigit_le_nine {d : Nat} (hd : d ≤ 9) (bit : Bool) : nudgeDigit d bit ≤ 9 := by
  have : ∀ n ≤ 9, ∀ b : Bool, nudgeDigit n b ≤ 9 := by decide
  exact this d hd bit

end Hesper.Stego
