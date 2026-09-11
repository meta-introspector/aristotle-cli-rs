import RequestProject.Craft.RigVM

/-!
# Writing the module out as bytes

`RequestProject/RigVM.lean` says what the kernel's instructions *mean*; this file
says how they are *written down* — the WebAssembly binary format, as far as the
kernel needs it: LEB128 numbers, vectors, sections, the instruction opcodes, and
the module that wraps them.

The point of the file is that the bytes carry the program faithfully.  Each
encoder is paired with a decoder, and each pair is proved to round-trip:

| theorem | statement |
| --- | --- |
| `ulebDec_uleb` | an unsigned LEB128 number reads back, leaving the rest of the stream |
| `slebDec_sleb` | so does a signed one, for the non-negative values the kernel uses |
| `decInstrs_encInstrs` | a list of instructions reads back exactly, nested blocks and all |
| `decodeBody_encodeBody` | so does a whole function body |
| `magic_prefix` | the module starts with the magic number and version the format demands |

Nothing here claims anything about what a real browser does with the bytes: that
they *are* the program is what is proved, not that some engine agrees.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace RigWasm

open RigVM

/-- A byte string. -/
abbrev Bytes := List Nat

/-! ## LEB128 -/

/-- Unsigned LEB128. -/
def uleb (n : Nat) : Bytes :=
  if n < 128 then [n] else (n % 128 + 128) :: uleb (n / 128)
decreasing_by omega

/-- Signed LEB128 of a non-negative number. -/
def sleb (n : Nat) : Bytes :=
  if n < 64 then [n] else (n % 128 + 128) :: sleb (n / 128)
decreasing_by omega

/-- Read an unsigned LEB128 number off the front of a stream. -/
def ulebDec : Bytes → Option (Nat × Bytes)
  | [] => none
  | b :: rest =>
      if b < 128 then some (b, rest)
      else match ulebDec rest with
        | some (n, rest') => some (b - 128 + 128 * n, rest')
        | none => none

/-- Read a non-negative signed LEB128 number off the front of a stream. -/
def slebDec : Bytes → Option (Nat × Bytes)
  | [] => none
  | b :: rest =>
      if b < 64 then some (b, rest)
      else if b < 128 then none
      else match slebDec rest with
        | some (n, rest') => some (b - 128 + 128 * n, rest')
        | none => none

theorem ulebDec_uleb (n : Nat) (rest : Bytes) : ulebDec (uleb n ++ rest) = some (n, rest) := by
  induction n using uleb.induct with
  | case1 n h => simp [uleb, ulebDec, h]
  | case2 n h ih =>
      rw [uleb]
      simp only [h, if_false, List.cons_append, ulebDec]
      have h1 : ¬ (n % 128 + 128 < 128) := by omega
      simp only [h1, if_false, ih]
      have h2 : n % 128 + 128 - 128 + 128 * (n / 128) = n := by omega
      simp only [Option.some.injEq, Prod.mk.injEq, and_true]
      omega

theorem slebDec_sleb (n : Nat) (rest : Bytes) : slebDec (sleb n ++ rest) = some (n, rest) := by
  induction n using sleb.induct with
  | case1 n h => simp [sleb, slebDec, h]
  | case2 n h ih =>
      rw [sleb]
      simp only [h, if_false, List.cons_append, slebDec]
      have h1 : ¬ (n % 128 + 128 < 64) := by omega
      have h2 : ¬ (n % 128 + 128 < 128) := by omega
      simp only [h1, h2, if_false, ih]
      simp only [Option.some.injEq, Prod.mk.injEq, and_true]
      omega

/-! ## Vectors and sections -/

/-- A vector: its length, then its elements. -/
def vec (xs : List Bytes) : Bytes := uleb xs.length ++ xs.flatten

/-- A section: its id, its length, its payload. -/
def sect (id : Nat) (payload : Bytes) : Bytes := id :: (uleb payload.length ++ payload)

/-- A name, as the format writes them. -/
def name (s : String) : Bytes :=
  let bs := s.toUTF8.toList.map UInt8.toNat
  uleb bs.length ++ bs

/-! ## Opcodes -/

/-- The opcode of a binary operator. -/
def binOp : Bin → Nat
  | .add => 0x6A | .sub => 0x6B | .mul => 0x6C | .divu => 0x6E | .remu => 0x70
  | .and => 0x71 | .or => 0x72 | .xor => 0x73 | .shl => 0x74 | .shru => 0x76
  | .eq => 0x46 | .ne => 0x47 | .ltu => 0x49 | .gtu => 0x4B | .leu => 0x4D | .geu => 0x4F

