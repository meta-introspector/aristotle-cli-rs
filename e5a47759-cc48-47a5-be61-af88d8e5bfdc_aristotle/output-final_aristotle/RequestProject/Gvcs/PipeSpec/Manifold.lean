import RequestProject.Gvcs.PipeSpec.Export

/-!
# Milestone: one valve manifold, end to end

This file is the first-milestone checkpoint asked for before any closed-loop
claim: a single hand-picked circuit — a pump feeding a three-way manifold that
serves a valve to the sump, a pressure gauge, and a straight return — taken all
the way from a description term to a print job and a robot program, with every
number below *computed* from the model rather than asserted.

The circuit (`valveManifold`, plumbed at 10 mm bore in printed PETG with 250 mm
segments):

```
supply tank ──▶ pump ──▶ manifold ┬─▶ valve ──▶ sump
                                  ├─▶ gauge
                                  └─▶ sump
```

The dry-run report:

* **Structure** — 7 components, 6 pipe segments, 12 ports; well-formed by
  `emit_wf`, so every port is joined exactly once (`valveManifold_ports_twice`).
* **Bill** — 49 lines, 61 individual items; **25 printed, 36 sourced**, so the
  rig makes 25/61 of the item count itself, a shade over two fifths, and the
  other 36 items are the bill of sourced materials (`valveManifold_bosm_lines`).
* **Print** — the printed items occupy 124 cells of plastic; the plate laid out
  on a 22 × 24 × 8 cell bed contains all 124 of them
  (`valveManifold_nothing_clipped`), and the job is 126 instructions long and
  runs to completion without a fault at 205 °C from a cold start, taking 644
  ticks (`valveManifold_prints`).
* **Assembly** — the manifest is 49 pick-and-place rows and 12 fastening
  operations, two per segment, and those 12 operations address the 12 ports of
  the circuit exactly once each (`valveManifold_joints_cover_ports`).
* **Human steps for this sub-part alone** — six, enumerated in
  `manifoldHumanSteps`; the full closed-loop list is in
  `RequestProject/PipeSpec/SelfHost.lean`.
-/

namespace LifeTrac
namespace PipeSpec

open LifeTrac.Printer
open LifeTrac.Voxel

set_option maxRecDepth 1000000
set_option maxHeartbeats 2000000

/-! ## The circuit -/

/-- The plumbing configuration of the demonstration circuit: 10 mm bore, printed
PETG pipe, 250 mm segments. -/
def demoCfg : Cfg := ⟨10, .petg, 250⟩

/-- The description term: a pump feeding a three-way manifold, which serves a
valve to the sump, a pressure gauge, and a straight return. -/
def valveManifold : Desc := .pump (.manifold [.valve .sump, .gauge, .sump])

/-- The generated specification. -/
def valveManifoldSpec : Spec := emitPipeSpec demoCfg valveManifold

/-- It is well-formed, by the general theorem about the generator. -/
theorem valveManifold_wf : wf valveManifoldSpec = true := emit_wf _ _

/-! ## Structure -/

theorem valveManifold_nodes : valveManifoldSpec.nodes.length = 7 := by decide

theorem valveManifold_edges : valveManifoldSpec.edges.length = 6 := by decide

theorem valveManifold_labels :
    valveManifoldSpec.nodes.map Node.label =
      ["supply tank", "pump", "manifold", "valve", "sump", "gauge", "sump"] := by decide

/-- Twelve ports, two per segment: nothing dangling, nothing joined twice. -/
theorem valveManifold_ports_twice :
    valveManifoldSpec.allPorts.length = 2 * valveManifoldSpec.edges.length :=
  wf_two_mul_edges valveManifold_wf

theorem valveManifold_ports : valveManifoldSpec.allPorts.length = 12 := by decide

/-! ## The bill: printed against sourced -/

theorem valveManifold_bill_lines : (allParts valveManifoldSpec).length = 49 := by decide

theorem valveManifold_bosm_lines : (bosm valveManifoldSpec).length = 24 := by decide

/-- Twenty-five of the sixty-one items are printed by the rig. -/
theorem valveManifold_printed_items : partCount (printedParts valveManifoldSpec) = 25 := by decide

