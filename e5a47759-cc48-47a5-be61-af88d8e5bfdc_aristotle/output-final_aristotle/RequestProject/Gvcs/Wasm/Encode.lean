import RequestProject.Gvcs.Wasm.Ir

/-!
# The binary encoder: from the IR to a real `.wasm` file

`RequestProject/Wasm/Ir.lean` gives the abstract syntax and the semantics that
the compiler correctness proofs are stated against.  This file turns that
abstract syntax into the WebAssembly *binary format* — the bytes a browser or
`WebAssembly.instantiate` will accept — and is the one trusted step of the
pipeline: it is checked by running the emitted module (see `web/test.mjs`),
not by proof.

Encoding notes.

* Every value is an `i64`; comparisons are emitted as the corresponding signed
  `i64` comparison followed by `i64.extend_i32_u`, so they leave `0` or `1` on
  the stack, exactly as `Wasm.exec` says.
* `Instr.and` and `Instr.or` are emitted as the bitwise `i64.and` / `i64.or`,
  which agree with the logical connectives of `Wasm.exec` on the `0`/`1` values
  the code generator gives them.
* `Instr.ifte`/`Instr.ifstmt` wrap the `i64` condition with `i32.wrap_i64`
  first, since WebAssembly's `if` takes an `i32`.
* The initial contents of the memory (the constant tables of the game) are
  emitted as one active data segment at offset `0`.
-/

namespace LifeTrac
namespace Wasm

/-- One function of a module: its exported name, how many `i64` parameters it
takes, how many scratch locals it needs, whether it returns a value, and its
body. -/
structure Func where
  /-- The name the function is exported under. -/
  name : String
  /-- Number of `i64` parameters. -/
  params : Nat
  /-- Number of scratch `i64` locals, all initialised to zero. -/
  locals : Nat
  /-- Does the function return an `i64`? -/
  returns : Bool
  /-- The body. -/
  body : List Instr

/-- A module: a memory of `memPages` 64 KiB pages, an initial memory image
given as (byte address, 64-bit word) pairs, and the functions. -/
structure Mod where
  /-- Size of the linear memory in 64 KiB pages. -/
  memPages : Nat
  /-- Initial memory image: 8-aligned byte addresses and their words. -/
  image : List (Nat × Int)
  /-- The exported functions. -/
  funcs : List Func

/-! ## LEB128 -/

/-- Unsigned LEB128. -/
def uleb (n : Nat) : List UInt8 :=
  let b := n % 128
  let r := n / 128
  if r = 0 then [b.toUInt8] else (b + 128).toUInt8 :: uleb r
decreasing_by omega

/-- Signed LEB128.  `n % 128` is Lean's Euclidean remainder, so it is already
in `[0, 128)`, and `(n - n % 128) / 128` is the exact quotient. -/
def sleb (n : Int) : List UInt8 :=
  let b : Int := n % 128
  let r : Int := (n - b) / 128
  if (r = 0 ∧ b < 64) ∨ (r = -1 ∧ 64 ≤ b) then [b.toNat.toUInt8]
  else (b.toNat + 128).toUInt8 :: sleb r
termination_by n.natAbs
decreasing_by omega

/-- A byte vector, prefixed by its length. -/
def vecBytes (l : List UInt8) : List UInt8 := uleb l.length ++ l

/-- A vector of items, prefixed by the number of items. -/
def vec (l : List (List UInt8)) : List UInt8 := uleb l.length ++ l.flatten

/-- A section: its id, then its contents prefixed by their length. -/
def section' (id : Nat) (body : List UInt8) : List UInt8 :=
  id.toUInt8 :: vecBytes body

/-- The UTF-8 bytes of a name, length-prefixed. -/
def nameBytes (s : String) : List UInt8 := vecBytes s.toUTF8.toList

/-! ## Instructions -/

/-- A comparison opcode followed by `i64.extend_i32_u`. -/
def cmp (op : UInt8) : List UInt8 := [op, 0xAD]

