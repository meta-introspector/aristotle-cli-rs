import Mathlib

/-!
# The GIF bitstream

The formal counterpart of the container layer of `web/js/gif.js`: the part of
the animated-GIF encoder that sits *underneath* LZW.  A frame is compressed
into a list of codes, each written with the code width in force when it was
emitted; those codes are packed into bytes least-significant-bit first, and the
bytes are cut into sub-blocks, each preceded by its length and the run
terminated by a zero-length block.  Every GIF decoder undoes exactly these two
steps before it looks at a single dictionary entry.

What is proved is that this layer is lossless:

* `readCodes_emitCodes` — codes written at varying widths are read back
  unchanged (and trailing padding bits are harmless), so a change of code width
  never desynchronises the stream;
* `bitsOfBytes_bytesOfBits` — packing bits into bytes only ever appends padding
  (`take_bitsOfBytes_bytesOfBits` states the same thing as a truncation), and
  `bytesOfBits_lt` — what it produces really is a stream of bytes;
* `unframe_frameBlocks` — the sub-block framing is exactly invertible, and
  `frameBlocks_lt` — it too produces bytes;
* `codeStream_roundtrip` — the three together: reading the framed byte stream
  the encoder writes gives back precisely the codes it emitted.

The LZW dictionary itself is not modelled here; that the *whole* encoder is
correct is checked end to end instead, by decoding its output with Pillow in
`tests/node/check_outputs.py`.
-/

namespace Hesper.Gif

/-! ## Bits -/

/-- The `w` low bits of `c`, least significant first — the order the GIF bit
accumulator shifts them out in. -/
def bitsOf : ℕ → ℕ → List Bool
  | 0, _ => []
  | w + 1, c => (c % 2 == 1) :: bitsOf w (c / 2)

/-- The number a bit list stands for, least significant bit first. -/
def valOf : List Bool → ℕ
  | [] => 0
  | b :: t => b.toNat + 2 * valOf t

@[simp] theorem length_bitsOf (w c : ℕ) : (bitsOf w c).length = w := by
  induction w generalizing c with
  | zero => rfl
  | succ n ih => simp [bitsOf, ih]

theorem valOf_bitsOf (w c : ℕ) : valOf (bitsOf w c) = c % 2 ^ w := by
  induction w generalizing c with
  | zero => simp [bitsOf, valOf, Nat.mod_one]
  | succ n ih =>
      have key : c % 2 ^ (n + 1) = c % 2 + 2 * (c / 2 % 2 ^ n) := by
        rw [pow_succ, mul_comm (2 ^ n) 2, Nat.mod_mul]
      simp only [bitsOf, valOf, ih, key]
      rcases Nat.even_or_odd c with he | ho
      · have h : c % 2 = 0 := Nat.even_iff.1 he
        simp [h]
      · have h : c % 2 = 1 := Nat.odd_iff.1 ho
        simp [h]

theorem bitsOf_valOf : ∀ l : List Bool, bitsOf l.length (valOf l) = l := by
  intro l
  induction l with
  | nil => rfl
  | cons b t ih =>
      have hb : b.toNat < 2 := by cases b <;> simp
      have h1 : (b.toNat + 2 * valOf t) % 2 = b.toNat := by omega
      have h2 : (b.toNat + 2 * valOf t) / 2 = valOf t := by omega
      simp only [List.length_cons, bitsOf, valOf, h1, h2, ih]
      cases b <;> simp

theorem valOf_lt : ∀ l : List Bool, valOf l < 2 ^ l.length := by
  intro l
  induction l with
  | nil => simp [valOf]
  | cons b t ih =>
      have hb : b.toNat < 2 := by cases b <;> simp
      have : (2:ℕ) ^ (t.length + 1) = 2 * 2 ^ t.length := by rw [pow_succ]; ring
      simp only [valOf, List.length_cons, this]
      omega

theorem bitsOf_add (a b c : ℕ) : bitsOf (a + b) c = bitsOf a c ++ bitsOf b (c / 2 ^ a) := by
  induction a generalizing c with
  | zero => simp [bitsOf]
  | succ n ih =>
      simp only [Nat.succ_add, bitsOf, ih, List.cons_append]
      congr 2
      rw [Nat.div_div_eq_div_mul, pow_succ, mul_comm]

/-! ## The code stream

The encoder emits `(width, code)` pairs: the width is the code size in force at
that moment, which grows as the dictionary fills and drops back after a clear
code.  A decoder tracks the same widths, so reading is indexed by the list of
widths alone. -/

/-- The bits the encoder writes for a list of `(width, code)` pairs. -/
def emitCodes : List (ℕ × ℕ) → List Bool
  | [] => []
  | (w, c) :: t => bitsOf w c ++ emitCodes t

