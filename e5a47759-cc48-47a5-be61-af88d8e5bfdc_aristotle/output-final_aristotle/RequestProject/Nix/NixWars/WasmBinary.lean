import RequestProject.Nix.NixWars.Board

/-!
# The WebAssembly binary format

`Wasm.lean` proves the compiled module computes the game. This file turns that
module into an actual `.wasm` file: the binary encoding of the WebAssembly
module format (magic number, type / function / export / code sections, LEB128
integers, opcodes).

The encoding is written in Lean and evaluated at build time, so the bytes the
page ships are produced from the same `nixModule` the correctness theorem talks
about. The unsigned LEB128 encoding used for every index, length and section
size is proved unambiguous: `ulebDecode_uleb` shows a number can be read back
out of a stream that continues with arbitrary further bytes, which is exactly
the property the format relies on.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Wasm

/-! ## LEB128 -/

/-- Unsigned LEB128, with an explicit fuel argument so that the definition is
structurally recursive (and so the emitted bytes reduce in the kernel). -/
def ulebAux : Nat → Nat → List UInt8
  | 0, n => [UInt8.ofNat (n % 128)]
  | f + 1, n =>
      if n < 128 then [UInt8.ofNat n]
      else UInt8.ofNat (n % 128 + 128) :: ulebAux f (n / 128)

/-- Unsigned LEB128. -/
def uleb (n : Nat) : List UInt8 := ulebAux n n

/-- The fuel does not matter as long as there is enough of it. -/
theorem ulebAux_fuel : ∀ (n f g : Nat), n ≤ f → n ≤ g → ulebAux f n = ulebAux g n := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro f g hf hg
    by_cases h : n < 128
    · match f, g with
      | 0, 0 => rfl
      | 0, g + 1 => simp [ulebAux, h, Nat.mod_eq_of_lt h]
      | f + 1, 0 => simp [ulebAux, h, Nat.mod_eq_of_lt h]
      | f + 1, g + 1 => simp [ulebAux, h]
    · match f, g with
      | 0, _ => omega
      | _, 0 => omega
      | f + 1, g + 1 =>
        have hlt : n / 128 < n := by omega
        have h1 : n / 128 ≤ f := by omega
        have h2 : n / 128 ≤ g := by omega
        simp [ulebAux, h, ih (n / 128) hlt f g h1 h2]

/-- The defining equation of `uleb`. -/
theorem uleb_eq (n : Nat) :
    uleb n = if n < 128 then [UInt8.ofNat n]
      else UInt8.ofNat (n % 128 + 128) :: uleb (n / 128) := by
  by_cases h : n < 128
  · match n with
    | 0 => rfl
    | m + 1 => simp [uleb, ulebAux, h]
  · match n with
    | 0 => omega
    | m + 1 =>
      have h1 : (m + 1) / 128 ≤ m := by omega
      simp only [uleb, ulebAux, if_neg h]
      rw [ulebAux_fuel ((m + 1) / 128) m ((m + 1) / 128) h1 le_rfl]

/-- Reading an unsigned LEB128 number back off the front of a byte stream. -/
def ulebDecode : List UInt8 → Option (Nat × List UInt8)
  | [] => none
  | b :: bs =>
      if b.toNat < 128 then some (b.toNat, bs)
      else match ulebDecode bs with
        | none => none
        | some (n, rest) => some (b.toNat - 128 + 128 * n, rest)

