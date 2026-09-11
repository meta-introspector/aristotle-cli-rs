import RequestProject.Gvcs.PipeSpec.Bosm
import RequestProject.Gvcs.Printer.Gcode

/-!
# Export: from a `PipeSpec` to a toolpath and a pick-and-place manifest

A specification is of no use to a workshop until it becomes two files:

* a **toolpath** for the printer — here the instruction list of
  `RequestProject/Printer/Machine.lean`, written out as G-code by
  `RequestProject/Printer/Gcode.lean`.  Every printed line of the bill
  (`printedParts`) becomes a box on the bed, one box per item, laid out left to
  right and wrapped into rows that fit the bed;
* a **pick-and-place manifest** for the loader arm — one `Pick` row per line of
  the bill (part name, source bin, quantity, what it belongs to, where it goes)
  and one `JointOp` row per pipe end (which port, which segment, how it is
  fastened and with what seal).

## What is proved

* `plate_supported`, `toolpath_prints` — the emitted toolpath is printable and
  what it leaves on the bed is exactly the plate of parts the spec calls for.
* `item_sub_plate` — every printed item of the bill really is on the plate: no
  part is silently dropped in slicing.
* `printedItems_length`, `gcodeLines_length` (from `Printer/Gcode.lean`) — the
  item count and the line count are preserved: one G-code line per instruction.
* `picks_faithful` — the manifest's rows carry exactly the name, bin and
  quantity of every line of the bill of materials, in order.
* `joints_ports_eq` and `joints_ports_perm` — the fastening operations address
  exactly the ends of the pipe segments and, in a well-formed spec, exactly the
  ports of the circuit, each once.  This is the "no dangling port, no port
  fastened twice" property carried through to the robot program.

## Where verification stops (the transcription boundary)

Three steps are *not* verified and are recorded here as assumptions, not
theorems:

1. **G-code text.**  `Printer.gcode` renders one line per instruction and
   `gcodeLines_length` proves the count; that the resulting ASCII is interpreted
   by a physical printer's firmware the way `Printer.Machine.step` interprets
   the instruction is an assumption about the firmware.  (The repository's
   `tools/check_gcode.py` re-simulates the text independently, which is a check,
   not a proof.)
2. **Geometry.**  `partBox` is a coarse cell-grid stand-in for real part
   geometry: the theorems say the plate is printed faithfully, not that a
   5 × 3 × 2 cell box is a working manifold body.
3. **Physics.**  Nothing here claims that a printed body holds pressure, that a
   thread grips, or that an adhesive bonds.  Those enter as the tolerance and
   pressure side conditions of `RequestProject/PipeSpec/SelfHost.lean`.
-/

namespace LifeTrac
namespace PipeSpec

open Voxel
open LifeTrac.Printer

/-! ## Geometry of the printed items -/

/-- The bounding box, in printer cells, of each printed part the system knows
how to make.  Anything unrecognised gets the default 2 × 2 × 1 blank. -/
def partBox : String → ℤ × ℤ × ℤ
  | "manifold body" => (5, 3, 2)
  | "valve housing" => (3, 3, 2)
  | "pump mount bracket" => (4, 3, 1)
  | "union nut" => (1, 1, 1)
  | "pipe segment" => (6, 1, 1)
  | "tank port boss" => (2, 2, 1)
  | "gauge adapter" => (2, 2, 1)
  | _ => (2, 2, 1)

/-- One printed item per unit of quantity, in bill order. -/
def printedItems (s : Spec) : List String :=
  (printedParts s).flatMap fun p => List.replicate p.qty p.name

/-- The solid of one printed item, with its near left corner at `(x0, y0)`,
resting on the bed. -/
def itemSolid (x0 y0 : ℤ) (name : String) : Solid :=
  let b := partBox name
  Solid.box (x0, y0, 0) (x0 + b.1 - 1, y0 + b.2.1 - 1, b.2.2 - 1)

/-- The width of the bed the layout wraps at, in cells. -/
def bedWidth : ℤ := 22

/-- The pitch between rows of parts, in cells. -/
def rowPitch : ℤ := 4

