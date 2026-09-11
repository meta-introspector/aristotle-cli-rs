import RequestProject.Gvcs.Wasm.Encode

/-!
# A decoder for the WebAssembly binary format

`RequestProject/Wasm/Encode.lean` turns the IR of `RequestProject/Wasm/Ir.lean`
into the bytes of a `.wasm` file.  This file walks the other way: it reads the
bytes back.  It is written independently of the encoder — it is a parser for
the fragment of the binary format the encoder uses, with all the length
prefixes, LEB128 numbers and section headers checked as a real consumer would
check them — and `RequestProject/Wasm/DecodeCorrect.lean` proves that reading
back what the encoder wrote returns exactly the module it was given.

That round trip is what pins the encoder down: a byte string can be parsed as
at most one module, so the file the extractor writes determines the abstract
syntax the correctness proofs are about, and every length prefix, opcode and
LEB128 field in it is the one the decoder — a reader of the format written
without looking at the encoder — expects.

What is *not* proved here, and cannot be inside Lean, is that this decoder is
the WebAssembly specification's decoder; that remains a reading of the format
document, backed by running the emitted module in a real engine
(`node web/test.mjs`).

* `Dec α` is a byte-string parser.
* `ulebDec`, `slebDec` read LEB128 numbers.
* `decInstr`, `decBlock` read the instruction encoding, including the
  multi-instruction patterns the encoder uses for `load` and `store`.
* `decodeMod` reads a whole module into a `DecMod`.
-/

namespace LifeTrac
namespace Wasm

/-! ## Parsers -/

/-- A parser: it consumes a prefix of the byte string and returns a value
together with what is left. -/
abbrev Dec (α : Type) := List UInt8 → Option (α × List UInt8)

/-- Consume one given byte. -/
def expectB (b : UInt8) : Dec Unit
  | [] => none
  | c :: r => if c = b then some ((), r) else none

/-- Consume exactly `n` bytes. -/
def takeN (n : Nat) : Dec (List UInt8) := fun l =>
  if n ≤ l.length then some (l.take n, l.drop n) else none

/-- Run a parser on a byte string and insist that it consumes all of it. -/
def runDec {α : Type} (d : Dec α) (l : List UInt8) : Option α :=
  match d l with
  | some (a, []) => some a
  | _ => none

/-! ## LEB128 -/

/-- Read an unsigned LEB128 number. -/
def ulebDec : Dec Nat
  | [] => none
  | b :: r =>
      if b.toNat < 128 then some (b.toNat, r)
      else match ulebDec r with
        | none => none
        | some (v, r') => some ((b.toNat - 128) + 128 * v, r')

/-- Read a signed LEB128 number. -/
def slebDec : Dec Int
  | [] => none
  | b :: r =>
      if b.toNat < 128 then
        some (if b.toNat < 64 then (b.toNat : Int) else (b.toNat : Int) - 128, r)
      else match slebDec r with
        | none => none
        | some (v, r') => some (((b.toNat : Int) - 128) + 128 * v, r')

/-- Read a length-prefixed byte vector. -/
def decVecBytes : Dec (List UInt8) := fun l =>
  match ulebDec l with
  | none => none
  | some (n, l) => takeN n l

