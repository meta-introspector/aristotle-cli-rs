import RequestProject.Gvcs.PipeSpec.Export

/-!
# Self-hosting: the fixed-point condition, stated and checked

The rig is a 3-D printer plus a loader arm.  Its own hydraulics — the circuit
that drives the arm — is a `PipeSpec`, and the rig's controller carries the
*description term* of that circuit (`Rig.selfDesc`, `Rig.selfCfg`).  The
self-hosting question is whether the spec generated from that self-description
is a spec the rig in front of you can actually build.

`Buildable` is that question made precise.  A rig `r` can build a spec `s` when

* `wellFormed` — `s` is a well-formed circuit (`wf`);
* `plateFits` — every cell of the printed half of `s`'s bill fits inside `r`'s
  build volume: the plate enumerated inside the envelope has exactly as many
  cells as the bill's items have volume, so nothing is lost off the edge;
* `tempLow`, `tempHigh` — `r`'s hot end will run at the commanded temperature;
* `stocked` — for every line of the **bill of sourced materials**, the total
  demand of that item is in `r`'s bins;
* `tolerance` — `r`'s positional tolerance is no coarser than the clearance the
  seal design needs;
* `pressure` — the circuit's working pressure is within what the printed bodies
  hold.

All seven fields are decidable, so for a concrete rig they are *checked*, not
assumed:
`rig_buildable` is proved by computation for `theRig` and `rigSpec`, and
`selfHosting` is the resulting fixed-point statement

> `Buildable theRig (emitPipeSpec theRig.selfCfg theRig.selfDesc)`

— the spec generated from the rig's own self-description is buildable on that
rig.  `generations_buildable` extends this along the generations: given the
realization assumption below and a fresh bill of sourced materials for each
copy, every generation can build the next.

## What is assumed, and where the proof stops

The theorem `generations_buildable` takes its physical content as *explicit
hypotheses*, not as proved facts:

* `hRealize` — **the realization assumption**.  Assembling the printed parts and
  the sourced items of a buildable spec, by the manifest, yields a machine with
  the same parameters as its parent: same build volume, same hot end, same
  positional tolerance, same pressure rating, carrying the same
  self-description.  Nothing in Lean can establish this; it is a claim about
  plastic, screws and calibration.
* `hKit` — **the bootstrap assumption**.  Each copy is handed a fresh load of
  sourced materials covering the bill.  The BOSM is not self-replicating and is
  never claimed to be: motors, cartridges, gauges, O-rings and fasteners come
  from outside, and `bosmSteps` is the human's shopping list.

Everything else — that the generated spec is well-formed, that the plate fits,
that the bins as loaded cover the bill, that the toolpath prints the plate
exactly, and that the manifest joins every port exactly once — is proved.

The transcription boundary of `RequestProject/PipeSpec/Export.lean` still
applies: the G-code text, the coarse cell geometry, and the physics of a printed
pressure boundary are outside what is verified here.
-/

namespace LifeTrac
namespace PipeSpec

open LifeTrac.Printer
open LifeTrac.Voxel

set_option maxRecDepth 1000000
set_option maxHeartbeats 4000000

/-! ## A rig -/

/-- A fabrication rig: a printer, a loader arm's stock of bought-in parts, the
tolerances it holds, and the description of its own pipe circuit. -/
structure Rig where
  /-- The printer. -/
  printer : Machine
  /-- The temperature it prints at. -/
  temp : ℤ
  /-- The loaded bins: item name against how many are in stock. -/
  bins : List (String × ℕ)
  /-- The printer's positional tolerance, in micrometres. -/
  tolMicron : ℕ
  /-- The clearance the seal design allows, in micrometres. -/
  clearanceMicron : ℕ
  /-- What the printed bodies hold, in bar. -/
  maxPressureBar : ℕ
  /-- What the circuit runs at, in bar. -/
  workingBar : ℕ
  /-- The plumbing configuration of its own circuit. -/
  selfCfg : Cfg
  /-- The description term of its own circuit. -/
  selfDesc : Desc

/-- How many of an item the rig has in its bins. -/
def Rig.stock (r : Rig) (name : String) : ℕ := (r.bins.lookup name).getD 0

/-- How many of an item a spec's bill of sourced materials calls for in total. -/
def demand (s : Spec) (name : String) : ℕ :=
  (((bosm s).filter fun p => p.name == name).map Part.qty).sum

/-- The bins cover the bill of sourced materials. -/
def binsCover (r : Rig) (s : Spec) : Bool :=
  (bosm s).all fun p => decide (demand s p.name ≤ r.stock p.name)