/-- The items laid out left to right with one cell of clearance, wrapped into
rows of `bedWidth`. -/
def layoutFrom : ℤ → ℤ → List String → List Solid
  | _, _, [] => []
  | x0, y0, n :: ns =>
      let b := partBox n
      if x0 + b.1 ≤ bedWidth then
        itemSolid x0 y0 n :: layoutFrom (x0 + b.1 + 1) y0 ns
      else
        itemSolid 0 (y0 + rowPitch) n :: layoutFrom (b.1 + 1) (y0 + rowPitch) ns

/-- The plate: every printed item of the bill, laid out on the bed. -/
def plate (s : Spec) : Solid := Solid.unions (layoutFrom 0 0 (printedItems s))

/-- Every item box rests on the bed, so the whole plate is self-supporting. -/
theorem layoutFrom_supported : ∀ (x0 y0 : ℤ) (l : List String),
    ∀ sol ∈ layoutFrom x0 y0 l, Supported sol := by
  intro x0 y0 l
  induction l generalizing x0 y0 with
  | nil => intro sol h; simp [layoutFrom] at h
  | cons n ns ih =>
      intro sol h
      rw [layoutFrom] at h
      split at h <;>
        · rcases List.mem_cons.1 h with rfl | h
          · exact supported_box rfl
          · exact ih _ _ sol h

theorem plate_supported (s : Spec) : Supported (plate s) :=
  Supported.unions (layoutFrom_supported 0 0 (printedItems s))

/-- Nothing is dropped in layout: the plate has one box for every printed item
of the bill. -/
theorem layoutFrom_length : ∀ (x0 y0 : ℤ) (l : List String),
    (layoutFrom x0 y0 l).length = l.length := by
  intro x0 y0 l
  induction l generalizing x0 y0 with
  | nil => rfl
  | cons n ns ih =>
      rw [layoutFrom]
      split <;> simp [ih]

/-- Every printed item of the bill is on the plate. -/
theorem item_sub_plate (s : Spec) : ∀ sol ∈ layoutFrom 0 0 (printedItems s),
    Solid.Sub sol (plate s) := fun _ h => Solid.sub_of_mem_unions h

/-- The number of printed items is the number of printed things the bill calls
for. -/
theorem printedItems_length (s : Spec) : (printedItems s).length = partCount (printedParts s) := by
  rw [printedItems, partCount]
  induction printedParts s with
  | nil => rfl
  | cons p ps ih => simp [ih]

/-- The total volume of printed material the bill calls for, in cells: the sum
of the item boxes, computed without reference to the layout. -/
def printedVolume (s : Spec) : ℤ :=
  ((printedItems s).map fun n => let b := partBox n; b.1 * b.2.1 * b.2.2).sum

/-! ## The toolpath -/

/-- The print job for a spec: home, heat to `t`, then lay down the plate. -/
def toolpath (M : Machine) (t : ℤ) (s : Spec) : List Instr := job M t (plate s)

/-- The job as G-code text. -/
def gcodeOf (M : Machine) (t : ℤ) (s : Spec) : String :=
  Printer.gcode "pipespec printed parts" (toolpath M t s)

/-- **The toolpath is a faithful realization of the printed half of the bill.**
On a machine whose hot end will take the commanded temperature, the job runs to
completion without a fault and what is left on the bed is exactly the plate of
printed parts, restricted to the build volume, at one cell of filament per
cell of part. -/
theorem toolpath_prints (M : Machine) (s : Spec) (t a : ℤ)
    (hlo : M.minTemp ≤ t) (hhi : t ≤ M.maxTemp) :
    (run M (toolpath M t s) (State.init a)).fault = none ∧
      (∀ v, v ∈ (run M (toolpath M t s) (State.init a)).deposited ↔
        (plate s v = true ∧ M.env.mem v = true)) ∧
      (run M (toolpath M t s) (State.init a)).filament = (enum M.env (plate s)).length :=
  let h := job_prints M (plate s) t a (plate_supported s) hlo hhi
  ⟨h.1, h.2.1, h.2.2.1⟩

/-- One line of G-code per instruction of the toolpath. -/
theorem gcode_line_count (M : Machine) (t : ℤ) (s : Spec) :
    (Printer.gcodeLines 0 (toolpath M t s)).length = (toolpath M t s).length :=
  Printer.gcodeLines_length 0 (toolpath M t s)

