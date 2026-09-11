import RequestProject.Nix.NixWars.Monster.FlightMachine
import RequestProject.Nix.NixWars.WasmBinary
import RequestProject.Nix.NixWars.WasmDecode

/-!
# The voxel flight, in WebAssembly

`Monster/FlightMachine.lean` compiles the flight into the expression language of
`Machine.lean`.  This file takes the last step down: the same table is compiled
into the wasm-style stack machine of `Wasm.lean`, assembled into a module, and
serialized to the bytes of `www/fly.wasm`, with a proof that calling an
exported function of that module computes exactly what the flight's own
transition function computes.

Two things are new here, and both come from the wrap.

* The board's doors run inside `Wasm.B = 2 ^ 30`, a bound wide enough that
  nothing they compute can reach `2 ^ 32`.  The flight multiplies — a modulo is
  a multiplication, and the flight is the first door that needs one whose
  factors are both unknown when the table is emitted — so it runs inside
  `flyBound = 2 ^ 16 - 1` instead, where a product of two values still fits in
  an `i32`.  `callExport_runIR_bound` is the board's `callExport_runIR` with the
  bound left free, which is all that is needed to reuse the compiler and its
  correctness proof unchanged.
* The table itself is written to keep that bound reachable: the throttle is
  reduced into the axis once and the move is then a conditional subtraction, so
  no modulo is ever nested inside another (`moveIR`).  `bnd_flightStepIR`
  checks, expression by expression, that nothing in the emitted table can
  overflow at `flyBound`.

The result, `wasm_fly_step_correct`, is the flight's analogue of the board's
`wasm_step_correct`: the module *is* the flight, under the 32-bit semantics,
wrapping arithmetic and all.
-/

set_option maxRecDepth 100000

namespace NixWars

namespace Monster

open Wasm

/-! ## Compiling a table under a bound of one's own -/

/-- **A compiled command is its program**, under any bound the values keep to.
This is `Wasm.callExport_runIR` with the bound left free: the board fixes it at
`2 ^ 30`, the flight needs a smaller one because it multiplies. -/
theorem callExport_runIR_bound {M : Module} (hM : HasHelpers M) {f : Nat} {fn : Func}
    {prog : List Expr} (hfn : M[f]? = some fn) (hbody : fn.body = compileProg prog)
    (hres : fn.results = prog.length) (fields : List Nat) (arg : Nat)
    (harity : fn.arity = fields.length + 1) {bound : Nat} (hbW : bound < W)
    (hf : ∀ x ∈ fields, x ≤ bound) (ha : arg ≤ bound)
    (hbnd : ∀ e ∈ prog, e.bnd bound < W) :
    callExport M f (arg :: fields) = some (runIR prog fields arg) := by
  have hfW : ∀ x ∈ fields, x < W := fun x hx => lt_of_le_of_lt (hf x hx) hbW
  have haW : arg < W := lt_of_le_of_lt ha hbW
  rw [callExport_compileProg hM hfn hbody hres fields arg harity hfW haW]
  unfold runIR
  exact congrArg some (List.map_congr_left fun e he =>
    Expr.eval32_eq_eval bound fields arg hf ha e (hbnd e he))

/-! ## The module -/

/-- The bound the flight keeps its values under: everything in the state vector,
and the axis named by `AIM`, is at most `2 ^ 16 - 1`.  Every field but the
command counter is small by construction; the counter is the one that has to be
assumed, and `2 ^ 16` commands is a long session. -/
def flyBound : Nat := 65535

theorem flyBound_lt_W : flyBound < W := by decide

/-- The flight as compiled code: twenty-two fields, one program per command. -/
def flyIR : DoorIR :=
  ⟨"fly", 22, flyTagsWithNames.map (fun p => (p.1, flightStepIR p.2))⟩

/-- **The module `www/fly.wasm` ships**: the two arithmetic helpers and the
eight commands of the flight. -/
def flyModule : Module := boardModule [flyIR]

theorem flyModule_hasHelpers : HasHelpers flyModule := boardModule_hasHelpers [flyIR]

/-- Index of a command in the module. -/
def flyTagIndex : FlyTag → Nat
  | .aim => 2
  | .flip => 3
  | .thrust => 4
  | .brake => 5
  | .fly => 6
  | .dock => 7
  | .descend => 8
  | .ascend => 9

