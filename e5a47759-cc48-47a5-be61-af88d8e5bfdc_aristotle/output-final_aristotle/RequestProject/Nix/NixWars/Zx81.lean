import RequestProject.Nix.NixWars.Session

/-!
# A ZX81 in Lean

The BBS would not be a BBS without a machine to run it on. This file is a
model of the Sinclair ZX81: a Z80 processor (the fragment of the instruction
set the ROMs below use), a byte-addressed memory, and a display file that the
page draws as a screen in the ZX81 character set.

Everything is defined the same way as the rest of the development — as total
functions on natural numbers — so the emulator is deterministic by
construction, and the facts about it are proved rather than tested:

* decoding is total and deterministic (`decode`), and an opcode outside the
  fragment decodes to `Z80.unknown`, which halts the machine rather than doing
  something unspecified (`exec_unknown`);
* every instruction leaves the memory the same size (`step_mem_length`) and
  every byte of it a byte (`step_mem_bytes`), and leaves the program counter
  inside the address space (`step_pc_lt`);
* a halted machine is a fixed point (`step_halted`, `run_halted`);
* and the three ROMs do what they say: the banner ROM pokes `NIXWARS` into the
  top line of the display file, the counter ROM adds `10 + 9 + ⋯ + 1 = 55` with
  a `DJNZ` loop, and the fill ROM paints the whole screen.

The address space is 256 bytes, the lower half code and the upper half the
display file (8 lines of 16 characters). That is a small ZX81, but it is a
ZX81: the character set is Sinclair's, not ASCII, and the newline code `0x76`
is the `HALT` opcode, exactly as on the real machine.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Zx81

/-! ## The machine -/

/-- Size of the address space, in bytes. -/
def memSize : Nat := 256

/-- Where the display file starts. -/
def dfile : Nat := 128

/-- Characters per line of the display file. -/
def cols : Nat := 16

/-- Lines in the display file. -/
def rows : Nat := 8

/-- The processor state, and the memory it addresses. -/
structure Cpu where
  /-- The accumulator. -/
  a : Nat
  /-- The `B` register, used as the loop counter by `DJNZ`. -/
  b : Nat
  /-- The `C` register. -/
  c : Nat
  /-- The high byte of `HL`. -/
  h : Nat
  /-- The low byte of `HL`. -/
  l : Nat
  /-- The program counter. -/
  pc : Nat
  /-- The zero flag. -/
  zf : Bool
  /-- Whether the processor has executed `HALT`. -/
  halted : Bool
  /-- The memory. -/
  mem : List Nat
  deriving DecidableEq, Repr, Inhabited

/-- Reading a byte. -/
def rd (s : Cpu) (addr : Nat) : Nat := s.mem.getD (addr % memSize) 0

/-- Writing a byte. -/
def wr (s : Cpu) (addr v : Nat) : Cpu :=
  { s with mem := s.mem.set (addr % memSize) (v % 256) }

/-- The address in `HL`. -/
def hlAddr (s : Cpu) : Nat := (s.h * 256 + s.l) % memSize

/-- The program counter advanced by `k` bytes. -/
def bump (s : Cpu) (k : Nat) : Nat := (s.pc + k) % memSize

/-- A relative jump. Because the address space is exactly 256 bytes, adding the
displacement byte modulo `memSize` *is* adding the signed displacement. -/
def jrTarget (base e : Nat) : Nat := (base + e) % memSize

/-! ## Instructions -/