/-! ## The pick-and-place manifest -/

/-- One pick-and-place row: what to fetch, from where, how many, what it belongs
to, and the pose it is placed at. -/
structure Pick where
  /-- The part to fetch. -/
  item : String
  /-- The bin it comes from (`"bed"` for printed parts). -/
  bin : String
  /-- How many. -/
  qty : ℕ
  /-- The component or segment it belongs to. -/
  owner : String
  /-- Where the arm puts it, in assembly cells. -/
  pose : ℤ × ℤ × ℤ
  deriving DecidableEq, Repr, Inhabited

/-- One fastening operation: which port of the circuit, which segment meets it,
and how the joint is made. -/
structure JointOp where
  /-- The port being joined. -/
  port : Endpoint
  /-- The index of the pipe segment being joined to it. -/
  segment : ℕ
  /-- Threaded, glued, or pushed on. -/
  joint : JointKind
  /-- The seal element. -/
  sealing : SealKind
  deriving DecidableEq, Repr, Inhabited

/-- The robot program for a circuit. -/
structure Manifest where
  /-- Everything to fetch and place. -/
  picks : List Pick
  /-- Everything to fasten. -/
  joints : List JointOp
  deriving DecidableEq, Repr, Inhabited

/-- Where component `i` sits on the assembly jig. -/
def nodePose (i : ℕ) : ℤ × ℤ × ℤ := (10 * (i : ℤ), 0, 0)

/-- Where segment `j` is routed. -/
def edgePose (j : ℕ) : ℤ × ℤ × ℤ := (10 * (j : ℤ), 10, 0)

/-- The picks for the components, starting from component `i`. -/
def nodePicks : ℕ → List Node → List Pick
  | _, [] => []
  | i, n :: ns =>
      (nodeParts n.kind).map (fun p => ⟨p.name, p.bin, p.qty, n.label, nodePose i⟩) ++
        nodePicks (i + 1) ns

/-- The picks for the pipe segments, starting from segment `j`. -/
def edgePicks : ℕ → List Edge → List Pick
  | _, [] => []
  | j, e :: es =>
      (edgeParts e).map (fun p => ⟨p.name, p.bin, p.qty, e.label, edgePose j⟩) ++
        edgePicks (j + 1) es

/-- The fastening operations, starting from segment `j`: two per segment, one at
each end. -/
def edgeJoints : ℕ → List Edge → List JointOp
  | _, [] => []
  | j, e :: es =>
      ⟨e.src, j, e.srcJoint.joint, e.srcJoint.sealing⟩ ::
        ⟨e.dst, j, e.dstJoint.joint, e.dstJoint.sealing⟩ :: edgeJoints (j + 1) es

/-- **The export to the loader arm.** -/
def manifest (s : Spec) : Manifest :=
  ⟨nodePicks 0 s.nodes ++ edgePicks 0 s.edges, edgeJoints 0 s.edges⟩

/-! ## The manifest is faithful -/

theorem nodePicks_faithful : ∀ (i : ℕ) (ns : List Node),
    (nodePicks i ns).map (fun p => (p.item, p.bin, p.qty)) =
      (ns.flatMap fun n => nodeParts n.kind).map (fun p => (p.name, p.bin, p.qty)) := by
  intro i ns
  induction ns generalizing i with
  | nil => rfl
  | cons n ns ih => simp [nodePicks, ih]

theorem edgePicks_faithful : ∀ (j : ℕ) (es : List Edge),
    (edgePicks j es).map (fun p => (p.item, p.bin, p.qty)) =
      (es.flatMap edgeParts).map (fun p => (p.name, p.bin, p.qty)) := by
  intro j es
  induction es generalizing j with
  | nil => rfl
  | cons e es ih => simp [edgePicks, ih]

/-- **Nothing of the bill is lost in the manifest.**  The pick rows carry
exactly the name, source bin and quantity of every line of the bill of
materials, in bill order. -/
theorem picks_faithful (s : Spec) :
    (manifest s).picks.map (fun p => (p.item, p.bin, p.qty)) =
      (allParts s).map (fun p => (p.name, p.bin, p.qty)) := by
  simp [manifest, allParts, nodePicks_faithful, edgePicks_faithful]