mutual
/-- The binary encoding of one instruction.  `sc` is the index of the scratch
local the encoder reserves in every function: WebAssembly addresses are `i32`,
so a store has to park its value there while the address is narrowed with
`i32.wrap_i64`. -/
def encInstr (sc : Nat) : Instr → List UInt8
  | .const n => 0x42 :: sleb n
  | .localGet i => 0x20 :: uleb i
  | .localSet i => 0x21 :: uleb i
  | .localTee i => 0x22 :: uleb i
  | .load => [0xA7, 0x29, 0x03, 0x00]
  | .store => (0x21 :: uleb sc) ++ [0xA7] ++ (0x20 :: uleb sc) ++ [0x37, 0x03, 0x00]
  | .add => [0x7C]
  | .sub => [0x7D]
  | .mul => [0x7E]
  | .divs => [0x7F]
  | .lt => cmp 0x53
  | .le => cmp 0x57
  | .gt => cmp 0x55
  | .ge => cmp 0x59
  | .eq => cmp 0x51
  | .ne => cmp 0x52
  | .and => [0x83]
  | .or => [0x84]
  | .eqz => cmp 0x50
  | .drop => [0x1A]
  | .ifte t e =>
      [0xA7, 0x04, 0x7E] ++ encInstrs sc t ++ [0x05] ++ encInstrs sc e ++ [0x0B]
  | .ifstmt t e =>
      [0xA7, 0x04, 0x40] ++ encInstrs sc t ++ [0x05] ++ encInstrs sc e ++ [0x0B]

/-- The binary encoding of a block of instructions. -/
def encInstrs (sc : Nat) : List Instr → List UInt8
  | [] => []
  | i :: l => encInstr sc i ++ encInstrs sc l
end

/-- The binary encoding of a block of instructions. -/
def encBody (sc : Nat) (l : List Instr) : List UInt8 := encInstrs sc l

@[simp] theorem encInstrs_eq (sc : Nat) (l : List Instr) :
    encInstrs sc l = (l.map (encInstr sc)).flatten := by
  induction l with
  | nil => rfl
  | cons i l ih => simp [encInstrs, ih]

/-! ## Sections -/

/-- The type of a function: `params` `i64`s in, one or no `i64` out. -/
def funcType (f : Func) : List UInt8 :=
  0x60 :: uleb f.params ++ List.replicate f.params (0x7E : UInt8) ++
    (if f.returns then [0x01, 0x7E] else [0x00])

/-- The code entry of a function: its locals declaration and its body. -/
def funcCode (f : Func) : List UInt8 :=
  let n := f.locals + 1
  let locals : List UInt8 := 0x01 :: uleb n ++ [0x7E]
  vecBytes (locals ++ encBody (f.params + f.locals) f.body ++ [0x0B])

/-- The little-endian bytes of a 64-bit word. -/
def word64 (v : Int) : List UInt8 :=
  let u : Nat := (v % (2 ^ 64) + 2 ^ 64).toNat % (2 ^ 64)
  (List.range 8).map (fun i => ((u / (2 ^ (8 * i))) % 256).toUInt8)

/-- The initial memory image as a flat byte string. -/
def imageBytes (image : List (Nat × Int)) : List UInt8 :=
  let top := image.foldl (fun acc p => max acc (p.1 + 8)) 0
  let arr : Array UInt8 := Array.replicate top 0
  let arr := image.foldl
    (fun (a : Array UInt8) (p : Nat × Int) =>
      (word64 p.2).zipIdx.foldl (fun (a : Array UInt8) (q : UInt8 × Nat) =>
        a.set! (p.1 + q.2) q.1) a) arr
  arr.toList

/-- The whole module, as the bytes of a `.wasm` file. -/
def encodeMod (m : Mod) : List UInt8 :=
  let magic : List UInt8 := [0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]
  let types := section' 1 (vec (m.funcs.map funcType))
  let funcs := section' 3 (vec ((m.funcs.zipIdx).map (fun p => uleb p.2)))
  let mems := section' 5 (vec [[0x00] ++ uleb m.memPages])
  let exports := section' 7 (vec (
    (nameBytes "mem" ++ [0x02] ++ uleb 0) ::
      (m.funcs.zipIdx).map (fun p => nameBytes p.1.name ++ [0x00] ++ uleb p.2)))
  let img := imageBytes m.image
  let datas :=
    if img.isEmpty then []
    else section' 11 (vec [[0x00, 0x41, 0x00, 0x0B] ++ vecBytes img])
  let code := section' 10 (vec (m.funcs.map funcCode))
  magic ++ types ++ funcs ++ mems ++ exports ++ code ++ datas

/-- The module as a `ByteArray`, ready to be written to disk. -/
def encodeModBytes (m : Mod) : ByteArray := ⟨(encodeMod m).toArray⟩

end Wasm
end LifeTrac