/-- **The fixed-point condition.**  What has to be true of a rig and a spec for
the rig to build the spec. -/
structure Buildable (r : Rig) (s : Spec) : Prop where
  /-- The circuit is well-formed. -/
  wellFormed : wf s = true
  /-- The whole plate of printed parts fits inside the build volume. -/
  plateFits : ((enum r.printer.env (plate s)).length : ℤ) = printedVolume s
  /-- The hot end will reach the commanded temperature. -/
  tempLow : r.printer.minTemp ≤ r.temp
  /-- And survive it. -/
  tempHigh : r.temp ≤ r.printer.maxTemp
  /-- The bins cover the bill of sourced materials. -/
  stocked : binsCover r s = true
  /-- The printer is no coarser than the seals need. -/
  tolerance : r.tolMicron ≤ r.clearanceMicron
  /-- The circuit runs below what the printed bodies hold. -/
  pressure : r.workingBar ≤ r.maxPressureBar

/-- A buildable spec prints: the job runs without a fault and leaves exactly the
plate of printed parts on the bed, at one cell of filament per cell of part. -/
theorem Buildable.prints {r : Rig} {s : Spec} (h : Buildable r s) (a : ℤ) :
    (run r.printer (toolpath r.printer r.temp s) (State.init a)).fault = none ∧
      (∀ v, v ∈ (run r.printer (toolpath r.printer r.temp s) (State.init a)).deposited ↔
        (plate s v = true ∧ r.printer.env.mem v = true)) ∧
      ((run r.printer (toolpath r.printer r.temp s) (State.init a)).filament : ℤ) =
        printedVolume s := by
  obtain ⟨h1, h2, h3⟩ := toolpath_prints r.printer s r.temp a h.tempLow h.tempHigh
  exact ⟨h1, h2, by rw [h3]; exact h.plateFits⟩

/-- A buildable spec assembles: the loader arm makes one joint at every port of
the circuit, none left open and none joined twice. -/
theorem Buildable.assembles {r : Rig} {s : Spec} (h : Buildable r s) :
    ((manifest s).joints.map JointOp.port).Perm s.allPorts :=
  joints_ports_perm h.wellFormed

/-! ## The rig's own circuit -/

/-- The rig's hydraulics run at 8 mm bore in printed nylon, with 300 mm
segments. -/
def rigCfg : Cfg := ⟨8, .nylon, 300⟩

/-- The rig's own circuit: a pump feeding a four-way manifold that serves the
three arm axes through valves, plus a pressure gauge. -/
def rigDesc : Desc := .pump (.manifold [.valve .sump, .valve .sump, .valve .sump, .gauge])

/-- The rig's own specification, generated from its self-description. -/
def rigSpec : Spec := emitPipeSpec rigCfg rigDesc

/-- The rig's printer: a 220 × 320 × 30 mm build volume at 10 mm to the cell. -/
def rigPrinter : Machine :=
  { env := { sx := 22, sy := 32, sz := 3 }, minTemp := 180, maxTemp := 260, homeTicks := 30 }

/-- One load of sourced materials: the bins a human fills before a build. -/
def rigKit : List (String × ℕ) :=
  [ ("reservoir, 5 L", 4), ("gear pump", 1), ("shaft coupling", 1), ("M5 cap screw", 24),
    ("O-ring", 24), ("valve cartridge", 3), ("valve spring", 3), ("pressure gauge", 1),
    ("PTFE tape, 1 m", 2), ("anaerobic adhesive", 1), ("tube or hose, cut to length", 4) ]

/-- The rig in front of you: printing at 205 °C, holding 0.1 mm, sealing at
0.15 mm clearance, bodies rated to 60 bar against a 40 bar circuit, carrying its
own description. -/
def theRig : Rig :=
  { printer := rigPrinter, temp := 205, bins := rigKit, tolMicron := 100,
    clearanceMicron := 150, maxPressureBar := 60, workingBar := 40,
    selfCfg := rigCfg, selfDesc := rigDesc }

/-! ## What the rig's own circuit comes to -/

theorem rig_wf : wf rigSpec = true := emit_wf _ _

theorem rig_nodes : rigSpec.nodes.length = 10 := by decide

theorem rig_edges : rigSpec.edges.length = 9 := by decide

theorem rig_ports : rigSpec.allPorts.length = 18 := by decide

theorem rig_bill_lines : (allParts rigSpec).length = 74 := by decide