/-- Thirty-six have to come out of a bin. -/
theorem valveManifold_sourced_items : partCount (bosm valveManifoldSpec) = 36 := by decide

theorem valveManifold_total_items : partCount (allParts valveManifoldSpec) = 61 := by decide

/-- And the two halves account for the whole bill. -/
theorem valveManifold_bill_splits :
    partCount (printedParts valveManifoldSpec) + partCount (bosm valveManifoldSpec) =
      partCount (allParts valveManifoldSpec) := partCount_partition _

/-! ## The print job -/

/-- The printed items come to 124 cells of plastic. -/
theorem valveManifold_volume : printedVolume valveManifoldSpec = 124 := by decide

/-- And all 124 are on the bed of a 220 × 240 × 80 mm printer: the layout loses
nothing to the edge of the build volume. -/
theorem valveManifold_nothing_clipped :
    ((enum d3d.env (plate valveManifoldSpec)).length : ℤ) = printedVolume valveManifoldSpec := by
  decide

theorem valveManifold_job_length : (toolpath d3d 205 valveManifoldSpec).length = 126 := by decide

theorem valveManifold_pathCost :
    pathCost (0, 0, 0) (enum d3d.env (plate valveManifoldSpec)) = 429 := by decide

/-- **The manifold's printed parts print.**  From a cold bed at 20 °C, heating
to 205 °C, the job runs without a fault; what is left on the bed is exactly the
plate the specification calls for; it consumes 124 cells of filament and the
clock reads 644 ticks — thirty to home, 185 to heat and 429 of printing. -/
theorem valveManifold_prints :
    (run d3d (toolpath d3d 205 valveManifoldSpec) (State.init 20)).fault = none ∧
      (∀ v, v ∈ (run d3d (toolpath d3d 205 valveManifoldSpec) (State.init 20)).deposited ↔
        (plate valveManifoldSpec v = true ∧ d3d.env.mem v = true)) ∧
      (run d3d (toolpath d3d 205 valveManifoldSpec) (State.init 20)).filament = 124 ∧
      (run d3d (toolpath d3d 205 valveManifoldSpec) (State.init 20)).clock = 644 := by
  obtain ⟨h1, h2, h3, h4, h5⟩ :=
    job_prints d3d (plate valveManifoldSpec) 205 20 (plate_supported _) (by decide) (by decide)
  refine ⟨h1, h2, ?_, ?_⟩
  · rw [toolpath, h3]; decide
  · rw [toolpath, h5, valveManifold_pathCost]; rfl

/-! ## The robot program -/

theorem valveManifold_picks : (manifest valveManifoldSpec).picks.length = 49 := by decide

theorem valveManifold_joints : (manifest valveManifoldSpec).joints.length = 12 := by decide

/-- **Every port of the circuit gets exactly one fastening operation.** -/
theorem valveManifold_joints_cover_ports :
    ((manifest valveManifoldSpec).joints.map JointOp.port).Perm valveManifoldSpec.allPorts :=
  joints_ports_perm valveManifold_wf

/-! ## The human steps for this sub-part -/

/-- What a human has to do to get this one manifold built, assuming the printer
and the arm already exist and are calibrated.  Six steps; the closed-loop list
for building a whole rig is `RequestProject/PipeSpec/SelfHost.lean`. -/
def manifoldHumanSteps : List String :=
  [ "1. Load a 1 kg spool of PETG filament into the printer.",
    "2. Load the sourced bins this circuit calls for: bin-tank (2 reservoirs), " ++
      "bin-pump (1 gear pump), bin-valve (1 cartridge), bin-gauge (1 gauge), " ++
      "bin-seal (16 O-rings), bin-fastener (12 M5 cap screws), bin-misc " ++
      "(1 coupling, 1 spring).",
    "3. Transfer valveManifoldSpec's G-code and pick-and-place manifest to the controllers.",
    "4. Confirm the first-layer calibration checkpoint after the printer homes.",
    "5. Confirm the bin-registration checkpoint before the arm's first pick.",
    "6. Pressure-test the finished manifold to twice working pressure and sign it off." ]

theorem manifoldHumanSteps_count : manifoldHumanSteps.length = 6 := by decide

end PipeSpec
end LifeTrac
