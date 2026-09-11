import RequestProject.Nix.NixWars.Machine
import RequestProject.Nix.NixWars.Zx81

/-!
# The ZX81 as a door on the board

The emulator of `Zx81.lean` has a 256-byte memory, which is far too much state
to carry in a URL fragment. It does not have to be carried: the machine is
deterministic and starts from a known ROM, so the whole of it is determined by
two numbers — *which* ROM is in the machine and *how many* processor cycles
have run. That pair is the door's state, and `machine` is the function that
turns it back into a ZX81.

The theorems below say that this really is the ZX81: pressing the door's
`step` command advances the emulated machine by exactly one Z80 cycle
(`machine_step`), `fast` by exactly that many (`machine_fast`), and `reset`
puts a freshly booted machine back (`machine_reset`). So the ZX81 rides the
same five wires as the games, in two numbers, and it is compiled into the same
WebAssembly module by the same compiler (`tapeStepIR_correct`).
-/

namespace NixWars

/-- The state of the ZX81 door: a ROM and a cycle count. -/
structure Tape where
  /-- Which ROM is loaded. -/
  rom : Nat
  /-- How many processor cycles have been run since it was loaded. -/
  cycles : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the ZX81 door. -/
inductive TapeCmd
  /-- Advance one processor cycle. -/
  | step
  /-- Advance `n` processor cycles. -/
  | fast (n : Nat)
  /-- Restart the loaded ROM. -/
  | reset
  /-- Load ROM `i` and restart. -/
  | load (i : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- The transition function of the door. -/
def tapeStep (s : Tape) : TapeCmd → Tape
  | .step => { s with cycles := s.cycles + 1 }
  | .fast n => { s with cycles := s.cycles + n }
  | .reset => { s with cycles := 0 }
  | .load i => { rom := i, cycles := 0 }

/-- **The ZX81 that a door state denotes.** -/
def machine (s : Tape) : Zx81.Cpu :=
  Zx81.run s.cycles (Zx81.boot (Zx81.romOf s.rom))

/-- The door state as a payload. -/
def tapeSerialize (s : Tape) : List Nat := [s.rom, s.cycles]

/-- Reading a door state back from a payload. -/
def tapeDeserialize : List Nat → Option Tape
  | [rom, cycles] => some { rom := rom, cycles := cycles }
  | _ => none

theorem tapeDeserialize_tapeSerialize (s : Tape) :
    tapeDeserialize (tapeSerialize s) = some s := by
  cases s
  simp [tapeSerialize, tapeDeserialize]

/-- **The ZX81 as a door game.** -/
def zx81Door : DoorGame where
  State := Tape
  Cmd := TapeCmd
  step := tapeStep
  serialize := tapeSerialize
  deserialize := tapeDeserialize
  deserialize_serialize := tapeDeserialize_tapeSerialize

/-- The machine the page starts with: the banner ROM, not yet run. -/
def initialTape : Tape := { rom := 0, cycles := 0 }

/-! ### The door really is the machine -/

/-- **One command, one Z80 cycle.** -/
theorem machine_step (s : Tape) : machine (tapeStep s .step) = Zx81.step (machine s) := by
  show Zx81.run (s.cycles + 1) _ = _
  rw [Zx81.run_add s.cycles 1]
  rfl

/-- **Fast-forwarding is running the machine.** -/
theorem machine_fast (s : Tape) (n : Nat) :
    machine (tapeStep s (.fast n)) = Zx81.run n (machine s) := by
  show Zx81.run (s.cycles + n) _ = _
  rw [Zx81.run_add s.cycles n]
  rfl

/-- Resetting boots the loaded ROM again. -/
theorem machine_reset (s : Tape) : machine (tapeStep s .reset) = Zx81.boot (Zx81.romOf s.rom) :=
  rfl

/-- Loading boots the ROM that was asked for. -/
theorem machine_load (s : Tape) (i : Nat) :
    machine (tapeStep s (.load i)) = Zx81.boot (Zx81.romOf i) := rfl

/-- Once the emulated machine has halted, further commands of the door change
nothing about it. -/
theorem machine_halted (s : Tape) (h : (machine s).halted = true) (c : TapeCmd)
    (hc : c = .step ∨ ∃ n, c = .fast n) : machine (tapeStep s c) = machine s := by
  rcases hc with rfl | ⟨n, rfl⟩
  · rw [machine_step, Zx81.step_halted _ h]
  · rw [machine_fast, Zx81.run_halted _ _ h]

/-- The memory of the emulated machine is always the full address space. -/
theorem machine_mem_length (s : Tape) : (machine s).mem.length = Zx81.memSize := by
  rw [machine, Zx81.run_mem_length, Zx81.boot_mem_length]

/-- **The banner ROM, played through the door.** Thirty presses of `step` from
a fresh session put `NIXWARS` on the ZX81's screen. -/
theorem zx81_door_banner :
    Zx81.screenRow (machine (zx81Door.run initialTape (List.replicate 30 TapeCmd.step))) 0
      = "NIXWARS         ".toList := by
  have h : zx81Door.run initialTape (List.replicate 30 TapeCmd.step)
      = { rom := 0, cycles := 30 } := by rfl
  rw [h]
  exact Zx81.banner_prints.2

/-! ### The compiled table -/

/-- The commands of the ZX81 door, as the page names them. -/
inductive TapeTag
  | step
  | fast
  | reset
  | load
  deriving DecidableEq, Repr, Inhabited

/-- A tag plus the numeric argument is a command. -/
def TapeTag.cmd : TapeTag → Nat → TapeCmd
  | .step, _ => .step
  | .fast, n => .fast n
  | .reset, _ => .reset
  | .load, i => .load i

/-- The state vector is `[rom, cycles]`. -/
def tapeFieldNames : List String := ["rom", "cycles"]

/-- The compiled transition table of the ZX81 door. -/
def tapeStepIR : TapeTag → List Expr
  | .step => [.fld 0, .add (.fld 1) (.lit 1)]
  | .fast => [.fld 0, .add (.fld 1) .arg]
  | .reset => [.fld 0, .lit 0]
  | .load => [.arg, .lit 0]

/-- **The compiled table is the ZX81 door.** -/
theorem tapeStepIR_correct (tag : TapeTag) (s : Tape) (v : Nat) :
    runIR (tapeStepIR tag) (tapeSerialize s) v = tapeSerialize (tapeStep s (tag.cmd v)) := by
  cases tag <;>
    simp [runIR, tapeStepIR, Expr.eval, tapeSerialize, tapeStep, TapeTag.cmd]

/-- The commands with the names the page uses. -/
def tapeTagsWithNames : List (String × TapeTag) :=
  [("step", .step), ("fast", .fast), ("reset", .reset), ("load", .load)]

/-! ### The ZX81 inherits the whole BBS -/

/-- A ZX81 session as a URL. -/
def zx81Url (s : GameSession zx81Door) : String := transmit urlTransport s

theorem zx81Url_roundtrip (s : GameSession zx81Door) :
    receive zx81Door urlTransport (zx81Url s) = some s :=
  receive_transmit urlTransport s

/-- The ZX81 is stateless too: the whole emulated machine travels as two
numbers, and playing over the wire is playing locally. -/
theorem zx81_play_eq (s : GameSession zx81Door) (cs : List zx81Door.Cmd) :
    runOverWire (g := zx81Door) urlTransport (zx81Url s) cs
      = some (zx81Url { s with state := zx81Door.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