/-- The fragment of the Z80 the ROMs use. -/
inductive Z80
  /-- `NOP`. -/
  | nop
  /-- `LD A,n`. -/
  | ldAn (n : Nat)
  /-- `LD B,n`. -/
  | ldBn (n : Nat)
  /-- `LD C,n`. -/
  | ldCn (n : Nat)
  /-- `LD HL,nn`. -/
  | ldHLnn (lo hi : Nat)
  /-- `INC HL`. -/
  | incHL
  /-- `INC A`. -/
  | incA
  /-- `DEC A`. -/
  | decA
  /-- `INC B`. -/
  | incB
  /-- `DEC B`. -/
  | decB
  /-- `INC C`. -/
  | incC
  /-- `LD (HL),A`. -/
  | ldHLA
  /-- `LD A,(HL)`. -/
  | ldAHL
  /-- `LD A,C`. -/
  | ldAC
  /-- `ADD A,B`. -/
  | addAB
  /-- `ADD A,C`. -/
  | addAC
  /-- `SUB B`. -/
  | subB
  /-- `DJNZ e`. -/
  | djnz (e : Nat)
  /-- `JR e`. -/
  | jr (e : Nat)
  /-- `JR NZ,e`. -/
  | jrnz (e : Nat)
  /-- `JR Z,e`. -/
  | jrz (e : Nat)
  /-- `HALT`. On the ZX81 the same byte, `0x76`, is the newline character of
  the display file. -/
  | halt
  /-- Anything else. -/
  | unknown (op : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- Decoding one instruction: the opcode and the two bytes that follow it. -/
def decode (op n m : Nat) : Z80 :=
  if op = 0x00 then .nop
  else if op = 0x3E then .ldAn n
  else if op = 0x06 then .ldBn n
  else if op = 0x0E then .ldCn n
  else if op = 0x21 then .ldHLnn n m
  else if op = 0x23 then .incHL
  else if op = 0x3C then .incA
  else if op = 0x3D then .decA
  else if op = 0x04 then .incB
  else if op = 0x05 then .decB
  else if op = 0x0C then .incC
  else if op = 0x77 then .ldHLA
  else if op = 0x7E then .ldAHL
  else if op = 0x79 then .ldAC
  else if op = 0x80 then .addAB
  else if op = 0x81 then .addAC
  else if op = 0x90 then .subB
  else if op = 0x10 then .djnz n
  else if op = 0x18 then .jr n
  else if op = 0x20 then .jrnz n
  else if op = 0x28 then .jrz n
  else if op = 0x76 then .halt
  else .unknown op

/-- How many bytes an instruction occupies. -/
def Z80.size : Z80 → Nat
  | .ldAn _ | .ldBn _ | .ldCn _ | .djnz _ | .jr _ | .jrnz _ | .jrz _ => 2
  | .ldHLnn _ _ => 3
  | _ => 1

/-- Executing one decoded instruction. -/
def exec (s : Cpu) : Z80 → Cpu
  | .nop => { s with pc := bump s 1 }
  | .ldAn n => { s with a := n % 256, pc := bump s 2 }
  | .ldBn n => { s with b := n % 256, pc := bump s 2 }
  | .ldCn n => { s with c := n % 256, pc := bump s 2 }
  | .ldHLnn lo hi => { s with l := lo % 256, h := hi % 256, pc := bump s 3 }
  | .incHL =>
      let v := (s.h * 256 + s.l + 1) % 65536
      { s with h := v / 256, l := v % 256, pc := bump s 1 }
  | .incA => let v := (s.a + 1) % 256; { s with a := v, zf := v == 0, pc := bump s 1 }
  | .decA => let v := (s.a + 255) % 256; { s with a := v, zf := v == 0, pc := bump s 1 }
  | .incB => let v := (s.b + 1) % 256; { s with b := v, zf := v == 0, pc := bump s 1 }
  | .decB => let v := (s.b + 255) % 256; { s with b := v, zf := v == 0, pc := bump s 1 }
  | .incC => let v := (s.c + 1) % 256; { s with c := v, zf := v == 0, pc := bump s 1 }
  | .ldHLA => { (wr s (hlAddr s) s.a) with pc := bump s 1 }
  | .ldAHL => { s with a := rd s (hlAddr s), pc := bump s 1 }
  | .ldAC => { s with a := s.c % 256, pc := bump s 1 }
  | .addAB => let v := (s.a + s.b) % 256; { s with a := v, zf := v == 0, pc := bump s 1 }
  | .addAC => let v := (s.a + s.c) % 256; { s with a := v, zf := v == 0, pc := bump s 1 }
  | .subB => let v := (s.a + 256 - s.b % 256) % 256;
      { s with a := v, zf := v == 0, pc := bump s 1 }
  | .djnz e =>
      let v := (s.b + 255) % 256
      let target := if v = 0 then bump s 2 else jrTarget (bump s 2) e
      { s with b := v, zf := v == 0, pc := target }
  | .jr e => { s with pc := jrTarget (bump s 2) e }
  | .jrnz e => { s with pc := if s.zf then bump s 2 else jrTarget (bump s 2) e }
  | .jrz e => { s with pc := if s.zf then jrTarget (bump s 2) e else bump s 2 }
  | .halt => { s with halted := true }
  | .unknown _ => { s with halted := true }

/-- One processor cycle: fetch, decode, execute. A halted machine stays put. -/
def step (s : Cpu) : Cpu :=
  if s.halted then s
  else exec s (decode (rd s s.pc) (rd s (s.pc + 1)) (rd s (s.pc + 2)))

/-- Running `n` cycles. -/
def run : Nat → Cpu → Cpu
  | 0, s => s
  | n + 1, s => run n (step s)

@[simp] theorem run_zero (s : Cpu) : run 0 s = s := rfl

@[simp] theorem run_succ (n : Nat) (s : Cpu) : run (n + 1) s = run n (step s) := rfl

/-- Running `m + n` cycles is running `m` and then `n`. -/
theorem run_add (m n : Nat) (s : Cpu) : run (m + n) s = run n (run m s) := by
  induction m generalizing s with
  | zero => simp
  | succ m ih => simpa [Nat.succ_add] using ih (step s)

/-! ## Basic facts -/

/-- An opcode outside the fragment halts the machine instead of doing something
unspecified. -/
theorem exec_unknown (s : Cpu) (op : Nat) : (exec s (.unknown op)).halted = true := by
  simp [exec]

/-- **A halted machine is a fixed point.** -/
theorem step_halted (s : Cpu) (h : s.halted = true) : step s = s := by
  simp [step, h]

/-- A halted machine stays halted, however long it is run. -/
theorem run_halted (n : Nat) (s : Cpu) (h : s.halted = true) : run n s = s := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => rw [run_succ, step_halted s h, ih s h]

/-- Every instruction leaves the memory the same size. -/
theorem exec_mem_length (s : Cpu) (i : Z80) : (exec s i).mem.length = s.mem.length := by
  cases i <;> simp [exec, wr]

/-- **The memory never changes size.** -/
theorem step_mem_length (s : Cpu) : (step s).mem.length = s.mem.length := by
  unfold step
  split
  · rfl
  · exact exec_mem_length _ _

theorem run_mem_length (n : Nat) (s : Cpu) : (run n s).mem.length = s.mem.length := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => rw [run_succ, ih (step s), step_mem_length]

/-- Every byte of memory stays a byte. -/
theorem exec_mem_bytes (s : Cpu) (i : Z80) (h : ∀ x ∈ s.mem, x < 256) :
    ∀ x ∈ (exec s i).mem, x < 256 := by
  cases i <;> simp only [exec] <;> try exact h
  · -- `LD (HL),A`
    intro x hx
    rcases List.mem_or_eq_of_mem_set hx with hx' | hx'
    · exact h x hx'
    · exact hx' ▸ Nat.mod_lt _ (by decide)

/-- **Every byte of memory stays a byte.** -/
theorem step_mem_bytes (s : Cpu) (h : ∀ x ∈ s.mem, x < 256) :
    ∀ x ∈ (step s).mem, x < 256 := by
  unfold step
  split
  · exact h
  · exact exec_mem_bytes _ _ h

/-- The program counter never leaves the address space. -/
theorem exec_pc_lt (s : Cpu) (i : Z80) (h : s.pc < memSize) : (exec s i).pc < memSize := by
  have hm : 0 < memSize := by decide
  cases i <;>
    simp only [exec, bump, jrTarget] <;>
    first
      | exact h
      | exact Nat.mod_lt _ hm
      | (split <;> exact Nat.mod_lt _ hm)

/-- **The program counter never leaves the address space.** -/
theorem step_pc_lt (s : Cpu) (h : s.pc < memSize) : (step s).pc < memSize := by
  unfold step
  split
  · exact h
  · exact exec_pc_lt _ _ h

/-! ## The ZX81 character set

Sinclair's codes, not ASCII: `0` is a space, the punctuation runs from `0x0B`,
the digits from `0x1C` and the letters from `0x26`. -/

/-- The printable half of the ZX81 character set, code by code. -/
def charTable : List Char :=
  [' ', '▘', '▝', '▀', '▖', '▌', '▞', '▛', '░', '▒', '▓',
   '"', '£', '$', ':', '?', '(', ')', '>', '<', '=', '+', '-', '*', '/', ';', ',', '.',
   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
   'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

/-- The character a code prints as. -/
def charOf (n : Nat) : Char := charTable.getD n ' '

/-- The code of a character, if the ZX81 has one. -/
def codeOf (c : Char) : Option Nat := (List.range 64).find? (fun n => charOf n == c)

/-- The table has one entry per code of the printable half. -/
theorem charTable_length : charTable.length = 64 := by rfl

/-- **The character set round-trips.** A character that has a code prints from
that code as itself. -/
theorem charOf_codeOf (c : Char) (n : Nat) (h : codeOf c = some n) : charOf n = c := by
  have := List.find?_some h
  simpa using this

/-- Every code below 64 is the code of the character it prints. -/
theorem codeOf_charOf : ∀ n < 64, codeOf (charOf n) = some n := by decide

/-- Text as ZX81 codes; anything the machine cannot print becomes a space. -/
def encodeText (cs : List Char) : List Nat :=
  cs.map (fun c => (codeOf c).getD 0)

/-- ZX81 codes as text. -/
def decodeText (ns : List Nat) : List Char := ns.map charOf

/-- **Printable text round-trips through the character set.** -/
theorem decodeText_encodeText (cs : List Char) (h : ∀ c ∈ cs, (codeOf c).isSome) :
    decodeText (encodeText cs) = cs := by
  induction cs with
  | nil => rfl
  | cons c cs ih =>
      obtain ⟨n, hn⟩ := Option.isSome_iff_exists.1 (h c (List.mem_cons_self ..))
      have hcn := charOf_codeOf c n hn
      simp only [decodeText, encodeText, List.map_cons, hn, Option.getD_some, hcn,
        List.cons.injEq, true_and]
      exact ih (fun x hx => h x (List.mem_cons_of_mem _ hx))

/-! ## Booting a ROM -/

/-- A fresh machine with `rom` loaded at address zero and a blank screen. -/
def boot (rom : List Nat) : Cpu :=
  { a := 0, b := 0, c := 0, h := 0, l := 0, pc := 0, zf := false, halted := false,
    mem := (rom ++ List.replicate memSize 0).take memSize }

theorem boot_mem_length (rom : List Nat) : (boot rom).mem.length = memSize := by
  show ((rom ++ List.replicate memSize 0).take memSize).length = memSize
  rw [List.length_take, List.length_append, List.length_replicate]
  omega

/-- One line of the display file, as text. -/
def screenRow (s : Cpu) (r : Nat) : List Char :=
  decodeText ((List.range cols).map (fun i => rd s (dfile + r * cols + i)))

/-- The whole screen, as text. -/
def screen (s : Cpu) : List (List Char) :=
  (List.range rows).map (screenRow s)

/-! ## Three ROMs

Each is written the way a ZX81 program is written: bytes, poked into memory. -/

/-- Poke the seven characters of `NIXWARS` into the top line of the display
file: `LD HL,dfile`, then `LD A,code` / `LD (HL),A` / `INC HL` per character,
then `HALT`. -/
def bannerRom : List Nat :=
  [0x21, dfile, 0x00] ++
    (encodeText "NIXWARS".toList).flatMap (fun code => [0x3E, code, 0x77, 0x23]) ++
    [0x76]

/-- `LD A,0` / `LD B,10` / `ADD A,B` / `DJNZ` / `HALT`: the sum `10 + 9 + ⋯ + 1`.
The displacement `0xFD` is `-3`, back to the `ADD`. -/
def countRom : List Nat :=
  [0x3E, 0x00, 0x06, 0x0A, 0x80, 0x10, 0xFD, 0x76]

/-- Fill the whole display file with the checkerboard character (code 9):
`LD HL,dfile` / `LD A,9` / `LD B,128` / `LD (HL),A` / `INC HL` / `DJNZ` / `HALT`.
The displacement `0xFC` is `-4`. -/
def fillRom : List Nat :=
  [0x21, dfile, 0x00, 0x3E, 0x09, 0x06, 0x80, 0x77, 0x23, 0x10, 0xFC, 0x76]

/-- The ROMs the door can load. -/
def roms : List (List Nat) := [bannerRom, countRom, fillRom]

/-- The ROM with a given index; out of range, the banner. -/
def romOf (i : Nat) : List Nat := roms.getD i bannerRom

/-! ### What the ROMs do -/

/-- **The banner ROM prints `NIXWARS`.** After thirty cycles the machine has
halted and the top line of the display file reads `NIXWARS`. -/
theorem banner_prints :
    (run 30 (boot bannerRom)).halted = true ∧
      screenRow (run 30 (boot bannerRom)) 0 = "NIXWARS         ".toList := by
  refine ⟨rfl, rfl⟩

/-- **The counter ROM adds up to 55.** `10 + 9 + ⋯ + 1 = 55`, computed by a
`DJNZ` loop, with the loop counter run down to zero. -/
theorem count_sums :
    (run 40 (boot countRom)).halted = true ∧
      (run 40 (boot countRom)).a = 55 ∧
      (run 40 (boot countRom)).b = 0 := by
  refine ⟨rfl, rfl, rfl⟩

/-- **The fill ROM paints the screen.** After the loop every cell of the
display file holds the checkerboard character. -/
theorem fill_paints :
    (run 400 (boot fillRom)).halted = true ∧
      screen (run 400 (boot fillRom)) = List.replicate rows (List.replicate cols '▒') := by
  refine ⟨rfl, rfl⟩

end Zx81
end NixWars