/-- Where each command sits in the module. -/
theorem flyModule_func (tag : FlyTag) :
    ∃ nm, flyModule[flyTagIndex tag]? = some ⟨nm, 23, 22, compileProg (flightStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

theorem length_flightStepIR (tag : FlyTag) : (flightStepIR tag).length = 22 := by
  cases tag <;> rfl

/-- Nothing in the emitted table can overflow an `i32` while the values stay
inside `flyBound`. -/
theorem bnd_flightStepIR (tag : FlyTag) : ∀ e ∈ flightStepIR tag, e.bnd flyBound < W := by
  cases tag <;> decide

/-- Every field of a serialized ship is inside the bound as soon as the tank
and the command counter are: the level, the coordinates, the nose axis, the
direction, the throttle and the clamp are all small by construction. -/
theorem flightSerialize_le_bound {s : Ship} (h : Ok s) (hfuel : s.fuel ≤ flyBound)
    (hturn : s.turn ≤ flyBound) : ∀ x ∈ flightSerialize s, x ≤ flyBound := by
  have hdim : s.dim ≤ flyBound := by have := h.dim_le; simp only [flyBound]; omega
  have hax : s.ax ≤ flyBound := by
    rcases h.ax_ok with hax | hax
    · have := h.dim_le; simp only [flyBound]; omega
    · simp [hax, flyBound]
  have hsp : s.speed ≤ flyBound := by
    have := h.speed_le
    simp only [maxThrottle, frontierMaxSpeed] at this
    simp only [flyBound]; omega
  have hcoord : ∀ i, s.pos.getD i 0 ≤ flyBound := by
    intro i
    have h1 : s.pos.getD i 0 < axisLen s.dim i := coord_lt_axisLen h i
    have h2 : axisLen s.dim i ≤ 71 := by
      by_cases hi : i < s.dim
      · rw [axisLen_eq hi]
        have hi15 : i < 15 := lt_of_lt_of_le hi h.dim_le
        interval_cases i <;> decide
      · have : axisLen s.dim i = 1 :=
          List.getD_eq_default _ _ (by rw [level_length h.dim_le]; omega)
        omega
    simp only [flyBound]; omega
  intro x hx
  simp only [flightSerialize, axisSlots, List.map_cons, List.map_nil, List.cons_append,
    List.nil_append, List.mem_cons, List.not_mem_nil, or_false] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
      rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact hdim
  · exact hcoord 0
  · exact hcoord 1
  · exact hcoord 2
  · exact hcoord 3
  · exact hcoord 4
  · exact hcoord 5
  · exact hcoord 6
  · exact hcoord 7
  · exact hcoord 8
  · exact hcoord 9
  · exact hcoord 10
  · exact hcoord 11
  · exact hcoord 12
  · exact hcoord 13
  · exact hcoord 14
  · exact hax
  · cases s.fwd <;> simp [flyBound]
  · exact hsp
  · exact hfuel
  · cases s.docked <;> simp [flyBound]
  · exact hturn

/-- **The module is the flight.**  Calling the exported function of a command,
on the serialized ship and the command's numeric argument, returns exactly the
serialized successor state — under the 32-bit stack-machine semantics, wrapping
arithmetic included. -/
theorem wasm_fly_step_correct (tag : FlyTag) {s : Ship} (h : Ok s) (v : Nat)
    (hs : ∀ x ∈ flightSerialize s, x ≤ flyBound) (hv : v ≤ flyBound) :
    callExport flyModule (flyTagIndex tag) (v :: flightSerialize s)
      = some (flightSerialize (step s (tag.cmd v))) := by
  obtain ⟨nm, hfn⟩ := flyModule_func tag
  rw [callExport_runIR_bound flyModule_hasHelpers hfn rfl (by simp [length_flightStepIR])
    (flightSerialize s) v rfl flyBound_lt_W hs hv (bnd_flightStepIR tag)]
  rw [flightStepIR_correct tag h v]

/-! ## The bytes -/

/-- **The emitted `www/fly.wasm`.** -/
def flyWasmBytes : List UInt8 := encodeModule flyModule

/-- Every export name of the flight's module is ASCII. -/
theorem flyModule_names_ascii : ∀ fn ∈ flyModule, ∀ c ∈ fn.name.toList, c.toNat < 128 := by
  have h : flyModule.all (fun fn => fn.name.toList.all (fun c => decide (c.toNat < 128))) = true :=
    rfl
  simpa using h

/-- **`www/fly.wasm` is the flight's module.**  The concrete bytes written to
disk and embedded in `www/fly.html` decode — by the independent decoder of
`WasmDecode.lean` — to exactly the module `wasm_fly_step_correct` is about. -/
theorem decodeModule_flyWasmBytes : decodeModule flyWasmBytes = some flyModule :=
  decodeModule_encodeModule flyModule flyModule_names_ascii (by decide)

/-- The bytes as a JavaScript array literal, for embedding in the page. -/
def flyWasmBytesJs : String :=
  "[" ++ String.intercalate "," (flyWasmBytes.map (fun b => toString b.toNat)) ++ "]"

/-- Write the module next to the page. -/
def writeFlyWasm : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeBinFile "www/fly.wasm" ⟨flyWasmBytes.toArray⟩

#eval writeFlyWasm

end Monster

end NixWars
