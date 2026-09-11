/-
# Emitting the memory/loop fragment as a `.wasm` binary

`RequestProject.Wasm.Encode` emits straight-line functions.  A function
that loops over linear memory needs three more pieces of the binary
format, all from the WebAssembly core specification, release 2.0,
section 5:

* the *memory section* (id 5) and a memory export, so a caller can write
  the buffer the function reads;
* *local declarations* in a code entry, for the accumulator, index and
  byte;
* the opcodes of `block` (`0x02`), `loop` (`0x03`), `br` (`0x0C`),
  `br_if` (`0x0D`), `local.set` (`0x21`), `i64.load8_u` (`0x31`),
  `i32.wrap_i64` (`0xA7`) and `end` (`0x0B`).

The section order is the one the format prescribes: type (1), function
(3), memory (5), export (7), code (10).

Mathlib-free by design.
-/
import RequestProject.Wasm.MemKernel
import RequestProject.Wasm.Encode

namespace Kant.Wasm.MemEncode

open Kant.Wasm.Encode
open Kant.Wasm.Leb128

/-- A function of the emitted module: a name, `arity` `i64` parameters,
`locals` further `i64` locals, and a body in the extended fragment. -/
structure MemFunc where
  name : String
  arity : Nat
  locals : Nat
  body : List MInstr

/-- A module with one linear memory of `pages` 64 KiB pages, exported
under the name `memory`, and a list of exported functions. -/
structure MemModule where
  pages : Nat
  funcs : List MemFunc

mutual

/-- Encoding of a single instruction of the extended fragment. -/
def minstr : MInstr → Bytes
  | .plain i => Encode.instr i
  | .wrap => [0xA7]
  | .load8 => [0x31, 0x00, 0x00]
  | .localSet i => 0x21 :: uleb i
  | .br l => 0x0C :: uleb l
  | .brIf l => 0x0D :: uleb l
  | .block b => (0x02 : UInt8) :: (0x40 : UInt8) :: (minstrs b ++ [0x0B])
  | .loop b => (0x03 : UInt8) :: (0x40 : UInt8) :: (minstrs b ++ [0x0B])

/-- Encoding of an instruction sequence. -/
def minstrs : List MInstr → Bytes
  | [] => []
  | i :: is => minstr i ++ minstrs is

end

/-- The local declarations of a code entry: one run of `n` `i64` locals,
or an empty vector when there are none. -/
def localDecls (n : Nat) : Bytes :=
  if n = 0 then uleb 0 else uleb 1 ++ uleb n ++ [i64Byte]

/-- The code entry of a function: its locals, its body, `end`. -/
def memCode (f : MemFunc) : Bytes :=
  let body := localDecls f.locals ++ minstrs f.body ++ [0x0B]
  uleb body.length ++ body

/-- Payload of the type section. -/
def memTypePayload (m : MemModule) : Bytes :=
  vec (m.funcs.map fun f => funcType f.arity)

/-- Payload of the function section. -/
def memFuncPayload (m : MemModule) : Bytes :=
  vec ((List.range m.funcs.length).map uleb)

/-- Payload of the memory section: one memory with a minimum size and no
maximum (limits flag `0x00`). -/
def memMemoryPayload (m : MemModule) : Bytes :=
  vec [(0x00 : UInt8) :: uleb m.pages]

/-- Payload of the export section: every function, then the memory. -/
def memExportPayload (m : MemModule) : Bytes :=
  vec ((m.funcs.zipIdx.map fun (f, i) => name f.name ++ (0x00 : UInt8) :: uleb i) ++
    [name "memory" ++ (0x02 : UInt8) :: uleb 0])

/-- Payload of the code section. -/
def memCodePayload (m : MemModule) : Bytes :=
  vec (m.funcs.map memCode)

/-- **The extractor** for the memory/loop fragment: the bytes of the
`.wasm` file. -/
def memModuleFile (m : MemModule) : Bytes :=
  magic ++ version ++ sec 1 (memTypePayload m) ++ sec 3 (memFuncPayload m)
    ++ sec 5 (memMemoryPayload m) ++ sec 7 (memExportPayload m) ++ sec 10 (memCodePayload m)

/-- The emitted file as a `ByteArray`. -/
def memModuleBytes (m : MemModule) : ByteArray := ⟨(memModuleFile m).toArray⟩

/-! ## The module that is written to disk -/

/-- `fnv1a_mem(ptr, len)`: two parameters, three locals, the fold program. -/
def fnvMemFunc : MemFunc :=
  { name := "fnv1a_mem", arity := 2, locals := 3, body := MemKernel.fnvMemProgram }

/-- The emitted module: one page of memory (64 KiB) and the digest
function. -/
def fnvMemModule : MemModule :=
  { pages := 1, funcs := [fnvMemFunc] }

/-- The bytes of `dist/kant_mem.wasm`. -/
def fnvMemBytes : ByteArray := memModuleBytes fnvMemModule

/-! ## Structural guarantees about the emitted bytes -/

/-- The emitted file starts with the wasm magic number and version. -/
theorem memModuleFile_prefix (m : MemModule) :
    (memModuleFile m).take 8 = [0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00] := by
  simp [memModuleFile, magic, version]

/-- The sections appear in the order the binary format requires: type,
function, memory, export, code. -/
theorem memModuleFile_sections (m : MemModule) :
    memModuleFile m = magic ++ version
      ++ sec 1 (memTypePayload m) ++ sec 3 (memFuncPayload m) ++ sec 5 (memMemoryPayload m)
      ++ sec 7 (memExportPayload m) ++ sec 10 (memCodePayload m) := rfl

/-- The export section names every function and then the memory. -/
theorem memExportPayload_names (m : MemModule) :
    memExportPayload m =
      uleb (m.funcs.length + 1) ++
        ((m.funcs.zipIdx.map fun (p : MemFunc × Nat) =>
            name p.1.name ++ (0x00 : UInt8) :: uleb p.2) ++
          [name "memory" ++ (0x02 : UInt8) :: uleb 0]).flatten := by
  simp [memExportPayload, vec]

end Kant.Wasm.MemEncode