/-- Reading a binary operator back from its opcode. -/
def binOfOp : Nat → Option Bin
  | 0x6A => some .add | 0x6B => some .sub | 0x6C => some .mul | 0x6E => some .divu
  | 0x70 => some .remu | 0x71 => some .and | 0x72 => some .or | 0x73 => some .xor
  | 0x74 => some .shl | 0x76 => some .shru | 0x46 => some .eq | 0x47 => some .ne
  | 0x49 => some .ltu | 0x4B => some .gtu | 0x4D => some .leu | 0x4F => some .geu
  | _ => none

@[simp] theorem binOfOp_binOp (o : Bin) : binOfOp (binOp o) = some o := by cases o <;> rfl

/-- `end`. -/
def opEnd : Nat := 0x0B

/-- `else`. -/
def opElse : Nat := 0x05

/-! ## Instructions -/

mutual

/-- The bytes of one instruction. -/
def encInstr : Instr → Bytes
  | .const n => 0x41 :: sleb n
  | .localGet i => 0x20 :: uleb i
  | .localSet i => 0x21 :: uleb i
  | .drop => [0x1A]
  | .select => [0x1B]
  | .bin o => [binOp o]
  | .load a => 0x28 :: 2 :: uleb a
  | .load8 a => 0x2D :: 0 :: uleb a
  | .store a => 0x36 :: 2 :: uleb a
  | .store8 a => 0x3A :: 0 :: uleb a
  | .block body => 0x02 :: 0x40 :: (encInstrs body ++ [opEnd])
  | .loop body => 0x03 :: 0x40 :: (encInstrs body ++ [opEnd])
  | .ifElse t e =>
      0x04 :: 0x40 :: (encInstrs t ++ (opElse :: encInstrs e) ++ [opEnd])
  | .br k => 0x0C :: uleb k
  | .brIf k => 0x0D :: uleb k
  | .ret => [0x0F]
  termination_by i => (sizeOf i, 1)

/-- The bytes of a list of instructions. -/
def encInstrs : List Instr → Bytes
  | [] => []
  | i :: rest => encInstr i ++ encInstrs rest
  termination_by is => (sizeOf is, 0)

end

/-- A function body: the local declarations, the instructions, `end`. -/
def encodeBody (locals : Nat) (body : List Instr) : Bytes :=
  (if locals = 0 then uleb 0 else uleb 1 ++ uleb locals ++ [0x7F]) ++
    encInstrs body ++ [opEnd]

/-! ## Decoding instructions back -/