/-- Read `n` items with the same parser. -/
def decVecN {α : Type} (d : Dec α) : Nat → Dec (List α)
  | 0, l => some ([], l)
  | n + 1, l =>
      match d l with
      | none => none
      | some (a, l') =>
          match decVecN d n l' with
          | none => none
          | some (as, l'') => some (a :: as, l'')

/-- Read a count-prefixed vector of items. -/
def decVec {α : Type} (d : Dec α) : Dec (List α) := fun l =>
  match ulebDec l with
  | none => none
  | some (n, l) => decVecN d n l

/-- Read a section with the given id, returning its contents. -/
def decSection (id : UInt8) : Dec (List UInt8)
  | [] => none
  | c :: r => if c = id then decVecBytes r else none

/-! ## Instructions -/

mutual
/-- The fuel an instruction needs to be read back: one for the instruction
itself, plus the fuel of the arms of a conditional. -/
def szI : Instr → Nat
  | .ifte t e => 1 + szL t + szL e
  | .ifstmt t e => 1 + szL t + szL e
  | _ => 1

/-- The fuel a block needs to be read back. -/
def szL : List Instr → Nat
  | [] => 1
  | i :: l => 1 + szI i + szL l
end

/-- The tail of the encoder's `i64.store` pattern: after `local.set sc` comes
`i32.wrap_i64`, `local.get sc` and the store itself.  Returns what is left
when the bytes are that pattern. -/
def storeTail (sc : Nat) : List UInt8 → Option (List UInt8)
  | 0xA7 :: 0x20 :: r =>
      match ulebDec r with
      | some (j, 0x37 :: 0x03 :: 0x00 :: r3) => if j = sc then some r3 else none
      | _ => none
  | _ => none

mutual

/-- Read one instruction.  `sc` is the scratch local of the function being
read: the encoder spells `i64.store` as a four-instruction dance through that
local, and `decInstr` recognises the whole pattern. -/
def decInstr (fuel sc : Nat) (l : List UInt8) : Option (Instr × List UInt8) :=
  match fuel with
  | 0 => none
  | fuel + 1 =>
    match l with
    | [] => none
    | b :: r =>
      if b = 0x42 then
        match slebDec r with
        | none => none
        | some (n, r') => some (Instr.const n, r')
      else if b = 0x20 then
        match ulebDec r with
        | none => none
        | some (i, r') => some (Instr.localGet i, r')
      else if b = 0x22 then
        match ulebDec r with
        | none => none
        | some (i, r') => some (Instr.localTee i, r')
      else if b = 0x21 then
        match ulebDec r with
        | none => none
        | some (i, r1) =>
          if i = sc then
            match storeTail sc r1 with
            | some r3 => some (Instr.store, r3)
            | none => some (Instr.localSet i, r1)
          else some (Instr.localSet i, r1)
      else if b = 0xA7 then
        match r with
        | 0x29 :: 0x03 :: 0x00 :: r1 => some (Instr.load, r1)
        | 0x04 :: 0x7E :: r1 => decIf fuel sc true r1
        | 0x04 :: 0x40 :: r1 => decIf fuel sc false r1
        | _ => none
      else if b = 0x7C then some (Instr.add, r)
      else if b = 0x7D then some (Instr.sub, r)
      else if b = 0x7E then some (Instr.mul, r)
      else if b = 0x7F then some (Instr.divs, r)
      else if b = 0x83 then some (Instr.and, r)
      else if b = 0x84 then some (Instr.or, r)
      else if b = 0x1A then some (Instr.drop, r)
      -- the comparisons, each followed by `i64.extend_i32_u`
      else
        match r with
        | 0xAD :: r1 =>
            if b = 0x53 then some (Instr.lt, r1)
            else if b = 0x57 then some (Instr.le, r1)
            else if b = 0x55 then some (Instr.gt, r1)
            else if b = 0x59 then some (Instr.ge, r1)
            else if b = 0x51 then some (Instr.eq, r1)
            else if b = 0x52 then some (Instr.ne, r1)
            else if b = 0x50 then some (Instr.eqz, r1)
            else none
        | _ => none
termination_by (fuel, 2)

/-- Read the two arms of a conditional, and the `end` that closes it. -/
def decIf (fuel sc : Nat) (res : Bool) (l : List UInt8) : Option (Instr × List UInt8) :=
  match decBlock fuel sc l with
  | some (t, 0x05 :: r1) =>
      match decBlock fuel sc r1 with
      | some (e, 0x0B :: r2) =>
          some (if res then Instr.ifte t e else Instr.ifstmt t e, r2)
      | _ => none
  | _ => none
termination_by (fuel, 1)

/-- Read instructions until an `else` or an `end` (which is left unconsumed),
or until the input runs out. -/
def decBlock (fuel sc : Nat) (l : List UInt8) : Option (List Instr × List UInt8) :=
  match fuel with
  | 0 => none
  | fuel + 1 =>
    match l with
    | [] => some ([], [])
    | b :: _ =>
      if b = 0x05 ∨ b = 0x0B then some ([], l)
      else
        match decInstr fuel sc l with
        | none => none
        | some (i, r) =>
            match decBlock fuel sc r with
            | none => none
            | some (is, r') => some (i :: is, r')
termination_by (fuel, 0)
end

/-! ## Modules -/

/-- A function as the decoder sees it.  The export name comes back as its
UTF-8 bytes: decoding UTF-8 is no part of the WebAssembly format. -/
structure DecFunc where
  /-- The UTF-8 bytes of the name the function is exported under. -/
  name : List UInt8
  /-- Number of `i64` parameters. -/
  params : Nat
  /-- Number of scratch `i64` locals beyond the one the encoder reserves. -/
  locals : Nat
  /-- Does the function return an `i64`? -/
  returns : Bool
  /-- The body. -/
  body : List Instr

/-- A module as the decoder sees it: the memory image comes back as the flat
byte string of the data segment, since the association list the encoder was
given is not recoverable from it. -/
structure DecMod where
  /-- Size of the linear memory in 64 KiB pages. -/
  memPages : Nat
  /-- The bytes of the active data segment at offset `0`. -/
  data : List UInt8
  /-- The exported functions. -/
  funcs : List DecFunc

/-- Read a function type: `n` `i64` parameters and at most one `i64` result. -/
def decFuncType : Dec (Nat × Bool)
  | 0x60 :: r =>
      match ulebDec r with
      | none => none
      | some (p, r1) =>
        match takeN p r1 with
        | none => none
        | some (vs, r2) =>
          if vs = List.replicate p (0x7E : UInt8) then
            match r2 with
            | 0x01 :: 0x7E :: r3 => some ((p, true), r3)
            | 0x00 :: r3 => some ((p, false), r3)
            | _ => none
          else none
  | _ => none

/-- Read one export entry: a name, the kind byte, and the index. -/
def decExport : Dec (List UInt8 × UInt8 × Nat) := fun l =>
  match decVecBytes l with
  | none => none
  | some (nm, r) =>
    match r with
    | k :: r1 =>
        match ulebDec r1 with
        | none => none
        | some (i, r2) => some ((nm, k, i), r2)
    | _ => none

/-- Read the code entry of a function whose type declares `params`
parameters: the locals declaration and then the body, up to the closing
`end`.  Returns the number of scratch locals beyond the reserved one. -/
def decCode (fuel params : Nat) : Dec (Nat × List Instr) := fun l =>
  match decVecBytes l with
  | none => none
  | some (body, r) =>
    match body with
    | 0x01 :: b1 =>
      match ulebDec b1 with
      | none => none
      | some (n, b2) =>
        match b2 with
        | 0x7E :: b3 =>
            if n = 0 then none
            else
              match decBlock fuel (params + (n - 1)) b3 with
              | some (is, [0x0B]) => some ((n - 1, is), r)
              | _ => none
        | _ => none
    | _ => none

/-- Read the code entries of a list of functions whose types are given. -/
def decCodes (fuel : Nat) : List (Nat × Bool) → Dec (List (Nat × List Instr))
  | [], l => some ([], l)
  | t :: ts, l =>
      match decCode fuel t.1 l with
      | none => none
      | some (c, l1) =>
        match decCodes fuel ts l1 with
        | none => none
        | some (cs, l2) => some (c :: cs, l2)

/-- Read a memory entry: an unbounded memory of the given number of pages. -/
def decMem : Dec Nat
  | 0x00 :: r => ulebDec r
  | _ => none

/-- Read the one data segment: active, in memory 0, at offset `i32.const 0`. -/
def decData : Dec (List UInt8)
  | 0x00 :: 0x41 :: 0x00 :: 0x0B :: r => decVecBytes r
  | _ => none

/-- Glue a name, a type and a code entry into a function. -/
def mkDecFunc (nm : List UInt8) (t : Nat × Bool) (c : Nat × List Instr) : DecFunc :=
  { name := nm, params := t.1, locals := c.1, returns := t.2, body := c.2 }

/-- Glue the names, types and code entries of a module into functions. -/
def zipFuncs : List (List UInt8) → List (Nat × Bool) → List (Nat × List Instr) → List DecFunc
  | n :: ns, t :: ts, c :: cs => mkDecFunc n t c :: zipFuncs ns ts cs
  | _, _, _ => []

/-- The magic number and version of a `.wasm` file. -/
def wasmMagic : List UInt8 := [0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]

/-- Read a whole module. -/
def decodeMod (fuel : Nat) (bs : List UInt8) : Option DecMod := do
  let (magic, l0) ← takeN 8 bs
  guard (magic = wasmMagic)
  let (tySec, l1) ← decSection 1 l0
  let tys ← runDec (decVec decFuncType) tySec
  let (fnSec, l2) ← decSection 3 l1
  let idxs ← runDec (decVec ulebDec) fnSec
  guard (idxs = List.range tys.length)
  let (memSec, l3) ← decSection 5 l2
  let mems ← runDec (decVec decMem) memSec
  let pages ← (match mems with | [p] => some p | _ => none)
  let (exSec, l4) ← decSection 7 l3
  let exps ← runDec (decVec decExport) exSec
  let fnExps ← (match exps with
    | (_, k, i) :: fs => if k = 0x02 ∧ i = 0 then some fs else none
    | [] => none)
  guard (fnExps.map Prod.snd = (List.range tys.length).map (fun i => ((0x00 : UInt8), i)))
  let (codeSec, l5) ← decSection 10 l4
  let codes ← runDec (fun l => do
      let (n, l') ← ulebDec l
      guard (n = tys.length)
      decCodes fuel tys l') codeSec
  let img ← (if l5 = [] then some [] else do
      let (dSec, rest) ← decSection 11 l5
      guard (rest = [])
      let ds ← runDec (decVec decData) dSec
      match ds with | [d] => some d | _ => none)
  some { memPages := pages, data := img,
         funcs := zipFuncs (fnExps.map Prod.fst) tys codes }

end Wasm
end LifeTrac