/-- Thirty-seven printed items against fifty-six bought in: the rig makes a
little over two fifths of its own hydraulics by item count. -/
theorem rig_printed_items : partCount (printedParts rigSpec) = 37 := by decide

theorem rig_sourced_items : partCount (bosm rigSpec) = 56 := by decide

theorem rig_printed_volume : printedVolume rigSpec = 188 := by decide

/-! ## The rig's own print job -/

/-- All 188 cells are on the bed of the rig's own printer: the layout loses
nothing to the edge of the build volume. -/
theorem rig_nothing_clipped :
    ((enum rigPrinter.env (plate rigSpec)).length : ℤ) = printedVolume rigSpec := by decide

theorem rig_job_length : (toolpath rigPrinter 205 rigSpec).length = 190 := by decide

theorem rig_pathCost : pathCost (0, 0, 0) (enum rigPrinter.env (plate rigSpec)) = 694 := by decide

/-- **The rig's own printed parts print.**  From a cold bed at 20 °C, heating to
205 °C, the job runs without a fault; what is left on the bed is exactly the
plate the rig's own specification calls for; it consumes 188 cells of filament
and the clock reads 909 ticks — thirty to home, 185 to heat and 694 of
printing. -/
theorem rig_prints :
    (run rigPrinter (toolpath rigPrinter 205 rigSpec) (State.init 20)).fault = none ∧
      (∀ v, v ∈ (run rigPrinter (toolpath rigPrinter 205 rigSpec) (State.init 20)).deposited ↔
        (plate rigSpec v = true ∧ rigPrinter.env.mem v = true)) ∧
      (run rigPrinter (toolpath rigPrinter 205 rigSpec) (State.init 20)).filament = 188 ∧
      (run rigPrinter (toolpath rigPrinter 205 rigSpec) (State.init 20)).clock = 909 := by
  obtain ⟨h1, h2, h3, h4, h5⟩ :=
    job_prints rigPrinter (plate rigSpec) 205 20 (plate_supported _) (by decide) (by decide)
  refine ⟨h1, h2, ?_, ?_⟩
  · rw [toolpath, h3]; decide
  · rw [toolpath, h5, rig_pathCost]; rfl

/-! ## The fixed point -/

/-- The generator applied to the rig's own self-description gives the rig's own
specification. -/
theorem rig_fixed_point : emitPipeSpec theRig.selfCfg theRig.selfDesc = rigSpec := rfl

/-- **The rig can build its own circuit.**  All seven conditions are checked by
computation for the concrete rig. -/
theorem rig_buildable : Buildable theRig rigSpec where
  wellFormed := rig_wf
  plateFits := by decide
  tempLow := by decide
  tempHigh := by decide
  stocked := by decide
  tolerance := by decide
  pressure := by decide

/-- **Self-hosting.**  The spec the generator produces from the rig's own
self-description is buildable on that rig. -/
theorem selfHosting : Buildable theRig (emitPipeSpec theRig.selfCfg theRig.selfDesc) :=
  rig_fixed_point ▸ rig_buildable

/-! ## Along the generations -/

/-- The machine parameters a copy has to inherit for the loop to close. -/
def Rig.params (r : Rig) :
    Machine × ℤ × ℕ × ℕ × ℕ × ℕ × Cfg × Desc :=
  (r.printer, r.temp, r.tolMicron, r.clearanceMicron, r.maxPressureBar, r.workingBar,
    r.selfCfg, r.selfDesc)

/-- Buildability depends on a rig only through its parameters and its bins. -/
theorem buildable_of_params {r q : Rig} {s : Spec} (hp : q.params = r.params)
    (hb : Buildable r s) (hstock : binsCover q s = true) : Buildable q s := by
  simp only [Rig.params, Prod.mk.injEq] at hp
  obtain ⟨hprinter, htemp, htol, hclear, hmax, hwork, -, -⟩ := hp
  exact
    { wellFormed := hb.wellFormed
      plateFits := by rw [hprinter]; exact hb.plateFits
      tempLow := by rw [hprinter, htemp]; exact hb.tempLow
      tempHigh := by rw [hprinter, htemp]; exact hb.tempHigh
      stocked := hstock
      tolerance := by rw [htol, hclear]; exact hb.tolerance
      pressure := by rw [hmax, hwork]; exact hb.pressure }