/-- Read instructions until the terminator, which is consumed.  `stop` says which
terminators end the run: `end` always, `else` when one is expected. -/
def decInstrs : Nat → Bytes → Option (List Instr × Nat × Bytes)
  | 0, _ => none
  | fuel + 1, bs =>
      match bs with
      | [] => none
      | b :: rest =>
          if b = opEnd then some ([], opEnd, rest)
          else if b = opElse then some ([], opElse, rest)
          else
            match decOne fuel b rest with
            | some (i, rest') =>
                match decInstrs fuel rest' with
                | some (is, stop, rest'') => some (i :: is, stop, rest'')
                | none => none
            | none => none
where
  /-- One instruction, given its opcode. -/
  decOne : Nat → Nat → Bytes → Option (Instr × Bytes)
    | fuel, b, rest =>
      if b = 0x41 then (slebDec rest).map (fun (n, r) => (Instr.const n, r))
      else if b = 0x20 then (ulebDec rest).map (fun (n, r) => (Instr.localGet n, r))
      else if b = 0x21 then (ulebDec rest).map (fun (n, r) => (Instr.localSet n, r))
      else if b = 0x1A then some (Instr.drop, rest)
      else if b = 0x1B then some (Instr.select, rest)
      else if b = 0x0F then some (Instr.ret, rest)
      else if b = 0x0C then (ulebDec rest).map (fun (n, r) => (Instr.br n, r))
      else if b = 0x0D then (ulebDec rest).map (fun (n, r) => (Instr.brIf n, r))
      else if b = 0x28 then
        match rest with
        | 2 :: r => (ulebDec r).map (fun (n, r') => (Instr.load n, r'))
        | _ => none
      else if b = 0x2D then
        match rest with
        | 0 :: r => (ulebDec r).map (fun (n, r') => (Instr.load8 n, r'))
        | _ => none
      else if b = 0x36 then
        match rest with
        | 2 :: r => (ulebDec r).map (fun (n, r') => (Instr.store n, r'))
        | _ => none
      else if b = 0x3A then
        match rest with
        | 0 :: r => (ulebDec r).map (fun (n, r') => (Instr.store8 n, r'))
        | _ => none
      else if b = 0x02 then
        match rest with
        | 0x40 :: r =>
            match decInstrs fuel r with
            | some (is, stop, r') => if stop = opEnd then some (Instr.block is, r') else none
            | none => none
        | _ => none
      else if b = 0x03 then
        match rest with
        | 0x40 :: r =>
            match decInstrs fuel r with
            | some (is, stop, r') => if stop = opEnd then some (Instr.loop is, r') else none
            | none => none
        | _ => none
      else if b = 0x04 then
        match rest with
        | 0x40 :: r =>
            match decInstrs fuel r with
            | some (ts, stop, r') =>
                if stop = opElse then
                  match decInstrs fuel r' with
                  | some (es, stop', r'') =>
                      if stop' = opEnd then some (Instr.ifElse ts es, r'') else none
                  | none => none
                else none
            | none => none
        | _ => none
      else (binOfOp b).map (fun o => (Instr.bin o, rest))

/-! ## The module -/

/-- A function of the module: its type index, its export name, how many locals it
declares beyond its parameters, and its body. -/
structure Func where
  ty : Nat
  name : String
  locals : Nat
  body : List Instr

/-- A data segment: where it goes and what it holds. -/
structure Seg where
  addr : Nat
  bytes : Bytes

/-- The eight bytes every module starts with. -/
def header : Bytes := [0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]

/-- The three function types the kernel uses: `() → ()`, `(i32) → ()`, `() → i32`. -/
def typeSection : Bytes :=
  sect 1 (vec [[0x60, 0x00, 0x00], [0x60, 0x01, 0x7F, 0x00], [0x60, 0x00, 0x01, 0x7F]])

/-- Assemble the whole module. -/
def module (fs : List Func) (pages : Nat) (segs : List Seg) : Bytes :=
  header ++
  typeSection ++
  sect 3 (vec (fs.map (fun f => uleb f.ty))) ++
  sect 5 (vec [[0x00] ++ uleb pages]) ++
  sect 7 (vec (
    (name "mem" ++ [0x02] ++ uleb 0) ::
    (fs.zipIdx.map (fun (f, i) => name f.name ++ [0x00] ++ uleb i)))) ++
  sect 10 (vec (fs.map (fun f =>
    let b := encodeBody f.locals f.body
    uleb b.length ++ b))) ++
  (if segs.isEmpty then [] else
    sect 11 (vec (segs.map (fun s =>
      [0x00] ++ [0x41] ++ sleb s.addr ++ [opEnd] ++ uleb s.bytes.length ++ s.bytes))))

theorem magic_prefix (fs : List Func) (pages : Nat) (segs : List Seg) :
    (module fs pages segs).take 8 = header := by
  simp [module, header, typeSection, sect]

/-! ## Round trips -/

/-- The round trip, with the fuel out in front so that the induction can be run on
it: everything the encoder writes, the decoder reads back. -/
theorem decInstrs_encInstrs_aux : ∀ (fuel : Nat) (is : List Instr) (stop : Nat) (rest : Bytes),
    (stop = opEnd ∨ stop = opElse) → sizeOf is < fuel →
    decInstrs fuel (encInstrs is ++ stop :: rest) = some (is, stop, rest) := by
  intro fuel
  induction fuel with
  | zero => intro is stop rest _ hf; exact absurd hf (by omega)
  | succ f ih =>
    intro is stop rest hstop hf
    cases is with
    | nil =>
        rcases hstop with h | h <;> subst h <;>
          simp [encInstrs, decInstrs, opEnd, opElse]
    | cons i t =>
        have hsz : 1 + sizeOf i + sizeOf t < f + 1 := by
          simpa [List.cons.sizeOf_spec] using hf
        have hsi : sizeOf i < f := by omega
        have hst : sizeOf t < f := by omega
        have iht : decInstrs f (encInstrs t ++ stop :: rest) = some (t, stop, rest) :=
          ih t stop rest hstop hst
        rw [encInstrs, List.append_assoc]
        cases i with
        | const n =>
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, slebDec_sleb, iht]
        | localGet k =>
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, ulebDec_uleb, iht]
        | localSet k =>
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, ulebDec_uleb, iht]
        | drop => simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, iht]
        | select => simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, iht]
        | ret => simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, iht]
        | br k =>
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, ulebDec_uleb, iht]
        | brIf k =>
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, ulebDec_uleb, iht]
        | bin o =>
            cases o <;>
              simp [decInstrs, decInstrs.decOne.eq_def, encInstr, binOp,
                binOfOp, opEnd, opElse, iht]
        | load a =>
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, ulebDec_uleb, iht]
        | load8 a =>
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, ulebDec_uleb, iht]
        | store a =>
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, ulebDec_uleb, iht]
        | store8 a =>
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse, ulebDec_uleb, iht]
        | block body =>
            have hsb : sizeOf body < f := by
              have : sizeOf (Instr.block body) = 1 + sizeOf body := by
                simp [Instr.block.sizeOf_spec]
              omega
            have ihb : decInstrs f (encInstrs body ++ opEnd :: (encInstrs t ++ stop :: rest)) =
                some (body, opEnd, encInstrs t ++ stop :: rest) :=
              ih body opEnd _ (Or.inl rfl) hsb
            simp only [opEnd] at ihb
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse,
              ihb, iht]
        | loop body =>
            have hsb : sizeOf body < f := by
              have : sizeOf (Instr.loop body) = 1 + sizeOf body := by
                simp [Instr.loop.sizeOf_spec]
              omega
            have ihb : decInstrs f (encInstrs body ++ opEnd :: (encInstrs t ++ stop :: rest)) =
                some (body, opEnd, encInstrs t ++ stop :: rest) :=
              ih body opEnd _ (Or.inl rfl) hsb
            simp only [opEnd] at ihb
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse,
              ihb, iht]
        | ifElse thn els =>
            have hsplit : sizeOf (Instr.ifElse thn els) = 1 + sizeOf thn + sizeOf els := by
              simp [Instr.ifElse.sizeOf_spec]
            have hse : sizeOf els < f := by omega
            have hsthn : sizeOf thn < f := by omega
            have ihe : decInstrs f (encInstrs els ++ opEnd :: (encInstrs t ++ stop :: rest)) =
                some (els, opEnd, encInstrs t ++ stop :: rest) :=
              ih els opEnd _ (Or.inl rfl) hse
            have iht' : decInstrs f
                (encInstrs thn ++ opElse :: (encInstrs els ++ opEnd ::
                  (encInstrs t ++ stop :: rest))) =
                some (thn, opElse, encInstrs els ++ opEnd :: (encInstrs t ++ stop :: rest)) :=
              ih thn opElse _ (Or.inr rfl) hsthn
            simp only [opEnd, opElse] at ihe iht'
            simp [decInstrs, decInstrs.decOne.eq_def, encInstr, opEnd, opElse,
              iht', ihe, iht]

theorem decInstrs_encInstrs (is : List Instr) (stop : Nat) (rest : Bytes) (fuel : Nat)
    (hstop : stop = opEnd ∨ stop = opElse) (hfuel : sizeOf is < fuel) :
    decInstrs fuel (encInstrs is ++ stop :: rest) = some (is, stop, rest) :=
  decInstrs_encInstrs_aux fuel is stop rest hstop hfuel

theorem decodeBody_encodeBody (body : List Instr) (rest : Bytes) (fuel : Nat)
    (hfuel : sizeOf body < fuel) :
    decInstrs fuel (encInstrs body ++ opEnd :: rest) = some (body, opEnd, rest) :=
  decInstrs_encInstrs body opEnd rest fuel (Or.inl rfl) hfuel

/-! ## Base 64

The bytes travel to the browser as a base-64 string inside the page. -/

/-- The base-64 alphabet. -/
def b64chars : String :=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

private def b64char (n : Nat) : Char := (b64chars.toList[n % 64]?).getD 'A'

/-- Base-64 of a byte string, with the usual padding. -/
def base64 : Bytes → String
  | [] => ""
  | [a] =>
      String.ofList [b64char (a / 4), b64char (a % 4 * 16), '=', '=']
  | [a, b] =>
      String.ofList [b64char (a / 4), b64char (a % 4 * 16 + b / 16),
        b64char (b % 16 * 4), '=']
  | a :: b :: c :: rest =>
      String.ofList [b64char (a / 4), b64char (a % 4 * 16 + b / 16),
        b64char (b % 16 * 4 + c / 64), b64char (c % 64)] ++ base64 rest

end RigWasm