/-- **LEB128 is unambiguous**: a number encoded at the front of a stream is read
back exactly, whatever follows it. This is what lets the sections, vectors and
indices of the emitted module be parsed at all. -/
theorem ulebDecode_uleb (n : Nat) :
    ∀ rest : List UInt8, ulebDecode (uleb n ++ rest) = some (n, rest) := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro rest
    rw [uleb_eq]
    by_cases h : n < 128
    · simp only [h, if_true, List.cons_append, List.nil_append, ulebDecode]
      have hn : (UInt8.ofNat n).toNat = n := by
        simp [Nat.mod_eq_of_lt (by omega : n < 256)]
      simp [hn, h]
    · have hlt : n / 128 < n := by omega
      have hb : (UInt8.ofNat (n % 128 + 128)).toNat = n % 128 + 128 := by
        have hlt' : n % 128 + 128 < 256 := by omega
        simp [Nat.mod_eq_of_lt hlt']
      simp only [h, if_false, List.cons_append, ulebDecode, hb]
      rw [if_neg (by omega), ih (n / 128) hlt rest]
      simp only [Option.some.injEq, Prod.mk.injEq, and_true]
      omega

/-- Signed LEB128 of a non-negative number below `2 ^ 31` — the form `i32.const`
takes. The last byte must have bit 6 clear, which is why the cut-off is 64 and
not 128. -/
def slebAux : Nat → Nat → List UInt8
  | 0, n => [UInt8.ofNat (n % 128)]
  | f + 1, n =>
      if n < 64 then [UInt8.ofNat n]
      else UInt8.ofNat (n % 128 + 128) :: slebAux f (n / 128)

/-- Signed LEB128 of a non-negative number below `2 ^ 31`. -/
def slebNat (n : Nat) : List UInt8 := slebAux n n

/-! ## Sections -/

/-- A vector: a LEB128 count followed by the elements. -/
def wvec (xs : List (List UInt8)) : List UInt8 := uleb xs.length ++ xs.flatten

/-- A section: its id, its length in bytes, then its contents. -/
def wsection (id : Nat) (payload : List UInt8) : List UInt8 :=
  UInt8.ofNat id :: (uleb payload.length ++ payload)

/-- The `i32` value type. -/
def i32 : UInt8 := 0x7f

/-- A function type `(i32^n) -> (i32^m)`. -/
def ftype (n m : Nat) : List UInt8 :=
  0x60 :: (uleb n ++ List.replicate n i32 ++ uleb m ++ List.replicate m i32)

/-- The opcode bytes of an instruction. -/
def encodeInstr : Instr → List UInt8
  | .const n =>
      0x41 :: slebNat (n % 2147483648)
  | .localGet i => 0x20 :: uleb i
  | .add => [0x6a]
  | .mul => [0x6c]
  | .sub => [0x6b]
  | .divU => [0x6e]
  | .leU => [0x4d]
  | .eqz => [0x45]
  | .select => [0x1b]
  | .call f => 0x10 :: uleb f

/-- A function body: no extra locals, the instructions, then `end`. -/
def encodeBody (fn : Func) : List UInt8 :=
  let code := uleb 0 ++ fn.body.flatMap encodeInstr ++ [0x0b]
  uleb code.length ++ code

/-- Bytes of an export name. Every name we emit is ASCII, so a character is a
byte. -/
def encodeName (s : String) : List UInt8 :=
  let bs := s.toList.map (fun c => UInt8.ofNat c.toNat)
  uleb bs.length ++ bs

/-! ## The module -/

/-- The shape of a function: how many parameters, how many results. -/
def typeOf (fn : Func) : Nat × Nat := (fn.arity, fn.results)

/-- The distinct function types of a module, in order of first use. -/
def moduleTypes (M : Module) : List (Nat × Nat) := (M.map typeOf).dedup

/-- The type index of a function of a module. -/
def typeIndexOf (M : Module) (fn : Func) : Nat := (moduleTypes M).idxOf (typeOf fn)

/-- The binary encoding of a module. -/
def encodeModule (M : Module) : List UInt8 :=
  let magic : List UInt8 := [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00]
  let typeSec := wsection 1 (wvec ((moduleTypes M).map (fun p => ftype p.1 p.2)))
  let funcSec := wsection 3 (wvec (M.map (fun fn => uleb (typeIndexOf M fn))))
  let exportSec := wsection 7 (wvec
    (M.zipIdx.map (fun p => encodeName p.1.name ++ [0x00] ++ uleb p.2)))
  let codeSec := wsection 10 (wvec (M.map encodeBody))
  magic ++ typeSec ++ funcSec ++ exportSec ++ codeSec

/-- **The emitted `.wasm` file**: the whole board, every door. -/
def wasmBytes : List UInt8 := encodeModule board

/-- The bytes as a JavaScript array literal, for embedding in the page. -/
def wasmBytesJs : String :=
  "[" ++ String.intercalate "," (wasmBytes.map (fun b => toString b.toNat)) ++ "]"

/-! ## Golden values for the binary

The emitted module is small and fixed; these pin its size and header so a change
in the encoder cannot slip through unnoticed. -/

example : wasmBytes.length = 7813 := by rfl

example : wasmBytes.take 8 = [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00] := by rfl

example : uleb 624485 = [0xe5, 0x8e, 0x26] := by rfl

example : slebNat 100 = [0xe4, 0x00] := by rfl

/-- Write the module next to the page. -/
def writeWasm : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeBinFile "www/nixwars.wasm" ⟨wasmBytes.toArray⟩

end Wasm
end NixWars