/-- **The loop closes.**  Suppose building a rig's own spec on it yields a copy
with the same machine parameters (`hRealize` — the realization assumption), and
suppose every copy is handed a fresh load of sourced materials covering the bill
(`hKit` — the bootstrap assumption).  Then every generation can build the next,
for ever. -/
theorem generations_buildable (build : Rig → Rig)
    (hRealize : ∀ q, Buildable q rigSpec → (build q).params = q.params)
    (hKit : ∀ q, binsCover (build q) rigSpec = true)
    (r : Rig) (hr : Buildable r rigSpec) : ∀ n, Buildable (build^[n] r) rigSpec := by
  intro n
  induction n with
  | zero => simpa using hr
  | succ n ih =>
      rw [Function.iterate_succ_apply']
      exact buildable_of_params (hRealize _ ih) ih (hKit _)

/-! ## The human bootstrap: a finite, explicit list -/

/-- The calibration checkpoints a human signs off during a build. -/
def calibrationCheckpoints : List String :=
  [ "C1. Printer axes home and the bed probes level within 0.1 mm.",
    "C2. First layer of the plate is down and adhering across all rows.",
    "C3. Extruder flow check: filament consumed matches the 188 cells the job commands.",
    "C4. Arm zero: the jig fiducial is picked up within 0.1 mm.",
    "C5. Bin registration: each loaded bin answers at its recorded pose.",
    "C6. Dry-fit of the manifold before any seal is fitted.",
    "C7. Torque check on the 24 threaded joints.",
    "C8. Pressure test of the finished circuit at 80 bar, twice working pressure." ]

theorem calibrationCheckpoints_count : calibrationCheckpoints.length = 8 := by decide

/-- **The bootstrap.**  Every human action needed to go from an empty workshop
to a first working copy.  Twelve steps; nothing else is required of a human, and
the list is finite and explicit by construction. -/
def bootstrapSteps : List String :=
  [ "B1.  Buy and assemble, by hand, a bootstrap 3-D printer (any printer that " ++
      "meets rigPrinter's build volume, hot-end range and 0.1 mm tolerance).",
    "B2.  Buy and assemble, by hand, a bootstrap loader arm able to execute a " ++
      "pick-and-place manifest over the bins and the jig.",
    "B3.  Load a spool of nylon filament into the printer.",
    "B4.  Fill the bins of rigKit: 4 reservoirs, 1 gear pump, 1 shaft coupling, " ++
      "24 M5 cap screws, 24 O-rings, 3 valve cartridges, 3 valve springs, " ++
      "1 pressure gauge, 2 rolls of PTFE tape, 1 bottle of anaerobic adhesive, " ++
      "4 lengths of hose.",
    "B5.  Load the self-description (rigCfg, rigDesc) onto the control system.",
    "B6.  Start the build; the controller emits rigSpec, its G-code and its manifest.",
    "B7.  Sign off calibration checkpoints C1-C3 during the print.",
    "B8.  Sign off calibration checkpoints C4-C5 before the arm's first pick.",
    "B9.  Sign off calibration checkpoints C6-C7 during assembly.",
    "B10. Sign off calibration checkpoint C8: pressure-test the finished circuit.",
    "B11. Commission the copy: hand it a fresh rigKit load and a spool, and have " ++
      "it print and assemble one further circuit unaided.",
    "B12. Record the copy's own self-description on its controller and release it." ]

theorem bootstrapSteps_count : bootstrapSteps.length = 12 := by decide

/-- The items a human must source from outside for one generation.  This list is
never claimed to be self-replicating: it is the boundary of the loop. -/
def bosmSteps : List String := rigKit.map fun (name, n) => toString n ++ " x " ++ name

theorem bosmSteps_count : bosmSteps.length = 11 := by decide

/-- The claims this development does *not* prove, recorded so the reader does
not have to infer them from silence. -/
def statedAssumptions : List String :=
  [ "A1. Firmware fidelity: a physical printer executes the emitted G-code the " ++
      "way Printer.Machine.step interprets the instruction list.",
    "A2. Geometry: partBox is a coarse cell-grid stand-in; that a box of those " ++
      "dimensions is a working manifold body is a design claim, not a theorem.",
    "A3. Realization: assembling a buildable spec yields a machine with the same " ++
      "parameters as its parent (the hypothesis hRealize).",
    "A4. Fresh sourced materials: every generation is handed a bill of sourced " ++
      "materials from outside (the hypothesis hKit).",
    "A5. Materials: that printed nylon bodies hold 60 bar, that threads grip and " ++
      "that adhesive bonds are material claims entering only as the numbers in " ++
      "theRig." ]

theorem statedAssumptions_count : statedAssumptions.length = 5 := by decide

end PipeSpec
end LifeTrac