/-- The manifest has one pick row per line of the bill. -/
theorem picks_length (s : Spec) : (manifest s).picks.length = (allParts s).length := by
  have := congrArg List.length (picks_faithful s)
  simpa using this

/-- Two fastening operations per pipe segment. -/
theorem joints_length : ∀ (j : ℕ) (es : List Edge), (edgeJoints j es).length = 2 * es.length := by
  intro j es
  induction es generalizing j with
  | nil => rfl
  | cons e es ih => simp [edgeJoints, ih]; omega

theorem manifest_joints_length (s : Spec) :
    (manifest s).joints.length = 2 * s.edges.length := joints_length 0 s.edges

/-- **The fastening operations address exactly the ends of the pipe
segments** — in order, with nothing added and nothing dropped. -/
theorem joints_ports_eq : ∀ (j : ℕ) (es : List Edge),
    (edgeJoints j es).map JointOp.port = es.flatMap fun e => [e.src, e.dst] := by
  intro j es
  induction es generalizing j with
  | nil => rfl
  | cons e es ih => simp [edgeJoints, ih]

/-- **And in a well-formed circuit that means every port, exactly once.**  The
loader arm makes one joint at every port of every component: none is left open
and none is fastened twice. -/
theorem joints_ports_perm {s : Spec} (h : wf s = true) :
    ((manifest s).joints.map JointOp.port).Perm s.allPorts := by
  have : (manifest s).joints.map JointOp.port = s.edgeEnds := joints_ports_eq 0 s.edges
  rw [this]
  exact wf_ends_perm h

/-- Each fastening operation carries the joint mechanics and seal the spec asked
for at that end. -/
theorem joints_data : ∀ (j : ℕ) (es : List Edge),
    (edgeJoints j es).map (fun o => (o.joint, o.sealing)) =
      es.flatMap fun e =>
        [(e.srcJoint.joint, e.srcJoint.sealing), (e.dstJoint.joint, e.dstJoint.sealing)] := by
  intro j es
  induction es generalizing j with
  | nil => rfl
  | cons e es ih => simp [edgeJoints, ih]

/-! ## Serialisation -/

/-- A pose as JSON. -/
def poseJson (p : ℤ × ℤ × ℤ) : String :=
  "[" ++ toString p.1 ++ "," ++ toString p.2.1 ++ "," ++ toString p.2.2 ++ "]"

/-- A joint kind as a word. -/
def jointWord : JointKind → String
  | .threaded => "thread"
  | .glued => "glue"
  | .sealFit => "seal-fit"

/-- A seal kind as a word. -/
def sealWord : SealKind → String
  | .oring => "o-ring"
  | .ptfeTape => "ptfe-tape"
  | .bonded => "bonded"
  | .dry => "dry"

/-- The manifest as JSON, for the loader arm's controller. -/
def manifestJson (s : Spec) : String :=
  let m := manifest s
  let pick := fun (p : Pick) =>
    "{\"item\":\"" ++ p.item ++ "\",\"bin\":\"" ++ p.bin ++ "\",\"qty\":" ++ toString p.qty ++
      ",\"owner\":\"" ++ p.owner ++ "\",\"pose\":" ++ poseJson p.pose ++ "}"
  let joint := fun (o : JointOp) =>
    "{\"node\":" ++ toString o.port.node ++ ",\"port\":" ++ toString o.port.port ++
      ",\"segment\":" ++ toString o.segment ++ ",\"op\":\"" ++ jointWord o.joint ++
      "\",\"seal\":\"" ++ sealWord o.sealing ++ "\"}"
  "{\n  \"picks\": [\n    " ++ String.intercalate ",\n    " (m.picks.map pick) ++
    "\n  ],\n  \"joints\": [\n    " ++ String.intercalate ",\n    " (m.joints.map joint) ++
    "\n  ]\n}\n"

/-- The bill of sourced materials as text, for the human doing the buying. -/
def bosmText (s : Spec) : String :=
  String.join ((bosm s).map fun p =>
    "  " ++ toString p.qty ++ " x " ++ p.name ++ "  [" ++ p.bin ++ "]\n")

end PipeSpec
end LifeTrac