/-- Reading codes back, given the widths in force. -/
def readCodes : List ℕ → List Bool → Option (List ℕ)
  | [], _ => some []
  | w :: ws, bs =>
      if bs.length < w then none
      else (readCodes ws (bs.drop w)).map fun r => valOf (bs.take w) :: r

/-- **Codes survive the bit packing**: whatever widths were in force, the
decoder reads back exactly the codes that were written — and bits that follow
the last code (the encoder's final padding) do not disturb it. -/
theorem readCodes_emitCodes :
    ∀ (ps : List (ℕ × ℕ)), (∀ p ∈ ps, p.2 < 2 ^ p.1) → ∀ rest : List Bool,
      readCodes (ps.map Prod.fst) (emitCodes ps ++ rest) = some (ps.map Prod.snd) := by
  intro ps
  induction ps with
  | nil => intro _ _; rfl
  | cons p t ih =>
      obtain ⟨w, c⟩ := p
      intro h rest
      have hc : c < 2 ^ w := h (w, c) (by simp)
      have hlen : ¬ ((bitsOf w c ++ (emitCodes t ++ rest)).length < w) := by simp
      have htake : (bitsOf w c ++ (emitCodes t ++ rest)).take w = bitsOf w c := by simp
      have hdrop : (bitsOf w c ++ (emitCodes t ++ rest)).drop w = emitCodes t ++ rest := by simp
      simp only [List.map_cons, emitCodes, List.append_assoc, readCodes, hlen, if_false,
        htake, hdrop, ih (fun q hq => h q (by simp [hq])) rest, Option.map_some,
        valOf_bitsOf, Nat.mod_eq_of_lt hc]

/-! ## Bits to bytes -/

/-- Pack bits into bytes, eight at a time, least significant bit first; a short
tail is padded with zero bits, exactly as the encoder's final flush does. -/
def bytesOfBits : List Bool → List ℕ
  | [] => []
  | b :: bs => valOf ((b :: bs).take 8) :: bytesOfBits ((b :: bs).drop 8)
  termination_by l => l.length
  decreasing_by simp

/-- Unpack a byte stream into bits, least significant bit first. -/
def bitsOfBytes (l : List ℕ) : List Bool := l.flatMap (bitsOf 8)

/-- **Packing only appends padding**: the bits come back, followed by at most
the zero bits that filled the last byte. -/
theorem bitsOfBytes_bytesOfBits :
    ∀ bs : List Bool, ∃ pad : List Bool, bitsOfBytes (bytesOfBits bs) = bs ++ pad := by
  intro bs
  induction bs using bytesOfBits.induct with
  | case1 => exact ⟨[], by simp [bitsOfBytes, bytesOfBits]⟩
  | case2 b t ih =>
      obtain ⟨pad, hpad⟩ := ih
      by_cases h8 : 8 ≤ (b :: t).length
      · refine ⟨pad, ?_⟩
        have h8' : 7 ≤ t.length := by simpa using h8
        have hlen : ((b :: t).take 8).length = 8 := by simp; omega
        have hbits := bitsOf_valOf ((b :: t).take 8)
        rw [hlen] at hbits
        simp only [bytesOfBits, bitsOfBytes, List.flatMap_cons] at *
        rw [hbits, hpad, ← List.append_assoc, List.take_append_drop]
      · push_neg at h8
        have hdrop : (b :: t).drop 8 = [] := List.drop_eq_nil_of_le (le_of_lt h8)
        have htake : (b :: t).take 8 = b :: t := List.take_of_length_le (le_of_lt h8)
        set n := (b :: t).length with hn
        refine ⟨bitsOf (8 - n) (valOf (b :: t) / 2 ^ n), ?_⟩
        have hsum : n + (8 - n) = 8 := by omega
        simp only [bytesOfBits, bitsOfBytes, List.flatMap_cons, htake, hdrop]
        rw [← hsum, bitsOf_add, bitsOf_valOf]
        simp

/-- The same statement as a truncation: the first `bs.length` bits of the
unpacked stream are the bits that were packed. -/
theorem take_bitsOfBytes_bytesOfBits (bs : List Bool) :
    (bitsOfBytes (bytesOfBits bs)).take bs.length = bs := by
  obtain ⟨pad, hpad⟩ := bitsOfBytes_bytesOfBits bs
  rw [hpad]
  simp

/-- What the packer produces really is a stream of bytes. -/
theorem bytesOfBits_lt : ∀ bs : List Bool, ∀ x ∈ bytesOfBits bs, x < 256 := by
  intro bs
  induction bs using bytesOfBits.induct with
  | case1 => intro x hx; simp [bytesOfBits] at hx
  | case2 b t ih =>
      intro x hx
      simp only [bytesOfBits, List.mem_cons] at hx
      rcases hx with rfl | hx
      · have hlen : ((b :: t).take 8).length ≤ 8 := by simp
        have h1 := valOf_lt ((b :: t).take 8)
        have h2 : (2:ℕ) ^ ((b :: t).take 8).length ≤ 2 ^ 8 :=
          Nat.pow_le_pow_right (by norm_num) hlen
        omega
      · exact ih x hx

/-! ## Sub-blocks

A GIF image's data is a run of sub-blocks: a length byte of at most 255, that
many data bytes, and finally a zero-length block. -/

/-- Cut a byte stream into GIF sub-blocks. -/
def frameBlocks : List ℕ → List ℕ
  | [] => [0]
  | b :: t => min 255 (b :: t).length :: ((b :: t).take 255 ++ frameBlocks ((b :: t).drop 255))
  termination_by l => l.length
  decreasing_by simp

/-- Read a run of sub-blocks, stopping at the terminator. -/
def unframe : List ℕ → Option (List ℕ)
  | [] => none
  | 0 :: _ => some []
  | (n + 1) :: rest =>
      if rest.length < n + 1 then none
      else (unframe (rest.drop (n + 1))).map fun r => rest.take (n + 1) ++ r
  termination_by l => l.length
  decreasing_by simp

theorem unframe_cons_succ (n : ℕ) (rest : List ℕ) :
    unframe ((n + 1) :: rest) =
      if rest.length < n + 1 then none
      else (unframe (rest.drop (n + 1))).map fun r => rest.take (n + 1) ++ r := by
  rw [unframe]

/-- **The sub-block framing is exactly invertible**: reading the blocks back
concatenates to the stream they were cut from. -/
theorem unframe_frameBlocks : ∀ l : List ℕ, unframe (frameBlocks l) = some l := by
  intro l
  induction l using frameBlocks.induct with
  | case1 => simp [frameBlocks, unframe]
  | case2 b t ih =>
      have hpos : 0 < min 255 (b :: t).length := by simp
      obtain ⟨n, hn⟩ : ∃ n, min 255 (b :: t).length = n + 1 :=
        ⟨min 255 (b :: t).length - 1, by omega⟩
      have hn1 : ((b :: t).take 255).length = n + 1 := by
        rw [List.length_take]; omega
      have htake : ((b :: t).take 255 ++ frameBlocks ((b :: t).drop 255)).take (n + 1)
          = (b :: t).take 255 := by rw [← hn1]; simp
      have hdrop : ((b :: t).take 255 ++ frameBlocks ((b :: t).drop 255)).drop (n + 1)
          = frameBlocks ((b :: t).drop 255) := by rw [← hn1]; simp
      have hge : ¬ (((b :: t).take 255 ++ frameBlocks ((b :: t).drop 255)).length < n + 1) := by
        rw [List.length_append, hn1]; omega
      rw [frameBlocks, hn, unframe_cons_succ, if_neg hge, htake, hdrop, ih]
      simp

/-- The framing writes bytes: every length byte is at most 255 and the data
bytes are the ones it was given. -/
theorem frameBlocks_lt : ∀ l : List ℕ, (∀ y ∈ l, y < 256) → ∀ x ∈ frameBlocks l, x < 256 := by
  intro l
  induction l using frameBlocks.induct with
  | case1 => intro _ x hx; simp [frameBlocks] at hx; omega
  | case2 b t ih =>
      intro hl x hx
      rw [frameBlocks] at hx
      simp only [List.mem_cons, List.mem_append] at hx
      rcases hx with rfl | hx
      · omega
      rcases hx with hx | hx
      · exact hl x (List.mem_of_mem_take hx)
      · exact ih (fun y hy => hl y (List.mem_of_mem_drop hy)) x hx

/-! ## The container is lossless -/

/-- **The GIF container layer loses nothing**: whatever codes the compressor
emits, at whatever widths, packing them into bytes and cutting the bytes into
sub-blocks is undone exactly — a decoder reading the framed stream recovers the
very list of codes that was written. -/
theorem codeStream_roundtrip (ps : List (ℕ × ℕ)) (h : ∀ p ∈ ps, p.2 < 2 ^ p.1) :
    (unframe (frameBlocks (bytesOfBits (emitCodes ps)))).bind
        (fun bytes => readCodes (ps.map Prod.fst) (bitsOfBytes bytes))
      = some (ps.map Prod.snd) := by
  obtain ⟨pad, hpad⟩ := bitsOfBytes_bytesOfBits (emitCodes ps)
  rw [unframe_frameBlocks]
  simpa [hpad] using readCodes_emitCodes ps h pad

end Hesper.Gif
